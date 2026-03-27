@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help for Status'
@ObjectModel.resultSet.sizeCategory: #XS // <--- Μετατρέπει το F4 σε Dropdown List

define view entity ZI_APG_STATUS_VH
  as select from zapg_point
{
      @UI.hidden: true
  key active as StatusCode,

      @EndUserText.label: 'Status'
      case active
        when 'X' then 'Active'
        else 'Inactive'
      end as StatusText
}
group by active
