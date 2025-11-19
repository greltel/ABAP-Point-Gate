interface ZIF_APG_HANDLER
  public .


*      RAISING
*        zcx_apg_error
  methods EXECUTE
    importing
      !I_CONTEXT type ref to ZIF_APG_CONTEXT
    changing
      !CO_MESSAGE_CONTAINER type BAPIRET2_T              "or custom message handler
    raising
      ZCX_APG_ERROR .
endinterface.
