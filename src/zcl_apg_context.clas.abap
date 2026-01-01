CLASS zcl_apg_context DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_apg_context .

    ALIASES get_data
      FOR zif_apg_context~get_data .
    ALIASES has_data
      FOR zif_apg_context~has_data .
    ALIASES set_data
      FOR zif_apg_context~set_data .
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
ENDCLASS.
