CLASS zcl_apg_context DEFINITION
PUBLIC
FINAL
CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES zif_apg_context.
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
    READ TABLE mt_data INTO DATA(ls_pair)
    WITH KEY name = i_name.
    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE cx_sy_itab_line_not_found.
    ENDIF.
    e_value = ls_pair-value.
  ENDMETHOD.


  METHOD zif_apg_context~has_data.
    READ TABLE mt_data WITH KEY name = i_name TRANSPORTING NO FIELDS.
    r_has = xsdbool( sy-subrc = 0 ).
  ENDMETHOD.


  METHOD zif_apg_context~set_data.
    DATA(ls_pair) = VALUE ty_pair(
    name = i_name
    value = i_value ).
    DELETE mt_data WHERE name = i_name.
    INSERT ls_pair INTO TABLE mt_data.
  ENDMETHOD.
ENDCLASS.
