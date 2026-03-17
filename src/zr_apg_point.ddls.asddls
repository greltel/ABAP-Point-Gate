@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Point Header'

@Search.searchable: true

define root view entity ZR_APG_Point
  as select from zapg_point

  composition [0..*] of ZR_APG_GateHandle as _Gates

{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key point_id         as PointId,

      active           as Active,
      activation_class as ActivationClass,

      @Semantics.user.createdBy: true
      created_by       as CreatedBy,

      @Semantics.systemDateTime.createdAt: true
      created_at       as CreatedAt,

      @Semantics.user.localInstanceLastChangedBy: true
      last_changed_by  as LastChangedBy,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      last_changed_at  as LastChangedAt,

      _Gates
}
