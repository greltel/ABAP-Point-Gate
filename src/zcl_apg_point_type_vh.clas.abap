CLASS zcl_apg_point_type_vh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

  INTERFACES if_rap_query_provider .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_apg_point_type_vh IMPLEMENTATION.
  METHOD if_rap_query_provider~select.
    io_request->get_sort_elements( ).
    io_request->get_paging( ).
    DATA lt_values     TYPE STANDARD TABLE OF zi_apg_point_type_vh WITH EMPTY KEY.
    DATA lv_point_Type TYPE zapg_point_type.

    TRY.

        DATA(lt_domain_values) = CAST cl_abap_elemdescr( cl_abap_typedescr=>describe_by_data( lv_point_Type ) )->get_ddic_fixed_values(
            cl_abap_context_info=>get_user_language_abap_format( ) ).
        LOOP AT lt_domain_values ASSIGNING FIELD-SYMBOL(<fs_domain_value>).

          APPEND VALUE #( point_type       = <fs_domain_value>-low
                          point_type_descr = <fs_domain_value>-ddtext ) TO lt_values.

        ENDLOOP.

        DATA(ld_all_entries) = lines( lt_values ).

        IF io_request->is_data_requested( ).
          io_response->set_data( lt_values ).
        ENDIF.

        IF io_request->is_total_numb_of_rec_requested( ).
          io_response->set_total_number_of_records( CONV #( ld_all_entries ) ).
        ENDIF.

      CATCH cx_abap_context_info_error.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
