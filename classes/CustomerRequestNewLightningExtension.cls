global with sharing class CustomerRequestNewLightningExtension {
    
    
    ApexPages.standardController m_stdController = null;
    public Account theAcc {get;set;}
    public change_request__c cr {get;set;}
    public change_request__c theCR {get;set;} 
    public String theSSCName {get; set;}
    public String theRepName {get; set;}
    public String theRegionName {get; set;}
    public String theClassName {get; set;}
    public String theClassDetails {get; set;}
    public String theTypeName {get; set;}
    public String theAccountName {get; set;}
    public String theAccountNumber {get; set;}
    public String uiTheme {get; set;}
    public String errorLevel {get; set;}
    public String messageName {get; set;}
    public Boolean crossSBU {get; set;}
    public Boolean shipToChage {get; set;}
    public Boolean newShipto {get; set;}
    public Boolean newShiptoAddress {get; set;}
    public Boolean updateCopyBillto {get; set;}
    public Boolean addressChange {get; set;}   
    public Boolean typeChange {get; set;}  
    public Boolean isErrorVisiable {get;set;}
    public static Boolean firstRun = true;
    public Boolean allChange {get; set;}   
    String[] changeType = new String[]{};
    String leadCheckVal = 'Lead';
    String createType = 'update';

    ApexPages.StandardController controller;
    
    public CustomerRequestNewLightningExtension(ApexPages.StandardController controller) {
        this.controller = controller; 
        String type = controller.getRecord().getSObjectType().getDescribe().getName();
        String theSObjectType =  String.valueof(controller.getRecord().getSObjectType());
        String theActualId =  String.valueof(controller.getRecord().get('Id')); 
        String theRecord =  String.valueof(controller.getRecord());
        String theRecordtemp =  theRecord.removeEnd('}');
        String theGenericRecordizerPt1 = theRecordtemp.right(18);            
        String theRecordCheckId = theGenericRecordizerPt1.removeStart('_c=');        
        System.debug('controller: ' + controller);
        System.debug('theRecord: ' + theRecord);
        System.debug('theRecords Type: ' + theSObjectType);        
        System.debug('theRecordCheckId: ' + theRecordCheckId);
        System.debug('theActualId...' + theActualId);        
        theCR = new Change_Request__c();
        String theCRId = '';
        
        isErrorVisiable = true;
        
        if ((theSObjectType == 'Account') && (theActualId != NULL)) {
  
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
                              WHERE ID = :theActualId
                              ];
            System.debug('::::CustomerRequestNewLightningExtension + contoller + the cr + theAcc : ::::> ' + theAcc);            
            
            List<Change_Request__c> listTheCR = [SELECT
                     ID
                     ,NAME
                     ,Account__c
                     ,CreatedDate
                     ,TheID__c
                     FROM Change_Request__c
                     WHERE Account__c = :theAcc.Id
                     order by CreatedDate DESC
                     limit 1
                    ];
             
            theCR = new Change_Request__c();
            System.debug('::::CustomerRequestNewLightningExtension + contoller + the cr + theAcc : ::::> ' + theAcc);
            System.debug('::::CustomerRequestNewLightningExtension + contoller + the cr + theAcc.SSC__c : ::::> ' + theAcc.SSC__c);
            SSC__c theSSC = [SELECT Name, ID FROM SSC__c WHERE ID = :theAcc.SSC__c];
            System.debug('::::CustomerRequestNewLightningExtension + changeAccount + theSSC.Name : ::::> ' + theSSC.Name);   
            Sales_Representative__c theRep = [SELECT Name, ID FROM Sales_Representative__c WHERE ID = :theAcc.Salesman__c];
            System.debug('::::CustomerRequestNewLightningExtension + changeAccount + theRep.Name : ::::> ' + theRep.Name);  
            Region__c theRegion = [SELECT Name, ID FROM Region__c WHERE ID = :theAcc.Region__c];
            System.debug('::::CustomerRequestNewLightningExtension + changeAccount + theRegion.Name : ::::> ' + theRegion.Name);  
            Customer_Class__c theClass = [SELECT Name, ID, Customer_Class_Details__c FROM Customer_Class__c WHERE ID = :theAcc.Customer_Class__c];
            System.debug('::::CustomerRequestNewLightningExtension + changeAccount + theClass.Name : ::::> ' + theClass.Name);  
            Customer_Type__c theType = [SELECT Name, ID FROM Customer_Type__c WHERE ID = :theAcc.Customer_Type__c]; 
            System.debug('::::CustomerRequestNewLightningExtension + changeAccount + theType.Name : ::::> ' + theType.Name);  
            theCR.Sales_Representative__c = theRep.ID;
            theCR.SSC__c = theSSC.ID;
            theCR.Region__c = theRegion.ID;
            theCR.Account__c = theAcc.id;
            theCR.Customer_Class__c = theClass.ID;
            theCR.Customer_Type__c = theType.ID;

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
            if (theAcc.Customer_Class__r.CustClass__c == 'DEL') {
                theCR.Mark_For_Deletion__c = true;
            }
            theCR.PO_Required__c = theAcc.PO_Required__c;            

            theSSCName = theAcc.SSC__r.Name;
            theRepName = theAcc.Salesman__r.Name;
            theRegionName = theAcc.Region__r.Name;
            theClassName = theAcc.Customer_Class__r.Name;
            theClassDetails = theAcc.Customer_Class__r.Customer_Class_Details__c;
            theTypeName = theAcc.Customer_Type__r.Name;
            theAccountName = theAcc.Name;
            theAccountNumber = theAcc.DW_ID__c;
            updateCopyBillto = false;

        } else if ((theSObjectType == 'Change_Request__c') && (theRecordCheckId.startsWith('00Q'))) {

            theAcc = new Account();
            theCR = new Change_Request__c();

        }
    }   

    public PageReference doCheckForUX() {

            System.debug('uiTheme!!!!' + uiTheme);
            if (uiTheme != 'TestTheme3D'){
                uiTheme = UserInfo.getUiTheme();
            }
            System.debug('uiTheme!!!!' + uiTheme);
            if (uiTheme == 'Theme3'){
                                PageReference customerUpdatePage = new PageReference('/apex/CustomerRequestNewClassic');
                                customerUpdatePage.setRedirect(true);
                                return customerUpdatePage;
            } else {
                                PageReference customerUpdatePage = new PageReference('/apex/CustomerRequestNewLightning');
                                customerUpdatePage.setRedirect(true);
                                return customerUpdatePage;                  
            }

        }
    
    public PageReference createCR() {

        String type = controller.getRecord().getSObjectType().getDescribe().getName();
        String theSObjectType =  String.valueof(controller.getRecord().getSObjectType());
        String theActualId =  String.valueof(controller.getRecord().get('Id')); 
        String theRecord =  String.valueof(controller.getRecord());
        String theRecordtemp =  theRecord.removeEnd('}');
        String theGenericRecordizerPt1 = theRecordtemp.right(18);            
        String theRecordCheckId = theGenericRecordizerPt1.removeStart('_c=');     
        System.debug('theRecords Type: ' + theSObjectType);        
        System.debug('theRecordCheckId: ' + theRecordCheckId);
        System.debug('theActualId...' + theActualId);        

        System.debug('MADE IT TO createCR!');
        if (firstRun) {
            firstRun = false;
            if (theSObjectType  == 'Account') {
            
                theAcc = [SELECT ID
                          ,NAME
                          ,GroupKey__c                
                          ,SAP_Account_Id__c                    
                          ,DBA_Name__c
                          ,AccountNumber
                          ,Customer_Base__c
                          ,Customer_Class__c
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
                          ,Website
                          FROM Account 
                          WHERE ID = :theActualId];
            
                //Querying for Record Type Details.
                List < RecordType > rtList = [Select SobjectType, Name, Id From RecordType where SobjectType = 'Change_Request__c'];
                //Querying SSC table for RVP & RSM.
                List < SSC__c > sscList = [select id, Name, RSM__c, RVP__c from SSC__c where id =  : theAcc .SSC__c];
                //Creating new Change request record.
                cr = new change_request__c();
                cr.Account__c = theAcc .id;
                cr.Customer_Base__c = theAcc .Customer_Base__c;
                cr.Suffix__c = theAcc .Customer_Suffix__c;
                cr.Customer_DW_ID__c = theAcc .DW_ID__c;
                cr.Group_Key__c = theAcc .GroupKey__c;                
                cr.SAP_Account_Id__c = theAcc .SAP_Account_Id__c;                
                cr.Bill_Address_1__c = theAcc .BillingStreet;
                cr.Billing_City_Account__c = theAcc .BillingCity;
                cr.Billing_State_Account__c = theAcc .BillingState;
                cr.Bill_Country__c = theAcc .BillingCountry;
                cr.Billing_Zip_Account__c = theAcc .BillingPostalCode;
                cr.Billing_street__c = theAcc .ShippingStreet;
                cr.Billing_city__c = theAcc .ShippingCity;
                cr.Billing_state__c = theAcc .ShippingState;
                cr.Billing_country__c = theAcc .ShippingCountry;
                cr.BILLING_ZIP__C = theAcc .ShippingPostalCode;
                cr.SBU__c = theAcc .SBU__C;
                cr.Phone__c = theAcc .phone;
                cr.fax__c = theAcc .Fax;
                cr.Website__c = theAcc .Website;
                cr.Customer_Class__c = theAcc .Customer_Class__c;
                cr.Customer_Type__c = theAcc .Customer_Type__c;
                cr.Mark_For_Deletion__c = theAcc .Mark_For_Deletion__c;
                cr.PO_Required__c = theAcc.PO_Required__c;
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
                    cr = theCR;
                    //                    PageReference customerUpdatePage = new PageReference('/apex/CustomerChangeRequest?id=' + cr.id);
                    //                    customerUpdatePage.setRedirect(true);
                    //                    return customerUpdatePage;
                    //                    return new ApexPages.StandardController(cr).edit();
                    return null;
                } catch (Exception e) {
                    return null;
                }
            } else {
                return null;
            } 
        } else {
            System.debug('Not first Run...Already ran!');
            //            PageReference acctPage = new ApexPages.StandardController(acct).view();
            //            acctPage.setRedirect(true);
            return null;
        }
    }
    
    
    public Id getRequestedAccount() {
        return theCR.Account__c;
    }
    
    public PageReference doCancel() {
        System.debug('Close the darn window!');
        //       PageReference accRedirect = sforce.one.navigateToSObject('/001/');
        PageReference backToAccounts = new PageReference('/001');
        backToAccounts.setRedirect(true);
        return backToAccounts;                                          
        //                return accRedirect;
        //        return null;
    }
    
    public list<SelectOption> getRecordTypes() {
        list<SelectOption> options = new list<SelectOption>();
        for (list<RecordType> rts : [SELECT ID, 
                                     name 
                                     FROM RecordType 
                                     WHERE SObjectType = 'Account' 
                                     AND Name='Person Account'
                                     ORDER BY name]) {
                                         for (RecordType rt : rts) {
                                             options.add(new SelectOption(rt.ID, rt.Name));
                                         } 
                                     }
        return options;
    }   
    
    public String getColor() { 
    System.debug('entered getColor!!!!' + theCr.Error_Messages__c);
    String errorColor;
        if(theCr.Error_Messages__c != '' && theCr.Error_Messages__c != null && theCr.Error_Messages__c != 'null') {
            System.debug('must have an error!!!!' + theCr.Error_Messages__c);
            errorColor = '#c23934 !important'; 
        } else {
            System.debug('no error error!!!!' + theCr.Error_Messages__c);
            errorColor = 'null';
        }
        theCr.Error_Color__c = errorColor;
        return errorColor;
    }    
        
    
    public String getContextUserUiTheme() {
        uiTheme = UserInfo.getUiTheme();
        return UserInfo.getUiTheme();
    }    

    public PageReference changeAddress() {    
        
        addressChange = theCR.Address_Change__c;
        newShiptoAddress = theCR.ShipTo_Address_Change__c;
        System.debug('::::CustomerRequestNewLightningExtension + changeAddress + addressChange : ::::> ' + addressChange);
        theCR.ShipTo_Address_Change__c = addressChange;
        
        if (addressChange != null){
            theCR.ShipTo_Address_Change__c = addressChange;
        } else if (newShiptoAddress == true ){
            theCR.ShipTo_Address_Change__c = newShiptoAddress;
        }
        
        System.debug('::::CustomerRequestNewLightningExtension + changeAddress + theCR.ShipTo_Address_Change__c : ::::> ' + theCR.ShipTo_Address_Change__c);
        return null;
        
    }
    
    public PageReference changeType() {    
        
        typeChange = theCR.Type_Change__c;
        newShiptoAddress = theCR.ShipTo_Address_Change__c;
        System.debug('::::CustomerRequestNewLightningExtension + changeAddress + addressChange : ::::> ' + addressChange);
        theCR.ShipTo_Address_Change__c = addressChange;
        
        if (addressChange != null){
            theCR.ShipTo_Address_Change__c = addressChange;
        } else if (newShiptoAddress == true ){
            theCR.ShipTo_Address_Change__c = newShiptoAddress;
        }
        
        System.debug('::::CustomerRequestNewLightningExtension + changeAddress + theCR.ShipTo_Address_Change__c : ::::> ' + theCR.ShipTo_Address_Change__c);
        return null;
        
    }    
    public PageReference changeDetails() {    
        
        addressChange = theCR.Address_Change__c;
        allChange = theCR.All_Updates__c;
        newShipto = theCR.New_ShipTo_Request__c;
        crossSBU = theCR.Cross_SBU_Request__c;
        shipToChage = theCR.ShipTo_Address_Change__c;
        typeChange = theCR.Type_Change__c;
        
        if (theCR.All_Updates__c != NULL) {
            theCR.Rep_Change__c = allChange;
            theCR.Class_Change__c = allChange;
            theCR.SSC_Change__c = allChange;
            theCR.Address_Change__c = allChange;
            theCR.ShipTo_Address_Change__c = allChange;
            theCR.Name_Change__c = allChange;
            theCR.Type_Change__c = allChange;
            theCR.Other_Change__c = allChange;
        } 
        return null;       
    }   

    public PageReference changeShipTo() {    
        
        addressChange = theCR.Address_Change__c;
        allChange = theCR.All_Updates__c;
        newShipto = theCR.New_ShipTo_Request__c;
        crossSBU = theCR.Cross_SBU_Request__c;
        shipToChage = theCR.ShipTo_Address_Change__c;
        typeChange = theCR.Type_Change__c;

        if (newShipto != null) {
            theCR.Address_Change__c = newShipto;
            theCR.New_ShipTo_Request__c = newShipto;
            theCR.ShipTo_Address_Change__c = newShipto;
            if ( crossSBU != NULL) {
                theCR.All_Updates__c = crossSBU;
                theCR.Rep_Change__c = crossSBU;
                theCR.Class_Change__c = crossSBU;
                theCR.SSC_Change__c = crossSBU;
                theCR.Name_Change__c = crossSBU;        
                theCR.Type_Change__c = crossSBU;
                theCR.Other_Change__c = crossSBU;
            } 
        } 
    return null;       
    }   
    
    public PageReference changeAccount() {
        
        System.debug('::::CustomerRequestNewLightningExtension + changeAccount + theAcc : ::::> ' + theAcc);
        System.debug('::::CustomerRequestNewLightningExtension + changeAccount + theCR.Id : ::::> ' + theCR.Id);    
        System.debug('::::CustomerRequestNewLightningExtension + changeAccount + theCR.Account__c : ::::> ' + theCR.Account__c);             
        
        theAcc = [SELECT ID
                  ,NAME
                  ,GroupKey__c                
                  ,SAP_Account_Id__c                    
                  ,DBA_Name__c
                  ,AccountNumber
                  ,Customer_Base__c
                  ,Customer_Class__c
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
                  FROM Account 
                  WHERE ID = :theCR.Account__c];
        
        System.debug('::::CustomerRequestNewLightningExtension + changeAccount + theAcc : ::::> ' + theAcc);
        
        
        SSC__c theSSC = [SELECT Name, ID FROM SSC__c WHERE ID = :theAcc.SSC__c];
        System.debug('::::CustomerRequestNewLightningExtension + changeAccount + theSSC.Name : ::::> ' + theSSC.Name);   
        Sales_Representative__c theRep = [SELECT Name, ID FROM Sales_Representative__c WHERE ID = :theAcc.Salesman__c];
        System.debug('::::CustomerRequestNewLightningExtension + changeAccount + theRep.Name : ::::> ' + theRep.Name);  
        Region__c theRegion = [SELECT Name, ID FROM Region__c WHERE ID = :theAcc.Region__c];
        System.debug('::::CustomerRequestNewLightningExtension + changeAccount + theRegion.Name : ::::> ' + theRegion.Name);  
        Customer_Class__c theClass = [SELECT Name, ID, Customer_Class_Details__c FROM Customer_Class__c WHERE ID = :theAcc.Customer_Class__c];
        System.debug('::::CustomerRequestNewLightningExtension + changeAccount + theClass.Name : ::::> ' + theClass.Name);  
        Customer_Type__c theType = [SELECT Name, ID FROM Customer_Type__c WHERE ID = :theAcc.Customer_Type__c]; 
        System.debug('::::CustomerRequestNewLightningExtension + changeAccount + theType.Name : ::::> ' + theType.Name);  
        
        theSSCName = theSSC.Name;
        theRepName = theRep.Name;
        theRegionName = theRegion.Name;
        theClassName = theClass.Name;
        theTypeName = theType.Name;
        theClassDetails = theClass.Customer_Class_Details__c;
        theAccountName = theAcc.Name;
        theAccountNumber = theAcc.DW_ID__c;
        
        LIST<RecordType> rts = [SELECT ID, name 
                                FROM RecordType 
                                WHERE SObjectType = 'Change_Request__c' 
                                AND Name='Customer Update'
                                ORDER BY name];
        
        theCR.Sales_Representative__c = theRep.ID;
        theCR.DBA_Name__c = theAcc.DBA_Name__c;
        theCR.SSC__c = theSSC.ID;
        theCR.Region__c = theRegion.ID;
        theCR.Account__c = theAcc.id;
        theCR.Customer_Base__c = theAcc.Customer_Base__c; 
        theCR.Suffix__c = theAcc.Customer_Suffix__c;
        theCR.Customer_DW_ID__c = theAcc.DW_ID__c;
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
        theCR.SBU__c = theAcc.SBU__C;
        theCR.Phone__c = theAcc.phone;
        theCR.fax__c = theAcc.Fax;
        theCR.Customer_Class__c = theClass.ID;
        theCR.Customer_Type__c = theType.ID;
        if (!rts.isEmpty()){
            theCR.RecordTypeId  =  rts.get(0).Id;
        } else {}

        System.debug('::::CustomerRequestNewLightningExtension + changeAccount + theCR.Region__r.Name : ::::> ' + theCR.Region__r.Name);            
        return null;
    }    
    
    public List<SelectOption> getExisting() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('allChange','All')); 
        options.add(new SelectOption('repChange','Rep ')); 
        options.add(new SelectOption('classChange','Class ')); 
        options.add(new SelectOption('sscChange','SSC ')); 
        options.add(new SelectOption('addressChange','Address ')); 
        options.add(new SelectOption('nameChange','Name '));
        options.add(new SelectOption('shipToChange','New ShipTo'));
        System.debug('options: ' + options );           
        return options; 
    }


    @RemoteAction
    global static String createCR( id updateAccount ){
        System.debug('createrequest updateAccount: ' + updateAccount);  

        String updateAccountId = updateAccount;
        Change_Request__c theCR = new Change_Request__c();        
        Account theAcc = new Account();
        List < RecordType > rtList = [Select SobjectType, Name, Id From RecordType where SobjectType = 'Change_Request__c'];
        theAcc = [SELECT
                    ID
                    ,NAME
                    ,DBA_Name__c
                    ,AccountNumber
                    ,Customer_Base__c
                    ,Customer_Class__c
                    ,Customer_Class__r.Name
                    ,Customer_Class__r.Customer_Class_Details__c
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
                    ,GroupKey__c
                    ,SAP_Account_Id__c
                    ,Website
                    ,Mark_For_Deletion__c
                    ,PO_Required__c
                FROM Account 
                WHERE ID = :updateAccountId        
        ]; 
        System.debug('createrequest theAcc: ' + theAcc);  

        theCR.Account__c = theAcc.id;             
        theCR.Sales_Representative__c = theAcc.Salesman__c;
        theCR.DBA_Name__c = theAcc.DBA_Name__c;
        theCR.SSC__c = theAcc.SSC__c;
        theCR.Region__c = theAcc.Region__c;
        theCR.Customer_Base__c = theAcc.Customer_Base__c;
        theCR.Suffix__c = theAcc.Customer_Suffix__c;
        theCR.Customer_DW_ID__c = theAcc.DW_ID__c;
        theCR.Group_Key__c = theAcc.GroupKey__c;                
        theCR.SAP_Account_Id__c = theAcc.SAP_Account_Id__c;                
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
        theCR.SBU__c = theAcc.SBU__C;
        theCR.Phone__c = theAcc.phone;
        theCR.fax__c = theAcc.Fax;
        theCR.Website__c = theAcc.Website;
        theCR.Customer_Class__c = theAcc.Customer_Class__c;
        theCR.Customer_Type__c = theAcc.Customer_Type__c;
        theCR.Mark_For_Deletion__c = theAcc.Mark_For_Deletion__c;
        theCR.PO_Required__c = theAcc.PO_Required__c;
        theCr.Status__c = 'Creating';
        
        String error;
        
        if (rtList != null && rtList.size() > 0) {
            for (RecordType rt : rtList) {
                if (rt.Name == 'Customer Update') {
                    theCR.RecordTypeId = rt.Id;
                }
            }
        } 
        try {
                insert theCR;
                System.debug('::::createrequest + theCR ' + theCR);
            }   catch (Exception e) {
                    error=e.getMessage();
                    System.debug('::::error creating / updating CR::::> ' + e.getMessage());
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, error));               
            } 
        String theCRId = theCr.id;
        Boolean isErrorVisiable = true;
        String returnValue;
        if (theCRId != null ){
            returnValue = theCRId;
        } else {
            returnValue = error;
        }
        System.debug('::::createrequest + returnValue ' + returnValue);
        return returnValue;
    }                                           
        
    @RemoteAction
    global static String updateCRShipToAddress( String newCRId
                                        ,Boolean updateRep
                                        ,Boolean updateClass
                                        ,Boolean updateSSC   
                                        ,Boolean updateNewShiptoAccount
                                        ,Boolean updateShipto
                                        ,String updateShipToCountryChange
                                        ,String updateShipToAddress1Change
                                        ,String updateShipToAddress2Change
                                        ,String updateShipToCityChange
                                        ,String updateShipToZip
                                        ,String updateShipToState
                                        ,String updateAccount
                                        ){    
        String error;
        List<Change_Request__c> listTheCR = new List<Change_Request__c>();
        if (newCRId != ''){
            
        listTheCR = [SELECT
                     ID
                     ,NAME
                     ,Account__c
                     ,CreatedDate
                     FROM Change_Request__c
                     WHERE id = :newCRId
                     order by CreatedDate DESC
                     limit 1
                    ];
        } else {
            
        listTheCR = [SELECT
                     ID
                     ,NAME
                     ,Account__c
                     ,CreatedDate
                     FROM Change_Request__c
                     WHERE Account__c = :updateAccount
                     order by CreatedDate DESC
                     limit 1
                    ];
        }
        
        for (Change_Request__c theCR:listTheCR) {     
                if(updateShipToCountryChange != '000000000000000' && updateShipToCountryChange != 'false' && updateShipToCountryChange != ''){
                    System.debug('::::updateShipToCountryChange + updateShipToCountryChange ' + updateShipToCountryChange);
                    list<Country__c> listCountryCheck = [
                                                        SELECT
                                                            Id
                                                            , Name
                                                        FROM
                                                            Country__c
                                                        WHERE 
                                                            Name = : updateShipToCountryChange
                    ];
                    if (!listCountryCheck.isEmpty()) {
                        System.debug('::::updateShipToCountryChange + listCountryCheck ' + listCountryCheck); 
                        for(Country__c c : listCountryCheck){
                            theCR.Country_N2__c = updateShipToCountryChange;    
                        }
                    } else{
                        System.debug('::::updateShipToCountryChange + didnt work ' + updateShipToCountryChange); 
                        error = 'Your new ShipTo Country does not match an existing Country.  Please verify the 2 letter Country code.';
                    }
                }
                if(updateShipToAddress1Change != '000000000000000' && updateShipToAddress1Change != 'false' && updateShipToAddress1Change != ''){
                    theCR.Shipping_street__c = updateShipToAddress1Change;
                }
                if(updateShipToAddress2Change != '000000000000000' && updateShipToAddress2Change != 'false' && updateShipToAddress2Change != ''){
                    theCR.Shipping_Address_2__c = updateShipToAddress2Change;
                }
                if(updateShipToCityChange != '000000000000000' && updateShipToCityChange != 'false' && updateShipToCityChange != ''){
                    theCR.Shipping_City__c = updateShipToCityChange;
                }
                if(updateShipToZip != '000000000000000' && updateShipToZip != 'false' && updateShipToZip != ''){
                    theCR.Shipping_Zip_N__c = updateShipToZip;
                }
                if(updateShipToState != '000000000000000' && updateShipToState != 'false' && updateShipToState != ''){
                    list<State__c> listStateCheck = [
                                                        SELECT
                                                            Id
                                                            , Name
                                                        FROM
                                                            State__c
                                                        WHERE 
                                                            Name = : updateShipToState
                    ];
                    if (!listStateCheck.isEmpty()) {
                        for(State__c s : listStateCheck){
                            theCR.Shipping_State_N2__c = updateShipToState;
                        }
                    } else {
                        System.debug('::::updateShipToCountryChange + didnt work ' + updateShipToState); 
                        error = 'Your new ShipTo State does not match an existing State.  Please verify the 2 letter State code.';
                    }
                }
                if (updateRep == false && updateClass == false && updateSSC == false && updateNewShiptoAccount == false){
//                    theCr.Status__c = 'Submitted to Support Team';                
                }
                theCr.ShipTo_Address_Change__c = updateShipto;
                Boolean isErrorVisiable = true;

            try {
                    update theCR;
                    System.debug('::::updateRecords + theCR ' + theCR);
                }   catch (Exception e) {
                    error=e.getMessage();
                    System.debug('::::error creating / updating CR::::> ' + e.getMessage());
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, error));
                } 
        }
        return error;
    }

    @RemoteAction
    global static String updateCRBillToAddress( String newCRId
                                        ,Boolean updateRep
                                        ,Boolean updateClass
                                        ,Boolean updateSSC   
                                        ,Boolean updateNewShiptoAccount
                                        ,Boolean updateBillTo
                                        ,String updateBillToCountryChange
                                        ,String updateBillToAddress1Change
                                        ,String updateBillToAddress2Change
                                        ,String updateBillToCityChange
                                        ,String updateBillToZip
                                        ,String updateBillToState
                                        ,Boolean updateCopyBillto
                                        ,String updateAccount
                                        ){    
        String error;
        List<Change_Request__c> listTheCR = new List<Change_Request__c>();
        if (newCRId != ''){
            
        listTheCR = [SELECT
                     ID
                     ,NAME
                     ,Account__c
                     ,CreatedDate
                     FROM Change_Request__c
                     WHERE id = :newCRId
                     order by CreatedDate DESC
                     limit 1
                    ];
        } else {
            
        listTheCR = [SELECT
                     ID
                     ,NAME
                     ,Account__c
                     ,CreatedDate
                     FROM Change_Request__c
                     WHERE Account__c = :updateAccount
                     order by CreatedDate DESC
                     limit 1
                    ];
        }
        
        for (Change_Request__c theCR:listTheCR) {     
                if(updateBillToCountryChange != '000000000000000' && updateBillToCountryChange != 'false' && updateBillToCountryChange != ''){
                    System.debug('::::updateBillToCountryChange + updateBillToCountryChange ' + updateBillToCountryChange);
                    list<Country__c> listCountryCheck = [
                                                        SELECT
                                                            Id
                                                            , Name
                                                        FROM
                                                            Country__c
                                                        WHERE 
                                                            Name = : updateBillToCountryChange
                    ];
                    if (!listCountryCheck.isEmpty()) {
                        System.debug('::::updateBillToCountryChange + listCountryCheck ' + listCountryCheck); 
                        for(Country__c c : listCountryCheck){
                            theCR.Bill_Country_N__c = updateBillToCountryChange;    
                        }
                    } else{
                        System.debug('::::updateBillToCountryChange + didnt work ' + updateBillToCountryChange); 
                        error = 'Your new BillTo Country does not match an existing Country.  Please verify the 2 letter Country code.';
                    }
                }
                if(updateBillToAddress1Change != '000000000000000' && updateBillToAddress1Change != 'false' && updateBillToAddress1Change != ''){
                    theCR.Billing_Street_N__c = updateBillToAddress1Change;
                }
                if(updateBillToAddress2Change != '000000000000000' && updateBillToAddress2Change != 'false' && updateBillToAddress2Change != ''){
                    theCR.Address2__c = updateBillToAddress2Change;
                }
                if(updateBillToCityChange != '000000000000000' && updateBillToCityChange != 'false' && updateBillToCityChange != ''){
                    theCR.Billing_City_N__c = updateBillToCityChange;
                }
                if(updateBillToZip != '000000000000000' && updateBillToZip != 'false' && updateBillToZip != ''){
                    theCR.Billing_Zip_N__c = updateBillToZip;
                }
                if(updateBillToState != '000000000000000' && updateBillToState != 'false' && updateBillToState != ''){
                    list<State__c> listStateCheck = [
                                                        SELECT
                                                            Id
                                                            , Name
                                                        FROM
                                                            State__c
                                                        WHERE 
                                                            Name = : updateBillToState
                    ];
                    if (!listStateCheck.isEmpty()) {
                        for(State__c s : listStateCheck){
                            theCR.Billing_State_N2__c = updateBillToState;
                        }
                    } else {
                        System.debug('::::updateBillToStateChange + didnt work ' + updateBillToState); 
                        error = 'Your new BillTo State does not match an existing State.  Please verify the 2 letter State code.';
                    }
                }               
                if(updateCopyBillto != false){
                    theCR.Copy_Bill_To_Address__c = updateCopyBillto;
                }
                if (updateRep == false && updateClass == false && updateSSC == false && updateNewShiptoAccount == false){
                    theCr.Status__c = 'Submitted to Support Team';                
                }
                theCr.BillTo_Address_Change__c= updateBillTo;
                Boolean isErrorVisiable = true;

            try {
                    update theCR;
                    System.debug('::::updateRecords + theCR ' + theCR);
                }   catch (Exception e) {
                    error=e.getMessage();
                    System.debug('::::error creating / updating CR::::> ' + e.getMessage());
                    System.debug('::::deleting theCR ' + theCR);
                    delete theCr;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, error));
                } 
        }
        return error;
    }


    public void showMessage() {
        if(errorLevel == 'ERROR') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, messageName));
        }
    } 
    
    @RemoteAction
    global static String updateCRUpdates( String newCRId
                                                    ,Boolean updateAll
                                                    ,Boolean updateRep
                                                    ,Boolean updateClass
                                                    ,Boolean updateSSC
                                                    ,Boolean updateAddress
                                                    ,Boolean updateName
                                                    ,Boolean updateType
                                                    ,Boolean updateOther
                                                    ,Boolean updateNewShiptoAccount
                                                    ,Boolean updateNewExtendShipTo        
                                                    ){
        String error;  
        System.debug('updateCRUpdates --->'
                    + 'newCRId:' + newCRId + ', '
                    + 'updateAll:' + updateAll + ', '
                    + 'updateClass:' + updateClass + ', '
                    + 'updateSSC:' + updateSSC + ', '
                    + 'updateAddress:' + updateAddress + ', '
                    + 'updateName:' + updateName + ', '
                    + 'updateType:' + updateType + ', '
                    + 'updateOther:' + updateOther + ', '
                    + 'updateNewShiptoAccount:' + updateNewShiptoAccount + ', '
                    + 'updateNewExtendShipTo:' + updateNewExtendShipTo + ', '
                    );
        
        List<Change_Request__c> listTheCR = new List<Change_Request__c>();

        listTheCR = [SELECT
                     ID
                     ,NAME
                     ,Account__c
                     ,CreatedDate
                     ,Status__c
                     FROM Change_Request__c
                     WHERE id = :newCRId
                     order by CreatedDate DESC
                     limit 1
                    ];

        for (Change_Request__c theCR : listTheCR) {   
            System.debug('updateRecords + theCR --->' + theCR);
            theCR.All_Updates__c = updateAll;
            theCR.Rep_Change__c = updateRep;
            theCR.Class_Change__c = updateClass;
            theCR.SSC_Change__c = updateSSC;
            theCR.Address_Change__c = updateAddress;
            theCR.Name_Change__c = updateName;
            theCR.Type_Change__c = updateType;
            theCR.Other_Change__c = updateOther;
            theCR.New_ShipTo_Request__c = updateNewShiptoAccount;
            theCR.Cross_SBU_Request__c = updateNewExtendShipTo;

            if (updateRep == false && updateClass == false && updateSSC == false && updateNewShiptoAccount == false && updateAddress == false && updateOther == false && updateType == false){
                theCr.Status__c = 'Submitted to Support Team';                
            }

			Boolean isErrorVisiable = true;
             try {
                    update theCR;
                    System.debug('::::updateRecords + theCR ' + theCR);
                }   catch (Exception e) {
                    error=e.getMessage();
                    System.debug('::::error creating / updating CR::::> ' + e.getMessage());
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, error));
                } 
        }
        return error;
    }                                           
    
    @RemoteAction
    global static String updateCROptions( String newCRId
                                    	,String updateNewShipToReason
                                    	,String updateNameChange
                                    	,String updateDBANameChange
                                    	,String updateNewRegion
                                    	,String updateNewRep
                                    	,String updateNewSSC
                                    	,String updateNewCusClass
                                    	,String updateNewReasonForClass
                                    	,String updateNewCusType         
                                    	){

    	System.debug('updateRecords --->'
    	+ 'updateNameChange:' + updateNameChange + ', '
    	+ 'updateDBANameChange:' + updateDBANameChange + ', '
    	+ 'updateNewRegion:' + updateNewRegion + ', '
    	+ 'updateNewRep:' + updateNewRep + ', '
    	+ 'updateNewSSC:' + updateNewSSC + ', '
    	+ 'updateNewCusClass:' + updateNewCusClass + ', '
    	+ 'updateNewReasonForClass:' + updateNewReasonForClass + ', '
    	+ 'updateNewCusType:' + updateNewCusType
    	);
    
    	String error; 
    	String updateNewRegionId = updateNewRegion;
    	String updateNewRepId = updateNewRep;
    	String updateNewSSCId = updateNewSSC;
    	String updateCustomerClassId = updateNewCusClass;
    	String updateNewCusTypeId = updateNewCusType;
    
    	List<Change_Request__c> listTheCR = new List<Change_Request__c>();
    
    	listTheCR = [SELECT
    					ID
    					,NAME
    					,Account__c
    					,CreatedDate
    					,Status__c
    				FROM Change_Request__c
    				WHERE id = :newCRId
    				order by CreatedDate DESC
    				limit 1
    	];
    
    	for (Change_Request__c theCR : listTheCR) {   
    		System.debug('updateRecords + theCR --->' + theCR);
    		theCR.Reason_for_New_Suffix__c = updateNewShipToReason;
    		if (updateNameChange != '' && updateNameChange != NULL){
    			theCR.Customer_Name_Change__c = updateNameChange;     
    		}
    		if (updateDBANameChange != '' && updateDBANameChange != NULL){
    			theCR.DBA_Name_Change__c = updateDBANameChange;     
    		}
    		if (updateNewRegionId != '000000000000000' && updateNewRegionId != 'false' && updateNewRegionId != ''){
    			theCR.Region_n__c = updateNewRegionId;     
    		}
    		if (updateNewRepId != '000000000000000' && updateNewRepId != 'false' && updateNewRepId != ''){
    			theCR.Sales_Representative_n__c = updateNewRepId; 
    		}
    		if (updateNewSSCId != '000000000000000' && updateNewSSCId != 'false' && updateNewSSCId != ''){
    			theCR.SSC_N__c = updateNewSSCId; 
    		}
    		if (updateCustomerClassId != '000000000000000' && updateCustomerClassId != 'false' && updateCustomerClassId != ''){
    			theCR.Customer_Class_N__c = updateCustomerClassId; 
    		}
    		if (updateNewReasonForClass != '000000000000000' && updateNewReasonForClass != 'false'){
    			theCR.Business_Reason__c = updateNewReasonForClass; 
    		}
    		if (updateNewCusTypeId != '000000000000000' && updateNewCusTypeId != 'false' && updateNewCusTypeId != ''){
    			theCR.Customer_Type_N__c = updateNewCusTypeId; 
    		}
    		Boolean isErrorVisiable = true;
    		try {
    			update theCR;
    			System.debug('::::updateRecords + theCR ' + theCR);
    		}   catch (Exception e) {
    			error=e.getMessage();
    			System.debug('::::error creating / updating CR::::> ' + e.getMessage());
    			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, error));
    		} 
    	}
         return error;
    }                                           
    
    @RemoteAction
    global static String updateCRDetails( String newCRId
                                        , String updateContact
                                        , String updatePhone
                                        , String updateFax
                                        , String updateAccount
                                        , String updateComments
                                        ) {
        System.debug('updateRecords --->'
            + 'newCRId:' + newCRId + ', '
            + 'updateContact:' + updateContact + ', '
            + 'updatePhone:' + updatePhone + ', '
            + 'updateFax:' + updateFax + ', '
            + 'updateComments:' + updateComments + ', '            
            );
        String error;       
        List<Change_Request__c> listTheCR = new List<Change_Request__c>();
            
        listTheCR = [SELECT
                     ID
                     ,NAME
                     ,Account__c
                     ,CreatedDate
                     ,Status__c
                     ,All_Updates__c
                     ,SSC_Change__c
                     ,Rep_Change__c
                     ,Class_Change__c
                     ,Address_Change__c
                     ,Name_Change__c
                     ,New_ShipTo_Request__c
                     ,Cross_SBU_Request__c
                     ,Workflow_required__c
                     ,Comments__c
                     ,Other_Change__c
                     ,Type_Change__c
                     FROM Change_Request__c
                     WHERE id = :newCRId
                     order by CreatedDate DESC
                     limit 1
                    ];

        for (Change_Request__c theCR:listTheCR) {
            System.debug('::::updateCRDetails + theCR 1' + theCR);
            Boolean updateAll = theCR.All_Updates__c;
            Boolean updateRep = theCR.Rep_Change__c;
            Boolean updateClass = theCR.Class_Change__c;
            Boolean updateSSC = theCR.SSC_Change__c;
            Boolean updateAddress = theCR.Address_Change__c;
            Boolean updateName = theCR.Name_Change__c;
            Boolean updateNewShiptoAccount = theCR.New_ShipTo_Request__c;
            Boolean updateNewExtendShipTo = theCR.Cross_SBU_Request__c;
            Boolean updateType = theCR.Type_Change__c;
            Boolean updateOther = theCR.Other_Change__c;
            if ( theCr.Status__c == 'Creating') {
                if (updateContact != '' && updateContact != 'false'){
                    theCR.Contact__c = updateContact;
                }
                if (updatePhone != '' && updatePhone != 'false'){
                    theCr.Ship_To_Phone__c = updatePhone;
                }
                if (updateFax != '' && updateFax != 'false'){
                    theCr.Fax_N__c = updateFax;
                }            
                theCr.Comments__c = updateComments;
                if (updateRep == false && updateClass == false && updateSSC == false && updateNewShiptoAccount == false && updateAddress == false){
                    theCr.Status__c = 'Submitted to Support Team';       
                    theCr.Workflow_required__c = 'Yes';
                } else {
                    theCr.Status__c = 'Submitting for Approval';       
                    theCr.Workflow_required__c = 'Yes';     
                }
                
                Boolean isErrorVisiable = true;
                try {
                        update theCR;
                        System.debug('::::updateCRDetails + theCR ' + theCR);
                    }   catch (Exception e) {
                        error=e.getMessage();
                        System.debug('::::error updateCRDetails::::> ' + e.getMessage());
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, error));
                    } 
                
            }
        }
        return error;
    }   

    @RemoteAction
    global static String deleteCR( String newCRId) {
        System.debug('deleteCR --->'
            + 'newCRId:' + newCRId);
        String error;
        List<Change_Request__c> listTheCR = new List<Change_Request__c>();
        if (newCRId != ''){           
	        listTheCR = [SELECT
	                     ID
	                     ,NAME
	                     ,Account__c
	                     ,CreatedDate
	                     FROM Change_Request__c
	                     WHERE id = :newCRId
	                     order by CreatedDate DESC
	                     limit 1
	                    ];
        }        
        Approval.UnlockResult[] urList = Approval.unlock(listTheCR, false);

        // Iterate through each returned result
        for(Approval.UnlockResult ur : urList) {
            if (ur.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully unlocked cr with ID: ' + ur.getId());
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : ur.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('cr fields that affected this error: ' + err.getFields());
                }
            }
        }        
        
        for (Change_Request__c theCR:listTheCR) {
            try {
                    delete theCR;
                    System.debug('::::delete + theCR ' + theCR);
                }   catch (Exception e) {
                    error=e.getMessage();
                    System.debug('::::error delete + ::::> ' + e.getMessage());
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, error));
                } 
        }
        return error;
    }   

    @RemoteAction
    global static String saveNewCustomer( String updateName
                                        ,String updateContact
                                        ,String updatePhone
                                        ,String updateFax
                                        ,String updateComments
                                    	,String updateDBAName
                                    	,String updateWebsite
                                    	,String updateNewRegion
                                    	,String updateNewRep
                                    	,String updateNewSSC
                                    	,String updateNewCusClass
                                    	,String updateNewReasonForClass
                                    	,String updateNewCusType
                                        ,String updateShipToCountryChange
                                        ,String updateShipToAddress1Change
                                        ,String updateShipToAddress2Change
                                        ,String updateShipToCityChange
                                        ,String updateShipToZip
                                        ,String updateShipToState  
                                        ,String updateBillToCountryChange
                                        ,String updateBillToAddress1Change
                                        ,String updateBillToAddress2Change
                                        ,String updateBillToCityChange
                                        ,String updateBillToZip
                                        ,String updateBillToState
                                        ,Boolean updateCopyBillto
                                        ,Boolean updateContactProExch
                                        ,String updateContactFirstName
                                        ,String updateContactLastName
                                        ,String updateContactPhone
                                        ,String updateContactEmail
                                    	){
        System.debug('::::saveNewCustomer');
        String error;
        String theCRId;
        String returnValue;
        Change_Request__c cr = new Change_Request__c();
                 LIST<RecordType> rts = [SELECT ID, name 
                                        FROM RecordType 
                                        WHERE SObjectType = 'Change_Request__c' 
                                        AND Name='New Customer Request'
                                        ORDER BY name];            
        if (!rts.isEmpty()){
            cr.RecordTypeId  =  rts.get(0).Id;
        } 
        
        cr.Customer_Name__c = updateName;
        cr.Contact__c = updateContact;
        cr.Phone_N__c = updatePhone;
        cr.fax__c = updateFax;
        cr.Comments__c = updateComments;
        cr.DBA_Name__c = updateDBAName;
        cr.Website__c = updateWebsite;
        cr.Region__c = updateNewRegion;
        cr.Sales_Representative__c = updateNewRep;
        cr.SSC__c = updateNewSSC;
        cr.Customer_Class__c = updateNewCusClass;
        cr.Business_Reason__c = updateNewReasonForClass;
        cr.Customer_Type__c = updateNewCusType;
        cr.Country_N2__c = updateShipToCountryChange;
        cr.Billing_Street__c = updateShipToAddress1Change;
        cr.Shipping_Address_2__c = updateShipToAddress2Change;
        cr.Billing_City__c = updateShipToCityChange;
        cr.Shipping_Zip_N__c = updateShipToZip;
        cr.Shipping_State_N2__c = updateShipToState;
        cr.Bill_Country_N__c = updateBillToCountryChange;
        cr.Billing_Street_N__c = updateBillToAddress1Change;
        cr.Address2__c = updateBillToAddress2Change;
        cr.Billing_City_N__c = updateBillToCityChange;
        cr.Billing_Zip_N__c = updateBillToZip;
        cr.Billing_State_N2__c = updateBillToState;
        cr.Copy_Bill_To_Address__c = updateCopyBillto;
        cr.Set_Up_In_ProExchange__c = updateContactProExch;
        cr.Contact_First_Name__c = updateContactFirstName;
        cr.Contact_Last_Name__c = updateContactLastName;
        cr.Contact_Phone__c = updateContactPhone;
        cr.Contact_Email__c = updateContactEmail;

        cr.Status__c = 'Submitting for Approval';

        System.debug('::::updateCRDetails + theCR ' + cr);
        try {
            insert cr;
            System.debug('::::updateCRDetails + theCR ' + cr);
            if (cr != null) {
                theCRId = cr.id;
                // ChangeRequestGateway.autoSubUpdate(cr);
                PageReference crPage = new ApexPages.StandardController(cr).view();
                crPage.setRedirect(true);
                return cr.id;  
            }
        }   catch (Exception e) {
            error=e.getMessage();
            System.debug('::::error updateCRDetails::::> ' + e.getMessage());
        } 
        
        if (theCRId != null ){
            returnValue = theCRId;
        } else {
            returnValue = error;
        }
        System.debug('::::createrequest + returnValue ' + returnValue);
        
    return returnValue;
    }

    public PageReference saveNewRequestData(){
        System.debug('::::saveData');
        String error;
        Change_Request__c cr = new Change_Request__c();
                 LIST<RecordType> rts = [SELECT ID, name 
                                        FROM RecordType 
                                        WHERE SObjectType = 'Change_Request__c' 
                                        AND Name='Customer Update'
                                        ORDER BY name];            
        if (!rts.isEmpty()){
            cr.RecordTypeId  =  rts.get(0).Id;
        } 
        
        cr.Account__c = theCR.Account__c;             
        cr.Sales_Representative__c = theCR.Sales_Representative__c;
        cr.DBA_Name__c = theCR.DBA_Name__c;
        cr.SSC__c = theCR.SSC__c;
        cr.Region__c = theCR.Region__c;
        cr.Customer_Base__c = theCR.Customer_Base__c;
        cr.Suffix__c = theCR.Suffix__c;
        cr.Customer_DW_ID__c = theCR.Customer_DW_ID__c;
        cr.Group_Key__c = theCR.Group_Key__c;                
        cr.SAP_Account_Id__c = theCR.SAP_Account_Id__c;                
        cr.Bill_Address_1__c = theCR.Bill_Address_1__c;
        cr.Billing_City_Account__c = theCR.Billing_City_Account__c;
        cr.Billing_State_Account__c = theCR.Billing_State_Account__c;
        cr.Bill_Country__c = theCR.Bill_Country__c;
        cr.Billing_Zip_Account__c = theCR.Billing_Zip_Account__c;
        cr.Address3__c = theCR.Address3__c;
        cr.Billing_street__c = theCR.Billing_street__c;
        cr.Billing_city__c = theCR.Billing_city__c;
        cr.Billing_state__c = theCR.Billing_state__c;
        cr.Billing_country__c = theCR.Billing_country__c;
        cr.BILLING_ZIP__C = theCR.BILLING_ZIP__C;
        cr.SBU__c = theCR.SBU__C;
        cr.Phone__c = theCR.Phone__c;
        cr.fax__c = theCR.fax__c;
        cr.Website__c = theCR.Website__c;
        cr.Customer_Class__c = theCR.Customer_Class__c;
        cr.Customer_Type__c = theCR.Customer_Type__c;
        cr.Mark_For_Deletion__c = theCR.Mark_For_Deletion__c;
        cr.PO_Required__c = theCR.PO_Required__c;   

        try {
            if (error != null){
                    System.debug('::::tried to submit but there was an error + error ' + error);
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, error));   
            } else {
                insert cr;
                System.debug('::::updateCRDetails + theCR ' + cr);
                if (cr != null) {
                    ChangeRequestGateway.autoSubUpdate(cr);
                    PageReference crPage = new ApexPages.StandardController(cr).view();
                    crPage.setRedirect(true);
                    return crPage;  
                }
            }            
        }   catch (Exception e) {
            error=e.getMessage();
            System.debug('::::error updateCRDetails::::> ' + e.getMessage());
        } 
    return null;  
    }        
    
    @RemoteAction
    global static List<Region__c> queryRegions(String keyword) {
        List<Region__c> regionList = new List<Region__c>();
        if (keyword != null && keyword.trim() != '') {
            keyword = '%' + keyword + '%';
            regionList = [Select Id, DW_ID__c, Name 
                            from Region__c 
                            WHERE Select__c = TRUE
                            AND (Name like :keyword 
                            OR DW_ID__c LIKE :keyword )
                            limit 5];
        }
        System.debug('::::regionList::::> ' + regionList);
        return regionList;
    }       
    @RemoteAction
    global static List<Sales_Representative__c> queryReps(String keyword) {
        List<Sales_Representative__c> repList = new List<Sales_Representative__c>();
        if (keyword != null && keyword.trim() != '') {
            keyword = '%' + keyword + '%';
            repList = [Select Id, Name, DW_ID__c 
                        from Sales_Representative__c 
                        WHERE Select__c = 'TRUE'
                        AND (Name like :keyword 
                        OR DW_ID__c LIKE :keyword )
                        limit 5];
        }
        System.debug('::::regionList::::> ' + repList);
        return repList;
    }  
    @RemoteAction
    global static List<SSC__c> querySSC(String keyword) {
        List<SSC__c> sscList = new List<SSC__c>();
        if (keyword != null && keyword.trim() != '') {
            keyword = '%' + keyword + '%';
            sscList = [Select Id
                            , Name
                            , DW_ID__c 
                            , Select__c
                        from SSC__c 
                        WHERE Select__c = true
                        AND Closed__c = false
                        AND (Name like :keyword 
                        OR DW_ID__c LIKE :keyword )
                        limit 5];
        }
        System.debug('::::sscList::::> ' + sscList);
        return sscList;
    }  
    @RemoteAction
    global static List<Customer_Class__c> queryClass(String keyword) {
        List<Customer_Class__c> classList = new List<Customer_Class__c>();
        if (keyword != null && keyword.trim() != '') {
            keyword = '%' + keyword + '%';
            classList = [Select Id
                            , Name
                            , Customer_Class_Details__c 
                            from Customer_Class__c  
                            WHERE Active__c = TRUE
                            AND (Name like :keyword 
                            OR Customer_Class_Details__c LIKE :keyword 
                            OR CustClass__c LIKE : keyword)
                            limit 5];
        }
        System.debug('::::classList::::> ' + classList);
        return classList;
    }  
    @RemoteAction
    global static List<Customer_Type__c> queryType(String keyword) {
        List<Customer_Type__c> typeList = new List<Customer_Type__c>();
        if (keyword != null && keyword.trim() != '') {
            keyword = '%' + keyword + '%';
            typeList = [Select Id, Name, Cust_Type__c from Customer_Type__c  
                            WHERE Active__c = TRUE
                            AND Name like :keyword 
                            limit 10];
        }
        System.debug('::::typeList::::> ' + typeList);
        return typeList;
    }  
}