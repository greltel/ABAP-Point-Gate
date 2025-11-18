INTERFACE zif_apg_handler
  PUBLIC .

  METHODS:
    execute
      IMPORTING
        io_context           TYPE REF TO zif_apg_context
      CHANGING
        co_message_container TYPE REF TO if_t100_message "or custom message handler
*      RAISING
*        zcx_apg_error
        .

ENDINTERFACE.
