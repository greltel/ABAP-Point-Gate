INTERFACE zif_apg_handler
  PUBLIC .

  METHODS execute
    IMPORTING
      !i_context            TYPE REF TO zif_apg_context
    CHANGING
      !co_message_container TYPE zcl_apg_execution=>tt_bapiret2
    RAISING
      zcx_apg_error .
ENDINTERFACE.
