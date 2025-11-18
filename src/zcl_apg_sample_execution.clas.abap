CLASS zcl_apg_sample_execution DEFINITION
PUBLIC
FINAL
CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES zif_apg_handler.
ENDCLASS.



CLASS ZCL_APG_SAMPLE_EXECUTION IMPLEMENTATION.


  METHOD zif_apg_handler~execute.

    DATA lt_vbak TYPE STANDARD TABLE OF vbak.

    " Get Data from Context
    io_context->get_data(
    EXPORTING
    i_name = 'VBAK'
    IMPORTING
    e_value = DATA(lr_data) ).

    lt_vbak = lr_data->*.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcx_apg_error.
    ENDIF.

    " Example validation
*    IF <ls_vbak>-bstnk IS INITIAL.
*      " Fill message container or raise exception depending on design
*      " Example: raise exception
*      RAISE EXCEPTION TYPE zcx_apg_error.
*    ENDIF.

  ENDMETHOD.
ENDCLASS.
