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
      value(RT_HANDLERS) type TT_APG_HANDLER
    raising
      ZCX_APG_ERROR .
private section.

  class-methods CREATE_HANDLER
    importing
      !I_CLASSNAME type SEOCLSNAME
    returning
      value(RO_HANDLER) type ref to ZIF_APG_HANDLER
    raising
      ZCX_APG_ERROR .
  class-methods CUSTOM_TOGGLE_IS_ACTIVE
    importing
      !I_ACTIVATION_CLASS type ZAPG_ACTIVATION_CLASS
      !I_CONTEXT type ref to ZIF_APG_CONTEXT
    returning
      value(R_IS_ACTIVE) type BOOLEAN
    raising
      ZCX_APG_ERROR .
ENDCLASS.



CLASS ZCL_APG_FACTORY IMPLEMENTATION.


  METHOD create_handler.

    CLEAR ro_handler.

    TRY.
        DATA lo_obj TYPE REF TO object.

        CREATE OBJECT lo_obj TYPE (i_classname).
        ro_handler = CAST #( lo_obj ).

      CATCH cx_sy_create_object_error INTO DATA(lx_create).
        RAISE EXCEPTION TYPE zcx_apg_error EXPORTING previous = lx_create.
    ENDTRY.

  ENDMETHOD.


  METHOD custom_toggle_is_active.

    CLEAR r_is_active.

    TRY.
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

    "Keep only the Active Points
    LOOP AT lt_point_gate_handle INTO DATA(ls_point) WHERE point-active EQ c_custom_act_toggle.

      IF custom_toggle_is_active( i_activation_class = ls_point-point-activation_class
                                  i_context = i_context ) EQ abap_false.
        ls_point-deletion_mark = abap_true.
      ENDIF.

    ENDLOOP.

    DELETE lt_point_gate_handle WHERE deletion_mark EQ abap_true.
    CHECK lt_point_gate_handle IS NOT INITIAL.

    "Keep only the Active Gates and Return Handlers
    rt_handlers = VALUE #( FOR ls IN lt_point_gate_handle
                         ( COND #( WHEN ls-gate-active EQ abap_true
                                   THEN create_handler( ls-gate-handler_class )
                                   WHEN ls-gate-active EQ c_custom_act_toggle
                                   AND custom_toggle_is_active( i_activation_class = ls-gate-activation_class i_context = i_context )
                                   THEN create_handler( ls-gate-handler_class ) ) ) ).

  ENDMETHOD.
ENDCLASS.
