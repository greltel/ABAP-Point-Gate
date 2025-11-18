*&---------------------------------------------------------------------*
*& Report ZABAP_POINT_GATE_SAMPLE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zabap_point_gate_sample.

TABLES vbak.

DATA(lo_context) = NEW zcl_apg_context( ).
DATA lr_vbak TYPE REF TO vbak.
DATA lo_msg_cont TYPE REF TO if_t100_message.
" Create data reference and assign current VBAK structure
CREATE DATA lr_vbak.
lr_vbak->* = vbak.
" Put VBAK into context under key 'VBAK'
lo_context->zif_apg_context~set_data(
i_name = 'VBAK'
i_value = lr_vbak ).
" Call the gate before saving the sales order
TRY.
    zcl_apg_execution=>execute_gate(
    EXPORTING
    i_point_id = 'SALES_SAVE_BEFORE'
    io_context = lo_context
    CHANGING
    co_message_container = lo_msg_cont ).
  CATCH zcx_apg_error INTO DATA(lx_apg).
    " Error handling: logging, rollback, user message etc.
ENDTRY.
