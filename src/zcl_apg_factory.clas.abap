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

    TRY.
        DATA lo_obj TYPE REF TO object.
        CREATE OBJECT lo_obj TYPE (i_classname).
      CATCH cx_sy_create_object_error INTO DATA(lx_create).
        RAISE EXCEPTION TYPE zcx_apg_error EXPORTING previous = lx_create.
    ENDTRY.

    ro_handler = CAST #( lo_obj ).

  ENDMETHOD.


  METHOD get_handlers_for_gate.

    SELECT FROM zapg_gate_handle AS gate
      INNER JOIN zapg_point AS point ON point~point_id EQ gate~point_id
      FIELDS gate~*
      WHERE gate~point_id EQ @i_point_id
        AND gate~active   EQ @abap_true
    INTO TABLE @DATA(lt_gate_handle).

    SORT lt_gate_handle BY seqno ASCENDING.

    LOOP AT lt_gate_handle ASSIGNING FIELD-SYMBOL(<ls_impl>).
      APPEND create_handler( <ls_impl>-handler_class ) TO rt_handlers.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
