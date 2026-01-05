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
        DATA ls_bkpf TYPE bkpf.

        "Get Data from Context
        i_context->get_data( EXPORTING i_name = 'BKPF'
                              IMPORTING e_value = DATA(lr_data) ).

        ls_bkpf = lr_data->*.

        IF ls_bkpf-budat NE CL_ABAP_CONTEXT_INFO=>get_system_date( ).
          r_active = abap_true.
        ENDIF.

      CATCH cx_root.
        CLEAR r_active.
        RAISE EXCEPTION TYPE zcx_apg_error.
    ENDTRY.


  ENDMETHOD.
ENDCLASS.
