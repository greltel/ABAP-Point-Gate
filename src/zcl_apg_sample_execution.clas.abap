CLASS zcl_apg_sample_execution DEFINITION
PUBLIC
FINAL
CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES zif_apg_handler.
protected section.
private section.
ENDCLASS.



CLASS ZCL_APG_SAMPLE_EXECUTION IMPLEMENTATION.


  METHOD zif_apg_handler~execute.

    DATA ls_journal_entry TYPE i_journalentry.

    TRY.
        " Get Data from Context
        i_context->get_data( EXPORTING i_name = 'JOURNAL_ENTRY'
                             IMPORTING e_value = DATA(lr_data) ).

        ls_journal_entry = lr_data->*.

      CATCH cx_root.
        RAISE EXCEPTION TYPE zcx_apg_error.
    ENDTRY.

    "Example validation
    IF ls_journal_entry-postingdate IS NOT INITIAL.
      " Fill message container or raise exception depending on design
      co_message_container = VALUE #( ( message = 'Budat Must Be Initial' type = 'E' ) ).
      " Example: raise exception
      RAISE EXCEPTION TYPE zcx_apg_error.
    ENDIF.

    "Example Change Data
    ls_journal_entry-postingdate = cl_abap_context_info=>get_system_date( ).
    lr_data->*    = ls_journal_entry.
    i_context->set_data( i_name  = 'JOURNAL_ENTRY'
                         i_value = lr_data ).

  ENDMETHOD.
ENDCLASS.
