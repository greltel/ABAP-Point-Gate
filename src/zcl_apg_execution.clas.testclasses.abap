*"* use this source file for your ABAP unit test classes

CLASS lcl_mock_toggle DEFINITION.
  PUBLIC SECTION.
    INTERFACES zif_apg_activation_toggle.
    DATA mv_should_be_active TYPE abap_bool.
ENDCLASS.

CLASS lcl_mock_toggle IMPLEMENTATION.
  METHOD zif_apg_activation_toggle~is_active.
    r_active = mv_should_be_active.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_mock_handler DEFINITION.
  PUBLIC SECTION.
    INTERFACES zif_apg_handler.
    DATA mv_called TYPE abap_bool.
ENDCLASS.

CLASS lcl_mock_handler IMPLEMENTATION.
  METHOD zif_apg_handler~execute.
    mv_called = abap_true.

    APPEND VALUE #( type = 'S' id = 'ZMSG' number = '000' message = 'Success' )
           TO co_message_container.

  ENDMETHOD.
ENDCLASS.

CLASS ltc_execution_test DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA: mo_context TYPE REF TO zif_apg_context,
          mo_mock    TYPE REF TO lcl_mock_handler.

    METHODS: setup,
      teardown,
      test_handler_execution FOR TESTING RAISING zcx_apg_error,
      test_execution_toggle_act FOR TESTING RAISING zcx_apg_error,
      test_execution_toggle_inactive FOR TESTING RAISING zcx_apg_error.
ENDCLASS.

CLASS ltc_execution_test IMPLEMENTATION.

  METHOD setup.
    zcl_apg_injector=>clear( ).
    mo_context = NEW zcl_apg_context( ).
    mo_mock    = NEW lcl_mock_handler( ).
  ENDMETHOD.

  METHOD teardown.
    zcl_apg_injector=>clear( ).
  ENDMETHOD.

  METHOD test_handler_execution.

    TRY.

        DATA lt_mock_config TYPE zcl_apg_factory=>tt_point_gate_handle.
        APPEND VALUE #(
          point = VALUE #( point_id = 'TEST' active = abap_true )
          gate  = VALUE #( point_id = 'TEST' handler_class = 'ZCL_MOCK_HANDLER' active = abap_true ) ) TO lt_mock_config.

        zcl_apg_injector=>inject_configuration(
          i_point_id = 'TEST'
          i_config   = lt_mock_config ).

        zcl_apg_injector=>inject_instance(
            i_classname = 'ZCL_MOCK_HANDLER'
            i_instance  = mo_mock ).

        DATA lt_messages TYPE zcl_apg_execution=>tt_bapiret2.

        zcl_apg_execution=>execute_gate(
          EXPORTING i_point_id = 'TEST'
                    i_context  = mo_context
          CHANGING  co_message_container = lt_messages ).

        cl_abap_unit_assert=>assert_true(
            act = mo_mock->mv_called
            msg = 'Mock Handler not Called' ).

        cl_abap_unit_assert=>assert_not_initial(
            act = lt_messages
            msg = 'Messages should exist in the container' ).

      CATCH zcx_apg_error INTO DATA(lo_exception).
        cl_abap_unit_assert=>assert_true( abap_false ).
    ENDTRY.

  ENDMETHOD.

  METHOD test_execution_toggle_act.

    DATA lt_mock_config TYPE zcl_apg_factory=>tt_point_gate_handle.

    APPEND VALUE #(
      point = VALUE #( point_id = 'CUSTOM_TEST' active = 'X' )
      gate  = VALUE #( point_id = 'CUSTOM_TEST'
                       handler_class = 'ZCL_MOCK_HANDLER'
                       active = 'C'
                       activation_class = 'ZCL_MY_CUSTOM_TOGGLE' )
    ) TO lt_mock_config.

    zcl_apg_injector=>inject_configuration(
        i_point_id = 'CUSTOM_TEST'
        i_config   = lt_mock_config ).

    DATA(lo_toggle) = NEW lcl_mock_toggle( ).
    lo_toggle->mv_should_be_active = abap_true.

    zcl_apg_injector=>inject_instance(
        i_classname = 'ZCL_MY_CUSTOM_TOGGLE'
        i_instance  = lo_toggle ).

    DATA(lo_handler) = NEW lcl_mock_handler( ).
    zcl_apg_injector=>inject_instance(
        i_classname = 'ZCL_MOCK_HANDLER'
        i_instance  = lo_handler ).

    DATA: lt_messages TYPE zcl_apg_execution=>tt_bapiret2.
    zcl_apg_execution=>execute_gate(
      EXPORTING i_point_id = 'CUSTOM_TEST'
                i_context  = mo_context
      CHANGING  co_message_container = lt_messages ).

    cl_abap_unit_assert=>assert_true(
        act = lo_handler->mv_called
        msg = 'Handle should be called' ).

  ENDMETHOD.

  METHOD test_execution_toggle_inactive.

    DATA lt_mock_config TYPE zcl_apg_factory=>tt_point_gate_handle.

    APPEND VALUE #(
      point = VALUE #( point_id = 'CUSTOM_TEST' active = 'X' )
      gate  = VALUE #( point_id = 'CUSTOM_TEST'
                       handler_class = 'ZCL_MOCK_HANDLER'
                       active = 'C'
                       activation_class = 'ZCL_MY_CUSTOM_TOGGLE' )
    ) TO lt_mock_config.

    zcl_apg_injector=>inject_configuration(
        i_point_id = 'CUSTOM_TEST'
        i_config   = lt_mock_config ).

    DATA(lo_toggle) = NEW lcl_mock_toggle( ).
    lo_toggle->mv_should_be_active = abap_false.

    zcl_apg_injector=>inject_instance(
        i_classname = 'ZCL_MY_CUSTOM_TOGGLE'
        i_instance  = lo_toggle ).

    DATA(lo_handler) = NEW lcl_mock_handler( ).
    zcl_apg_injector=>inject_instance(
        i_classname = 'ZCL_MOCK_HANDLER'
        i_instance  = lo_handler ).

    DATA: lt_messages TYPE zcl_apg_execution=>tt_bapiret2.
    zcl_apg_execution=>execute_gate(
      EXPORTING i_point_id = 'CUSTOM_TEST'
                i_context  = mo_context
      CHANGING  co_message_container = lt_messages ).

    cl_abap_unit_assert=>assert_false(
        act = lo_handler->mv_called
        msg = 'Handle should not be called' ).

  ENDMETHOD.

ENDCLASS.
