@EndUserText.label: 'Maintain Point - Projection'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZC_APG_Point
  provider contract transactional_query
  as projection on ZR_APG_Point
{
    key PointId,
    Active,
    ActivationClass,
    LastChangedAt,
    _Gates : redirected to composition child ZC_APG_GateHandle
}
