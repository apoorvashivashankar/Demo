public class CustomerDelRequestController {

    public Account theAcc {get;set;}
    public change_request__c theCR {get;set;} 

    ApexPages.StandardController controller;
    
    public CustomerDelRequestController(ApexPages.StandardController controller) {
        
        this.controller = controller; 
        String theActualId =  String.valueof(controller.getRecord().get('Id')); 
        Id varDELRecordType = Schema.SObjectType.Change_Request__c.getRecordTypeInfosByName().get('Customer Delete').getRecordTypeId(); 
        theCR = new Change_Request__c();
        
        theAcc = [SELECT ID
                      ,NAME
                      ,DBA_Name__c
                      ,AccountNumber
                      ,Customer_Base__c
                      ,Customer_Class__c
                      ,Customer_Class__r.Name
                      ,Customer_Class__r.Customer_Class_Details__c
                      ,Customer_Class__r.CustClass__c
                      ,phone
                      ,Customer_Type__c
                      ,Customer_Type__r.Name 
                      ,DW_ID__c
                      ,Fax
                      ,Require_PO__c
                      ,Region__c
                      ,Region__r.Name
                      ,Salesman__c
                      ,Salesman__r.Name
                      ,SSC__c
                      ,SSC__r.Name
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
                      ,SBU__C
                      ,Mark_For_Deletion__c
                      ,PO_Required__c
                  FROM Account 
                  WHERE ID = :theActualId];        
        
        theCR.RecordTypeId = varDELRecordType;
        theCR.Sales_Representative__c = theAcc.Salesman__c;
        theCR.SSC__c = theAcc.SSC__c;
        theCR.Region__c = theAcc.Region__c;
        theCR.Account__c = theAcc.ID;
        theCR.Customer_Base__c = theAcc.DW_ID__c;
        theCR.Customer_Class__c = theAcc.Customer_Class__c;
        theCR.Customer_Type__c = theAcc.Customer_Type__c;
        theCR.Bill_Address_1__c = theAcc.BillingStreet;
        theCR.Billing_City_Account__c = theAcc.BillingCity;
        theCR.Billing_State_Account__c = theAcc.BillingState;
        theCR.Bill_Country__c = theAcc.BillingCountry;
        theCR.Billing_Zip_Account__c = theAcc.BillingPostalCode;
        theCR.Billing_street__c = theAcc.ShippingStreet;
        theCR.Billing_city__c = theAcc.ShippingCity;
        theCR.Billing_state__c = theAcc.ShippingState;
        theCR.Billing_country__c = theAcc.ShippingCountry;
        theCR.BILLING_ZIP__C = theAcc.ShippingPostalCode;
        theCR.SBU__c = theAcc.SBU__c;
        theCR.Mark_For_Deletion__c = theAcc.Mark_For_Deletion__c;        
        theCR.Mark_For_Deletion_N__c = true;
        
    }
    
    public PageReference saveDel() {
        System.debug('Save the DEL record!');
        insert  theCR;                                          

        PageReference backToAccounts = new PageReference('/' + theAcc.ID);
        backToAccounts.setRedirect(true);
        return backToAccounts;  
    }    
    
    @RemoteAction
    public static String saveNewDEL (String theActualID) {
        Change_Request__c theCR = new Change_Request__c();
        
        Account theAcc = [SELECT ID
                      ,NAME
                      ,DBA_Name__c
                      ,AccountNumber
                      ,Customer_Base__c
                      ,Customer_Class__c
                      ,Customer_Class__r.Name
                      ,Customer_Class__r.Customer_Class_Details__c
                      ,Customer_Class__r.CustClass__c
                      ,phone
                      ,Customer_Type__c
                      ,Customer_Type__r.Name 
                      ,DW_ID__c
                      ,Fax
                      ,Require_PO__c
                      ,Region__c
                      ,Region__r.Name
                      ,Salesman__c
                      ,Salesman__r.Name
                      ,SSC__c
                      ,SSC__r.Name
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
                      ,SBU__C
                      ,Mark_For_Deletion__c
                      ,PO_Required__c
                  FROM Account 
                  WHERE ID = :theActualId];        
        Id varDELRecordType = Schema.SObjectType.Change_Request__c.getRecordTypeInfosByName().get('Customer Delete').getRecordTypeId();         
        theCR.RecordTypeId = varDELRecordType;
        theCR.Sales_Representative__c = theAcc.Salesman__c;
        theCR.SSC__c = theAcc.SSC__c;
        theCR.Region__c = theAcc.Region__c;
        theCR.Account__c = theAcc.ID;
        theCR.Customer_Base__c = theAcc.DW_ID__c;
        theCR.Customer_Class__c = theAcc.Customer_Class__c;
        theCR.Customer_Type__c = theAcc.Customer_Type__c;
        theCR.Bill_Address_1__c = theAcc.BillingStreet;
        theCR.Billing_City_Account__c = theAcc.BillingCity;
        theCR.Billing_State_Account__c = theAcc.BillingState;
        theCR.Bill_Country__c = theAcc.BillingCountry;
        theCR.Billing_Zip_Account__c = theAcc.BillingPostalCode;
        theCR.Billing_street__c = theAcc.ShippingStreet;
        theCR.Billing_city__c = theAcc.ShippingCity;
        theCR.Billing_state__c = theAcc.ShippingState;
        theCR.Billing_country__c = theAcc.ShippingCountry;
        theCR.BILLING_ZIP__C = theAcc.ShippingPostalCode;
        theCR.SBU__c = theAcc.SBU__c;
        theCR.Mark_For_Deletion__c = theAcc.Mark_For_Deletion__c;        
        theCR.Mark_For_Deletion_N__c = true;        
        
        System.debug('Save the DEL record!');
        insert  theCR;           
        
        return theCR.ID;
    }

}