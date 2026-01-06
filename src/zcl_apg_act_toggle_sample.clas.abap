class ZCL_APG_ACT_TOGGLE_SAMPLE definition
  public
  final
  create public .

public section.

  interfaces ZIF_APG_ACTIVATION_TOGGLE .
protected section.
private section.
ENDCLASS.



CLASS ZCL_APG_ACT_TOGGLE_SAMPLE IMPLEMENTATION.


  METHOD zif_apg_activation_toggle~is_active.

    CLEAR r_active.

    TRY.
        DATA ls_journalentry TYPE i_journalentry.

        "Get Data from Context
        i_context->get_data( EXPORTING i_name = 'JOURNAL_ENTRY'
                             IMPORTING e_value = DATA(lr_data) ).

        ls_journalentry = lr_data->*.

        IF ls_journalentry-postingdate NE cl_abap_context_info=>get_system_date( ).
          r_active = abap_true.
        ENDIF.

      CATCH cx_root.
        CLEAR r_active.
        RAISE EXCEPTION TYPE zcx_apg_error.
    ENDTRY.


  ENDMETHOD.
ENDCLASS.
