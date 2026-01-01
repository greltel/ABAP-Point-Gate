class ZCL_APG_FACTORY definition
  public
  final
  create public .

public section.

  types:
    tt_apg_handler TYPE STANDARD TABLE OF REF TO zif_apg_handler WITH EMPTY KEY .

  class-methods GET_ACTIVE_HANDLERS_FOR_GATE
    importing
      !I_POINT_ID type ZAPG_POINT_ID
      !I_CONTEXT type ref to ZIF_APG_CONTEXT
    returning
      value(R_HANDLERS) type TT_APG_HANDLER
    raising
      ZCX_APG_ERROR .
  class-methods INJECT_INSTANCE
    importing
      !I_CLASSNAME type SEOCLSNAME
      !I_INSTANCE type ref to OBJECT .
  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES: BEGIN OF ty_injection,
             classname TYPE seoclsname,
             instance  TYPE REF TO object,
           END OF ty_injection.

    CLASS-DATA mt_injections TYPE HASHED TABLE OF ty_injection WITH UNIQUE KEY classname.

    CLASS-METHODS create_handler
      IMPORTING
        !i_classname     TYPE seoclsname
      RETURNING
        VALUE(r_handler) TYPE REF TO zif_apg_handler
      RAISING
        zcx_apg_error .
    CLASS-METHODS custom_toggle_is_active
      IMPORTING
        !i_activation_class TYPE zapg_activation_class
        !i_context          TYPE REF TO zif_apg_context
      RETURNING
        VALUE(r_is_active)  TYPE boolean
      RAISING
        zcx_apg_error .
ENDCLASS.



CLASS ZCL_APG_FACTORY IMPLEMENTATION.


  METHOD create_handler.

    CLEAR r_handler.

    ASSIGN mt_injections[ classname = i_classname ] TO FIELD-SYMBOL(<ls_injection>).
    IF syst-subrc IS INITIAL AND <ls_injection> IS ASSIGNED.
      r_handler = CAST #( <ls_injection>-instance ).
      RETURN.
    ENDIF.

    TRY.
        DATA lo_obj TYPE REF TO object.

        CREATE OBJECT lo_obj TYPE (i_classname).
        r_handler = CAST #( lo_obj ).

      CATCH cx_sy_create_object_error INTO DATA(lx_create).
        RAISE EXCEPTION TYPE zcx_apg_error EXPORTING previous = lx_create.
    ENDTRY.

  ENDMETHOD.


  METHOD custom_toggle_is_active.

    CLEAR r_is_active.

    TRY.
        "Injection Check
        ASSIGN mt_injections[ classname = i_activation_class ] TO FIELD-SYMBOL(<ls_injection>).
        IF syst-subrc IS INITIAL AND <ls_injection> IS ASSIGNED.
          DATA lo_toggle TYPE REF TO zif_apg_activation_toggle.
          lo_toggle = CAST #( <ls_injection>-instance ).
          r_is_active = lo_toggle->is_active( i_context ).
          RETURN.
        ENDIF.

        "Normal Instantiation
        DATA lo_obj TYPE REF TO object.

        CREATE OBJECT lo_obj TYPE (i_activation_class).
        DATA(lo_handler) = CAST zif_apg_activation_toggle( lo_obj ).
        r_is_active = lo_handler->is_active( i_context ).

      CATCH cx_sy_create_object_error INTO DATA(lx_create).
        CLEAR r_is_active.
        RAISE EXCEPTION TYPE zcx_apg_error EXPORTING previous = lx_create.
    ENDTRY.

  ENDMETHOD.


  METHOD get_active_handlers_for_gate.

    CONSTANTS c_custom_act_toggle TYPE zapg_active VALUE 'C'.

    DATA lr_active TYPE RANGE OF zapg_active.
    lr_active = VALUE #( ( sign = 'I' option = 'EQ' low = abap_true )
                         ( sign = 'I' option = 'EQ' low = c_custom_act_toggle ) ).

    SELECT FROM zapg_gate_handle AS gate
      INNER JOIN zapg_point AS point ON point~point_id EQ gate~point_id
      FIELDS point~*     AS point,
             gate~*      AS gate,
             @abap_false AS deletion_mark
      WHERE   gate~point_id EQ @i_point_id
        AND ( gate~active   IN @lr_active )
       AND  ( point~active  IN @lr_active )
    ORDER BY gate~seqno ASCENDING
    INTO TABLE @DATA(lt_point_gate_handle).

    IF lt_point_gate_handle IS INITIAL.
      RAISE EXCEPTION TYPE zcx_apg_error EXPORTING textid = TEXT-001.
    ENDIF.

    "Keep only the Active Points of Custom Toggle
    LOOP AT lt_point_gate_handle INTO DATA(ls_point) WHERE point-active EQ c_custom_act_toggle.

      IF custom_toggle_is_active( i_activation_class = ls_point-point-activation_class
                                  i_context          = i_context ) EQ abap_false.
        ls_point-deletion_mark = abap_true.
      ENDIF.

    ENDLOOP.

    DELETE lt_point_gate_handle WHERE deletion_mark EQ abap_true.
    IF lt_point_gate_handle IS INITIAL.
      RAISE EXCEPTION TYPE zcx_apg_error EXPORTING textid = TEXT-001.
    ENDIF.

    "Keep only the Active Gates and Return Handlers
    r_handlers = VALUE #( FOR ls IN lt_point_gate_handle
                         ( COND #( WHEN ls-gate-active EQ abap_true
                                   THEN create_handler( ls-gate-handler_class )

                                   WHEN ls-gate-active EQ c_custom_act_toggle
                                   AND custom_toggle_is_active( i_activation_class = ls-gate-activation_class i_context = i_context )
                                   THEN create_handler( ls-gate-handler_class ) ) ) ).

  ENDMETHOD.


  METHOD inject_instance.

    DELETE mt_injections WHERE classname = i_classname.
    INSERT VALUE #( classname = i_classname instance = i_instance ) INTO TABLE mt_injections.

  ENDMETHOD.
ENDCLASS.
