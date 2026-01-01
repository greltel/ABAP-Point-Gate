class ZCL_APG_CONTEXT definition
  public
  final
  create public .

public section.

  interfaces ZIF_APG_CONTEXT .

  aliases GET_DATA
    for ZIF_APG_CONTEXT~GET_DATA .
  aliases GET_DATE
    for ZIF_APG_CONTEXT~GET_DATE .
  aliases GET_INTEGER
    for ZIF_APG_CONTEXT~GET_INTEGER .
  aliases GET_STRING
    for ZIF_APG_CONTEXT~GET_STRING .
  aliases HAS_DATA
    for ZIF_APG_CONTEXT~HAS_DATA .
  aliases SET_DATA
    for ZIF_APG_CONTEXT~SET_DATA .
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES:
      BEGIN OF ty_pair,
        name  TYPE string,
        value TYPE REF TO data,
      END OF ty_pair,
      ty_pairs TYPE HASHED TABLE OF ty_pair WITH UNIQUE KEY name.
    DATA mt_data TYPE ty_pairs.
ENDCLASS.



CLASS ZCL_APG_CONTEXT IMPLEMENTATION.


  METHOD zif_apg_context~get_data.

    e_value = VALUE #( mt_data[ name = i_name ]-value OPTIONAL ).

  ENDMETHOD.


  METHOD zif_apg_context~has_data.

    READ TABLE mt_data WITH KEY name = i_name TRANSPORTING NO FIELDS.
    r_has = xsdbool( syst-subrc IS INITIAL ).

  ENDMETHOD.


  METHOD zif_apg_context~set_data.

    IF line_exists( mt_data[ name = i_name ] ).
      mt_data[ name = i_name ]-value = i_value.
    ELSE.
      INSERT VALUE #( name = i_name value = i_value ) INTO TABLE mt_data.
    ENDIF.


  ENDMETHOD.


  METHOD zif_apg_context~get_date.

    get_data( EXPORTING i_name = i_name
              IMPORTING e_value = DATA(lr_data) ).

    IF lr_data IS BOUND.
      ASSIGN lr_data->* TO FIELD-SYMBOL(<lv_val>).

      TRY.
          r_val = <lv_val>.
        CATCH cx_root.
          CLEAR r_val.
      ENDTRY.

    ENDIF.

  ENDMETHOD.


  METHOD zif_apg_context~get_integer.

    get_data( EXPORTING i_name  = i_name
              IMPORTING e_value = DATA(lr_data) ).

    IF lr_data IS BOUND.

      ASSIGN lr_data->* TO FIELD-SYMBOL(<lv_val>).

      TRY.
          r_val = <lv_val>.
        CATCH cx_root.
      ENDTRY.

    ENDIF.

  ENDMETHOD.


  METHOD zif_apg_context~get_string.

    get_data( EXPORTING i_name = i_name
              IMPORTING e_value = DATA(lr_data) ).

    IF lr_data IS BOUND.

      ASSIGN lr_data->* TO FIELD-SYMBOL(<lv_val>).

      TRY.
          r_val = |{ <lv_val> }|.
        CATCH cx_root.
          CLEAR r_val.
      ENDTRY.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
