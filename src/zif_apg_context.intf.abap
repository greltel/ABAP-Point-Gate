interface ZIF_APG_CONTEXT
  public .


  methods SET_DATA
    importing
      !I_NAME type STRING
      !I_VALUE type ref to DATA .
  methods GET_DATA
    importing
      !I_NAME type STRING
    exporting
      !E_VALUE type ref to DATA
    raising
      ZCX_APG_ERROR .
  methods HAS_DATA
    importing
      !I_NAME type STRING
    returning
      value(R_HAS) type ABAP_BOOL .
  methods GET_STRING
    importing
      !I_NAME type STRING
    returning
      value(R_VAL) type STRING
    raising
      ZCX_APG_ERROR .
  methods GET_INTEGER
    importing
      !I_NAME type STRING
    returning
      value(R_VAL) type I
    exceptions
      ZCX_APG_ERROR .
  methods GET_DATE
    importing
      !I_NAME type STRING
    returning
      value(R_VAL) type XSDDATE_D
    exceptions
      ZCX_APG_ERROR .
endinterface.
