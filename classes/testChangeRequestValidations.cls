@ isTest
public class testChangeRequestValidations {
    
    static PageReference pageRef1; 
    static CustomerRequestNewLightningExtension con;
    static map <Id, Change_Request__c> crMap;
    public boolean hasErrors {get;set;}
    public boolean updateCopyBillto {get;set;}
    
    @testSetup static void setup() {

        // Test Users
        Profile pAdmin = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        UserRole rMGR = [SELECT Id, Name FROM UserRole WHERE Name = 'MW SSC Manager'];   
        String aUser = [Select Id, Name, Alias from User where ProfileId = :pAdmin.Id AND LastName != 'Rust' AND IsActive = TRUE limit 1].ID; 
        User uMGR = [SELECT ID, Name FROM User where UserRoleID =  : rMGR.Id AND IsActive = TRUE LIMIT 1];       
        
        // COUNTRY        
        Country__c cnt = new Country__c (name = 'US');
        insert cnt;
                                         
        // COUNT...  I Mean State (or republic of...)
        State__c st = new State__c (name = 'TX');
        insert st;
        
        // REGIONS
        LIST <Region__c> rLIst = new LIST <Region__c>();
        rLIst = [SELECT ID
                , Name
                , DW_ID__C
                FROM Region__c
                LIMIT 5];
 
        System.debug('::::testChangeRequestValidations + Region__c::::> ' + rLIst);
        
        // Region__c r = new Region__c(Select__c = true
        //                              , SBU__c = 'SC'
        //                              , DW_ID__c = '01'
        //                              , Name = 'SOUTHERN CA REGION');
        // insert r;

        Region__c r = new Region__c(Select__c = true
                                     , SBU__c = 'SC'
                                     , DW_ID__c = '66'
                                     , Name = 'TEXAS REGION');
        insert r;
        
        Region__c rAO = new Region__c(Select__c = true
                                     , SBU__c = 'DI'
                                     , DW_ID__c = '41'
                                     , Name = 'AOMZ West');
        insert rAO;        
        
        // CUSTOMER CLASS
        
        Customer_Class__c cc = new Customer_Class__c(Active__c = true
                                                     , COS__c = 111
                                                     , CustClass__c = 'S4Q'
                                                     , Cust_Count__c = 123
                                                     , Customer_Class_Details__c = 'TEST THIS'
                                                     , CustomerCountry__c = 'US'
                                                     , CustomerSBU__c = 'SC'
                                                     , Duplicate__c = false
                                                     , Net_Sales__c = 111
                                                     , Price_Region__c = r.Id
                                                     , PPS_Rgn__c = 'SC');
        insert cc;
        
        Customer_Class__c ccAO = new Customer_Class__c(Active__c = true
                                                      , COS__c = 111
                                                      , CustClass__c = 'S8Q'
                                                      , Cust_Count__c = 123
                                                      , Customer_Class_Details__c = 'TEST THIS'
                                                      , CustomerCountry__c = 'US'
                                                      , CustomerSBU__c = 'DI'
                                                      , Duplicate__c = false
                                                      , Net_Sales__c = 111
                                                      , Price_Region__c = rAO.Id
                                                      , PPS_Rgn__c = 'AO WCNSSC');
        insert ccAO;
        
        // SSC
        
        SSC__c ssc = new SSC__c(Closed__c = false
                                , DW_ID__c = '000111'    
                                , Loc_Type__c = 'SSC'
                                , Manager__c = UserInfo.getUserId()
                                , Region__c = r.Id
                                , ROM__c = UserInfo.getUserId()
                                , RSM__c = UserInfo.getUserId()
                                , RVP__c = UserInfo.getUserId()     
                                , Sales_Region__c = '04'
                                , SBU__c = 'DI'
                                , Select__c = true
                                , SSC_Fax_Number__c = '123-345-5567'
                                , SSC_Phone_Number__c = '123-345-5567'
                                , State__c = 'TX'
                                , Street_Address__c = '12345 1st street'
                                , Zip_Code__c = '12345');
        insert ssc;
        
        SSC__c sscAO = new SSC__c(Closed__c = false
                                 , DW_ID__c = '000112'
                                 , Loc_Type__c = 'SSC'
                                 , Manager__c = Null
                                 , Region__c = rAO.Id
                                 , ROM__c = Null
                                 , RSM__c = Null
                                 , RVP__c = Null
                                 , Sales_Region__c = '41'
                                 , SBU__c = 'DI'
                                 , Select__c = true
                                 , SSC_Fax_Number__c = '123-345-5567'
                                 , SSC_Phone_Number__c = '123-345-5567'
                                 , State__c = 'TX'
                                 , Street_Address__c = '12345 1st street'
                                 , Zip_Code__c = '12345');
        insert sscAO;                

        // CUSTOMER TYPE
        
        Customer_Type__c ct = new Customer_Type__c(Active__c = true
                                                   , Select__c = true
                                                   , SBU__c = 'SC'
                                                   , Region__c = r.Id);
        insert ct;
        
        Customer_Type__c ctAO = new Customer_Type__c(Active__c = true
                                                    , Select__c = true
                                                    , SBU__c = 'DI'
                                                    , Region__c = rAO.Id);
        insert ctAO;
                
        // SALES REPS
        
        Sales_Representative__c sr = new Sales_Representative__c(SBU__c = 'SC'
                                                                 , DW_ID__c = '07'
                                                                 , Region__c = r.Id);
        insert sr;
        
        Sales_Representative__c srAO = new Sales_Representative__c(SBU__c = 'DI'
                                                                  , DW_ID__c = '97'
                                                                  , Region__c = rAO.Id);
        insert srAO;
        
        Account a = new Account( NAME = 'Test Dal Account 1'
                                ,DBA_Name__c = 'Test Dal Account 1'
                                ,AccountNumber = '123'
                                ,Customer_Base__c = '123'
                                ,Customer_Class__c = cc.id
                                ,phone = '214-111-1111'
                                ,Customer_Type__c = ct.id
                                ,DW_ID__c = '123'
                                ,Fax = '214-111-1111'
                                ,Require_PO__c = true
                                ,Region__c = r.id
                                ,Salesman__c = sr.id
                                ,SSC__c = ssc.id
                                ,Customer_Suffix__c = '123'
                                ,BillingStreet = '123 st'
                                ,BillingCity = 'bill city'
                                ,BillingState = 'TX'
                                ,BillingPostalCode  = '75218'
                                ,BillingCountry = 'us'
                                ,ShippingStreet = '123 st'
                                ,ShippingCity = 'ship city'
                                ,ShippingState = 'TX'
                                ,ShippingPostalCode  = '75218'
                                ,ShippingCountry = 'US'
                                ,Mark_For_Deletion__c = FALSE
                                ,SBU__C = 'SC'
                                ,ownerID = uMGR.id
        ); 
        
        try {
            insert a;
            System.debug('::::testChangeRequestValidations + insert a::::> ' + a);
        }   catch (Exception e) {
            System.debug('::::testChangeRequestValidations + insert a::::> ' + e.getMessage());
        }           

        Account aDUPE = new Account( NAME = 'Test Dal Account 2'
                                ,DBA_Name__c = 'Test Dal Account 2'
                                ,AccountNumber = '1234'
                                ,Customer_Base__c = '1234'
                                ,Customer_Suffix__c  = '001'
                                ,Customer_Class__c = cc.id
                                ,phone = '214-111-1111'
                                ,Customer_Type__c = ct.id
                                ,DW_ID__c = '1234'
                                ,Fax = '214-111-1111'
                                ,Require_PO__c = true
                                ,Region__c = r.id
                                ,Salesman__c = sr.id
                                ,SSC__c = ssc.id
                                ,BillingStreet = '123 st'
                                ,BillingCity = 'bill city'
                                ,BillingState = 'TX'
                                ,BillingPostalCode  = '75218'
                                ,BillingCountry = 'us'
                                ,ShippingStreet = '123 st'
                                ,ShippingCity = 'ship city'
                                ,ShippingState = 'TX'
                                ,ShippingPostalCode  = '75218'
                                ,ShippingCountry = 'US'
                                ,Mark_For_Deletion__c = FALSE
                                ,SBU__C = 'SC'
                                ,PO_Required__c = true
        ); 
        
        try {
                insert aDUPE;
        }   catch (Exception e) {
            System.debug('::::testChangeRequestValidations + insert aDUPE::::> ' + e.getMessage());
        } 
        
        Change_Request__c cr = new Change_Request__c(SBU__c = 'SC'
                                                        , Account__c = a.id
                                                       , IsNew__c = false
                                                       , Reason_for_New_Suffix__c = 'cause'
                                                       , Customer_Class_n__c = ccAO.id
                                                       , Business_Reason__c = 'TEST'
                                                       , Sales_Representative__c = sr.Id
                                                       , Sales_Representative_n__c = srAO.id
                                                       , Customer_Class__c = cc.Id
                                                       , Customer_Type__c = ct.Id
                                                       , Customer_Type_n__c = ctAO.Id
                                                       , RecordTypeId = Label.CR_Customer_Update_RT
                                                       , SSC__c = ssc.Id
                                                       , SSC_N__c = sscAO.id
                                                       , Name__c = 'new'
                                                       , Ship_To_Phone__c = '(972) 489-4406'
                                                       , Fax__c = '(972) 489-4406'
                                                       , Region__c = r.Id
                                                       , Region_n__c = rAO.id
                                                       , Status__c = 'Submitted for Approval');            
        
        // Change_Request__c crDUPE = new Change_Request__c(SBU__c = 'SC'
        //                                                 , Account__c = aDUPE.id
        //                                                 , DBA_Name__c = aDUPE.DBA_Name__c
        //                                                 , Customer_Base__c = aDUPE.Customer_Base__c
        //                                                 , Suffix__c = aDUPE.Customer_Suffix__c 
        //                                                 , Customer_DW_ID__c  = aDUPE.DW_ID__c
        //                                                 , Group_Key__c = aDUPE.GroupKey__c             
        //                                                 , SAP_Account_Id__c = aDUPE.SAP_Account_Id__c         
        //                                                 , Phone__c = aDUPE.Phone
        //                                                 , fax__c = aDUPE.fax
        //                                                 , Website__c = aDUPE.Website
        //                                                 , Mark_For_Deletion__c = aDUPE.Mark_For_Deletion__c
        //                                                 , PO_Required__c = aDUPE.PO_Required__c    
        //                                                 , IsNew__c = false
        //                                                 , Reason_for_New_Suffix__c = 'cause'
        //                                                 , Customer_Class_n__c = ccAO.id
        //                                                 , Business_Reason__c = 'TEST'
        //                                                 , Sales_Representative__c = sr.Id
        //                                                 , Sales_Representative_n__c = srAO.id
        //                                                 , Customer_Class__c = cc.Id
        //                                                 , Customer_Type__c = ct.Id
        //                                                 , Customer_Type_n__c = ctAO.Id
        //                                                 , RecordTypeId = Label.CR_Customer_Update_RT
        //                                                 , SSC__c = ssc.Id
        //                                                 , SSC_N__c = sscAO.id
        //                                                 , Name__c = 'new'
        //                                                 , Ship_To_Phone__c = '(972) 489-4406'
        //                                                 , Region__c = r.Id
        //                                                 , Region_n__c = rAO.id
        //                                                 , Bill_Address_1__c = aDUPE.BillingStreet
        //                                                 , Billing_City_Account__c = aDUPE.BillingCity
        //                                                 , Billing_State_Account__c = aDUPE.BillingState
        //                                                 , Bill_Country__c = aDUPE.BillingCountry
        //                                                 , Billing_Zip_Account__c = aDUPE.BillingPostalCode
        //                                                 , Billing_street__c = aDUPE.ShippingStreet
        //                                                 , Billing_city__c = aDUPE.ShippingCity
        //                                                 , Billing_state__c = aDUPE.ShippingState
        //                                                 , Billing_country__c = aDUPE.ShippingCountry
        //                                                 , BILLING_ZIP__C = aDUPE.ShippingPostalCode
        //                                                 , Status__c = 'Submitted for Approval');         
        // try {
        //     insert crDUPE;
        //  System.debug('::::testChangeRequestValidations + crDUPE::::> ' + crDUPE);
        // }   catch (Exception e) {
        //  System.debug('::::testChangeRequestValidations + insert crDUPE::::> ' + e.getMessage());
        // }

        // Change_Request__c crDUPE2 = new Change_Request__c(SBU__c = 'SC'
        //                                                 , Account__c = aDUPE.id
        //                                                 , DBA_Name__c = aDUPE.DBA_Name__c
        //                                                 , Customer_Base__c = aDUPE.Customer_Base__c
        //                                                 , Suffix__c = aDUPE.Customer_Suffix__c 
        //                                                 , Customer_DW_ID__c  = aDUPE.DW_ID__c
        //                                                 , Group_Key__c = aDUPE.GroupKey__c             
        //                                                 , SAP_Account_Id__c = aDUPE.SAP_Account_Id__c         
        //                                                 , Phone__c = aDUPE.Phone
        //                                                 , fax__c = aDUPE.fax
        //                                                 , Website__c = aDUPE.Website
        //                                                 , Mark_For_Deletion__c = aDUPE.Mark_For_Deletion__c
        //                                                 , IsNew__c = false
        //                                                 , Reason_for_New_Suffix__c = 'cause'
        //                                                 , Customer_Class_n__c = ccAO.id
        //                                                 , Business_Reason__c = 'TEST'
        //                                                 , Sales_Representative__c = sr.Id
        //                                                 , Sales_Representative_n__c = srAO.id
        //                                                 , Customer_Class__c = cc.Id
        //                                                 , Customer_Type__c = ct.Id
        //                                                 , Customer_Type_n__c = ctAO.Id
        //                                                 , RecordTypeId = Label.CR_Customer_Update_RT
        //                                                 , SSC__c = ssc.Id
        //                                                 , SSC_N__c = sscAO.id
        //                                                 , Name__c = 'new'
        //                                                 , Ship_To_Phone__c = '(972) 489-4406'
        //                                                 , Region__c = r.Id
        //                                                 , Region_n__c = rAO.id
        //                                                 , Bill_Address_1__c = aDUPE.BillingStreet
        //                                                 , Billing_City_Account__c = aDUPE.BillingCity
        //                                                 , Billing_State_Account__c = aDUPE.BillingState
        //                                                 , Bill_Country__c = aDUPE.BillingCountry
        //                                                 , Billing_Zip_Account__c = aDUPE.BillingPostalCode
        //                                                 , Billing_street__c = aDUPE.ShippingStreet
        //                                                 , Billing_city__c = aDUPE.ShippingCity
        //                                                 , Billing_state__c = aDUPE.ShippingState
        //                                                 , Billing_country__c = aDUPE.ShippingCountry
        //                                                 , BILLING_ZIP__C = aDUPE.ShippingPostalCode
        //                                                 , Status__c = 'Submitted for Approval');         
        // try {
        //     insert crDUPE2;
        //  System.debug('::::testChangeRequestValidations + crDUPE2::::> ' + crDUPE2);
        // }   catch (Exception e) {
        //  System.debug('::::testChangeRequestValidations + insert crDUPE2::::> ' + e.getMessage());
        // }          
        
    }    

    @isTest static void testCRExtension() {

        System.debug('::::testCRExtension::::>');
//        setup();
        Profile pAdmin = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        UserRole rMGR = [SELECT Id, Name FROM UserRole WHERE Name = 'MW SSC Manager'];   
        String aUser = [Select Id, Name, Alias from User where ProfileId = :pAdmin.Id AND LastName != 'Rust' AND IsActive = TRUE limit 1].ID; 
        User uMGR = [SELECT ID, Name FROM User where UserRoleID =  : rMGR.Id AND IsActive = TRUE LIMIT 1];           
    
        Account acct = [SELECT Id 
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
                        ,Mark_For_Deletion__c
                        ,SBU__C
                        ,OwnerId
                        FROM Account                         
                        WHERE Name='Test Dal Account 1' LIMIT 1];
        string updateAccount = acct.id;

        Account acctDUPE = [SELECT Id 
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
                        ,Mark_For_Deletion__c
                        ,SBU__C
                        FROM Account                         
                        WHERE Name='Test Dal Account 2' LIMIT 1];
        string updateDupeAccount = acctDUPE.id;

        Region__c rID = [SELECT ID
                        FROM Region__c
                        WHERE DW_ID__c = '41'];

        Region__c rOldID = [SELECT ID
                        FROM Region__c
                        WHERE DW_ID__c = '66'];                        
       
       Customer_Class__c ccID = [SELECT ID
                                FROM Customer_Class__c
                                WHERE CustClass__c = 'S8Q'];
                                
       Customer_Class__c ccOldID = [SELECT ID
                                FROM Customer_Class__c
                                WHERE CustClass__c = 'S4Q'];                                
       
       SSC__c sscID = [SELECT ID
                       FROM SSC__c
                       WHERE DW_ID__c = '000112'];
                       
       SSC__c sscOldID = [SELECT ID
                       FROM SSC__c
                       WHERE DW_ID__c = '000111'];                       
       
       Customer_Type__c ctID = [SELECT ID
                                FROM Customer_Type__c
                                WHERE SBU__c = 'DI'];
       
       Customer_Type__c ctOldID = [SELECT ID
                                FROM Customer_Type__c
                                WHERE SBU__c = 'SC'];                                
       
       Sales_Representative__c srID = [SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '97'];
       
       Sales_Representative__c srOldID = [SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '07'];                                        
        
        System.debug('::::testCRExtension + got my acct , about to start::::>' + acct);
//        System.runAs(uMGR){
            try {
                pageRef1 = Page.CustomerChangeRequest;
                pageRef1.getParameters().put('id',acct.id);
                System.debug('::::con.createCR():::>1 ');
                Test.setCurrentPage(pageRef1);
                System.debug('::::con.createCR():::>2 ');
                ApexPages.StandardController tstCls2 = new ApexPages.StandardController(acct);
                System.debug('::::con.createCR():::>3 ');
                con = new CustomerRequestNewLightningExtension(tstCls2);
                CustomerRequestNewLightningExtension.createCR(updateAccount);
                con.getRequestedAccount();
                con.getRecordTypes();
                con.getColor();
                con.changeAddress();
                con.changeAddress();
                con.changeShipTo();
                con.changeAccount();
                con.getExisting();
                con.getContextUserUiTheme();
                con.changeDetails();
                con.doCheckForUX();
                con.createCR();
                ApexPages.currentPage().getParameters().put('Copy_Bill_To_Address__c','True');
                // con.saveData();
                con.saveNewRequestData();
                con.doCancel();
            }   catch (Exception e) {
                System.debug('::::testChangeRequestValidation::::> ' + e.getMessage());
            }         
            try {
                Change_Request__c cr = [SELECT ID
                                       , Account__c
                                       , Copy_Bill_To_Address__c
                                       , Rep_Change__c
                                       , Class_Change__c
                                       , SSC_Change__c
                                       , Region_n__c
                                       , Sales_Representative_n__c
                                       , Customer_Class_N__c
                                       , Business_Reason__c
                                       , SSC__c
                                       , SSC_N__c
                                       , Status__c
                                       FROM Change_Request__c
                                       WHERE Account__c = :updateAccount
                                       LIMIT 1];
                pageRef1.getParameters().put('updateCopyBillto','true');
                cr.Account__c = updateAccount;
                cr.Copy_Bill_To_Address__c = true;
                cr.Rep_Change__c = true;
                cr.Class_Change__c = true;
                cr.SSC_Change__c = true;
                cr.Region_n__c = rID.id;
                cr.Sales_Representative_n__c = srID.id;
                cr.Customer_Class_N__c = ccID.id;
                cr.Business_Reason__c = 'test';
                cr.SSC_N__c = sscID.id;       
                cr.SSC__c = sscOldID.id;
                cr.Status__c = 'Submitting for Approval';
                // con.saveData();
                update cr;
                System.debug('::::cr.Copy_Bill_To_Address__c::::> ' + cr.Copy_Bill_To_Address__c);
                // con.saveData();
                // CustomerRequestNewLightningExtension.doCancel();
                Change_Request__c clonedCR = cr.clone(false, true, false, false);

                System.debug('::::cr::::> ' + cr);
                Change_Request__c cr2 = [SELECT ID
                                       , Account__c
                                       , Copy_Bill_To_Address__c
                                       FROM Change_Request__c
                                       WHERE Account__c = :updateAccount
                                       ORDER BY Created_Date__c DESC
                                       LIMIT 1];            
                System.debug('::::cr2::::> ' + cr2);     
                System.debug('::::cr clonedCR::::> ' + clonedCR);
    
            }   catch (Exception e) {
                System.debug('::::testChangeRequestValidation::::> ' + e.getMessage());
            }         
  //      }
    }

    static testMethod void testCRExtensionSalesRepDupes() {


        Profile pAdmin = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        UserRole rMGR = [SELECT Id, Name FROM UserRole WHERE Name = 'MW SSC Manager'];   
        String aUser = [Select Id, Name, Alias from User where ProfileId = :pAdmin.Id AND LastName != 'Rust' AND IsActive = TRUE limit 1].ID; 
        User uMGR = [SELECT ID, Name FROM User where UserRoleID =  : rMGR.Id AND IsActive = TRUE LIMIT 1];           
    
        Account acct = [SELECT Id 
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
                        ,Mark_For_Deletion__c
                        ,SBU__C
                        ,PO_Required__c
                        ,OwnerId
                        FROM Account                         
                        WHERE Name='Test Dal Account 1' LIMIT 1];
        string updateAccount = acct.id;

        Account acctDUPE = [SELECT Id 
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
                        ,Mark_For_Deletion__c
                        ,SBU__C
                        ,PO_Required__c                        
                        FROM Account                         
                        WHERE Name='Test Dal Account 2' LIMIT 1];
        string updateDupeAccount = acctDUPE.id;

        Region__c rID = [SELECT ID
                        FROM Region__c
                        WHERE DW_ID__c = '41'];

        Region__c rOldID = [SELECT ID
                        FROM Region__c
                        WHERE DW_ID__c = '66'];                        
       
       Customer_Class__c ccID = [SELECT ID
                                FROM Customer_Class__c
                                WHERE CustClass__c = 'S8Q'];
                                
       Customer_Class__c ccOldID = [SELECT ID
                                FROM Customer_Class__c
                                WHERE CustClass__c = 'S4Q'];                                
       
       SSC__c sscID = [SELECT ID
                       FROM SSC__c
                       WHERE DW_ID__c = '000112'];
                       
       SSC__c sscOldID = [SELECT ID
                       FROM SSC__c
                       WHERE DW_ID__c = '000111'];                       
       
       Customer_Type__c ctID = [SELECT ID
                                FROM Customer_Type__c
                                WHERE SBU__c = 'DI'];
       
       Customer_Type__c ctOldID = [SELECT ID
                                FROM Customer_Type__c
                                WHERE SBU__c = 'SC'];                                
       
       Sales_Representative__c srID = [SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '97'];
       
       Sales_Representative__c srOldID = [SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '07'];                                        

       // test submitting dupe as MGR 1
       
        System.runAs(uMGR) {  
            try {
                Change_Request__c cMGR = new Change_Request__c(SBU__c = 'SC'
                                                                , Account__c = updateAccount
                                                               , IsNew__c = false
                                                               , Reason_for_New_Suffix__c = 'cause'
                                                               , Customer_Class_n__c = ccID.id
                                                               , Business_Reason__c = 'TEST'
                                                               , Sales_Representative__c = srOldId.Id
                                                               , Sales_Representative_n__c = srId.id
                                                               , Customer_Class__c = ccOldId.Id
                                                               , Customer_Type__c = ctOldID.Id
                                                               , Customer_Type_n__c = ctID.Id
                                                               , RecordTypeId = Label.CR_Customer_Update_RT
                                                               , SSC__c = sscOldID.Id
                                                               , SSC_N__c = sscID.id
                                                               , Name__c = 'new'
                                                               , Ship_To_Phone__c = '(972) 489-4406'
                                                               , Fax__c = '(972) 489-4406'
                                                               , Region__c = rOldID.Id
                                                               , Region_n__c = rID.id
                                                               , Status__c = 'Submitting for Approval');
                insert cMGR;      
                System.debug('::::cMGR::::> ' + cMGR);     
                
            }   catch (Exception e) {
                System.debug('::::testChangeRequestValidation::::> ' + e.getMessage());
            }            
            try {
                Change_Request__c cMGRRep = new Change_Request__c(SBU__c = 'SC'
                                                                , Account__c = updateAccount
                                                               , IsNew__c = false
                                                               , Reason_for_New_Suffix__c = 'cause'
                                                               , Customer_Class_n__c = ccID.id
                                                               , Business_Reason__c = 'TEST'
                                                               , Sales_Representative__c = srOldId.Id
                                                               , Sales_Representative_n__c = srId.id
                                                               , Customer_Class__c = ccOldId.Id
                                                               , Customer_Type__c = ctOldID.Id
                                                               , Customer_Type_n__c = ctID.Id
                                                               , RecordTypeId = Label.CR_Customer_Update_RT
                                                               , SSC__c = sscOldID.Id
                                                               , SSC_N__c = sscID.id
                                                               , Name__c = 'new'
                                                               , Ship_To_Phone__c = '(972) 489-4406'
                                                               , Fax__c = '(972) 489-4406'
                                                               , Region__c = rOldID.Id
                                                               , Region_n__c = rID.id
                                                               , Status__c = 'Submitting for Approval');
                insert cMGRRep;       
                System.debug('::::cMGRRep::::> ' + cMGRRep);  
                
            }   catch (Exception e) {
                System.debug('::::testChangeRequestValidation::::> ' + e.getMessage());
            }    
        }    
    }
    
    static testMethod void testCRExtensionSSCDupes() {


        Profile pAdmin = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        UserRole rMGR = [SELECT Id, Name FROM UserRole WHERE Name = 'MW SSC Manager'];   
        String aUser = [Select Id, Name, Alias from User where ProfileId = :pAdmin.Id AND LastName != 'Rust' AND IsActive = TRUE limit 1].ID; 
        User uMGR = [SELECT ID, Name FROM User where UserRoleID =  : rMGR.Id AND IsActive = TRUE LIMIT 1];           
    
        Account acct = [SELECT Id 
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
                        ,Mark_For_Deletion__c
                        ,SBU__C
                        ,PO_Required__c
                        ,OwnerId
                        FROM Account                         
                        WHERE Name='Test Dal Account 1' LIMIT 1];
        string updateAccount = acct.id;

        Account acctDUPE = [SELECT Id 
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
                        ,Mark_For_Deletion__c
                        ,SBU__C
                        ,PO_Required__c                        
                        FROM Account                         
                        WHERE Name='Test Dal Account 2' LIMIT 1];
        string updateDupeAccount = acctDUPE.id;

        Region__c rID = [SELECT ID
                        FROM Region__c
                        WHERE DW_ID__c = '41'];

        Region__c rOldID = [SELECT ID
                        FROM Region__c
                        WHERE DW_ID__c = '66'];                        
       
       Customer_Class__c ccID = [SELECT ID
                                FROM Customer_Class__c
                                WHERE CustClass__c = 'S8Q'];
                                
       Customer_Class__c ccOldID = [SELECT ID
                                FROM Customer_Class__c
                                WHERE CustClass__c = 'S4Q'];                                
       
       SSC__c sscID = [SELECT ID
                       FROM SSC__c
                       WHERE DW_ID__c = '000112'];
                       
       SSC__c sscOldID = [SELECT ID
                       FROM SSC__c
                       WHERE DW_ID__c = '000111'];                       
       
       Customer_Type__c ctID = [SELECT ID
                                FROM Customer_Type__c
                                WHERE SBU__c = 'DI'];
       
       Customer_Type__c ctOldID = [SELECT ID
                                FROM Customer_Type__c
                                WHERE SBU__c = 'SC'];                                
       
       Sales_Representative__c srID = [SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '97'];
       
       Sales_Representative__c srOldID = [SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '07'];                                        

       // test submitting dupe as MGR 1
       
        System.runAs(uMGR) {  
            try {
                Change_Request__c cMGR = new Change_Request__c(SBU__c = 'SC'
                                                                , Account__c = updateAccount
                                                               , IsNew__c = false
                                                               , Reason_for_New_Suffix__c = 'cause'
                                                               , Customer_Class_n__c = ccID.id
                                                               , Business_Reason__c = 'TEST'
                                                               , Sales_Representative__c = srOldId.Id
                                                               , Sales_Representative_n__c = srId.id
                                                               , Customer_Class__c = ccOldId.Id
                                                               , Customer_Type__c = ctOldID.Id
                                                               , Customer_Type_n__c = ctID.Id
                                                               , RecordTypeId = Label.CR_Customer_Update_RT
                                                               , SSC__c = sscOldID.Id
                                                               , SSC_N__c = sscID.id
                                                               , Name__c = 'new'
                                                               , Ship_To_Phone__c = '(972) 489-4406'
                                                               , Fax__c = '(972) 489-4406'
                                                               , Region__c = rOldID.Id
                                                               , Region_n__c = rID.id
                                                               , Status__c = 'Submitting for Approval');
                insert cMGR;      
                System.debug('::::cMGR::::> ' + cMGR);     
                
            }   catch (Exception e) {
                System.debug('::::testChangeRequestValidation::::> ' + e.getMessage());
            }
        }
       
        System.runAs(uMGR) {              
            try {
                Change_Request__c cMGRSSC = new Change_Request__c(SBU__c = 'SC'
                                                                , Account__c = updateAccount
                                                               , IsNew__c = false
                                                               , Reason_for_New_Suffix__c = 'cause'
                                                               , Customer_Class_n__c = ccID.id
                                                               , Business_Reason__c = 'TEST'
                                                               , Sales_Representative__c = srOldId.Id
                                                               , Customer_Class__c = ccOldId.Id
                                                               , Customer_Type__c = ctOldID.Id
                                                               , RecordTypeId = Label.CR_Customer_Update_RT
                                                               , SSC__c = sscOldID.Id
                                                               , SSC_N__c = sscID.id
                                                               , Name__c = 'new'
                                                               , Ship_To_Phone__c = '(972) 489-4406'
                                                               , Fax__c = '(972) 489-4406'
                                                               , Region__c = rOldID.Id
                                                               , Region_n__c = rID.id
                                                               , Status__c = 'Submitting for Approval');
                insert cMGRSSC;
                System.debug('::::cMGRSSC::::> ' + cMGRSSC);    
                
            }   catch (Exception e) {
                System.debug('::::testChangeRequestValidation::::> ' + e.getMessage());
            }                          
        }    
    }
    
    
   @isTest static void testCRExtensionRemoteActions() {
        Account acct = [SELECT Id 
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
                        ,Mark_For_Deletion__c
                        ,SBU__C
                        FROM Account                         
                        WHERE Name='Test Dal Account 1' LIMIT 1];
       
        Region__c rID = [SELECT ID
                        FROM Region__c
                        WHERE DW_ID__c = '41'];
       
       Customer_Class__c ccID = [SELECT ID
                                FROM Customer_Class__c
                                WHERE CustClass__c = 'S4Q'];
       
       SSC__c sscID = [SELECT ID
                       FROM SSC__c
                       WHERE DW_ID__c = '000112'];
       
       Customer_Type__c ctID = [SELECT ID
                                FROM Customer_Type__c
                                WHERE SBU__c = 'DI'];
       
       Sales_Representative__c srID = [SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '97'];
               
        string newCRId ;
        string newCR2Id ;
        Boolean updateAll = true;
        Boolean updateRep = true;
        Boolean updateClass = true;
        Boolean updateSSC = true;
        Boolean updateAddress = true;
        Boolean updateName = true;
        Boolean updateNewShiptoAccount = true;
        Boolean updateNewExtendShipTo = true;
        Boolean updateShipto = true;
        Boolean updateBillTo = true;
        Boolean updateCopyBillTo = true;
        Boolean updateType = true;
        Boolean updateOther = true;
        String updateNewShipToReason = 'TEST';
        string updateNameChange = 'TEST';
        string updateDBANameChange = 'TEST';
        string updateShipToCountryChange = 'US';
        string updateShipToAddress1Change = 'test 1';
        string updateShipToAddress2Change = 'test 2';
        string updateShipToCityChange = 'city';
        string updateShipToZip = '75218';
        string updateShipToState = 'TX';
        string updateBillToCountryChange = 'US';
        string updateBillToAddress1Change = 'test 1';
        string updateBillToAddress2Change = 'test 2';
        string updateBillToCityChange = 'city';
        string updateBillToZip = '75218';
        string updateBillToState = 'TX';
        string updateAccount = acct.id;
        string updateNewRegion = rID.id;
        string updateNewRep = srID.id;
        string updateNewSSC = sscID.id;
        string updateNewCusClass = ccID.id;
        string updateNewReasonForClass = 'TEST';
        string updateNewCusType = ctID.id;
        string updateContact = 'test name';
        string updatePhone = '972-489-4406';
        string updateFax = '972-489-4406';
        string keyword = 'Mid';
        string updateComments = 'text';
                                              

            pageRef1 = Page.CustomerChangeRequest;
            pageRef1.getParameters().put('id',acct.id);
            Test.setCurrentPage(pageRef1);
            ApexPages.StandardController tstCls2 = new ApexPages.StandardController(acct);
            con = new CustomerRequestNewLightningExtension(tstCls2);
            CustomerRequestNewLightningExtension.createCR(updateAccount);
        try {
            CustomerRequestNewLightningExtension.createCR( updateAccount );
            Change_Request__c cr = [SELECT ID
                                   , Account__c
                                   FROM Change_Request__c
                                   WHERE Account__c = :updateAccount
                                   LIMIT 1];
            newCRId = cr.id;
            CustomerRequestNewLightningExtension.updateCRUpdates(newCRId
                                        ,updateAll
                                        ,updateRep
                                        ,updateClass
                                        ,updateSSC
                                        ,updateAddress
                                        ,updateName
                                        ,updateType
                                        ,updateOther
                                        ,updateNewShiptoAccount
                                        ,updateNewExtendShipTo
            );            
            CustomerRequestNewLightningExtension.updateCRShipToAddress(newCRId
                                        ,updateRep
                                        ,updateClass
                                        ,updateSSC   
                                        ,updateNewShiptoAccount
                                        ,updateShipto
                                        ,updateShipToCountryChange
                                        ,updateShipToAddress1Change
                                        ,updateShipToAddress2Change
                                        ,updateShipToCityChange
                                        ,updateShipToZip
                                        ,updateShipToState
                                        ,updateAccount
            );
            CustomerRequestNewLightningExtension.updateCRBillToAddress(newCRId
                                        ,updateRep
                                        ,updateClass
                                        ,updateSSC   
                                        ,updateNewShiptoAccount
                                        ,updateBillTo
                                        ,updateBillToCountryChange
                                        ,updateBillToAddress1Change
                                        ,updateBillToAddress2Change
                                        ,updateBillToCityChange
                                        ,updateBillToZip
                                        ,updateBillToState
                                        ,updateCopyBillto
                                        ,updateAccount
            );
            con.showMessage();
            CustomerRequestNewLightningExtension.updateCROptions(newCRId
                                        ,updateNewShipToReason
                                        ,updateNameChange
                                        ,updateDBANameChange
                                        ,updateNewRegion
                                        ,updateNewRep
                                        ,updateNewSSC
                                        ,updateNewCusClass
                                        ,updateNewReasonForClass
                                        ,updateNewCusType    
            );
            CustomerRequestNewLightningExtension.updateCRDetails( newCRId
                                        , updateContact
                                        , updatePhone
                                        , updateFax
                                        , updateAccount
                                        , updateComments
            );
        } catch (Exception e) {
            System.debug('::::createCR::::> ' + e.getMessage());
        }  
        try {
            CustomerRequestNewLightningExtension.createCR( updateAccount );
            Change_Request__c cr2 = [SELECT ID
                                   , Account__c
                                   FROM Change_Request__c
                                   WHERE Account__c = :updateAccount
                                   AND ID != :newCRId
                                   ORDER BY Created_Date__c DESC
                                   LIMIT 1];
            newCR2Id = cr2.id;          
            CustomerRequestNewLightningExtension.updateCRUpdates(newCR2Id
                                        ,updateAll
                                        ,updateRep
                                        ,updateClass
                                        ,updateSSC
                                        ,updateAddress
                                        ,updateName
                                        ,updateType
                                        ,updateOther
                                        ,updateNewShiptoAccount
                                        ,updateNewExtendShipTo
            );     
            CustomerRequestNewLightningExtension.updateCRShipToAddress(newCR2Id
                                        ,updateRep
                                        ,updateClass
                                        ,updateSSC   
                                        ,updateNewShiptoAccount
                                        ,updateShipto
                                        ,updateShipToCountryChange
                                        ,updateShipToAddress1Change
                                        ,updateShipToAddress2Change
                                        ,updateShipToCityChange
                                        ,updateShipToZip
                                        ,updateShipToState
                                        ,updateAccount
            );
            CustomerRequestNewLightningExtension.updateCRBillToAddress(newCR2Id
                                        ,updateRep
                                        ,updateClass
                                        ,updateSSC   
                                        ,updateNewShiptoAccount
                                        ,updateBillTo
                                        ,updateBillToCountryChange
                                        ,updateBillToAddress1Change
                                        ,updateBillToAddress2Change
                                        ,updateBillToCityChange
                                        ,updateBillToZip
                                        ,updateBillToState
                                        ,updateCopyBillto
                                        ,updateAccount
            );
            con.showMessage();
            CustomerRequestNewLightningExtension.updateCROptions(newCR2Id
                                        ,updateNewShipToReason
                                        ,updateNameChange
                                        ,updateDBANameChange
                                        ,updateNewRegion
                                        ,updateNewRep
                                        ,updateNewSSC
                                        ,updateNewCusClass
                                        ,updateNewReasonForClass
                                        ,updateNewCusType    
            );
            CustomerRequestNewLightningExtension.updateCRDetails( newCR2Id
                                        , updateContact
                                        , updatePhone
                                        , updateFax
                                        , updateAccount
                                        , updateComments
            );
            CustomerRequestNewLightningExtension.queryRegions(keyword);
            CustomerRequestNewLightningExtension.queryReps(keyword);
            CustomerRequestNewLightningExtension.querySSC(keyword);
            CustomerRequestNewLightningExtension.queryClass(keyword);
            CustomerRequestNewLightningExtension.queryType(keyword);
            CustomerRequestNewLightningExtension.deleteCR(newCRId);
            CustomerRequestNewLightningExtension.deleteCR(newCR2Id);

        } catch (Exception e) {
            System.debug('::::createCR::::> ' + e.getMessage());
        }             
   }
   
       @isTest static void testCRNewAccountRemoteExtension(){

        Region__c r = [SELECT ID
                        FROM Region__c
                        WHERE DW_ID__c = '41'];
       
        Customer_Class__c cc = [SELECT ID
                                FROM Customer_Class__c
                                WHERE CustClass__c = 'S4Q'];
       
        SSC__c ssc = [SELECT ID
                       FROM SSC__c
                       WHERE DW_ID__c = '000112'];
       
        Customer_Type__c ct = [SELECT ID
                                FROM Customer_Type__c
                                WHERE SBU__c = 'DI'];
       
        Sales_Representative__c sr = [SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '97'];

        String updateName = 'updateName';
        String updateContact = 'updateContact';
        String updatePhone = 'updatePhone';
        String updateFax = 'updateFax';
        String updateComments = 'updateComments';
        String updateDBAName = 'updateDBAName';
        String updateWebsite = 'updateWebsite';
        String updateNewRegion = r.Id;
        String updateNewRep = sr.Id;
        String updateNewSSC = ssc.Id;
        String updateNewCusClass = cc.Id;
        String updateNewReasonForClass = 'updateNewReasonForClass';
        String updateNewCusType = ct.Id;
        String updateShipToCountryChange = 'updateShipToCountryChange';
        String updateShipToAddress1Change = 'updateShipToAddress1Change';
        String updateShipToAddress2Change = 'updateShipToAddress2Change';
        String updateShipToCityChange = 'updateShipToCityChange';
        String updateShipToZip = '75218';
        String updateShipToState   = 'TX';
        String updateBillToCountryChange = 'updateBillToCountryChange';
        String updateBillToAddress1Change = 'updateBillToAddress1Change';
        String updateBillToAddress2Change = 'updateBillToAddress2Change';
        String updateBillToCityChange = 'updateBillToCityChange';
        String updateBillToZip = '75218';
        String updateBillToState = 'TX';
        Boolean updateCopyBillto = true;
        Boolean updateContactProExch = true;
        string updateContactFirstName = 'TX';	
        string updateContactLastName = 'Oh TX';	
        string updateContactPhone = '2145557788';	
        string updateContactEmail = 'all.hail.the.mighty@state.io';
        
        CustomerRequestNewLightningExtension.saveNewCustomer( updateName
                                        ,updateContact
                                        ,updatePhone
                                        ,updateFax
                                        ,updateComments
                                    	,updateDBAName
                                    	,updateWebsite
                                    	,updateNewRegion
                                    	,updateNewRep
                                    	,updateNewSSC
                                    	,updateNewCusClass
                                    	,updateNewReasonForClass
                                    	,updateNewCusType
                                        ,updateShipToCountryChange
                                        ,updateShipToAddress1Change
                                        ,updateShipToAddress2Change
                                        ,updateShipToCityChange
                                        ,updateShipToZip
                                        ,updateShipToState  
                                        ,updateBillToCountryChange
                                        ,updateBillToAddress1Change
                                        ,updateBillToAddress2Change
                                        ,updateBillToCityChange
                                        ,updateBillToZip
                                        ,updateBillToState
                                        ,updateCopyBillto       
                                        ,updateContactProExch
                                        ,updateContactFirstName
                                        ,updateContactLastName
                                        ,updateContactPhone
                                        ,updateContactEmail		   
                                    	);

    }
}