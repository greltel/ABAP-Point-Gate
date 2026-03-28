@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Value Help for Include'

@Search.searchable: true

define view entity ZI_APG_INCLUDE_VH
  as select from zapg_point

{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @UI.lineItem: [ { position: 10 } ]
  key src_include as SrcInclude
}

where src_include is not initial
group by src_include
