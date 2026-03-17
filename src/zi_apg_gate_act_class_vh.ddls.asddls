@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help for Maintained Act. Classes'
@Search.searchable: true

define view entity ZI_APG_GATE_ACT_CLASS_VH
  as select from zapg_gate_handle
{
      @UI.lineItem: [{ position: 10 }]
      @EndUserText.label: 'Activation Class'
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key activation_class as ActivationClass
}
where activation_class is not initial
group by activation_class
