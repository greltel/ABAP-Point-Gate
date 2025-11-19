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
        zcx_apg_error,
    has_data
      IMPORTING
        i_name       TYPE string
      RETURNING
        VALUE(r_has) TYPE abap_bool.

ENDINTERFACE.
