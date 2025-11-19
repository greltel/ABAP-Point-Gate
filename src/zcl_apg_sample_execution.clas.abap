CLASS zcl_apg_sample_execution DEFINITION
PUBLIC
FINAL
CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES zif_apg_handler.
ENDCLASS.



CLASS ZCL_APG_SAMPLE_EXECUTION IMPLEMENTATION.


  METHOD zif_apg_handler~execute.

    DATA ls_bkpf TYPE bkpf.

    TRY.
        " Get Data from Context
        io_context->get_data( EXPORTING i_name = 'BKPF'
                              IMPORTING e_value = DATA(lr_data) ).

        ls_bkpf = lr_data->*.

      CATCH cx_root.
        RAISE EXCEPTION TYPE zcx_apg_error.
    ENDTRY.

    "Example validation
    IF ls_bkpf-budat IS NOT INITIAL.
      " Fill message container or raise exception depending on design
      co_message_container = VALUE #( ( message = 'Budat Must Be Initial' type = 'E' ) ).
      " Example: raise exception
      RAISE EXCEPTION TYPE zcx_apg_error.
    ENDIF.

    "Example Change Data
    ls_bkpf-budat = syst-datum.
    lr_data->*    = ls_bkpf.
    io_context->set_data( EXPORTING i_name  = 'BKPF'
                                    i_value = lr_data ).

  ENDMETHOD.
ENDCLASS.
