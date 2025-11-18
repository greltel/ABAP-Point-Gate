CLASS zcl_apg_factory DEFINITION
PUBLIC
FINAL
CREATE PUBLIC.
  PUBLIC SECTION.

    TYPES: tt_apg_handler TYPE STANDARD TABLE OF REF TO zif_apg_handler WITH EMPTY KEY.

    CLASS-METHODS:
      get_handlers_for_gate
        IMPORTING
          i_point_id         TYPE zapg_point_id
        RETURNING
          VALUE(rt_handlers) TYPE tt_apg_handler
        RAISING
          zcx_apg_error.
  PRIVATE SECTION.
    CLASS-METHODS:
      create_handler
        IMPORTING
          i_classname       TYPE seoclsname
        RETURNING
          VALUE(ro_handler) TYPE REF TO zif_apg_handler
        RAISING
          zcx_apg_error.
ENDCLASS.



CLASS ZCL_APG_FACTORY IMPLEMENTATION.


  METHOD create_handler.
    DATA lo_obj TYPE REF TO object.
    TRY.
        CREATE OBJECT lo_obj TYPE (i_classname).
      CATCH cx_sy_create_object_error INTO DATA(lx_create).
        RAISE EXCEPTION TYPE zcx_apg_error
          EXPORTING
            previous = lx_create.
    ENDTRY.
    ro_handler ?= lo_obj.
  ENDMETHOD.


  METHOD get_handlers_for_gate.
    DATA: lt_impl TYPE STANDARD TABLE OF zapg_gate_handle.
    SELECT *
    FROM zapg_gate_handle
    INTO TABLE lt_impl
    WHERE point_id = i_point_id
    AND active = 'X'
    ORDER BY seqno.
    LOOP AT lt_impl ASSIGNING FIELD-SYMBOL(<ls_impl>).
      APPEND create_handler( <ls_impl>-handler_class ) TO rt_handlers.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
