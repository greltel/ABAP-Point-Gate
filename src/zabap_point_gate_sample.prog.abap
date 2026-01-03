*&---------------------------------------------------------------------*
*& Report ZABAP_POINT_GATE_SAMPLE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zabap_point_gate_sample.

"Create Context Object and Give Data
SELECT SINGLE FROM i_journalentry
  FIELDS *
  INTO NEW @DATA(lr_bkpf).

DATA(lo_context) = NEW zcl_apg_context( ).
lo_context->set_data( i_name = 'BKPF' i_value = lr_bkpf ).
lo_context->set_data( i_name = 'STRING' i_value = REF #( 'TEST_STRING' ) ).
lo_context->set_data( i_name = 'DATE' i_value = REF #( syst-datum ) ).
lo_context->set_data( i_name = 'INTEGER' i_value = REF #( '123' ) ).

"Call the gate
TRY.
    DATA lt_msg_cont TYPE zcl_apg_execution=>tt_bapiret2.
    zcl_apg_execution=>execute_gate( EXPORTING i_point_id = 'SAMPLE_SAVE_BEFORE'
                                               i_context  = lo_context
                                     CHANGING  co_message_container = lt_msg_cont ).

    "Now we can read the message container for validations

    "Or take the new data back
    lo_context->get_data( EXPORTING i_name = 'BKPF' IMPORTING e_value = DATA(lr_changed_bkpf) ).

    DATA(lv_string)  = lo_context->get_string( 'STRING' ).
    DATA(lv_date)    = lo_context->get_date( 'DATE' ).
    DATA(lv_integer) = lo_context->get_integer( 'INTEGER' ).

    BREAK-POINT.

  CATCH zcx_apg_error INTO DATA(lx_apg).
    DATA(lv_exception_text) = lx_apg->get_text( ).
    " Error handling: logging, rollback, user message etc.
    BREAK-POINT.
ENDTRY.
