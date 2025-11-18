INTERFACE zif_apg_context
  PUBLIC .

  METHODS:
    set_data
      IMPORTING
        i_name  TYPE string
        i_value TYPE REF TO data,
    get_data
      IMPORTING
        i_name  TYPE string
      EXPORTING
        e_value TYPE REF TO data
      RAISING
        cx_sy_itab_line_not_found, "or custom ZCX_APG_ERROR
    has_data
      IMPORTING
        i_name       TYPE string
      RETURNING
        VALUE(r_has) TYPE abap_bool.

ENDINTERFACE.
