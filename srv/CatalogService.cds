//Service Layer
using {anubhav.db.master, anubhav.db.transaction } from '../db/datamodel1'; 
using {cappo.cds } from '../db/cdsviews';

service CatalogService @(path:'CatalogService') {
//In odata service an entityset is used as end point to perform
//CURDQ Create Update Read Delete and Query operations
//endpoints that take us to the data of the table
//entity <epointname> as pro on <table name>
entity BusinessPartnerSet as projection on master.businesspartner; 
entity AddressSet as projection on master.address;
entity EmployeeSet as projection on master. employees;
entity ProductSet as projection on master.product; 
entity POs @(
    //drafting enabled-users can now create delete update info 
    odata.draft.enabled: true,
    //adding default values
    //Common.DefaultValuesFunction : 'getOrderDefaults'
 ) as projection on transaction.purchaseorder
 {
    *,
    @title : 'Gross Amt'
    ROUND(GROSS_AMOUNT,0) AS GROSS_AMOUNT:Int64,
    Items,
    @title:'{i18n>OVERALL_STATUS}'
    case OVERALL_STATUS
            when 'N' then 'New'
            when 'P' then 'Paid'
            when 'B' then 'Blocked'
            else 'Delivered' 
            end as OVERALL_STATUS: String(20),
            case OVERALL_STATUS
            when 'N' then 0
            when 'P' then 2
            when 'B' then 1
            else 3 
            end as criticality: Integer
}
//Side Effects help refresh UI fields dynamically without requiring a full page reload.
actions{
      @cds.odata.bindingparameter.name : 'boosted_data'//when user clicks boosted new data store 
      //in this temp var 
        @Common.SideEffects : {
                TargetProperties : ['boosted_data/GROSS_AMOUNT']
    //When boosted_data is updated, the UI automatically reflects the new value in GROSS_AMOUNT.
            }  
        action boost();
        action setOrderProcessing();
        function largestOrder() returns array of POs; 
        function getOrderDefaults() returns POs;
    };
entity POItems as projection on transaction.poitems;
}