interface ZIF_APG_ACTIVATION_TOGGLE
  public .


  methods IS_ACTIVE
    importing
      !I_CONTEXT type ref to ZIF_APG_CONTEXT
    returning
      value(R_ACTIVE) type ABAP_BOOLEAN
    raising
      ZCX_APG_ERROR .
endinterface.
