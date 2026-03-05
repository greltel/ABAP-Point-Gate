@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Gate Handlers'

@Search.searchable: true

define view entity ZR_APG_GateHandle
  as select from zapg_gate_handle

  association to parent ZR_APG_Point as _Point on $projection.PointId = _Point.PointId

{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key point_id         as PointId,

  key seqno            as SeqNo,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      handler_class    as HandlerClass,

      active           as Active,
      activation_class as ActivationClass,

      /* Admin Data */
      @Semantics.user.createdBy: true
      created_by       as CreatedBy,

      @Semantics.systemDateTime.createdAt: true
      created_at       as CreatedAt,

      @Semantics.user.localInstanceLastChangedBy: true
      last_changed_by  as LastChangedBy,

      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      last_changed_at  as LastChangedAt,

      /* Reached from Parent */
      _Point
}
