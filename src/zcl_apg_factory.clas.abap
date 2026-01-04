CLASS zcl_apg_factory DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: BEGIN OF ty_point_gate_handle,
             point         TYPE zapg_point,
             gate          TYPE zapg_gate_handle,
             deletion_mark TYPE abap_bool,
           END OF ty_point_gate_handle,

           tt_point_gate_handle TYPE STANDARD TABLE OF ty_point_gate_handle WITH EMPTY KEY.


    TYPES:
      tt_apg_handler TYPE STANDARD TABLE OF REF TO zif_apg_handler WITH EMPTY KEY .

    CLASS-METHODS get_active_handlers_for_gate
      IMPORTING
        !i_point_id       TYPE zapg_point_id
        !i_context        TYPE REF TO zif_apg_context
      RETURNING
        VALUE(r_handlers) TYPE tt_apg_handler
      RAISING
        zcx_apg_error .
    CLASS-METHODS inject_instance
      IMPORTING
        !i_classname TYPE sxco_ao_object_name
        !i_instance  TYPE REF TO object .
  PROTECTED SECTION.
private section.

  types:
    BEGIN OF ty_injection,
             classname TYPE sxco_ao_object_name,
             instance  TYPE REF TO object,
           END OF ty_injection .

  class-data:
    mt_injections TYPE HASHED TABLE OF ty_injection WITH UNIQUE KEY classname .

  class-methods CREATE_HANDLER
    importing
      !I_CLASSNAME type SXCO_AO_OBJECT_NAME
    returning
      value(R_HANDLER) type ref to ZIF_APG_HANDLER
    raising
      ZCX_APG_ERROR .
  class-methods CUSTOM_TOGGLE_IS_ACTIVE
    importing
      !I_ACTIVATION_CLASS type ZAPG_ACTIVATION_CLASS
      !I_CONTEXT type ref to ZIF_APG_CONTEXT
    returning
      value(R_IS_ACTIVE) type ABAP_BOOLEAN
    raising
      ZCX_APG_ERROR .
ENDCLASS.



CLASS ZCL_APG_FACTORY IMPLEMENTATION.


  METHOD create_handler.

    CLEAR r_handler.

    r_handler = zcl_apg_injector=>get_handler( i_classname ).

  ENDMETHOD.


  METHOD custom_toggle_is_active.

    CLEAR r_is_active.

    DATA(lo_toggle) = zcl_apg_injector=>get_toggle( i_activation_class ).
    r_is_active = lo_toggle->is_active( i_context ).

  ENDMETHOD.


  METHOD get_active_handlers_for_gate.

    CONSTANTS c_custom_act_toggle TYPE zapg_active VALUE 'C'.

    DATA lr_active TYPE RANGE OF zapg_active.
    lr_active = VALUE #( ( sign = 'I' option = 'EQ' low = abap_true )
                         ( sign = 'I' option = 'EQ' low = c_custom_act_toggle ) ).

    DATA lt_point_gate_handle TYPE tt_point_gate_handle.

    zcl_apg_injector=>get_configuration(
      EXPORTING i_point_id = i_point_id
      IMPORTING e_config   = lt_point_gate_handle ).


    IF lt_point_gate_handle IS INITIAL."NO MOCK EXISTS

      SELECT FROM zapg_gate_handle AS gate
          INNER JOIN zapg_point AS point ON point~point_id EQ gate~point_id
          FIELDS point~*     AS point,
                 gate~*      AS gate,
                 @abap_false AS deletion_mark
          WHERE   gate~point_id EQ @i_point_id
            AND ( gate~active   IN @lr_active )
           AND  ( point~active  IN @lr_active )
        ORDER BY gate~seqno ASCENDING
        INTO TABLE @lt_point_gate_handle.

    ENDIF.

    LOOP AT lt_point_gate_handle INTO DATA(ls_cfg).

      IF ls_cfg-point-active EQ c_custom_act_toggle.
        IF zcl_apg_injector=>get_toggle( ls_cfg-point-activation_class )->is_active( i_context ) EQ abap_false.
          CONTINUE.
        ENDIF.
      ENDIF.

      IF ls_cfg-gate-active EQ abap_true.

        APPEND zcl_apg_injector=>get_handler( ls_cfg-gate-handler_class ) TO r_handlers.

      ELSEIF ls_cfg-gate-active EQ c_custom_act_toggle.

        IF zcl_apg_injector=>get_toggle( ls_cfg-gate-activation_class )->is_active( i_context ) EQ abap_true.
          APPEND zcl_apg_injector=>get_handler( ls_cfg-gate-handler_class ) TO r_handlers.
        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD inject_instance.

    DELETE mt_injections WHERE classname = i_classname.
    INSERT VALUE #( classname = i_classname instance = i_instance ) INTO TABLE mt_injections.

  ENDMETHOD.
ENDCLASS.
