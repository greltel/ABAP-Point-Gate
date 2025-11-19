class ZCL_APG_CONTEXT definition
  public
  final
  create public .

public section.

  interfaces ZIF_APG_CONTEXT .

  aliases GET_DATA
    for ZIF_APG_CONTEXT~GET_DATA .
  aliases HAS_DATA
    for ZIF_APG_CONTEXT~HAS_DATA .
  aliases SET_DATA
    for ZIF_APG_CONTEXT~SET_DATA .
  PRIVATE SECTION.
    TYPES:
      BEGIN OF ty_pair,
        name  TYPE string,
        value TYPE REF TO data,
      END OF ty_pair,
      ty_pairs TYPE STANDARD TABLE OF ty_pair WITH DEFAULT KEY.
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

    DELETE mt_data WHERE name = i_name.
    INSERT VALUE ty_pair( name = i_name value = i_value ) INTO TABLE mt_data.

  ENDMETHOD.
ENDCLASS.
