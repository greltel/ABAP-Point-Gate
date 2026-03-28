@EndUserText.label: 'Value Help for Point Type'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_APG_POINT_TYPE_VH'
define custom entity ZI_APG_POINT_TYPE_VH
{
      @EndUserText.label: 'Point Type'
      @EndUserText.quickInfo: 'Point Type'
  key point_type      : zapg_point_type;
      @EndUserText.label: 'Point Type Description'
      @EndUserText.quickInfo: 'Point Type Description'
      point_type_descr : abap.char(20);
}
