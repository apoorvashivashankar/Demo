public with sharing class ChangeRequestExtension {

    ApexPages.standardController m_stdController = null;
    public Account acc {get;set;}
    public Change_Request__c cr {get;set;}
    public String theRecord {get;set;}
    public String theRecordId {get;set;}    
    String createType = 'update';
    private final Account acct;
    public String messsage {get;set;}
    public String checkParam {get;set;}
    public static boolean firstRun = true;

    public ChangeRequestExtension(ApexPages.StandardController stdController) {
        m_stdController = stdController;
        this.acct = (Account)stdController.getRecord();
        String type = stdController.getRecord().getSObjectType().getDescribe().getName();
        String theSObjectType = String.valueof(stdController.getRecord().getSObjectType());
        String theRecord = String.valueof(stdController.getRecord());
        String theRecordtemp = theRecord.removeEnd(',');
        String theRecordIdAndStuff = theRecordtemp.substringAfter('Id=');
        String theRecordId = theRecordIdAndStuff.substring(0, 18);
        checkParam = 'not Ok!';
        messsage = 'Please click outside of the pop up window for Auto Close<br/>Please click  Close  to  see how parent window will be refreshed';
        System.debug('acct: ' + acct);
        System.debug('theRecord: ' + theRecord);
        System.debug('theRecordId: ' + theRecordId);

        //Check for Account ID.
        if (theRecordId != '' || theRecordId != NULL) {
            acc = [
                SELECT id
                    ,NAME
                    ,DBA_Name__c
                    ,AccountNumber
                    ,Customer_Base__c
                    ,Customer_Class__c
                    ,phone
                    ,Customer_Type__c
                    ,DW_ID__c
                    ,GroupKey__c
                    ,SAP_Account_Id__c
                    ,Fax
                    ,Website
                    ,Require_PO__c
                    ,Region__c
                    ,Salesman__c
                    ,SSC__c
                    ,Customer_Suffix__c
                    ,BillingStreet
                    ,BillingCity
                    ,BillingState
                    ,BillingPostalCode
                    ,BillingCountry
                    ,ShippingStreet
                    ,ShippingCity
                    ,ShippingState
                    ,ShippingPostalCode
                    ,ShippingCountry
                    ,Address_3__c
                    ,SBU__C
                FROM Account
                WHERE Id = : theRecordId
                ];
        } else {
            System.debug('WHERE IS YOUR ACCOUNT?!');
        }
    }

    public PageReference createCR() {
        System.debug('MADE IT TO createCR!');
        if (firstRun) {
            firstRun = false;
            if (acc != NULL && cr == NULL) {

                //Querying for Record Type Details.
                List < RecordType > rtList = [Select SobjectType, Name, Id From RecordType where SobjectType = 'Change_Request__c'];

                //Querying SSC table for RVP & RSM.
                List < SSC__c > sscList = [select id, Name, RSM__c, RVP__c from SSC__c where id =  : acc.SSC__c];

                //Creating new Change request record.
                cr = new change_request__c();

                cr.Sales_Representative__c = acc.Salesman__c;
                cr.DBA_Name__c = acc.DBA_Name__c;
                cr.SSC__c = acc.SSC__c;
                cr.Region__c = acc.Region__c;
                cr.Account__c = acc.id;
                cr.Customer_Base__c = acc.Customer_Base__c;
                cr.Suffix__c = acc.Customer_Suffix__c;
                cr.Customer_DW_ID__c = acc.DW_ID__c;
                cr.Group_Key__c = acc.GroupKey__c;                
                cr.SAP_Account_Id__c = acc.SAP_Account_Id__c;                
                cr.Bill_Address_1__c = acc.BillingStreet;
                cr.Billing_City_Account__c = acc.BillingCity;
                cr.Billing_State_Account__c = acc.BillingState;
                cr.Bill_Country__c = acc.BillingCountry;
                cr.Billing_Zip_Account__c = acc.BillingPostalCode;
                cr.Address3__c = acc.Address_3__c;
                cr.Billing_street__c = acc.ShippingStreet;
                cr.Billing_city__c = acc.ShippingCity;
                cr.Billing_state__c = acc.ShippingState;
                cr.Billing_country__c = acc.ShippingCountry;
                cr.BILLING_ZIP__C = acc.ShippingPostalCode;
                cr.SBU__c = acc.SBU__C;
                cr.Phone__c = acc.phone;
                cr.fax__c = acc.Fax;
                cr.Website__c = acc.Website;
                cr.Customer_Class__c = acc.Customer_Class__c;
                cr.Customer_Type__c = acc.Customer_Type__c;

                if (rtList != null && rtList.size() > 0) {
                    for (RecordType rt : rtList) {
                        if (createType == 'update' && rt.Name == 'Customer Update') {
                            cr.RecordTypeId = rt.Id;
                        } else if (createType == 'delete' && rt.Name == 'Customer Delete') {
                            cr.RecordTypeId = rt.Id;
                            System.debug('#########  RT set ###### --> ' + rt.Name);
                        }

                    }
                }

                try {
                    insert cr;
                    System.debug('cr ---> ' + cr);
                    PageReference customerUpdatePage = new PageReference('/apex/ChangeRequestLightningEditor?id=' + cr.id);
                    customerUpdatePage.setRedirect(true);
                    return customerUpdatePage;
//                    return new ApexPages.StandardController(cr).edit();


                } catch (Exception e) {
                    return null;
                }
            } else {
                return null;
            }
        } else {
            System.debug('Not first Run...Already ran!');
            PageReference acctPage = new ApexPages.StandardController(acct).view();
            acctPage.setRedirect(true);
            return acctPage;
        }
    }


}