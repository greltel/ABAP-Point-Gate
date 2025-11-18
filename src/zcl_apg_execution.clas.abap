CLASS zcl_apg_execution DEFINITION
PUBLIC
FINAL
CREATE PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS:
      execute_gate
        IMPORTING
          i_point_id           TYPE zapg_point_id
          io_context           TYPE REF TO zif_apg_context
        CHANGING
          co_message_container TYPE REF TO if_t100_message
        RAISING
          zcx_apg_error.
ENDCLASS.



CLASS ZCL_APG_EXECUTION IMPLEMENTATION.


  METHOD execute_gate.
    DATA lt_handlers TYPE STANDARD TABLE OF REF TO zif_apg_handler.
    lt_handlers = zcl_apg_factory=>get_handlers_for_gate( i_point_id ).
    LOOP AT lt_handlers INTO DATA(lo_handler).
      lo_handler->execute(
      EXPORTING
      io_context = io_context
      CHANGING
      co_message_container = co_message_container ).
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
