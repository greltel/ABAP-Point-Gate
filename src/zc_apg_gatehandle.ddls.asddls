@EndUserText.label: 'Maintain Handlers - Projection'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZC_APG_GateHandle
  as projection on ZR_APG_GateHandle
{
    key PointId,
    key SeqNo,
    Active,
    ActivationClass,
    HandlerClass,
    LastChangedAt,
    _Point : redirected to parent ZC_APG_Point
}
