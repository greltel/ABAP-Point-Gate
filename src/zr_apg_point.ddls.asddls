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
      src_main_prog    as SrcMainProg,
      src_include      as SrcInclude,
      src_line         as SrcLine,
      point_type       as PointTypeCode,
      activation_class as ActivationClass,

      case active
      when 'X' then 3
      else 1
      end              as ActiveCriticality,

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
