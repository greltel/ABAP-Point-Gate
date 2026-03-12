@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help for ABAP Classes'
@Search.searchable: true

define view entity ZI_APG_ClassVH
  as select from seoclass   as _Class
    left outer join seoclasstx as _Text on  _Class.clsname = _Text.clsname
                                        and _Text.langu    = $session.system_language
{
      @UI.lineItem: [{ position: 10 }]
      @EndUserText.label: 'Class Name'
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8     
  key _Class.clsname as ClassName,

      @UI.lineItem: [{ position: 20 }]
      @EndUserText.label: 'Description'
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      _Text.descript as Description
}
where
  _Class.clsname not like '/%' // Προαιρετικό φίλτρο για custom κλάσεις
