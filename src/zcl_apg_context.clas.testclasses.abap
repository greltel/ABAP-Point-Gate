*"* use this source file for your ABAP unit test classes
CLASS ltc_context_test DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA mo_cut TYPE REF TO zif_apg_context.

    METHODS: setup,
             test_string_storage FOR TESTING,
             test_date_conversion FOR TESTING,
             test_missing_data FOR TESTING.
ENDCLASS.

CLASS ltc_context_test IMPLEMENTATION.

  METHOD setup.
    mo_cut = NEW zcl_apg_context( ).
  ENDMETHOD.

  METHOD test_string_storage.
    mo_cut->set_data( i_name = 'TEST' i_value = NEW string( 'Hello' ) ).

    cl_abap_unit_assert=>assert_equals(
      exp = 'Hello'
      act = mo_cut->get_string( 'TEST' )
      msg = 'Το String δεν ανακτήθηκε σωστά από το context' ).
  ENDMETHOD.

  METHOD test_date_conversion.
    DATA(lv_date) = sy-datum.
    mo_cut->set_data( i_name = 'MYDATE' i_value = REF #( lv_date ) ).

    cl_abap_unit_assert=>assert_equals(
      exp = sy-datum
      act = mo_cut->get_date( 'MYDATE' )
      msg = 'Η ημερομηνία πρέπει να επιστρέφεται σωστά' ).
  ENDMETHOD.

  METHOD test_missing_data.

    cl_abap_unit_assert=>assert_initial(
      act = mo_cut->get_string( 'NOT_EXISTS' )
      msg = 'Πρέπει να επιστρέφει initial αν δεν υπάρχει το data' ).

  ENDMETHOD.

ENDCLASS.
