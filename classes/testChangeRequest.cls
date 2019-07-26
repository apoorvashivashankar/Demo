@ isTest
public class testChangeRequest {
    
    static PageReference pageRef1; 
    static CustomerRequestNewLightningExtension con;
    static CustomerDelRequestController conDEL;
    static ChangeRequestHandler th;
    static map <Id, Change_Request__c> crMap;
    static Boolean hasErrors;
    static String NEW_CUSTOMER_REQUEST;
    static String CUSTOMER_UPDATE;    
    public boolean updateCopyBillto {get;set;}
    
    @testSetup static void testSetup() {
        
        hasErrors = false;
        NEW_CUSTOMER_REQUEST = Label.CR_New_Customer_RT;
        CUSTOMER_UPDATE = Label.CR_Customer_Update_RT;    
        TriggerControl__c setting1 = new TriggerControl__c();
        setting1.Name = 'ChangeRequestTrigger';
        setting1.IsActive__c = TRUE;
        insert setting1;        
        
        TriggerControl__c setting2 = new TriggerControl__c();
        setting2.Name = 'UserTrigger';
        setting2.IsActive__c = TRUE;
        insert setting2;        
        
        Account aInternal = new Account();
        aInternal.Name = 'Test Daltile Internal Account';
        insert aInternal;
        
        String contactRecordTypeID = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard Contact').getRecordTypeId();
        
        UserContactDefaults__c ucd = new UserContactDefaults__c(Default_Account_Id__c = aInternal.Id
                                                               ,Default_Contact_Record_Type_Id__c = contactRecordTypeID
                                                               ,Maximum_SSC_Distance__c = 200);
        insert ucd;
                
        // USERS
        User uRSM;
        User uRVP;
        User uMGR1;
        User uMGR2;
        User uSR1;
        User uSR2;
        
        System.runAs(new User(Id=UserInfo.getUserId())) {
            Profile pRSM = [SELECT Id FROM Profile WHERE Name = 'MGMT'];
            UserRole rRSM = [SELECT Id, Name FROM UserRole WHERE Name LIKE '%RSM%' LIMIT 1];
            UserRole rRVP = [SELECT Id, Name FROM UserRole WHERE Name LIKE '%Region%' LIMIT 1];
            uRSM = new User(alias = 'RSM1'
                            , email= 'RSM@daltile.com'
                            , emailencodingkey='UTF-8'
                            , lastname='Manager'
                            , firstname='Regional Sales'
                            , languagelocalekey='en_US'
                            , localesidkey='en_US'
                            , timezonesidkey='GMT'
                            , ProfileId = pRSM.Id
                            , UserRoleId = rRSM.Id
                            , username = 'RSM@daltile.com.test');
            insert uRSM;                
            uRVP = new User(alias = 'RVP1'
                            , email= 'RVP@daltile.com'
                            , emailencodingkey='UTF-8'
                            , lastname='Manager'
                            , firstname='Regional Sales'
                            , languagelocalekey='en_US'
                            , localesidkey='en_US'
                            , timezonesidkey='GMT'
                            , ProfileId = pRSM.Id
                            , UserRoleId = rRVP.Id
                            , username = 'RVP@daltile.com.test');
            insert uRVP;                
            UserRole rMGR = [SELECT Id, Name FROM UserRole WHERE Name LIKE '%SSC Manager%' LIMIT 1];    
            id pMGR = [Select id 
                            From Profile
                            where UserType = 'Standard'
                            and Name = 'SSC Manager'
                            limit 1].Id;        
            uMGR1 = new User(alias = 'MGR1'
                            , email= 'AccountOwnerGuy@daltile.com'
                            , emailencodingkey='UTF-8'
                            , lastname='Owner'
                            , firstname='Account'
                            , languagelocalekey='en_US'
                            , localesidkey='en_US'
                            , timezonesidkey='GMT'
                            , ProfileId = pMGR
                            , UserRoleId = rMGR.Id
                            , username = 'MGR1@daltile.com.test');
            insert uMGR1;                
            uMGR2 = new User(alias = 'MGR2'
                            , email= 'MGR@daltile.com'
                            , emailencodingkey='UTF-8'
                            , lastname='Two'
                            , firstname='Manager'
                            , languagelocalekey='en_US'
                            , localesidkey='en_US'
                            , timezonesidkey='GMT'
                            , ProfileId = pMGR
                            , UserRoleId = rMGR.Id
                            , username = 'MGR2@daltile.com.test');
            insert uMGR2;        
            Profile pSR = [SELECT Id FROM Profile WHERE Name = 'Sales Rep User'];
            UserRole rsr = [SELECT Id, Name FROM UserRole WHERE Name LIKE '%Sales Rep%' LIMIT 1];
            uSR1 = new User(alias = 'sr1'
                            , email= 'uSR1@daltile.com'
                            , emailencodingkey='UTF-8'
                            , lastname='Rep'
                            , firstname='Sales'
                            , languagelocalekey='en_US'
                            , localesidkey='en_US'
                            , timezonesidkey='GMT'
                            , ProfileId = pSR.Id
                            , UserRoleId = rMGR.Id
                            , username = 'uSR1@daltile.com.test');
            insert uSR1;        
            uSR2 = new User(alias = 'sr1'
                            , email= 'uSR2@daltile.com'
                            , emailencodingkey='UTF-8'
                            , lastname='Rep'
                            , firstname='Sales'
                            , languagelocalekey='en_US'
                            , localesidkey='en_US'
                            , timezonesidkey='GMT'
                            , ProfileId = pSR.Id
                            , UserRoleId = rMGR.Id
                            , username = 'uSR2@daltile.com.test');
            insert uSR2;        
        }
        
        // ACCOUNT DATA
        Region__c r1 = new Region__c(Select__c = true
                                     , SBU__c = 'SC'
                                     , DW_ID__c = '01'
                                     , Name = 'SOUTHERN CA REGION');
        insert r1;
        
        Region__c r2 = new Region__c(Select__c = true
                                     , SBU__c = 'DI'
                                     , DW_ID__c = '02'
                                     , Name = 'NORTHERN SOUTHERN CA REGION');
        insert r2;
        
        Sales_Representative__c sr1 = new Sales_Representative__c(SBU__c = 'sc'
                                                                    , DW_ID__c = '001'
                                                                    , Region__c = r1.Id);
        insert sr1;
        
        Sales_Representative__c sr2 = new Sales_Representative__c(SBU__c = 'sc'
                                                                    , DW_ID__c = '002'
                                                                    , Region__c = r1.Id);
        insert sr2;
        
        Sales_Representative__c sr3 = new Sales_Representative__c(SBU__c = 'DI'
                                                                    , DW_ID__c = '003'
                                                                    , Region__c = r2.Id);
        insert sr3;


        Customer_Class__c cc1 = new Customer_Class__c(Active__c = true
                                                     , COS__c = 111
                                                     , CustClass__c = 'CC1'
                                                     , Cust_Count__c = 123
                                                     , Customer_Class_Details__c = 'CC1'
                                                     , CustomerCountry__c = 'US'
                                                     , CustomerSBU__c = 'SC'
                                                     , Duplicate__c = false
                                                     , Net_Sales__c = 111
                                                     , PPS_Rgn__c = '01');
        insert cc1;
        
        Customer_Class__c cc2 = new Customer_Class__c(Active__c = true
                                                     , COS__c = 111
                                                     , CustClass__c = 'CC2'
                                                     , Cust_Count__c = 123
                                                     , Customer_Class_Details__c = 'CC2'
                                                     , CustomerCountry__c = 'US'
                                                     , CustomerSBU__c = 'SC'
                                                     , Duplicate__c = false
                                                     , Net_Sales__c = 111
                                                     , PPS_Rgn__c = '01');
        insert cc2;

        Customer_Class__c cc3 = new Customer_Class__c(Active__c = true
                                                     , COS__c = 111
                                                     , CustClass__c = 'CC3'
                                                     , Cust_Count__c = 123
                                                     , Customer_Class_Details__c = 'CC3'
                                                     , CustomerCountry__c = 'US'
                                                     , CustomerSBU__c = 'DI'
                                                     , Duplicate__c = false
                                                     , Net_Sales__c = 111
                                                     , PPS_Rgn__c = '01');
        insert cc3;
        
        Customer_Class__c cc4 = new Customer_Class__c(Active__c = true
                                                     , COS__c = 111
                                                     , CustClass__c = 'DEL'
                                                     , Name = 'DEL'
                                                     , Cust_Count__c = 123
                                                     , Customer_Class_Details__c = 'DEL'
                                                     , CustomerCountry__c = 'US'
                                                     , CustomerSBU__c = 'SC'
                                                     , Duplicate__c = false
                                                     , Net_Sales__c = 111
                                                     , PPS_Rgn__c = '01');
        insert cc4;
        SSC__c ssc1 = new SSC__c(Closed__c = false
                                 , DW_ID__c = '001'
                                 , Loc_Type__c = 'SSC'
                                 , Manager__c = uMGR1.id
                                 , Region__c = r1.Id
                                 , ROM__c = uMGR2.id
                                 , RSM__c = uRSM.id
                                 , RVP__c = uRVP.id
                                 , Sales_Region__c = '01'
                                 , SBU__c = 'SC'
                                 , Select__c = true
                                 , SSC_Fax_Number__c = '123-345-5567'
                                 , SSC_Phone_Number__c = '123-345-5567'
                                 , State__c = 'TX'
                                 , Street_Address__c = '12345 1st street'
                                 , Zip_Code__c = '12345');
        insert ssc1; 
        
        SSC__c ssc2 = new SSC__c(Closed__c = false
                                 , DW_ID__c = '002'
                                 , Loc_Type__c = 'SSC'
                                 , Manager__c = uMGR1.id
                                 , Region__c = r1.Id
                                 , ROM__c = uMGR2.id
                                 , RSM__c = uRSM.id
                                 , RVP__c = uRVP.id
                                 , Sales_Region__c = '01'
                                 , SBU__c = 'SC'
                                 , Select__c = true
                                 , SSC_Fax_Number__c = '123-345-5567'
                                 , SSC_Phone_Number__c = '123-345-5567'
                                 , State__c = 'TX'
                                 , Street_Address__c = '12345 1st street'
                                 , Zip_Code__c = '12345');
        insert ssc2; 
        
        SSC__c ssc3 = new SSC__c(Closed__c = false
                                 , DW_ID__c = '003'
                                 , Loc_Type__c = 'SSC'
                                 , Manager__c = uMGR1.id
                                 , Region__c = r2.Id
                                 , ROM__c = uMGR2.id
                                 , RSM__c = uRSM.id
                                 , RVP__c = uRVP.id
                                 , Sales_Region__c = '02'
                                 , SBU__c = 'DI'
                                 , Select__c = true
                                 , SSC_Fax_Number__c = '123-345-5567'
                                 , SSC_Phone_Number__c = '123-345-5567'
                                 , State__c = 'TX'
                                 , Street_Address__c = '12345 1st street'
                                 , Zip_Code__c = '12345');
        insert ssc3;
        
        SSC__c sscNULL = new SSC__c(Closed__c = false
                                 , DW_ID__c = '004'
                                 , Loc_Type__c = 'SSC'
                                 , Manager__c = NULL
                                 , Region__c = r1.Id
                                 , ROM__c = NULL
                                 , RSM__c = NULL
                                 , RVP__c = NULL
                                 , Sales_Region__c = '01'
                                 , SBU__c = 'SC'
                                 , Select__c = true
                                 , SSC_Fax_Number__c = '123-345-5567'
                                 , SSC_Phone_Number__c = '123-345-5567'
                                 , State__c = 'TX'
                                 , Street_Address__c = '12345 1st street'
                                 , Zip_Code__c = '12345');
        insert sscNULL;
        
        Customer_Type__c ct1 = new Customer_Type__c( Name = 'DAL CT1'
                                                   , Active__c = true
                                                   , Select__c = true
                                                   , SBU__c = 'SC'
                                                   , Region__c = r1.Id);
        insert ct1;
        
        Customer_Type__c ct2 = new Customer_Type__c( Name = 'CANADIAN CT2'
                                                   , Active__c = true 
                                                   , Select__c = true
                                                   , SBU__c = 'SC'
                                                   , Region__c = r1.Id);
        insert ct2;
        
        Customer_Type__c ct3 = new Customer_Type__c( Name = 'CANADIAN CT3'
                                                   , Active__c = true 
                                                   , Select__c = true
                                                   , SBU__c = 'AS'
                                                   , Region__c = r2.Id);
        insert ct3;

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

        Region__c rExt = new Region__c(Select__c = true
                                     , SBU__c = 'SC'
                                     , DW_ID__c = '66'
                                     , Name = 'TEXAS REGION');
        insert rExt;
        
        Region__c rAOExt = new Region__c(Select__c = true
                                     , SBU__c = 'DI'
                                     , DW_ID__c = '41'
                                     , Name = 'AOMZ West');
        insert rAOExt;        
        
        // CUSTOMER CLASS
        
        Customer_Class__c ccExt = new Customer_Class__c(Active__c = true
                                                     , COS__c = 111
                                                     , CustClass__c = 'S4Q'
                                                     , Cust_Count__c = 123
                                                     , Customer_Class_Details__c = 'TEST THIS'
                                                     , CustomerCountry__c = 'US'
                                                     , CustomerSBU__c = 'SC'
                                                     , Duplicate__c = false
                                                     , Net_Sales__c = 111
                                                     , Price_Region__c = rExt.Id
                                                     , PPS_Rgn__c = 'SC');
        insert ccExt;
        
        Customer_Class__c ccAOExt = new Customer_Class__c(Active__c = true
                                                      , COS__c = 111
                                                      , CustClass__c = 'S8Q'
                                                      , Cust_Count__c = 123
                                                      , Customer_Class_Details__c = 'TEST THIS'
                                                      , CustomerCountry__c = 'US'
                                                      , CustomerSBU__c = 'DI'
                                                      , Duplicate__c = false
                                                      , Net_Sales__c = 111
                                                      , Price_Region__c = rAOExt.Id
                                                      , PPS_Rgn__c = 'AO WCNSSC');
        insert ccAOExt;
        
        // SSC
        
        SSC__c sscExt = new SSC__c(Closed__c = false
                                , DW_ID__c = '000111'    
                                , Loc_Type__c = 'SSC'
                                , Manager__c = UserInfo.getUserId()
                                , Region__c = rExt.Id
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
        insert sscExt;
        
        SSC__c sscAOExt = new SSC__c(Closed__c = false
                                 , DW_ID__c = '000112'
                                 , Loc_Type__c = 'SSC'
                                 , Manager__c = Null
                                 , Region__c = rAOExt.Id
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
        insert sscAOExt;                

        // CUSTOMER TYPE
        
        Customer_Type__c ctExt = new Customer_Type__c(Active__c = true
                                                   , Select__c = true
                                                   , SBU__c = 'SC'
                                                   , Name = 'CT EXT SC'
                                                   , Region__c = rExt.Id);
        insert ctExt;
        
        Customer_Type__c ctAOExt = new Customer_Type__c(Active__c = true
                                                    , Select__c = true
                                                    , SBU__c = 'DI'
                                                    , Name = 'CT EXT DI'
                                                    , Region__c = rAOExt.Id);
        insert ctAOExt;
                
        // SALES REPS
        
        Sales_Representative__c srExt = new Sales_Representative__c(SBU__c = 'SC'
                                                                 , DW_ID__c = '07'
                                                                 , Region__c = rExt.Id);
        insert srExt;
        
        Sales_Representative__c srAOExt = new Sales_Representative__c(SBU__c = 'DI'
                                                                  , DW_ID__c = '97'
                                                                  , Region__c = rAOExt.Id);
        insert srAOExt;

        String customerRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer Account').getRecordTypeId();
        
        Account a1 = new Account ( NAME = 'TEST ACCOUNT 01'
                           , RecordTypeId = customerRecordTypeID
                           , AccountNumber = '111111'
                           , Customer_Base__c = '111111'
                           , Customer_Class__c = cc1.id
                           , phone = '214-309-4193'
                           , Customer_Type__c = ct1.id
                           , DW_ID__c = '11111'
                           , GroupKey__c = '11111'
                           , SAP_Account_Id__c = '11111'
                           , Fax = '214-309-4193'
                           , Website = 'wwww.test.com'
                           , Require_PO__c = FALSE
                           , Region__c = r1.Id
                           , OwnerId = uSR2.id
                           , Salesman__c = sr1.id
                           , SSC__c = ssc1.id
                           , Customer_Suffix__c = '11'
                           , BillingStreet = '111111'
                           , BillingCity = 'DALLAS'
                           , BillingState = 'TX'
                           , BillingPostalCode = '75218'
                           , BillingCountry = 'US'
                           , ShippingStreet = '111111'
                           , ShippingCity = 'DALLAS'
                           , ShippingState = 'TX'
                           , ShippingPostalCode = '75218'
                           , ShippingCountry = 'DALLAS'
                           , Address_3__c = 'huh'
                           , SBU__C  = 'SC');
        insert a1;
        
        Account a2 = new Account ( NAME = 'Internal Account'
                           , AccountNumber = '111112'
                           , Customer_Base__c = '111111'
                           , OwnerId = uSR2.Id
                           , Customer_Class__c = cc1.id
                           , phone = '214-309-4193'
                           , Customer_Type__c = ct1.id
                           , DW_ID__c = '11112'
                           , GroupKey__c = '11111'
                           , SAP_Account_Id__c = '11111'
                           , Fax = '214-309-4193'
                           , Website = 'wwww.test.com'
                           , Require_PO__c = FALSE
                           , Region__c = r1.Id
                           , Salesman__c = sr1.id
                           , SSC__c = ssc1.id
                           , Customer_Suffix__c = '11'
                           , BillingStreet = '111111'
                           , BillingCity = 'DALLAS'
                           , BillingState = 'TX'
                           , BillingPostalCode = '75218'
                           , BillingCountry = 'US'
                           , ShippingStreet = '111111'
                           , ShippingCity = 'DALLAS'
                           , ShippingState = 'TX'
                           , ShippingPostalCode = '75218'
                           , ShippingCountry = 'DALLAS'
                           , Address_3__c = 'huh'
                           , SBU__C  = 'SC');
        insert a2;
        
        Account a3 = new Account ( NAME = 'TEST ACCOUNT 03'
                           , AccountNumber = '111113'
                           , OwnerId = uMGR1.Id
                           , Customer_Base__c = '111111'
                           , Customer_Class__c = cc1.id
                           , phone = '214-309-4193'
                           , Customer_Type__c = ct1.id
                           , DW_ID__c = '11113'
                           , GroupKey__c = '11111'
                           , SAP_Account_Id__c = '11111'
                           , Fax = '214-309-4193'
                           , Website = 'wwww.test.com'
                           , Require_PO__c = FALSE
                           , Region__c = r1.Id
                           , Salesman__c = sr1.id
                           , SSC__c = ssc1.id
                           , Customer_Suffix__c = '11'
                           , BillingStreet = '111111'
                           , BillingCity = 'DALLAS'
                           , BillingState = 'TX'
                           , BillingPostalCode = '75218'
                           , BillingCountry = 'US'
                           , ShippingStreet = '111111'
                           , ShippingCity = 'DALLAS'
                           , ShippingState = 'TX'
                           , ShippingPostalCode = '75218'
                           , ShippingCountry = 'DALLAS'
                           , Address_3__c = 'huh'
                           , SBU__C  = 'SC');
        insert a3;      
        
        Account a4 = new Account ( NAME = 'TEST ACCOUNT 04'
                                   , AccountNumber = '111114'
                                   , RecordTypeId = customerRecordTypeID
                                   , Customer_Base__c = '111114'
                                   , OwnerId = uSR2.Id
                                   , Customer_Class__c = cc3.id
                                   , phone = '214-309-4193'
                                   , Customer_Type__c = ct2.id
                                   , DW_ID__c = '111114'
                                   , GroupKey__c = '111114'
                                   , SAP_Account_Id__c = '111114'
                                   , Fax = '214-309-4193'
                                   , Website = 'wwww.test.com'
                                   , Require_PO__c = FALSE
                                   , Region__c = r2.Id
                                   , Salesman__c = sr3.id
                                   , SSC__c = ssc3.id
                                   , Customer_Suffix__c = '11'
                                   , BillingStreet = '111111'
                                   , BillingCity = 'DALLAS'
                                   , BillingState = 'TX'
                                   , BillingPostalCode = '75218'
                                   , BillingCountry = 'US'
                                   , ShippingStreet = '111111'
                                   , ShippingCity = 'DALLAS'
                                   , ShippingState = 'TX'
                                   , ShippingPostalCode = '75218'
                                   , ShippingCountry = 'DALLAS'
                                   , Address_3__c = 'huh'
                                   , SBU__C  = 'SC');
        insert a4;   

        Account aDUPE = new Account( NAME = 'TEST ACCOUNT DUPE'
                                   , AccountNumber = '180381'
                                   , RecordTypeId = customerRecordTypeID
                                   , Customer_Base__c = '180381'
                                   , Customer_Class__c = cc1.id
                                   , phone = '214-309-4193'
                                   , Customer_Type__c = ct1.id
                                   , DW_ID__c = '180381'
                                   , GroupKey__c = '180381'
                                   , SAP_Account_Id__c = '180381'
                                   , Fax = '214-309-4193'
                                   , Website = 'wwww.test.com'
                                   , Require_PO__c = FALSE
                                   , Region__c = r1.Id
                                   , OwnerId = uSR2.id
                                   , Salesman__c = sr1.id
                                   , SSC__c = ssc1.id
                                   , Customer_Suffix__c = '11'
                                   , BillingStreet = '111111'
                                   , BillingCity = 'DALLAS'
                                   , BillingState = 'TX'
                                   , BillingPostalCode = '75218'
                                   , BillingCountry = 'US'
                                   , ShippingStreet = '111111'
                                   , ShippingCity = 'DALLAS'
                                   , ShippingState = 'TX'
                                   , ShippingPostalCode = '75218'
                                   , ShippingCountry = 'DALLAS'
                                   , Address_3__c = 'huh'
                                   , SBU__C  = 'SC');
                                   
        try {
                insert aDUPE;
        }   catch (Exception e) {
            System.debug('::::testChangeRequestValidations + insert aDUPE::::> ' + e.getMessage());
        } 

        Contact con1 = new Contact();
            con1.FirstName = 'Jon';
            con1.LastName = 'Test';
            con1.AccountId = a1.Id;
            con1.Email = 'testingssome@tester.com.test';
            con1.Phone = '3216549871';
        insert con1;       
        
        Case cs1 = new Case();
            cs1.AccountId = a1.ID;
            cs1.ContactId = con1.Id;
            cs1.Type = 'Claims';
            cs1.Origin = 'Phone';
            cs1.Status = 'In Progress';
            cs1.Subject = 'ProExchange New Account Test';
        insert cs1;
        
        Change_Request__c cr1 = new Change_Request__c(SBU__c = 'SC'
                                                      , IsNew__c = false
                                                      , Customer_Name__c = 'Account For Dupe Catcher'
                                                      , Reason_for_New_Suffix__c = 'cause'
                                                      , Customer_Class_n__c = cc1.id
                                                      , Business_Reason__c = 'TEST'
                                                      , Sales_Representative__c = sr1.Id
                                                      , Customer_Class__c = cc1.Id
                                                      , Customer_Type__c = ct1.Id
                                                      , RecordTypeId = Label.CR_New_Customer_RT
                                                      , SSC__c = ssc1.Id
                                                      , Name__c = 'NULL Tester'
                                                      , Ship_To_Phone__c = '(972) 489-4406'
                                                      , Fax__c = '(972) 489-4406'
                                                      , Region__c = r1.Id
                                                      , Status__c = 'Submitting for Approval'
                                                      , Copy_Bill_To_Address__c = TRUE
                                                      , Bill_Country_N__c = 'US'
                                                      , Billing_Street_N__c = '13'
                                                      , Address2__c = '11'
                                                      , Billing_City_N__c = 'Dallas'
                                                      , Billing_State_N2__c = 'TX'
                                                      , Billing_Zip_N__c = '75218'
                                                      , Contact__c = 'Jim'
                                                      );
        insert cr1; 
        
        Change_Request__c cr2 = new Change_Request__c(SBU__c = 'SC'
                                                        , IsNew__c = false
                                                        , RecordTypeId = Label.CR_Customer_Update_RT
                                                        , Account__c = a1.Id
                                                        , Customer_Name_Change__c = 'Name Change Dupe Catcher'
                                                        , Region__c = r1.Id
                                                        , Sales_Representative__c = sr1.Id
                                                        , Customer_Class__c = cc1.Id                                                       
                                                        , Customer_Type__c = ct1.Id
                                                        , SSC__c = ssc1.Id
                                                        , SSC_N__C = ssc2.id
                                                        , Sales_Representative_n__c = sr2.id
                                                        , Customer_Class_n__c = cc2.id
                                                        , Business_Reason__c = 'Because I love it'
                                                        , Customer_Type_n__c = ct2.id
                                                        , Billing_Street_N__c = 'Billing_Street_N__c'
                                                        , Shipping_street__c = 'Shipping_street__c'
                                                        , Status__c = 'Submitting for Approval');
        insert cr2;

        Change_Request__c cr3 = new Change_Request__c(SBU__c = 'SC'
                                                      , IsNew__c = false
                                                      , Customer_Name__c = 'Account For ProExchange'
                                                      , Reason_for_New_Suffix__c = 'cause'
                                                      , Customer_Class_n__c = cc1.id
                                                      , Business_Reason__c = 'TEST'
                                                      , Sales_Representative__c = sr1.Id
                                                      , Customer_Class__c = cc1.Id
                                                      , Customer_Type__c = ct1.Id
                                                      , RecordTypeId = Label.CR_New_Customer_RT
                                                      , SSC__c = ssc1.Id
                                                      , Name__c = 'NULL Tester'
                                                      , Ship_To_Phone__c = '(972) 489-4406'
                                                      , Fax__c = '(972) 489-4406'
                                                      , Region__c = r1.Id
                                                      , Status__c = 'Submitting for Approval'
                                                      , Copy_Bill_To_Address__c = TRUE
                                                      , Bill_Country_N__c = 'US'
                                                      , Billing_Street_N__c = '13'
                                                      , Address2__c = '11'
                                                      , Billing_City_N__c = 'Dallas'
                                                      , Billing_State_N2__c = 'TX'
                                                      , Billing_Zip_N__c = '75218'
                                                      , Contact__c = 'Jim'
                                                      , Contact_First_Name__c = 'Jim'
                                                      , Contact_Last_Name__c = 'Jam'
                                                      , Contact_Email__c = 'Jim.Jam@rock.test.com.dttest'
                                                      , Set_Up_In_ProExchange__c = true
                                                      , Case__c = cs1.Id
                                                      );
        insert cr3; 

    }
    
    @isTest
    public static void testNewShipTo() {
        System.debug('testNewShipTo:...');
        Account a = [   SELECT ID
                        FROM Account
                        WHERE NAME = 'TEST ACCOUNT 01'
        ];
        Region__c r = [ SELECT ID
                        FROM Region__c
                        WHERE Name = 'SOUTHERN CA REGION'
        ];
        Customer_Class__c cc1 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC1'
        ];
        Customer_Class__c cc2 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC2'
        ];
        Customer_Type__c ct1 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'DAL CT1'
        ];
        Customer_Type__c ct2 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'CANADIAN CT3'
        ];
        SSC__c ssc1 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '001'
        ];
        SSC__c ssc2 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '002'
        ];
        Sales_Representative__c sr1 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '001'
        ];
        Sales_Representative__c sr2 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '002'
        ];
        
        User uSR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR1@daltile.com.test'
        ]; 
        
        User uSR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR2@daltile.com.test'
        ]; 

        User uMGR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR1@daltile.com.test'
        ]; 
        
        User uMGR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR2@daltile.com.test'
        ]; 
                
        User uRSM = [   SELECT ID
                        FROM User
                        WHERE username = 'RSM@daltile.com.test'
	    ];
	    
        User uRVP = [   SELECT ID
                        FROM User
                        WHERE username = 'RVP@daltile.com.test'
	    ];
	    
		Test.startTest();
        
    
        try {
                Change_Request__c cr = new Change_Request__c(SBU__c = 'SC'
                                                                , IsNew__c = false
                                                                , RecordTypeId = Label.CR_Customer_Update_RT
                                                                , Account__c = a.Id
                                                                , Region__c = r.Id
                                                                , Sales_Representative__c = sr1.Id
                                                                , Customer_Class__c = cc1.Id                                                       
                                                                , Customer_Type__c = ct1.Id
                                                                , SSC__c = ssc1.Id
                                                                , Name__c = 'NEW CUSTOMER NAME'
                                                                , Bill_Country_N__c = 'US'
                                                                , Business_Reason__c = 'testing...' 
                                                                , Copy_Bill_To_Address__c = TRUE
                                                                , Shipping_Zip_N__c = '75218'
                                                                , Billing_City__c = 'test city'
                                                                , Reason_for_New_Suffix__c = 'testing'
                                                                , SSC_N__C = ssc2.id
                                                                , Customer_Class_N__c = cc2.id
                                                                , Sales_Representative_n__c = sr2.id
                                                                , New_ShipTo_Request__c = TRUE
                                                                , Status__c = 'Creating');
                cr.Status__c = 'Submitting for Approval';
                cr.MGR_WF2__c = true;
                cr.RVPWF1__c = true;
            System.runAs(uSR2) { 
                insert cr;
            }          
            System.runAs(uMGR1) {      
                cr.Status__c = 'Submitted-Pending MGR Approval';
                cr.MGR_2_Approved__c = TRUE;
                Update cr;
                System.debug('testNewShipTo + MGR APPROVED + cr.Status__c:...' + cr.Status__c);
                System.debug('testNewShipTo + MGR APPROVED + cr.Approver1__c:...' + cr.Approver1__c);
                System.debug('testNewShipTo + uRVP:...' + uRVP);
            }          
            System.runAs(uRVP) {      
                cr.RVP_Approved__c = TRUE;
                Update cr;
                System.debug('testNewShipTo + RSM APPROVED + cr.Status__c:...' + cr.Status__c);
            }
            delete cr;
        }catch (Exception e) {
            System.debug('::::TestCaseTrigger + e : ' + e );
            
        }   
    }
    
    @isTest
    public static void testNewShipToRVP() {
        System.debug('testNewShipTo:...');
        Account a = [   SELECT ID
                        FROM Account
                        WHERE NAME = 'TEST ACCOUNT 01'
        ];
        Region__c r = [ SELECT ID
                        FROM Region__c
                        WHERE Name = 'SOUTHERN CA REGION'
        ];
        Customer_Class__c cc1 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC1'
        ];
        Customer_Class__c cc2 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC2'
        ];
        Customer_Type__c ct1 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'DAL CT1'
        ];
        Customer_Type__c ct2 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'CANADIAN CT3'
        ];
        SSC__c ssc1 = [  SELECT ID
                                , RSM__C
                                , RVP__c
                                , Manager__c
                        FROM SSC__c
                        WHERE DW_ID__c = '001'
        ];
        SSC__c ssc2 = [  SELECT ID
                                , RSM__C
                                , RVP__c
                                , Manager__c
                        FROM SSC__c
                        WHERE DW_ID__c = '002'
        ];
        Sales_Representative__c sr1 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '001'
        ];
        Sales_Representative__c sr2 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '002'
        ];
        
        User uSR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR1@daltile.com.test'
        ]; 
        
        User uSR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR2@daltile.com.test'
        ]; 

        User uMGR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR1@daltile.com.test'
        ]; 
        
        User uMGR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR2@daltile.com.test'
        ]; 
                
        User uRSM = [   SELECT ID
                        FROM User
                        WHERE username = 'RSM@daltile.com.test'
	    ];
	    
        User uRVP = [   SELECT ID
                            , Name
                            , ProfileId
                            , Profile.Name
                        FROM User
                        WHERE username = 'RVP@daltile.com.test'
	    ];
                
        System.debug( ' :::testNewShipToRVP + uRVP.Name + Profile.Name:::>' + uRVP.Name + ' / ' + uRVP.Profile.Name);
	    
		Test.startTest();
        
        System.runAs(uRVP) {     
			try {
					Change_Request__c cr = new Change_Request__c(SBU__c = 'SC'
																	, IsNew__c = false
																	, RecordTypeId = Label.CR_Customer_Update_RT
																	, Account__c = a.Id
																	, Region__c = r.Id
																	, Sales_Representative__c = sr1.Id
																	, Customer_Class__c = cc1.Id                                                       
																	, Customer_Type__c = ct1.Id
																	, SSC__c = ssc2.Id
																	, Name__c = 'NEW CUSTOMER NAME'
																	, Bill_Country_N__c = 'US'
																	, Business_Reason__c = 'testing...' 
																	, Copy_Bill_To_Address__c = TRUE
																	, Shipping_Zip_N__c = '75218'
																	, Billing_City__c = 'test city'
																	, Reason_for_New_Suffix__c = 'testing'
																	, SSC_N__C = ssc2.id
																	, Customer_Class_N__c = cc2.id
																	, Sales_Representative_n__c = sr2.id
																	, New_ShipTo_Request__c = TRUE
																	, Status__c = 'Creating');

					insert cr;
					
					cr.Status__c = 'Submitting for Approval';
					cr.MGR_WF2__c = true;
					cr.RVPWF1__c = true;
					
					update cr;
				delete cr;
			}catch (Exception e) {
				System.debug('::::TestCaseTrigger + e : ' + e );
				
			}   
		}
    }

    @isTest
    public static void testNewShipToRSM() {
        System.debug('testNewShipTo:...');
        Account a = [   SELECT ID
                        FROM Account
                        WHERE NAME = 'TEST ACCOUNT 01'
        ];
        Region__c r = [ SELECT ID
                        FROM Region__c
                        WHERE Name = 'SOUTHERN CA REGION'
        ];
        Customer_Class__c cc1 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC1'
        ];
        Customer_Class__c cc2 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC2'
        ];
        Customer_Type__c ct1 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'DAL CT1'
        ];
        Customer_Type__c ct2 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'CANADIAN CT3'
        ];
        SSC__c ssc1 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '001'
        ];
        SSC__c ssc2 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '002'
        ];
        Sales_Representative__c sr1 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '001'
        ];
        Sales_Representative__c sr2 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '002'
        ];
        
        User uSR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR1@daltile.com.test'
        ]; 
        
        User uSR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR2@daltile.com.test'
        ]; 

        User uMGR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR1@daltile.com.test'
        ]; 
        
        User uMGR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR2@daltile.com.test'
        ]; 
                
        User uRSM = [   SELECT ID
                        FROM User
                        WHERE username = 'RSM@daltile.com.test'
	    ];
	    
        User uRVP = [   SELECT ID
                        FROM User
                        WHERE username = 'RVP@daltile.com.test'
	    ];
	    
		Test.startTest();
        
		System.runAs(uRSM) {     
    
			try {
					Change_Request__c cr = new Change_Request__c(SBU__c = 'SC'
																	, IsNew__c = false
																	, RecordTypeId = Label.CR_Customer_Update_RT
																	, Account__c = a.Id
																	, Region__c = r.Id
																	, Sales_Representative__c = sr1.Id
																	, Customer_Class__c = cc1.Id                                                       
																	, Customer_Type__c = ct1.Id
																	, SSC__c = ssc1.Id
																	, Name__c = 'NEW CUSTOMER NAME'
																	, Bill_Country_N__c = 'US'
																	, Business_Reason__c = 'testing...' 
																	, Copy_Bill_To_Address__c = TRUE
																	, Shipping_Zip_N__c = '75218'
																	, Billing_City__c = 'test city'
																	, Reason_for_New_Suffix__c = 'testing'
																	, SSC_N__C = ssc2.id
																	, Customer_Class_N__c = cc2.id
																	, Sales_Representative_n__c = sr2.id
																	, New_ShipTo_Request__c = TRUE
																	, Status__c = 'Creating');
					cr.Status__c = 'Submitting for Approval';
					cr.MGR_WF2__c = true;
					cr.RVPWF1__c = true;
				System.runAs(uSR2) { 
					insert cr;
				}          
				System.runAs(uMGR1) {      
					cr.Status__c = 'Submitted-Pending MGR Approval';
					cr.MGR_2_Approved__c = TRUE;
					Update cr;
					System.debug('testNewShipTo + MGR APPROVED + cr.Status__c:...' + cr.Status__c);
					System.debug('testNewShipTo + MGR APPROVED + cr.Approver1__c:...' + cr.Approver1__c);
					System.debug('testNewShipTo + uRVP:...' + uRVP);
				}          
				System.runAs(uRVP) {      
					cr.RVP_Approved__c = TRUE;
					Update cr;
					System.debug('testNewShipTo + RSM APPROVED + cr.Status__c:...' + cr.Status__c);
				}
				delete cr;
			}catch (Exception e) {
				System.debug('::::TestCaseTrigger + e : ' + e );
				
			}   
		}
    }
	
    @isTest
    public static void testNewShipToMGR1() {
        System.debug('testNewShipTo:...');
        Account a = [   SELECT ID
                        FROM Account
                        WHERE NAME = 'TEST ACCOUNT 01'
        ];
        Region__c r = [ SELECT ID
                        FROM Region__c
                        WHERE Name = 'SOUTHERN CA REGION'
        ];
        Customer_Class__c cc1 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC1'
        ];
        Customer_Class__c cc2 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC2'
        ];
        Customer_Type__c ct1 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'DAL CT1'
        ];
        Customer_Type__c ct2 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'CANADIAN CT3'
        ];
        SSC__c ssc1 = [  SELECT ID, RSM__C, RVP__C, Manager__c, RSM__r.IsActive, RVP__r.IsActive, Manager__r.IsActive
                        FROM SSC__c
                        WHERE DW_ID__c = '001'
        ];
        SSC__c ssc2 = [  SELECT ID, RSM__C, RVP__C, Manager__c, RSM__r.IsActive, RVP__r.IsActive, Manager__r.IsActive
                        FROM SSC__c
                        WHERE DW_ID__c = '002'
        ];
        Sales_Representative__c sr1 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '001'
        ];
        Sales_Representative__c sr2 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '002'
        ];
        
        User uSR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR1@daltile.com.test'
        ]; 
        
        User uSR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR2@daltile.com.test'
        ]; 

        User uMGR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR1@daltile.com.test'
        ]; 
        
        User uMGR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR2@daltile.com.test'
        ]; 
                
        User uRSM = [   SELECT ID
                        FROM User
                        WHERE username = 'RSM@daltile.com.test'
	    ];
	    
        User uRVP = [   SELECT ID
                        FROM User
                        WHERE username = 'RVP@daltile.com.test'
	    ];
	    
		Test.startTest();
        
		System.runAs(uMGR1) {     
    
            try {
                    Change_Request__c cr = new Change_Request__c(SBU__c = 'SC'
                                                                    , IsNew__c = false
                                                                    , RecordTypeId = Label.CR_Customer_Update_RT
                                                                    , Account__c = a.Id
                                                                    , Region__c = r.Id
                                                                    , Sales_Representative__c = sr1.Id
                                                                    , Customer_Class__c = cc1.Id                                                       
                                                                    , Customer_Type__c = ct1.Id
                                                                    , SSC__c = ssc1.Id
                                                                    , Name__c = 'NEW CUSTOMER NAME'
                                                                    , Bill_Country_N__c = 'US'
                                                                    , Business_Reason__c = 'testing...' 
                                                                    , Copy_Bill_To_Address__c = TRUE
                                                                    , Shipping_Zip_N__c = '75218'
                                                                    , Billing_City__c = 'test city'
                                                                    , Reason_for_New_Suffix__c = 'testing'
                                                                    , SSC_N__C = ssc1.id
                                                                    , Customer_Class_N__c = cc2.id
                                                                    , Sales_Representative_n__c = sr2.id
                                                                    , New_ShipTo_Request__c = TRUE
                                                                    , Status__c = 'Creating');
                    cr.Status__c = 'Submitting for Approval';
                    cr.MGR_WF2__c = true;
                    cr.RVPWF1__c = true;
                System.runAs(uSR2) { 
                    insert cr;
                }          
                System.runAs(uMGR1) {      
                    cr.Status__c = 'Submitted-Pending MGR Approval';
                    cr.MGR_2_Approved__c = TRUE;
                    Update cr;
                    System.debug('testNewShipTo + MGR APPROVED + cr.Status__c:...' + cr.Status__c);
                    System.debug('testNewShipTo + MGR APPROVED + cr.Approver1__c:...' + cr.Approver1__c);
                    System.debug('testNewShipTo + uRVP:...' + uRVP);
                }          
                System.runAs(uRVP) {      
                    cr.RVP_Approved__c = TRUE;
                    Update cr;
                    System.debug('testNewShipTo + RSM APPROVED + cr.Status__c:...' + cr.Status__c);
                }
                delete cr;
            }catch (Exception e) {
                System.debug('::::TestCaseTrigger + e : ' + e );
                
            }   
        }
    }
		
    @isTest
    public static void testNewSscAsMGR2() {
        System.debug('testSSCChange:...');

        Account a = [   SELECT ID
                        FROM Account
                        WHERE NAME = 'TEST ACCOUNT 01'
        ];
        Region__c r = [ SELECT ID
                        FROM Region__c
                        WHERE Name = 'SOUTHERN CA REGION'
        ];
        Customer_Class__c cc1 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC1'
        ];
        Customer_Class__c cc2 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC2'
        ];
        Customer_Type__c ct1 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'DAL CT1'
        ];
        Customer_Type__c ct2 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'CANADIAN CT3'
        ];
        SSC__c ssc1 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '001'
        ];
        SSC__c ssc2 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '002'
        ];
        Sales_Representative__c sr1 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '001'
        ];
        Sales_Representative__c sr2 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '002'
        ];
        
        User uSR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR1@daltile.com.test'
        ]; 
        
        User uSR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR2@daltile.com.test'
        ]; 

        User uMGR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR1@daltile.com.test'
        ]; 
                
        User uMGR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR2@daltile.com.test'
        ]; 
                
		Test.startTest();
    
        // SSC Only Change
        System.runAs(uMGR2) {     
            try {
                
                Change_Request__c cr = new Change_Request__c(SBU__c = 'SC'
                                                                , IsNew__c = false
                                                                , RecordTypeId = Label.CR_Customer_Update_RT
                                                                , Account__c = a.Id
                                                                , Region__c = r.Id
                                                                , Sales_Representative__c = sr1.Id
                                                                , Customer_Class__c = cc1.Id                                                       
                                                                , Customer_Type__c = ct1.Id
                                                                , SSC__c = ssc1.Id
                                                                , SSC_N__C = ssc2.id
                                                                , Status__c = 'Creating');
                insert cr;
                Map <ID, SObject> mapRequest = new Map <ID, SObject>();
                mapRequest.put(cr.Id, cr);
                ChangeRequestGateway.onAfterInsert(mapRequest);
                ChangeRequestGateway.validate();
                cr.Status__c = 'Submitting for Approval';
                Update cr;
                cr.MGR_WF1__c = TRUE;
                cr.MGR_1_Approved__c = TRUE;
                Update cr;
                cr.MGR_2_Approved__c = TRUE;
                Update cr;
                
            }catch (Exception e) {
                System.debug('::::TestCaseTrigger + e : ' + e );
                
            }   
        }
    }	
	
    @isTest
    public static void testNewShipToNullApprovers() {
        System.debug('testNewShipTo:...');
        Account a = [   SELECT ID
                        FROM Account
                        WHERE NAME = 'TEST ACCOUNT 01'
        ];
        Region__c r = [ SELECT ID
                        FROM Region__c
                        WHERE Name = 'SOUTHERN CA REGION'
        ];
        Customer_Class__c cc1 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC1'
        ];
        Customer_Class__c cc2 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC2'
        ];
        Customer_Type__c ct1 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'DAL CT1'
        ];
        Customer_Type__c ct2 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'CANADIAN CT3'
        ];
        SSC__c sscNULL = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '004'
        ];
        SSC__c ssc2 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '002'
        ];
        Sales_Representative__c sr1 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '001'
        ];
        Sales_Representative__c sr2 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '002'
        ];
        
        User uSR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR1@daltile.com.test'
        ]; 
        
        User uSR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR2@daltile.com.test'
        ]; 

        User uMGR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR1@daltile.com.test'
        ]; 
        
        User uMGR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR2@daltile.com.test'
        ]; 
                
        User uRSM = [   SELECT ID
                        FROM User
                        WHERE username = 'RSM@daltile.com.test'
	    ];
	    
        User uRVP = [   SELECT ID
                        FROM User
                        WHERE username = 'RVP@daltile.com.test'
	    ];
	    
		Test.startTest();
        
		System.runAs(uMGR1) {     
    
            try {
                    Change_Request__c cr = new Change_Request__c(SBU__c = 'SC'
                                                                    , IsNew__c = false
                                                                    , RecordTypeId = Label.CR_Customer_Update_RT
                                                                    , Account__c = a.Id
                                                                    , Region__c = r.Id
                                                                    , Sales_Representative__c = sr1.Id
                                                                    , Customer_Class__c = cc1.Id                                                       
                                                                    , Customer_Type__c = ct1.Id
                                                                    , SSC__c = sscNULL.Id
                                                                    , Name__c = 'NEW CUSTOMER NAME'
                                                                    , Bill_Country_N__c = 'US'
                                                                    , Business_Reason__c = 'testing...' 
                                                                    , Copy_Bill_To_Address__c = TRUE
                                                                    , Shipping_Zip_N__c = '75218'
                                                                    , Billing_City__c = 'test city'
                                                                    , Reason_for_New_Suffix__c = 'testing'
                                                                    , SSC_N__C = sscNULL.id
                                                                    , Customer_Class_N__c = cc2.id
                                                                    , Sales_Representative_n__c = sr2.id
                                                                    , New_ShipTo_Request__c = TRUE
                                                                    , Status__c = 'Creating');
                    cr.Status__c = 'Submitting for Approval';
                    cr.MGR_WF2__c = true;
                    cr.RVPWF1__c = true;
                System.runAs(uSR2) { 
                    insert cr;
                }          
                System.runAs(uMGR1) {      
                    cr.Status__c = 'Submitted-Pending MGR Approval';
                    cr.MGR_2_Approved__c = TRUE;
                    Update cr;
                    System.debug('testNewShipTo + MGR APPROVED + cr.Status__c:...' + cr.Status__c);
                    System.debug('testNewShipTo + MGR APPROVED + cr.Approver1__c:...' + cr.Approver1__c);
                    System.debug('testNewShipTo + uRVP:...' + uRVP);
                }          
                System.runAs(uRVP) {      
                    cr.RVP_Approved__c = TRUE;
                    Update cr;
                    System.debug('testNewShipTo + RSM APPROVED + cr.Status__c:...' + cr.Status__c);
                }
                delete cr;
            }catch (Exception e) {
                System.debug('::::TestCaseTrigger + e : ' + e );
                
            }
		}
    }
	    
    
    @isTest
    public static void testSalesRepChange() {

        System.debug('testSalesRepChange:...');
        
        Account a = [   SELECT ID
                        FROM Account
                        WHERE NAME = 'TEST ACCOUNT 03'
        ];
        Region__c r = [ SELECT ID
                        FROM Region__c
                        WHERE Name = 'SOUTHERN CA REGION'
        ];
        Customer_Class__c cc1 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC1'
        ];
        Customer_Class__c cc2 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC2'
        ];
        Customer_Type__c ct1 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'DAL CT1'
        ];
        Customer_Type__c ct2 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'CANADIAN CT3'
        ];
        SSC__c ssc1 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '001'
        ];
        SSC__c ssc2 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '002'
        ];
        Sales_Representative__c sr1 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '001'
        ];
        Sales_Representative__c sr2 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '002'
        ];
        
        User uSR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR1@daltile.com.test'
        ]; 
        
        User uSR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR2@daltile.com.test'
        ]; 

        User MGR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR1@daltile.com.test'
        ]; 
                
		Test.startTest();
    
        // Sales Rep only change
        System.runAs(uSR2) {     
            try {
                
                Change_Request__c cr = new Change_Request__c(SBU__c = 'SC'
                                                                , IsNew__c = false
                                                                , RecordTypeId = Label.CR_Customer_Update_RT
                                                                , Account__c = a.Id
                                                                , Region__c = r.Id
                                                                , Sales_Representative__c = sr1.Id
                                                                , Customer_Class__c = cc1.Id                                                       
                                                                , Customer_Type__c = ct1.Id
                                                                , SSC__c = ssc1.Id
                                                                , Sales_Representative_n__c = sr2.id
                                                                , Status__c = 'Submitting for Approval');
                insert cr;
                cr.MGR_WF1__c = TRUE;
                cr.MGR_1_Approved__c = TRUE;
                Update cr;
                cr.MGR_2_Approved__c = TRUE;
                Update cr;
                
            }catch (Exception e) {
                System.debug('::::TestCaseTrigger + e : ' + e );
                
            }   
        }     
    }
    
    @isTest
    public static void testSSCChange() {

        System.debug('testSSCChange:...');

        Account a = [   SELECT ID
                        FROM Account
                        WHERE NAME = 'TEST ACCOUNT 01'
        ];
        Region__c r = [ SELECT ID
                        FROM Region__c
                        WHERE Name = 'SOUTHERN CA REGION'
        ];
        Customer_Class__c cc1 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC1'
        ];
        Customer_Class__c cc2 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC2'
        ];
        Customer_Type__c ct1 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'DAL CT1'
        ];
        Customer_Type__c ct2 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'CANADIAN CT3'
        ];
        SSC__c ssc1 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '001'
        ];
        SSC__c ssc2 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '002'
        ];
        Sales_Representative__c sr1 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '001'
        ];
        Sales_Representative__c sr2 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '002'
        ];
        
        User uSR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR1@daltile.com.test'
        ]; 
        
        User uSR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR2@daltile.com.test'
        ]; 

        User uMGR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR1@daltile.com.test'
        ]; 
                
		Test.startTest();
    
        // SSC Only Change
        System.runAs(uSR2) {     
            try {
                
                Change_Request__c cr = new Change_Request__c(SBU__c = 'SC'
                                                                , IsNew__c = false
                                                                , RecordTypeId = Label.CR_Customer_Update_RT
                                                                , Account__c = a.Id
                                                                , Region__c = r.Id
                                                                , Sales_Representative__c = sr1.Id
                                                                , Customer_Class__c = cc1.Id                                                       
                                                                , Customer_Type__c = ct1.Id
                                                                , SSC__c = ssc1.Id
                                                                , SSC_N__C = ssc2.id
                                                                , Status__c = 'Creating');
                insert cr;
                Map <ID, SObject> mapRequest = new Map <ID, SObject>();
                mapRequest.put(cr.Id, cr);
                ChangeRequestGateway.onAfterInsert(mapRequest);
                ChangeRequestGateway.validate();
                cr.Status__c = 'Submitting for Approval';
                Update cr;
                cr.MGR_WF1__c = TRUE;
                cr.RVPWF1__c = true;
                cr.MGR_1_Approved__c = TRUE;
                Update cr;
                cr.MGR_2_Approved__c = TRUE;
                Update cr;
                cr.RVP_Approved__c = TRUE;
                Update cr;
                
            }catch (Exception e) {
                System.debug('::::TestCaseTrigger + e : ' + e );
                
            }   
        }     
        
        // submitted by MGR
        
        System.runAs(uMGR1) {     
            try {
                
                Change_Request__c cr = new Change_Request__c(SBU__c = 'SC'
                                                                , IsNew__c = false
                                                                , RecordTypeId = Label.CR_Customer_Update_RT
                                                                , Account__c = a.Id
                                                                , Region__c = r.Id
                                                                , Sales_Representative__c = sr1.Id
                                                                , Customer_Class__c = cc1.Id                                                       
                                                                , Customer_Type__c = ct1.Id
                                                                , SSC__c = ssc1.Id
                                                                , SSC_N__C = ssc2.id
                                                                , Status__c = 'Creating');
                insert cr;
                Map <ID, SObject> mapRequest = new Map <ID, SObject>();
                mapRequest.put(cr.Id, cr);
                ChangeRequestGateway.onAfterInsert(mapRequest);
                ChangeRequestGateway.validate();
                cr.Status__c = 'Submitting for Approval';
                Update cr;
                cr.MGR_WF1__c = TRUE;
                cr.MGR_1_Approved__c = TRUE;
                Update cr;
                cr.MGR_2_Approved__c = TRUE;
                Update cr;
                
            }catch (Exception e) {
                System.debug('::::TestCaseTrigger + e : ' + e );
                
            }   
        }     
        Test.stopTest();
    }

   @isTest
    public static void testClassChange() {

        System.debug('testClassChange:...');

        Account a = [   SELECT ID
                        FROM Account
                        WHERE NAME = 'TEST ACCOUNT 01'
        ];
        System.debug('testClassChange + a :...' + a);
        Region__c r = [ SELECT ID
                        FROM Region__c
                        WHERE Name = 'SOUTHERN CA REGION'
        ];
        System.debug('testClassChange + r :...' + r);
        Customer_Class__c cc1 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC1'
        ];
        System.debug('testClassChange + cc1 :...' + cc1);
        Customer_Class__c cc2 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC2'
        ];
        System.debug('testClassChange + cc3 :...' + cc2);
        Customer_Type__c ct1 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'DAL CT1'
        ];
        System.debug('testClassChange + ct1 :...' + ct1);
        Customer_Type__c ct2 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'CANADIAN CT3'
        ];
        System.debug('testClassChange + ct2 :...' + ct2);
        SSC__c ssc1 = [  SELECT ID, Manager__c, RVP__c, RSM__c
                        FROM SSC__c
                        WHERE DW_ID__c = '001'
        ];
        System.debug('testClassChange + ssc1 :...' + ssc1);
        SSC__c ssc2 = [  SELECT ID, Manager__c, RVP__c, RSM__c
                        FROM SSC__c
                        WHERE DW_ID__c = '002'
        ];
        System.debug('testClassChange + ssc2 :...' + ssc2);
        Sales_Representative__c sr1 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '001'
        ];
        System.debug('testClassChange + sr1 :...' + sr1);
        Sales_Representative__c sr2 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '002'
        ];
        System.debug('testClassChange + sr2 :...' + sr2);
        
        User uSR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR1@daltile.com.test'
        ]; 
        
        User uSR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR2@daltile.com.test'
        ]; 

        User MGR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR1@daltile.com.test'
        ]; 
                
		Test.startTest();
    
        // Class  Only Change
        try {
            // System.runAs(uSR2) {         
                Change_Request__c cr = new Change_Request__c(SBU__c = 'SC'
                                                                , IsNew__c = false
                                                                , RecordTypeId = Label.CR_Customer_Update_RT
                                                                , Account__c = a.Id
                                                                , Region__c = r.Id
                                                                , Sales_Representative__c = sr1.Id
                                                                , Customer_Class__c = cc1.Id                                                       
                                                                , Customer_Type__c = ct1.Id
                                                                , SSC__c = ssc1.Id
                                                                , Customer_Class_n__c = cc2.id
                                                                , Business_Reason__c = 'Test'
                                                                , Status__c = 'Creating');
                insert cr;                
 
            // }                   
            // try {

            //     // Map <ID, SObject> mapRequest = new Map <ID, SObject>();
            //     // mapRequest.put(cr.Id, cr);
            //     // ChangeRequestGateway.onAfterInsert(mapRequest);
            //     // ChangeRequestGateway.validate();
            //     Update cr;
                
            //     System.debug(LoggingLevel.ERROR,'::::TestClassChange 1 + cr : ' + cr );
            // }catch (Exception e) {
            //     System.debug('::::TestClassChange + e : ' + e );
            // }   
            try {
                cr.MGR_WF1__c = TRUE; 
                cr.RVPWF1__c = TRUE;
                cr.VPWF1__c = TRUE;
                Update cr;

                System.debug(LoggingLevel.ERROR,'::::testClassChange 1 + cr : ' + cr );
            }catch (Exception e) {
                System.debug('::::testClassChange + e : ' + e );
            }  
            try {
                cr.Status__c = 'Submitting for Approval';
                Update cr;

                System.debug(LoggingLevel.ERROR,'::::testClassChange 1.5 + cr : ' + cr );
            }catch (Exception e) {
                System.debug('::::testClassChange + e : ' + e );
            } 
            try {
                cr.Status__c = 'Submitted-Pending MGR Approval';
                Update cr;

                System.debug(LoggingLevel.ERROR,'::::testClassChange 1.75 + cr : ' + cr );
            }catch (Exception e) {
                System.debug('::::testClassChange + e : ' + e );
            }   
            try {
                cr.MGR_1_Approved__c = TRUE;
                cr.Status__c = 'Submitted-Pending RVP Approval';
                Update cr;

                System.debug(LoggingLevel.ERROR,'::::testClassChange 2 + cr : ' + cr );
            }catch (Exception e) {
                System.debug('::::testClassChange + e : ' + e );
            }   
            try {

                cr.RVP_Approved__c = TRUE;
                Update cr;
                
                System.debug(LoggingLevel.ERROR,'::::testClassChange 3 + cr : ' + cr );
            }catch (Exception e) {
                System.debug('::::testClassChange + e : ' + e );
            }   
            try {

                cr.Status__c = 'Approved';
                Update cr;
                
                System.debug(LoggingLevel.ERROR,'::::testClassChange 3 + cr : ' + cr );
            }catch (Exception e) {
                System.debug('::::testClassChange + e : ' + e );
            }   
            try {
                
                cr.VP_Approved__c = TRUE;
                Update cr;                
                
                System.debug(LoggingLevel.ERROR,'::::testClassChange 4 + cr : ' + cr );
                
            }catch (Exception e) {
                System.debug('::::testClassChange + e : ' + e );
            }                  
                
        }catch (Exception e) {
            System.debug('::::testClassChange + e : ' + e );
        }   
  
        Test.stopTest();
    }


    @isTest
    public static void testNewAccount() {

        System.debug('testNewAccount:...');
        
        String theRtTest = NEW_CUSTOMER_REQUEST;
        System.debug('testNewAccount + theRtTest:...' + theRtTest);

        Account a = [   SELECT ID, DW_ID__C
                        FROM Account
                        WHERE NAME = 'TEST ACCOUNT 01'
        ];
        Region__c r = [ SELECT ID
                        FROM Region__c
                        WHERE Name = 'SOUTHERN CA REGION'
        ];
        Customer_Class__c cc1 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC1'
        ];
        Customer_Class__c cc2 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC2'
        ];
        Customer_Type__c ct1 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'DAL CT1'
        ];
        Customer_Type__c ct2 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'CANADIAN CT3'
        ];
        SSC__c ssc1 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '001'
        ];
        SSC__c ssc2 = [ SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '002'
        ];
        Sales_Representative__c sr1 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '001'
        ];
        Sales_Representative__c sr2 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '002'
        ];
        
        User uSR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR1@daltile.com.test'
        ]; 
        
        User uSR2 = [   SELECT ID   
                        FROM User
                        WHERE username = 'uSR2@daltile.com.test'
        ]; 
        
        User uMGR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR1@daltile.com.test'
        ]; 
        
        User uMGR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR2@daltile.com.test'
        ]; 
        
        
        User uRSM = [   SELECT ID
                        FROM User
                        WHERE username = 'RSM@daltile.com.test'
	    ];
		Test.startTest();
        
        System.runAs(uSR2) {     
            try {
                Change_Request__c newCustomer = new Change_Request__c(SBU__c = 'SC'
                                                                      , IsNew__c = false
                                                                      , Customer_Name__c = 'Test Account'
                                                                      , Reason_for_New_Suffix__c = 'cause'
                                                                      , Customer_Class_n__c = cc1.id
                                                                      , Business_Reason__c = 'TEST'
                                                                      , Sales_Representative__c = sr1.Id
                                                                      , Customer_Class__c = cc1.Id
                                                                      , Customer_Type__c = ct1.Id
                                                                      , RecordTypeId = Label.CR_New_Customer_RT
                                                                      , SSC__c = ssc1.Id
                                                                      , Name__c = 'NULL Tester'
                                                                      , Ship_To_Phone__c = '(972) 489-4406'
                                                                      , Fax__c = '(972) 489-4406'
                                                                      , Region__c = r.Id
                                                                      , Status__c = 'Submitting for Approval'
                                                                      , Copy_Bill_To_Address__c = TRUE
                                                                      , Bill_Country_N__c = 'US'
                                                                      , Billing_Street_N__c = '13'
                                                                      , Address2__c = '11'
                                                                      , Billing_City_N__c = 'Dallas'
                                                                      , Billing_State_N2__c = 'TX'
                                                                      , Billing_Zip_N__c = '75218'
                                                                      , Contact_First_Name__c = 'Jim'
                                                                      , Contact_Last_Name__c = 'Jam'
                                                                      , Contact_Email__c = 'Jim.Jam@rock.test.com.dttest'
                                                                      , Set_Up_In_ProExchange__c = true                                                                      
                                                                      );
                System.runAs(uSR2) { 
                    insert newCustomer;
                }          
                System.runAs(uMGR1) {      
                    newCustomer.DM_New_Acct_Nbr__c = '111111';
                    newCustomer.Status__c = 'Submitted-Pending MGR Approval';
                    newCustomer.MGR_1_Approved__c = TRUE;
                    Update newCustomer;
                }          
                System.runAs(uMGR2) {      
                    newCustomer.MGR_2_Approved__c = TRUE;
                    Update newCustomer;
                }
                System.runAs(uRSM) {      
                    newCustomer.RSM_Approved__c = TRUE;
                    Update newCustomer;
                }
            }   catch (Exception e) {
                System.debug('::::newCustomer::::> ' + e.getMessage());
            }
        }
    }

    @isTest
    public static void testNewAccountMGR() {

        System.debug('testNewAccount:...');

        Account a = [   SELECT ID
                        FROM Account
                        WHERE NAME = 'TEST ACCOUNT 01'
        ];
        Region__c r = [ SELECT ID
                        FROM Region__c
                        WHERE Name = 'SOUTHERN CA REGION'
        ];
        Customer_Class__c cc1 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC1'
        ];
        Customer_Class__c cc2 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC2'
        ];
        Customer_Type__c ct1 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'DAL CT1'
        ];
        Customer_Type__c ct2 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'CANADIAN CT3'
        ];
        SSC__c ssc1 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '001'
        ];
        SSC__c ssc2 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '002'
        ];
        Sales_Representative__c sr1 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '001'
        ];
        Sales_Representative__c sr2 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '002'
        ];
        
        User uSR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR1@daltile.com.test'
        ]; 
        
        User uSR2 = [   SELECT ID   
                        FROM User
                        WHERE username = 'uSR2@daltile.com.test'
        ]; 
        
        User uMGR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR1@daltile.com.test'
        ]; 
        
        User uMGR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR2@daltile.com.test'
        ]; 
        
        
        User uRSM = [   SELECT ID
                        FROM User
                        WHERE username = 'RSM@daltile.com.test'
	    ];
		Test.startTest();
        
        System.runAs(uMGR1) {     
            try {
                Change_Request__c newCustomer = new Change_Request__c(SBU__c = 'SC'
                                                                      , IsNew__c = false
                                                                      , Customer_Name__c = 'Test Account'
                                                                      , Reason_for_New_Suffix__c = 'cause'
                                                                      , Customer_Class_n__c = cc1.id
                                                                      , Business_Reason__c = 'TEST'
                                                                      , Sales_Representative__c = sr1.Id
                                                                      , Customer_Class__c = cc1.Id
                                                                      , Customer_Type__c = ct1.Id
                                                                      , RecordTypeId = Label.CR_New_Customer_RT
                                                                      , SSC__c = ssc1.Id
                                                                      , Name__c = 'NULL Tester'
                                                                      , Ship_To_Phone__c = '(972) 489-4406'
                                                                      , Fax__c = '(972) 489-4406'
                                                                      , Region__c = r.Id
                                                                      , Status__c = 'Submitting for Approval'
                                                                      , Copy_Bill_To_Address__c = TRUE
                                                                      , Bill_Country_N__c = 'US'
                                                                      , Billing_Street_N__c = '13'
                                                                      , Address2__c = '11'
                                                                      , Billing_City_N__c = 'Dallas'
                                                                      , Billing_State_N2__c = 'TX'
                                                                      , Billing_Zip_N__c = '75218'
                                                                      );
                System.runAs(uSR2) { 
                    insert newCustomer;
                } 
                System.runAs(uMGR1) {      
                    newCustomer.Status__c = 'Submitted-Pending MGR Approval';
                    newCustomer.MGR_1_Approved__c = TRUE;
                    Update newCustomer;
                }          
                System.runAs(uMGR2) {      
                    newCustomer.MGR_2_Approved__c = TRUE;
                    Update newCustomer;
                }
                System.runAs(uRSM) {      
                    newCustomer.RSM_Approved__c = TRUE;
                    Update newCustomer;
                }
            }   catch (Exception e) {
                System.debug('::::newCustomer::::> ' + e.getMessage());
            }
        }
    }

//     @isTest
//     public static void testNewAccountNoSSC() { 

//         System.debug('testNewAccount:...');

//         Account a = [   SELECT ID
//                         FROM Account
//                         WHERE NAME = 'TEST ACCOUNT 01'
//         ];
//         Region__c r = [ SELECT ID
//                         FROM Region__c
//                         WHERE Name = 'SOUTHERN CA REGION'
//         ];
//         Customer_Class__c cc1 = [    SELECT ID
//                                     FROM Customer_Class__c
//                                     WHERE Customer_Class_Details__c = 'CC1'
//         ];
//         Customer_Class__c cc2 = [    SELECT ID
//                                     FROM Customer_Class__c
//                                     WHERE Customer_Class_Details__c = 'CC2'
//         ];
//         Customer_Type__c ct1 = [ SELECT ID
//                                 FROM Customer_Type__c
//                                 WHERE Name = 'DAL CT1'
//         ];
//         Customer_Type__c ct2 = [ SELECT ID
//                                 FROM Customer_Type__c
//                                 WHERE Name = 'CANADIAN CT3'
//         ];
//         SSC__c ssc1 = [  SELECT ID
//                         FROM SSC__c
//                         WHERE DW_ID__c = '001'
//         ];
//         SSC__c ssc2 = [  SELECT ID
//                         FROM SSC__c
//                         WHERE DW_ID__c = '002'
//         ];
//         Sales_Representative__c sr1 = [  SELECT ID
//                                         FROM Sales_Representative__c
//                                         WHERE DW_ID__c = '001'
//         ];
//         Sales_Representative__c sr2 = [  SELECT ID
//                                         FROM Sales_Representative__c
//                                         WHERE DW_ID__c = '002'
//         ];
        
//         User uSR1 = [   SELECT ID
//                         FROM User
//                         WHERE username = 'uSR1@daltile.com.test'
//         ]; 
        
//         User uSR2 = [   SELECT ID   
//                         FROM User
//                         WHERE username = 'uSR2@daltile.com.test'
//         ]; 
        
//         User uMGR1 = [   SELECT ID
//                         FROM User
//                         WHERE username = 'MGR1@daltile.com.test'
//         ]; 
        
//         User uMGR2 = [   SELECT ID
//                         FROM User
//                         WHERE username = 'MGR2@daltile.com.test'
//         ]; 
        
        
//         User uRSM = [   SELECT ID
//                         FROM User
//                         WHERE username = 'RSM@daltile.com.test'
// 	    ];
// 		Test.startTest();
        
//         System.runAs(uMGR1) {     
//             try {
//                 Change_Request__c newCustomer = new Change_Request__c(SBU__c = 'SC'
//                                                                       , IsNew__c = false
//                                                                       , Customer_Name__c = 'Test Account'
//                                                                       , Reason_for_New_Suffix__c = 'cause'
//                                                                       , Customer_Class_n__c = cc1.id
//                                                                       , Business_Reason__c = 'TEST'
//                                                                       , Sales_Representative__c = sr1.Id
//                                                                       , Customer_Class__c = cc1.Id
//                                                                       , Customer_Type__c = ct1.Id
//                                                                       , RecordTypeId = Label.CR_New_Customer_RT
//                                                                       , Name__c = 'NULL Tester'
//                                                                       , Ship_To_Phone__c = '(972) 489-4406'
//                                                                       , Fax__c = '(972) 489-4406'
//                                                                       , Region__c = r.Id
//                                                                       , Status__c = 'Submitting for Approval'
//                                                                       , Copy_Bill_To_Address__c = TRUE
//                                                                       , Bill_Country_N__c = 'US'
//                                                                       , Billing_Street_N__c = '13'
//                                                                       , Address2__c = '11'
//                                                                       , Billing_City_N__c = 'Dallas'
//                                                                       , Billing_State_N2__c = 'TX'
//                                                                       , Billing_Zip_N__c = '75218'
//                                                                       );
//                 System.runAs(uSR2) { 
//                     insert newCustomer;
//                 }          
//                 System.runAs(uMGR1) {      
//                     newCustomer.Status__c = 'Submitted-Pending MGR Approval';
//                     newCustomer.MGR_1_Approved__c = TRUE;
//                     Update newCustomer;
//                 }          
//                 System.runAs(uMGR2) {      
//                     newCustomer.MGR_2_Approved__c = TRUE;
//                     Update newCustomer;
//                 }
//                 System.runAs(uRSM) {      
//                     newCustomer.RSM_Approved__c = TRUE;
//                     Update newCustomer;
//                 }
//             }   catch (Exception e) {
//                 System.debug('::::newCustomer::::> ' + e.getMessage());
//             }
//         }
//     }


   @isTest
    public static void testExceptionSSCNoApprovers() {

        System.debug('testExceptionSSCNoApprovers:...');

        Account a = [   SELECT ID
                        FROM Account
                        WHERE NAME = 'TEST ACCOUNT 01'
        ];
        Region__c r = [ SELECT ID
                        FROM Region__c
                        WHERE Name = 'SOUTHERN CA REGION'
        ];
        Customer_Class__c cc1 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC1'
        ];
        Customer_Class__c cc2 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC2'
        ];
        Customer_Type__c ct1 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'DAL CT1'
        ];
        Customer_Type__c ct2 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'CANADIAN CT3'
        ];
        SSC__c ssc1 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '001'
        ];
        SSC__c ssc2 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '002'
        ];
        
        SSC__c ssc3 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '003'
        ];                
        
        Sales_Representative__c sr1 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '001'
        ];
        Sales_Representative__c sr2 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '002'
        ];
        
        User uSR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR1@daltile.com.test'
        ]; 
        
        User uSR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR2@daltile.com.test'
        ]; 

        User MGR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR1@daltile.com.test'
        ]; 
                
		Test.startTest();
    
        // Test SSC Change , no approvers 
        System.runAs(uSR2) {     
            try {
                
                Change_Request__c cr = new Change_Request__c(SBU__c = 'SC'
                                                                , IsNew__c = false
                                                                , RecordTypeId = Label.CR_Customer_Update_RT
                                                                , Account__c = a.Id
                                                                , Region__c = r.Id
                                                                , Sales_Representative__c = sr1.Id
                                                                , Customer_Class__c = cc1.Id                                                       
                                                                , Customer_Type__c = ct1.Id
                                                                , SSC__c = ssc1.Id
                                                                , SSC_N__C = ssc3.id
                                                                , Status__c = 'Submitting for Approval');
                insert cr;
                Map <ID, SObject> mapRequest = new Map <ID, SObject>();
                mapRequest.put(cr.Id, cr);
                ChangeRequestGateway.onAfterInsert(mapRequest);
                ChangeRequestGateway.validate();
                cr.Status__c = 'Submitting for Approval';
                Update cr;
                cr.MGR_WF1__c = TRUE;
                cr.MGR_1_Approved__c = TRUE;
                Update cr;
                cr.MGR_2_Approved__c = TRUE;
                Update cr;
                Delete cr;
                
            }catch (Exception e) {
                System.debug('::::TestCaseTrigger + e : ' + e );
                
            }   
        }    
        Test.stopTest();
    }

    @isTest
    public static void testExceptionValidationsClassDEL() {

        System.debug('testClassChange:...');

        Account a = [   SELECT ID
                        FROM Account
                        WHERE NAME = 'TEST ACCOUNT 01'
        ];
        Region__c r = [ SELECT ID
                        FROM Region__c
                        WHERE Name = 'SOUTHERN CA REGION'
        ];
        Customer_Class__c cc1 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC1'
        ];
        Customer_Class__c ccDEL = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'DEL'
        ];
        Customer_Type__c ct1 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'DAL CT1'
        ];
        Customer_Type__c ct2 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'CANADIAN CT3'
        ];
        SSC__c ssc1 = [  SELECT ID, Manager__c, RVP__c, RSM__c
                        FROM SSC__c
                        WHERE DW_ID__c = '001'
        ];
        SSC__c ssc2 = [  SELECT ID, Manager__c, RVP__c, RSM__c
                        FROM SSC__c
                        WHERE DW_ID__c = '002'
        ];
        Sales_Representative__c sr1 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '001'
        ];
        Sales_Representative__c sr2 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '002'
        ];
        
        User uSR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR1@daltile.com.test'
        ]; 
        
        User uSR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR2@daltile.com.test'
        ]; 

        User MGR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR1@daltile.com.test'
        ]; 
                
		Test.startTest();
    
        // Class  Only Change
        System.runAs(uSR2) {     
            try {
                
                Change_Request__c cr = new Change_Request__c(SBU__c = 'SC'
                                                                , IsNew__c = false
                                                                , RecordTypeId = Label.CR_Customer_Update_RT
                                                                , Account__c = a.Id
                                                                , Region__c = r.Id
                                                                , Sales_Representative__c = sr1.Id
                                                                , Customer_Class__c = ccDEL.Id                                                       
                                                                , Customer_Type__c = ct1.Id
                                                                , SSC__c = ssc1.Id
                                                                , Customer_Class_n__c = cc1.id
                                                                , Business_Reason__c = 'Test'
                                                                , Status__c = 'Submitting for Approval');
                insert cr;
                
            }catch (Exception e) {
                System.debug('::::TestCaseTrigger + e : ' + e );
                
            }   
        }     
        Test.stopTest();
    }

    @isTest
    public static void testExceptionValidationsClassWrongRegion() {

        System.debug('testClassChange:...');

        Account a = [   SELECT ID
                        FROM Account
                        WHERE NAME = 'TEST ACCOUNT 01'
        ];
        Account aAO = [   SELECT ID
                        FROM Account
                        WHERE NAME = 'TEST ACCOUNT 04'
        ];
        Region__c r = [ SELECT ID
                        FROM Region__c
                        WHERE Name = 'SOUTHERN CA REGION'
        ];
        Customer_Class__c cc1 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC1'
        ];
        Customer_Class__c cc2 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC2'
        ];
        Customer_Class__c ccAO = [    SELECT ID , Region__c
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC3'
        ];
        Customer_Type__c ct1 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'DAL CT1'
        ];
        Customer_Type__c ctAO = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'CANADIAN CT3'
        ];
        SSC__c ssc1 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '001'
        ];
        SSC__c ssc2 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '002'
        ];
        SSC__c sscA0 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '003'
        ];                
        
        Sales_Representative__c sr1 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '001'
        ];
        Sales_Representative__c sr2 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '002'
        ];
        Sales_Representative__c srAO = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '003'
        ];
        
        User uSR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR1@daltile.com.test'
        ]; 
        
        User uSR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR2@daltile.com.test'
        ]; 

        User MGR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR1@daltile.com.test'
        ]; 
                
		Test.startTest();
    
        // Class Change
        // No Reason
        System.runAs(uSR2) {     
            try {
                
                Change_Request__c cr = new Change_Request__c(SBU__c = 'SC'
                                                                , IsNew__c = false
                                                                , RecordTypeId = Label.CR_Customer_Update_RT
                                                                , Account__c = a.Id
                                                                , Region__c = r.Id
                                                                , Sales_Representative__c = sr1.Id
                                                                , Customer_Class__c = cc1.Id                                                       
                                                                , Customer_Type__c = ct1.Id
                                                                , SSC__c = ssc1.Id
                                                                , Customer_Class_n__c = ccAO.id
                                                                , Status__c = 'Submitting for Approval');
                insert cr;
                ChangeRequestGateway.validate();

            }catch (Exception e) {
                System.debug('::::TestCaseTrigger + e : ' + e );
                
            }   
        }    
        Test.stopTest();
    }
    
    @isTest
    public static void testExceptionValidationsClassNoReason() {

        System.debug('testClassChange:...');

        Account a = [   SELECT ID
                        FROM Account
                        WHERE NAME = 'TEST ACCOUNT 01'
        ];
        Account aAO = [   SELECT ID
                        FROM Account
                        WHERE NAME = 'TEST ACCOUNT 04'
        ];
        Region__c r = [ SELECT ID
                        FROM Region__c
                        WHERE Name = 'SOUTHERN CA REGION'
        ];
        Customer_Class__c cc1 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC1'
        ];
        Customer_Class__c cc2 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC2'
        ];
        Customer_Class__c ccAO = [    SELECT ID , Region__c
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC3'
        ];
        Customer_Type__c ct1 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'DAL CT1'
        ];
        Customer_Type__c ctAO = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'CANADIAN CT3'
        ];
        SSC__c ssc1 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '001'
        ];
        SSC__c ssc2 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '002'
        ];
        SSC__c sscA0 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '003'
        ];                
        
        Sales_Representative__c sr1 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '001'
        ];
        Sales_Representative__c sr2 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '002'
        ];
        Sales_Representative__c srAO = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '003'
        ];
        
        User uSR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR1@daltile.com.test'
        ]; 
        
        User uSR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR2@daltile.com.test'
        ]; 

        User MGR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR1@daltile.com.test'
        ]; 
                
		Test.startTest();
    
        // Class Change
        // Wrong Region
        System.runAs(uSR2) {     
            try {
                
                Change_Request__c cr = new Change_Request__c(SBU__c = 'SC'
                                                                , IsNew__c = false
                                                                , RecordTypeId = Label.CR_Customer_Update_RT
                                                                , Account__c = a.Id
                                                                , Region__c = r.Id
                                                                , Sales_Representative__c = sr1.Id
                                                                , Customer_Class__c = cc1.Id                                                       
                                                                , Customer_Type__c = ct1.Id
                                                                , SSC__c = ssc1.Id
                                                                , Customer_Class_n__c = cc2.id
                                                                , GONE_THROUGH_APPROVAL_PROCESS__C = false
                                                                , Status__c = 'Submitting for Approval');
                insert cr;
                cr.Status__c = 'Submitted-Pending';
                update cr;                
                ChangeRequestGateway.validate();

            }catch (Exception e) {
                System.debug('::::TestCaseTrigger + e : ' + e );
                
            }   
        }    
        Test.stopTest();
    }
    
    @isTest
    public static void testExceptionValidationsCustomerType() {

        System.debug('testExceptionValidationsCustomerType:...');

        Account a = [   SELECT ID
                        FROM Account
                        WHERE NAME = 'TEST ACCOUNT 01'
        ];
        Account aAO = [   SELECT ID
                        FROM Account
                        WHERE NAME = 'TEST ACCOUNT 04'
        ];
        Region__c r = [ SELECT ID
                        FROM Region__c
                        WHERE Name = 'SOUTHERN CA REGION'
        ];
        Customer_Class__c cc1 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC1'
        ];
        Customer_Class__c cc2 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC2'
        ];
        Customer_Class__c ccAO = [    SELECT ID , Region__c
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC3'
        ];
        Customer_Type__c ct1 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'DAL CT1'
        ];
        Customer_Type__c ctAO = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'CANADIAN CT3'
        ];
        SSC__c ssc1 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '001'
        ];
        SSC__c ssc2 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '002'
        ];
        SSC__c sscA0 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '003'
        ];                
        
        Sales_Representative__c sr1 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '001'
        ];
        Sales_Representative__c sr2 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '002'
        ];
        Sales_Representative__c srAO = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '003'
        ];
        
        User uSR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR1@daltile.com.test'
        ]; 
        
        User uSR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR2@daltile.com.test'
        ]; 

        User MGR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR1@daltile.com.test'
        ]; 
                
		Test.startTest();
    
        // Customer Type
        // Wrong SBU
        System.runAs(uSR2) {     
            try {
                
                Change_Request__c cr = new Change_Request__c(SBU__c = 'SC'
                                                                , IsNew__c = false
                                                                , RecordTypeId = Label.CR_Customer_Update_RT
                                                                , Account__c = a.Id
                                                                , Region__c = r.Id
                                                                , Sales_Representative__c = sr1.Id
                                                                , Customer_Class__c = cc1.Id                                                       
                                                                , Customer_Type__c = ct1.Id
                                                                , SSC__c = ssc1.Id
                                                                , Bill_Country_N__c = 'US'
                                                                , Customer_Type_n__c = ctAO.id
                                                                , Status__c = 'Submitting for Approval');
                insert cr;
            } catch (Exception e) {
                System.debug('::::testExceptionValidationsCustomerType + e : ' + e );
                
            }   
        }   
        
        try {
            
            Change_Request__c cr = new Change_Request__c(SBU__c = 'SC'
                                                            , IsNew__c = false
                                                            , RecordTypeId = Label.CR_Customer_Update_RT
                                                            , Account__c = a.Id
                                                            , Region__c = r.Id
                                                            , Region_n__c = r.Id
                                                            , Sales_Representative__c = sr1.Id
                                                            , Customer_Class__c = cc1.Id                                                       
                                                            , Customer_Type__c = ct1.Id
                                                            , SSC__c = ssc1.Id
                                                            , Bill_Country_N__c = 'CA'
                                                            , Customer_Type_n__c = ctAO.id
                                                            , Status__c = 'Submitting for Approval');
            insert cr;
        } catch (Exception e) {
            System.debug('::::testExceptionValidationsCustomerType + e : ' + e );
            
        }   
        
        try {
            
            Change_Request__c cr = new Change_Request__c(SBU__c = 'SC'
                                                            , IsNew__c = false
                                                            , RecordTypeId = Label.CR_Customer_Update_RT
                                                            , Account__c = a.Id
                                                            , Region__c = r.Id
                                                            , Region_n__c = r.Id
                                                            , Sales_Representative__c = sr1.Id
                                                            , Customer_Class__c = cc1.Id                                                       
                                                            , Customer_Type__c = ct1.Id
                                                            , SSC__c = ssc1.Id
                                                            , Bill_Country_N__c = 'CA'
                                                            , Cross_SBU_Request__c = TRUE
                                                            , Status__c = 'Submitting for Approval');
            insert cr;
        } catch (Exception e) {
            System.debug('::::testExceptionValidationsCustomerType + e : ' + e );
            
        }   
        
        try {
            
            Change_Request__c cr = new Change_Request__c(SBU__c = 'SC'
                                                            , IsNew__c = false
                                                            , RecordTypeId = Label.CR_Customer_Update_RT
                                                            , Account__c = a.Id
                                                            , Region__c = r.Id
                                                            , Region_n__c = r.Id
                                                            , Sales_Representative__c = sr1.Id
                                                            , Customer_Class__c = cc1.Id                                                       
                                                            , Customer_Type__c = ct1.Id
                                                            , SSC__c = ssc1.Id
                                                            , Bill_Country_N__c = 'XO'
                                                            , Customer_Type_n__c = ctAO.id
                                                            , Status__c = 'Submitting for Approval');
            insert cr;
        } catch (Exception e) {
            System.debug('::::testExceptionValidationsCustomerType + e : ' + e );
            
        }   
        
        Test.stopTest();
    }
    
    @isTest
    public static void testExceptionValidationsSalesRep() {

        System.debug('testClassChange:...');

        Account a = [   SELECT ID
                        FROM Account
                        WHERE NAME = 'TEST ACCOUNT 01'
        ];
        Account aAO = [   SELECT ID
                        FROM Account
                        WHERE NAME = 'TEST ACCOUNT 04'
        ];
        Region__c r = [ SELECT ID
                        FROM Region__c
                        WHERE Name = 'SOUTHERN CA REGION'
        ];
        Customer_Class__c cc1 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC1'
        ];
        Customer_Class__c cc2 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC2'
        ];
        Customer_Class__c ccAO = [    SELECT ID , Region__c
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC3'
        ];
        Customer_Type__c ct1 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'DAL CT1'
        ];
        Customer_Type__c ctAO = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'CANADIAN CT3'
        ];
        SSC__c ssc1 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '001'
        ];
        SSC__c ssc2 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '002'
        ];
        SSC__c sscA0 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '003'
        ];                
        
        Sales_Representative__c sr1 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '001'
        ];
        Sales_Representative__c sr2 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '002'
        ];
        Sales_Representative__c srAO = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '003'
        ];
        
        User uSR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR1@daltile.com.test'
        ]; 
        
        User uSR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR2@daltile.com.test'
        ]; 

        User MGR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR1@daltile.com.test'
        ]; 
                
		Test.startTest();
    

    
        // Sales Rep
        // Wrong Region
        System.runAs(uSR2) {     
            try {
                
                Change_Request__c cr = new Change_Request__c(SBU__c = 'SC'
                                                                , IsNew__c = false
                                                                , RecordTypeId = Label.CR_Customer_Update_RT
                                                                , Account__c = a.Id
                                                                , Region__c = r.Id
                                                                , Sales_Representative__c = sr1.Id
                                                                , Customer_Class__c = cc1.Id                                                       
                                                                , Customer_Type__c = ct1.Id
                                                                , SSC__c = ssc1.Id
                                                                , Sales_Representative_n__c = srAO.id
                                                                , Status__c = 'Submitting for Approval');
                insert cr;
                cr.Status__c = 'Submitting for Approval';
                update cr;

            }catch (Exception e) {
                System.debug('::::TestCaseTrigger + e : ' + e );
                
            }   
        }   
        Test.stopTest();
    }
    
    @isTest
    public static void testExceptionValidationsAddress() {

        System.debug('testExceptionValidationsAddress:...');

        Account a = [   SELECT ID
                        FROM Account
                        WHERE NAME = 'TEST ACCOUNT 01'
        ];
        Account aAO = [   SELECT ID
                        FROM Account
                        WHERE NAME = 'TEST ACCOUNT 04'
        ];
        Region__c r = [ SELECT ID
                        FROM Region__c
                        WHERE Name = 'SOUTHERN CA REGION'
        ];
        Customer_Class__c cc1 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC1'
        ];
        Customer_Class__c cc2 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC2'
        ];
        Customer_Class__c ccAO = [    SELECT ID , Region__c
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC3'
        ];
        Customer_Type__c ct1 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'DAL CT1'
        ];
        Customer_Type__c ctAO = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'CANADIAN CT3'
        ];
        SSC__c ssc1 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '001'
        ];
        SSC__c ssc2 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '002'
        ];
        SSC__c sscA0 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '003'
        ];                
        
        Sales_Representative__c sr1 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '001'
        ];
        Sales_Representative__c sr2 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '002'
        ];
        Sales_Representative__c srAO = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '003'
        ];
        
        User uSR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR1@daltile.com.test'
        ]; 
        
        User uSR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR2@daltile.com.test'
        ]; 

        User MGR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR1@daltile.com.test'
        ]; 
                
		Test.startTest();
    

    
        // Sales Rep
        // Wrong Region
        System.runAs(uSR2) {     
            try {
                
                Change_Request__c cr = new Change_Request__c(SBU__c = 'SC'
                                                                , IsNew__c = false
                                                                , RecordTypeId = Label.CR_Customer_Update_RT
                                                                , Account__c = a.Id
                                                                , Region__c = r.Id
                                                                , Sales_Representative__c = sr1.Id
                                                                , Customer_Class__c = cc1.Id                                                       
                                                                , Customer_Type__c = ct1.Id
                                                                , SSC__c = ssc1.Id
                                                                , Customer_Type_n__c = ct1.Id
                                                                , Bill_Country_N__c = 'CA'  
                                                                , Shipping_street__c = 'PO something'
                                                                , Status__c = 'Creating');
                insert cr;
                System.debug('testExceptionValidationsAddress + cr:...' + cr);
                cr.Status__c = 'Submitting for Approval';
                update cr;

            }catch (Exception e) {
                Boolean expectedExceptionThrown1 =  e.getMessage().contains(Label.Customer_Type_must_match) ? true : false;
                Boolean expectedExceptionThrown2 =  e.getMessage().contains(Label.Customer_Type_must_match_County) ? true : false;
            }   
        }   
        Test.stopTest();
    }
    
    @isTest
    public static void testExceptionValidationsNewSuffix() {

        System.debug('testSalesRepChange:...');
        
        Account a = [   SELECT ID
                        FROM Account
                        WHERE NAME = 'TEST ACCOUNT 03'
        ];
        Region__c r = [ SELECT ID
                        FROM Region__c
                        WHERE Name = 'SOUTHERN CA REGION'
        ];
        Customer_Class__c cc1 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC1'
        ];
        Customer_Class__c cc2 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC2'
        ];
        Customer_Type__c ct1 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'DAL CT1'
        ];
        Customer_Type__c ct2 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'CANADIAN CT3'
        ];
        SSC__c ssc1 = [  SELECT ID , RVP__C , RSM__c
                        FROM SSC__c
                        WHERE DW_ID__c = '001'
        ];
        SSC__c ssc2 = [  SELECT ID , RVP__C , RSM__c
                        FROM SSC__c
                        WHERE DW_ID__c = '002'
        ];
        Sales_Representative__c sr1 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '001'
        ];
        Sales_Representative__c sr2 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '002'
        ];
        
        User uSR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR1@daltile.com.test'
        ]; 
        
        User uSR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR2@daltile.com.test'
        ]; 

        User MGR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR1@daltile.com.test'
        ]; 
                
        
        User uMGR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR2@daltile.com.test'
        ]; 
        
        
        User uRVP = [   SELECT ID
                        FROM User
                        WHERE username = 'RVP@daltile.com.test'
	    ];
	    
		Test.startTest();
    
        // Sales Rep only change
        System.runAs(uMGR2) {     
            try {
                
                Change_Request__c cr = new Change_Request__c(SBU__c = 'SC'
                                                                , IsNew__c = false
                                                                , RecordTypeId = Label.CR_Customer_Update_RT
                                                                , Account__c = a.Id
                                                                , Region__c = r.Id
                                                                , Sales_Representative__c = sr1.Id
                                                                , Customer_Class__c = cc1.Id                                                       
                                                                , Customer_Type__c = ct1.Id
                                                                , SSC__c = ssc1.Id
                                                                , New_ShipTo_Request__c = TRUE
                                                                , Status__c = 'Submitting for Approval');
                insert cr;
                cr.MGR_WF1__c = TRUE;
                cr.MGR_1_Approved__c = TRUE;
                Update cr;
                cr.MGR_2_Approved__c = TRUE;
                Update cr;
                
            }catch (Exception e) {
                System.debug('::::TestCaseTrigger + e : ' + e );
                
            }   
        }     
    }    
    
    @isTest
    public static void testExceptionValidationsNewCustomerZip() {

        System.debug('testNewAccount:...');

        Account a = [   SELECT ID
                        FROM Account
                        WHERE NAME = 'TEST ACCOUNT 01'
        ];
        Region__c r = [ SELECT ID
                        FROM Region__c
                        WHERE Name = 'SOUTHERN CA REGION'
        ];
        Customer_Class__c cc1 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC1'
        ];
        Customer_Class__c cc2 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC2'
        ];
        Customer_Type__c ct1 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'DAL CT1'
        ];
        Customer_Type__c ct2 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'CANADIAN CT3'
        ];
        SSC__c ssc1 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '001'
        ];
        SSC__c ssc2 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '002'
        ];
        Sales_Representative__c sr1 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '001'
        ];
        Sales_Representative__c sr2 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '002'
        ];
        
        User uSR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR1@daltile.com.test'
        ]; 
        
        User uSR2 = [   SELECT ID   
                        FROM User
                        WHERE username = 'uSR2@daltile.com.test'
        ]; 
        
        User uMGR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR1@daltile.com.test'
        ]; 
        
        User uMGR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR2@daltile.com.test'
        ]; 
        
        
        User uRSM = [   SELECT ID
                        FROM User
                        WHERE username = 'RSM@daltile.com.test'
	    ];
		Test.startTest();
        
        System.runAs(uSR2) {     
            try {
                Change_Request__c newCustomer = new Change_Request__c(SBU__c = 'SC'
                                                                      , IsNew__c = false
                                                                      , Customer_Name__c = 'Test Account'
                                                                      , Reason_for_New_Suffix__c = 'cause'
                                                                      , Customer_Class_n__c = cc1.id
                                                                      , Business_Reason__c = 'TEST'
                                                                      , Sales_Representative__c = sr1.Id
                                                                      , Customer_Class__c = cc1.Id
                                                                      , Customer_Type__c = ct1.Id
                                                                      , RecordTypeId = Label.CR_New_Customer_RT
                                                                      , SSC__c = ssc1.Id
                                                                      , Name__c = 'NULL Tester'
                                                                      , Ship_To_Phone__c = '(972) 489-4406'
                                                                      , Fax__c = '(972) 489-4406'
                                                                      , Region__c = r.Id
                                                                      , Status__c = 'Submitting for Approval'
                                                                      , Copy_Bill_To_Address__c = TRUE
                                                                      , Bill_Country_N__c = 'US'
                                                                      , Billing_Street_N__c = '13'
                                                                      , Address2__c = '11'
                                                                      , Billing_City_N__c = 'Dallas'
                                                                      , Billing_State_N2__c = 'TX'
                                                                      , Billing_Zip_N__c = NULL
                                                                      );
                System.runAs(uSR2) { 
                    insert newCustomer;
                }          
            }   catch (Exception e) {
                System.debug('::::newCustomer::::> ' + e.getMessage());
            }
        }
    }

    @isTest
    public static void testExceptionValidationsNewCustomer() {

        System.debug('testClassChange:...');

        Account a = [   SELECT ID
                        FROM Account
                        WHERE NAME = 'TEST ACCOUNT 01'
        ];
        Account aAO = [   SELECT ID
                        FROM Account
                        WHERE NAME = 'TEST ACCOUNT 04'
        ];
        Region__c r = [ SELECT ID
                        FROM Region__c
                        WHERE Name = 'SOUTHERN CA REGION'
        ];
        Customer_Class__c cc1 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC1'
        ];
        Customer_Class__c cc2 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC2'
        ];
        Customer_Class__c ccAO = [    SELECT ID , Region__c
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC3'
        ];
        Customer_Type__c ct1 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'DAL CT1'
        ];
        Customer_Type__c ctAO = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'CANADIAN CT3'
        ];
        SSC__c ssc1 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '001'
        ];
        SSC__c ssc2 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '002'
        ];
        SSC__c sscA0 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '003'
        ];                
        
        Sales_Representative__c sr1 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '001'
        ];
        Sales_Representative__c sr2 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '002'
        ];
        Sales_Representative__c srAO = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '003'
        ];
        
        User uSR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR1@daltile.com.test'
        ]; 
        
        User uSR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR2@daltile.com.test'
        ]; 

        User MGR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR1@daltile.com.test'
        ]; 
                
		Test.startTest();
    

        // New Customer
        // Address Issues
        System.runAs(uSR2) {    
            // shipping country error
            try {
                
                Change_Request__c newCustomer = new Change_Request__c(SBU__c = 'SC'
                                                                      , IsNew__c = false
                                                                      , Customer_Name__c = 'Account For Dupe Catcher'
                                                                      , Reason_for_New_Suffix__c = 'cause'
                                                                      , Customer_Class_n__c = cc1.id
                                                                      , Business_Reason__c = 'TEST'
                                                                      , Sales_Representative__c = sr1.Id
                                                                      , Customer_Class__c = cc1.Id
                                                                      , Customer_Type__c = ct1.Id
                                                                      , RecordTypeId = Label.CR_New_Customer_RT
                                                                      , SSC__c = ssc1.Id
                                                                      , Name__c = 'NULL Tester'
                                                                      , Ship_To_Phone__c = '(972) 489-4406'
                                                                      , Fax__c = '(972) 489-4406'
                                                                      , Region__c = r.Id
                                                                      , Status__c = 'Submitting for Approval'
                                                                      , Copy_Bill_To_Address__c = FALSE
                                                                      , Bill_Country_N__c = 'US'
                                                                      , Billing_Street_N__c = '13'
                                                                      , Address2__c = '11'
                                                                      , Billing_City_N__c = 'Dallas'
                                                                      , Billing_State_N2__c = 'TX'
                                                                      , Billing_Zip_N__c = '75218'
                                                                      , Contact__c = 'Jim'
                                                                      );
                insert newCustomer; 
                System.debug('testExceptionValidationsNewCustomer + newCustomer:...' + newCustomer);           
            }catch (Exception e) {
                System.debug('::::testExceptionValidationsNewCustomer + e : ' + e );
                
            }   
            // shipping country error
            try {
                
                Change_Request__c newCustomer = new Change_Request__c(SBU__c = 'SC'
                                                                      , IsNew__c = false
                                                                      , Customer_Name__c = 'Account For Dupe Catcher'
                                                                      , Reason_for_New_Suffix__c = 'cause'
                                                                      , Customer_Class_n__c = cc1.id
                                                                      , Business_Reason__c = 'TEST'
                                                                      , Sales_Representative__c = sr1.Id
                                                                      , Customer_Class__c = cc1.Id
                                                                      , Customer_Type__c = ctAO.Id
                                                                      , RecordTypeId = Label.CR_New_Customer_RT
                                                                      , SSC__c = ssc1.Id
                                                                      , Name__c = 'NULL Tester'
                                                                      , Ship_To_Phone__c = '(972) 489-4406'
                                                                      , Fax__c = '(972) 489-4406'
                                                                      , Region__c = r.Id
                                                                      , Status__c = 'Submitting for Approval'
                                                                      , Copy_Bill_To_Address__c = true
                                                                      , Bill_Country_N__c = 'CA'
                                                                      , Billing_Street_N__c = '13'
                                                                      , Address2__c = '11'
                                                                      , Billing_City_N__c = 'Dallas'
                                                                      , Billing_State_N2__c = 'TX'
                                                                      , Billing_Zip_N__c = '75218'
                                                                      , Contact__c = 'Jim'
                                                                      );
                insert newCustomer; 
                System.debug('testExceptionValidationsNewCustomer + newCustomer:...' + newCustomer);           
            }catch (Exception e) {
                System.debug('::::testExceptionValidationsNewCustomer + e : ' + e );
                
            }   
        }        
        
        Test.stopTest();
    }
 
 
    @isTest
    public static void testDuplicateCatcherNew() {

        System.debug('testDuplicateCatcher:...');

        Account a = [   SELECT ID
                        FROM Account
                        WHERE NAME = 'TEST ACCOUNT 01'
        ];
        Region__c r = [ SELECT ID
                        FROM Region__c
                        WHERE Name = 'SOUTHERN CA REGION'
        ];
        Customer_Class__c cc1 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC1'
        ];
        Customer_Class__c cc2 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC2'
        ];
        Customer_Type__c ct1 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'DAL CT1'
        ];
        Customer_Type__c ct2 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'CANADIAN CT3'
        ];
        SSC__c ssc1 = [ SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '001'
        ];
        SSC__c ssc2 = [ SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '002'
        ];
        Sales_Representative__c sr1 = [ SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '001'
        ];
        Sales_Representative__c sr2 = [ SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '002'
        ];
        
        User uSR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR1@daltile.com.test'
        ]; 
        
        User uSR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR2@daltile.com.test'
        ]; 
        
        User MGR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR1@daltile.com.test'
        ]; 
        
        Change_Request__c cr1 = [   SELECT ID
                                    , Name
                                    , CreatedById
                                    , Customer_Name__c
                                    , SSC__c
                                    , Created_Date__c
                                    , Sales_Representative__c
                                    , Customer_Class__c
                                    , Ship_To_Phone__c
                                    , Customer_Type__c
                                    , Region__c
                                    , Billing_Street_N__c
                                    , Address2__c
                                    , Bill_Country_N__c
                                    , Billing_City_N__c
                                    , Billing_State_N2__c
                                    , Billing_Zip_N__c
                                    , Contact__c
                                    , Status__c
                                FROM Change_Request__c        
                                WHERE Customer_Name__c = 'Account For Dupe Catcher'
        ];
        
        System.debug('testDuplicateCatcher + cr1:...' + cr1);
        
		Test.startTest();
           
        try {
            System.debug('testDuplicateCatcher + newCustomer:...');
            System.runAs(uSR2) {  
                Change_Request__c newCustomer = new Change_Request__c(SBU__c = 'SC'
                                                                      , IsNew__c = false
                                                                      , Customer_Name__c = 'Account For Dupe Catcher'
                                                                      , Reason_for_New_Suffix__c = 'cause'
                                                                      , Customer_Class_n__c = cc1.id
                                                                      , Business_Reason__c = 'TEST'
                                                                      , Sales_Representative__c = sr1.Id
                                                                      , Customer_Class__c = cc1.Id
                                                                      , Customer_Type__c = ct1.Id
                                                                      , RecordTypeId = Label.CR_New_Customer_RT
                                                                      , SSC__c = ssc1.Id
                                                                      , Name__c = 'NULL Tester'
                                                                      , Ship_To_Phone__c = '(972) 489-4406'
                                                                      , Fax__c = '(972) 489-4406'
                                                                      , Region__c = r.Id
                                                                      , Status__c = 'Submitting for Approval'
                                                                      , Copy_Bill_To_Address__c = TRUE
                                                                      , Bill_Country_N__c = 'US'
                                                                      , Billing_Street_N__c = '13'
                                                                      , Address2__c = '11'
                                                                      , Billing_City_N__c = 'Dallas'
                                                                      , Billing_State_N2__c = 'TX'
                                                                      , Billing_Zip_N__c = '75218'
                                                                      , Contact__c = 'Jim'
                                                                      , GONE_THROUGH_APPROVAL_PROCESS__C = false
                                                                      );
                insert newCustomer; 
                System.debug('testDuplicateCatcher + newCustomer:...' + newCustomer);
            }
        }   catch (Exception e) {
            System.debug('::::newCustomer::::> ' + e.getMessage());
        }                   
        
    Test.stopTest();        
    }
    
    @isTest
    public static void testDuplicateCatcherChangeSSC() {

        System.debug('testDuplicateCatcher:...');

        Account a = [   SELECT ID
                        FROM Account
                        WHERE NAME = 'TEST ACCOUNT 01'
        ];
        Region__c r = [ SELECT ID
                        FROM Region__c
                        WHERE Name = 'SOUTHERN CA REGION'
        ];
        Customer_Class__c cc1 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC1'
        ];
        Customer_Class__c cc2 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC2'
        ];
        Customer_Type__c ct1 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'DAL CT1'
        ];
        Customer_Type__c ct2 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'CANADIAN CT3'
        ];
        SSC__c ssc1 = [ SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '001'
        ];
        SSC__c ssc2 = [ SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '002'
        ];
        Sales_Representative__c sr1 = [ SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '001'
        ];
        Sales_Representative__c sr2 = [ SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '002'
        ];
        
        User uSR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR1@daltile.com.test'
        ]; 
        
        User uSR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR2@daltile.com.test'
        ]; 
        
        User MGR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR1@daltile.com.test'
        ]; 
        
        Change_Request__c cr1 = [   SELECT ID       
										   , Name
										   , CreatedById
										   , Created_Date__c
										   , Status__c
										   , Account__c
										   , Billing_Street_N__c
										   , Shipping_street__c
										   , New_ShipTo_Request__c
										   , Current_Approver__r.Email
										   , Current_Approver__c
										   , Sales_Representative__c
										   , Sales_Representative_n__c
										   , SSC__c
										   , SSC_N__c
										   , Customer_Class__c
										   , Customer_Class_N__c
										   , Customer_Type__c
										   , Customer_Type_N__c
										   , Customer_Name_Change__c
										   , Name_Change__c
                                FROM Change_Request__c        
                                WHERE Customer_Name_Change__c = 'Name Change Dupe Catcher'
        ];
        
		Test.startTest();
        
        System.runAs(uSR2) {     
            try {
                
                System.debug('testDuplicateCatcher + cr:...');
                Change_Request__c cr = new Change_Request__c(SBU__c = 'SC'
                                                                , IsNew__c = false
                                                                , RecordTypeId = Label.CR_Customer_Update_RT
                                                                , Account__c = a.Id
                                                                , Customer_Name_Change__c = 'Name Change Dupe Catcher'
                                                                , Region__c = r.Id
                                                                , Sales_Representative__c = sr1.Id
                                                                , Customer_Class__c = cc1.Id                                                       
                                                                , Customer_Type__c = ct1.Id
                                                                , SSC__c = ssc1.Id
                                                                , SSC_N__C = ssc2.id
                                                                , Status__c = 'Submitting for Approval');
                insert cr;
                System.debug('testDuplicateCatcher + cr:...' + cr);
                
            }catch (Exception e) {
                System.debug('::::newCustomer::::> ' + e.getMessage());
            }   
        }     
    Test.stopTest();        
    }
    
    @isTest
    public static void testDuplicateCatcherChangeRep() {

        System.debug('testDuplicateCatcher:...');

        Account a = [   SELECT ID
                        FROM Account
                        WHERE NAME = 'TEST ACCOUNT 01'
        ];
        Region__c r = [ SELECT ID
                        FROM Region__c
                        WHERE Name = 'SOUTHERN CA REGION'
        ];
        Customer_Class__c cc1 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC1'
        ];
        Customer_Class__c cc2 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC2'
        ];
        Customer_Type__c ct1 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'DAL CT1'
        ];
        Customer_Type__c ct2 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'CANADIAN CT3'
        ];
        SSC__c ssc1 = [ SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '001'
        ];
        SSC__c ssc2 = [ SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '002'
        ];
        Sales_Representative__c sr1 = [ SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '001'
        ];
        Sales_Representative__c sr2 = [ SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '002'
        ];
        
        User uSR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR1@daltile.com.test'
        ]; 
        
        User uSR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR2@daltile.com.test'
        ]; 
        
        User MGR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR1@daltile.com.test'
        ]; 
        
        Change_Request__c cr1 = [   SELECT ID       
										   , Name
										   , CreatedById
										   , Created_Date__c
										   , Status__c
										   , Account__c
										   , Billing_Street_N__c
										   , Shipping_street__c
										   , New_ShipTo_Request__c
										   , Current_Approver__r.Email
										   , Current_Approver__c
										   , Sales_Representative__c
										   , Sales_Representative_n__c
										   , SSC__c
										   , SSC_N__c
										   , Customer_Class__c
										   , Customer_Class_N__c
										   , Customer_Type__c
										   , Customer_Type_N__c
										   , Customer_Name_Change__c
										   , Name_Change__c
                                FROM Change_Request__c        
                                WHERE Customer_Name_Change__c = 'Name Change Dupe Catcher'
        ];
        
		Test.startTest();
        
        System.runAs(uSR2) {     
            try {
                
                System.debug('testDuplicateCatcher + cr:...');
                Change_Request__c cr = new Change_Request__c(SBU__c = 'SC'
                                                                , IsNew__c = false
                                                                , RecordTypeId = Label.CR_Customer_Update_RT
                                                                , Account__c = a.Id
                                                                , Customer_Name_Change__c = 'Name Change Dupe Catcher'
                                                                , Region__c = r.Id
                                                                , Sales_Representative__c = sr1.Id
                                                                , Customer_Class__c = cc1.Id                                                       
                                                                , Customer_Type__c = ct1.Id
                                                                , SSC__c = ssc1.Id
                                                                , Sales_Representative_n__c = sr2.id
                                                                , Status__c = 'Submitting for Approval');
                insert cr;
                System.debug('testDuplicateCatcher + cr:...' + cr);
                
            }catch (Exception e) {
                System.debug('::::newCustomer::::> ' + e.getMessage());
            }   
        }     
    Test.stopTest();        
    }    
 
    @isTest
    public static void testDuplicateCatcherChangeClass() {

        System.debug('testDuplicateCatcher:...');

        Account a = [   SELECT ID
                        FROM Account
                        WHERE NAME = 'TEST ACCOUNT 01'
        ];
        Region__c r = [ SELECT ID
                        FROM Region__c
                        WHERE Name = 'SOUTHERN CA REGION'
        ];
        Customer_Class__c cc1 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC1'
        ];
        Customer_Class__c cc2 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC2'
        ];
        Customer_Type__c ct1 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'DAL CT1'
        ];
        Customer_Type__c ct2 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'CANADIAN CT3'
        ];
        SSC__c ssc1 = [ SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '001'
        ];
        SSC__c ssc2 = [ SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '002'
        ];
        Sales_Representative__c sr1 = [ SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '001'
        ];
        Sales_Representative__c sr2 = [ SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '002'
        ];
        
        User uSR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR1@daltile.com.test'
        ]; 
        
        User uSR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR2@daltile.com.test'
        ]; 
        
        User MGR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR1@daltile.com.test'
        ]; 
        
        Change_Request__c cr1 = [   SELECT ID       
										   , Name
										   , CreatedById
										   , Created_Date__c
										   , Status__c
										   , Account__c
										   , Billing_Street_N__c
										   , Shipping_street__c
										   , New_ShipTo_Request__c
										   , Current_Approver__r.Email
										   , Current_Approver__c
										   , Sales_Representative__c
										   , Sales_Representative_n__c
										   , SSC__c
										   , SSC_N__c
										   , Customer_Class__c
										   , Customer_Class_N__c
										   , Customer_Type__c
										   , Customer_Type_N__c
										   , Customer_Name_Change__c
										   , Name_Change__c
                                FROM Change_Request__c        
                                WHERE Customer_Name_Change__c = 'Name Change Dupe Catcher'
        ];
        
		Test.startTest();
        
        System.runAs(uSR2) {     
            try {
                
                System.debug('testDuplicateCatcher + cr:...');
                Change_Request__c cr = new Change_Request__c(SBU__c = 'SC'
                                                                , IsNew__c = false
                                                                , RecordTypeId = Label.CR_Customer_Update_RT
                                                                , Account__c = a.Id
                                                                , Customer_Name_Change__c = 'Name Change Dupe Catcher'
                                                                , Region__c = r.Id
                                                                , Sales_Representative__c = sr1.Id
                                                                , Customer_Class__c = cc1.Id                                                       
                                                                , Customer_Type__c = ct1.Id
                                                                , SSC__c = ssc1.Id
                                                                , Business_Reason__c = 'Because I love it'
                                                                , Customer_Class_n__c = cc2.id
                                                                , Status__c = 'Submitting for Approval');
                insert cr;
                System.debug('testDuplicateCatcher + cr:...' + cr);
                
            }catch (Exception e) {
                System.debug('::::newCustomer::::> ' + e.getMessage());
            }   
        }     
    Test.stopTest();        
    }    
 
    @isTest
    public static void testDuplicateCatcherChangeType() {

        System.debug('testDuplicateCatcher:...');

        Account a = [   SELECT ID
                        FROM Account
                        WHERE NAME = 'TEST ACCOUNT 01'
        ];
        Region__c r = [ SELECT ID
                        FROM Region__c
                        WHERE Name = 'SOUTHERN CA REGION'
        ];
        Customer_Class__c cc1 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC1'
        ];
        Customer_Class__c cc2 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC2'
        ];
        Customer_Type__c ct1 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'DAL CT1'
        ];
        Customer_Type__c ct2 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'CANADIAN CT3'
        ];
        SSC__c ssc1 = [ SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '001'
        ];
        SSC__c ssc2 = [ SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '002'
        ];
        Sales_Representative__c sr1 = [ SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '001'
        ];
        Sales_Representative__c sr2 = [ SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '002'
        ];
        
        User uSR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR1@daltile.com.test'
        ]; 
        
        User uSR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR2@daltile.com.test'
        ]; 
        
        User MGR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR1@daltile.com.test'
        ]; 
        
        Change_Request__c cr1 = [   SELECT ID       
										   , Name
										   , CreatedById
										   , Created_Date__c
										   , Status__c
										   , Account__c
										   , Billing_Street_N__c
										   , Shipping_street__c
										   , New_ShipTo_Request__c
										   , Current_Approver__r.Email
										   , Current_Approver__c
										   , Sales_Representative__c
										   , Sales_Representative_n__c
										   , SSC__c
										   , SSC_N__c
										   , Customer_Class__c
										   , Customer_Class_N__c
										   , Customer_Type__c
										   , Customer_Type_N__c
										   , Customer_Name_Change__c
										   , Name_Change__c
                                FROM Change_Request__c        
                                WHERE Customer_Name_Change__c = 'Name Change Dupe Catcher'
        ];
        
		Test.startTest();
        
        System.runAs(uSR2) {     
            try {
                
                System.debug('testDuplicateCatcher + cr:...');
                Change_Request__c cr = new Change_Request__c(SBU__c = 'SC'
                                                                , IsNew__c = false
                                                                , RecordTypeId = Label.CR_Customer_Update_RT
                                                                , Account__c = a.Id
                                                                , Customer_Name_Change__c = 'Name Change Dupe Catcher'
                                                                , Region__c = r.Id
                                                                , Sales_Representative__c = sr1.Id
                                                                , Customer_Class__c = cc1.Id                                                       
                                                                , Customer_Type__c = ct1.Id
                                                                , SSC__c = ssc1.Id
                                                                , Customer_Type_n__c = ct2.id
                                                                , Status__c = 'Submitting for Approval');
                insert cr;
                System.debug('testDuplicateCatcher + cr:...' + cr);
                
            }catch (Exception e) {
                System.debug('::::newCustomer::::> ' + e.getMessage());
            }   
        }     
    Test.stopTest();        
    }        
    
    @isTest
    public static void testDuplicateCatcherChangeName() {

        System.debug('testDuplicateCatcher:...');

        Account a = [   SELECT ID
                        FROM Account
                        WHERE NAME = 'TEST ACCOUNT 01'
        ];
        Region__c r = [ SELECT ID
                        FROM Region__c
                        WHERE Name = 'SOUTHERN CA REGION'
        ];
        Customer_Class__c cc1 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC1'
        ];
        Customer_Class__c cc2 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC2'
        ];
        Customer_Type__c ct1 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'DAL CT1'
        ];
        Customer_Type__c ct2 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'CANADIAN CT3'
        ];
        SSC__c ssc1 = [ SELECT ID , RVP__C , RSM__c
                        FROM SSC__c
                        WHERE DW_ID__c = '001'
        ];
        SSC__c ssc2 = [ SELECT ID , RVP__C , RSM__c
                        FROM SSC__c
                        WHERE DW_ID__c = '002'
        ];
        Sales_Representative__c sr1 = [ SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '001'
        ];
        Sales_Representative__c sr2 = [ SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '002'
        ];
        
        User uSR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR1@daltile.com.test'
        ]; 
        
        User uSR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR2@daltile.com.test'
        ]; 
        
        User MGR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR1@daltile.com.test'
        ]; 
        
        Change_Request__c cr1 = [   SELECT ID       
										   , Name
										   , CreatedById
										   , Created_Date__c
										   , Status__c
										   , Account__c
										   , Billing_Street_N__c
										   , Shipping_street__c
										   , New_ShipTo_Request__c
										   , Current_Approver__r.Email
										   , Current_Approver__c
										   , Sales_Representative__c
										   , Sales_Representative_n__c
										   , SSC__c
										   , SSC_N__c
										   , Customer_Class__c
										   , Customer_Class_N__c
										   , Customer_Type__c
										   , Customer_Type_N__c
										   , Customer_Name_Change__c
										   , Name_Change__c
                                FROM Change_Request__c        
                                WHERE Customer_Name_Change__c = 'Name Change Dupe Catcher'
        ];
        
		Test.startTest();
        
        System.runAs(uSR2) {     
            try {
                
                System.debug('testDuplicateCatcher + cr:...');
                Change_Request__c cr = new Change_Request__c(SBU__c = 'SC'
                                                                , IsNew__c = false
                                                                , RecordTypeId = Label.CR_Customer_Update_RT
                                                                , Account__c = a.Id
                                                                , Name_Change__c = true
                                                                , Customer_Name_Change__c = 'Name Change Dupe Catcher'
                                                                , Region__c = r.Id
                                                                , Sales_Representative__c = sr1.Id
                                                                , Customer_Class__c = cc1.Id                                                       
                                                                , Customer_Type__c = ct1.Id
                                                                , SSC__c = ssc1.Id
                                                                , Status__c = 'Submitting for Approval');
                insert cr;
                System.debug('testDuplicateCatcher + cr:...' + cr);
                
            }catch (Exception e) {
                System.debug('::::newCustomer::::> ' + e.getMessage());
            }   
        }     
    Test.stopTest();        
    }        
    
    @isTest
    public static void testDuplicateCatcherChangeBillingStreet() {

        System.debug('testDuplicateCatcher:...');

        Account a = [   SELECT ID
                        FROM Account
                        WHERE NAME = 'TEST ACCOUNT 01'
        ];
        Region__c r = [ SELECT ID
                        FROM Region__c
                        WHERE Name = 'SOUTHERN CA REGION'
        ];
        Customer_Class__c cc1 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC1'
        ];
        Customer_Class__c cc2 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC2'
        ];
        Customer_Type__c ct1 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'DAL CT1'
        ];
        Customer_Type__c ct2 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'CANADIAN CT3'
        ];
        SSC__c ssc1 = [ SELECT ID , RVP__C , RSM__c
                        FROM SSC__c
                        WHERE DW_ID__c = '001'
        ];
        SSC__c ssc2 = [ SELECT ID , RVP__C , RSM__c
                        FROM SSC__c
                        WHERE DW_ID__c = '002'
        ];
        Sales_Representative__c sr1 = [ SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '001'
        ];
        Sales_Representative__c sr2 = [ SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '002'
        ];
        
        User uSR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR1@daltile.com.test'
        ]; 
        
        User uSR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR2@daltile.com.test'
        ]; 
        
        User MGR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR1@daltile.com.test'
        ]; 
        
        Change_Request__c cr1 = [   SELECT ID       
										   , Name
										   , CreatedById
										   , Created_Date__c
										   , Status__c
										   , Account__c
										   , Billing_Street_N__c
										   , Shipping_street__c
										   , New_ShipTo_Request__c
										   , Current_Approver__r.Email
										   , Current_Approver__c
										   , Sales_Representative__c
										   , Sales_Representative_n__c
										   , SSC__c
										   , SSC_N__c
										   , Customer_Class__c
										   , Customer_Class_N__c
										   , Customer_Type__c
										   , Customer_Type_N__c
										   , Customer_Name_Change__c
										   , Name_Change__c
                                FROM Change_Request__c        
                                WHERE Customer_Name_Change__c = 'Name Change Dupe Catcher'
        ];
        
		Test.startTest();
        
        System.runAs(uSR2) {     
            try {
                
                System.debug('testDuplicateCatcher + cr:...');
                Change_Request__c cr = new Change_Request__c(SBU__c = 'SC'
                                                                , IsNew__c = false
                                                                , RecordTypeId = Label.CR_Customer_Update_RT
                                                                , Account__c = a.Id
                                                                , Billing_Street_N__c = 'Billing_Street_N__c'
                                                                , Region__c = r.Id
                                                                , Sales_Representative__c = sr1.Id
                                                                , Customer_Class__c = cc1.Id                                                       
                                                                , Customer_Type__c = ct1.Id
                                                                , SSC__c = ssc1.Id
                                                                , Status__c = 'Submitting for Approval');
                insert cr;
                System.debug('testDuplicateCatcher + cr:...' + cr);
                
            }catch (Exception e) {
                System.debug('::::newCustomer::::> ' + e.getMessage());
            }   
        }     
    Test.stopTest();        
    }            
    
    @isTest
    public static void testDuplicateCatcherChangeShippingStreet() {

        System.debug('testDuplicateCatcher:...');

        Account a = [   SELECT ID
                        FROM Account
                        WHERE NAME = 'TEST ACCOUNT 01'
        ];
        Region__c r = [ SELECT ID
                        FROM Region__c
                        WHERE Name = 'SOUTHERN CA REGION'
        ];
        Customer_Class__c cc1 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC1'
        ];
        Customer_Class__c cc2 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC2'
        ];
        Customer_Type__c ct1 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'DAL CT1'
        ];
        Customer_Type__c ct2 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'CANADIAN CT3'
        ];
        SSC__c ssc1 = [ SELECT ID , RVP__C , RSM__c
                        FROM SSC__c
                        WHERE DW_ID__c = '001'
        ];
        SSC__c ssc2 = [ SELECT ID , RVP__C , RSM__c
                        FROM SSC__c
                        WHERE DW_ID__c = '002'
        ];
        Sales_Representative__c sr1 = [ SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '001'
        ];
        Sales_Representative__c sr2 = [ SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '002'
        ];
        
        User uSR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR1@daltile.com.test'
        ]; 
        
        User uSR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR2@daltile.com.test'
        ]; 
        
        User MGR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR1@daltile.com.test'
        ]; 
        
        Change_Request__c cr1 = [   SELECT ID       
										   , Name
										   , CreatedById
										   , Created_Date__c
										   , Status__c
										   , Account__c
										   , Billing_Street_N__c
										   , Shipping_street__c
										   , New_ShipTo_Request__c
										   , Current_Approver__r.Email
										   , Current_Approver__c
										   , Sales_Representative__c
										   , Sales_Representative_n__c
										   , SSC__c
										   , SSC_N__c
										   , Customer_Class__c
										   , Customer_Class_N__c
										   , Customer_Type__c
										   , Customer_Type_N__c
										   , Customer_Name_Change__c
										   , Name_Change__c
                                FROM Change_Request__c        
                                WHERE Customer_Name_Change__c = 'Name Change Dupe Catcher'
        ];
        
		Test.startTest();
        
        System.runAs(uSR2) {     
            try {
                
                System.debug('testDuplicateCatcher + cr:...');
                Change_Request__c cr = new Change_Request__c(SBU__c = 'SC'
                                                                , IsNew__c = false
                                                                , RecordTypeId = Label.CR_Customer_Update_RT
                                                                , Account__c = a.Id
                                                                , Shipping_street__c = 'Shipping_street__c'
                                                                , Region__c = r.Id
                                                                , Sales_Representative__c = sr1.Id
                                                                , Customer_Class__c = cc1.Id                                                       
                                                                , Customer_Type__c = ct1.Id
                                                                , SSC__c = ssc1.Id
                                                                , Status__c = 'Submitting for Approval');
                insert cr;
                System.debug('testDuplicateCatcher + cr:...' + cr);
                
            }catch (Exception e) {
                System.debug('::::newCustomer::::> ' + e.getMessage());
            }   
        }     
    Test.stopTest();        
    }            
    
    @isTest
    public static void testSalesRepChangeAsRSM() {

        System.debug('testSalesRepChange:...');
        
        Account a = [   SELECT ID
                        FROM Account
                        WHERE NAME = 'TEST ACCOUNT 03'
        ];
        Region__c r = [ SELECT ID
                        FROM Region__c
                        WHERE Name = 'SOUTHERN CA REGION'
        ];
        Customer_Class__c cc1 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC1'
        ];
        Customer_Class__c cc2 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC2'
        ];
        Customer_Type__c ct1 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'DAL CT1'
        ];
        Customer_Type__c ct2 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'CANADIAN CT3'
        ];
        SSC__c ssc1 = [  SELECT ID , RVP__C , RSM__c
                        FROM SSC__c
                        WHERE DW_ID__c = '001'
        ];
        SSC__c ssc2 = [  SELECT ID , RVP__C , RSM__c
                        FROM SSC__c
                        WHERE DW_ID__c = '002'
        ];
        Sales_Representative__c sr1 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '001'
        ];
        Sales_Representative__c sr2 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '002'
        ];
        
        User uSR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR1@daltile.com.test'
        ]; 
        
        User uSR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR2@daltile.com.test'
        ]; 

        User MGR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR1@daltile.com.test'
        ]; 
                
        
        User uMGR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR2@daltile.com.test'
        ]; 
        
        
        User uRSM = [   SELECT ID
                        FROM User
                        WHERE username = 'RSM@daltile.com.test'
	    ];
	    
		Test.startTest();
    
        // Sales Rep only change
        System.runAs(uRSM) {     
            try {
                
                Change_Request__c cr = new Change_Request__c(SBU__c = 'SC'
                                                                , IsNew__c = false
                                                                , RecordTypeId = Label.CR_Customer_Update_RT
                                                                , Account__c = a.Id
                                                                , Region__c = r.Id
                                                                , Sales_Representative__c = sr1.Id
                                                                , Customer_Class__c = cc1.Id                                                       
                                                                , Customer_Type__c = ct1.Id
                                                                , SSC__c = ssc1.Id
                                                                , Sales_Representative_n__c = sr2.id
                                                                , Status__c = 'Submitting for Approval');
                insert cr;
                cr.MGR_WF1__c = TRUE;
                cr.MGR_1_Approved__c = TRUE;
                Update cr;
                cr.MGR_2_Approved__c = TRUE;
                Update cr;
                
            }catch (Exception e) {
                System.debug('::::TestCaseTrigger + e : ' + e );
                
            }   
        }     
    }

    @isTest
    public static void testSalesRepChangeAsRVP() {

        System.debug('testSalesRepChange:...');
        
        Account a = [   SELECT ID
                        FROM Account
                        WHERE NAME = 'TEST ACCOUNT 03'
        ];
        Region__c r = [ SELECT ID
                        FROM Region__c
                        WHERE Name = 'SOUTHERN CA REGION'
        ];
        Customer_Class__c cc1 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC1'
        ];
        Customer_Class__c cc2 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC2'
        ];
        Customer_Type__c ct1 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'DAL CT1'
        ];
        Customer_Type__c ct2 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'CANADIAN CT3'
        ];
        SSC__c ssc1 = [  SELECT ID , RVP__C , RSM__c
                        FROM SSC__c
                        WHERE DW_ID__c = '001'
        ];
        SSC__c ssc2 = [  SELECT ID , RVP__C , RSM__c
                        FROM SSC__c
                        WHERE DW_ID__c = '002'
        ];
        Sales_Representative__c sr1 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '001'
        ];
        Sales_Representative__c sr2 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '002'
        ];
        
        User uSR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR1@daltile.com.test'
        ]; 
        
        User uSR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR2@daltile.com.test'
        ]; 

        User MGR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR1@daltile.com.test'
        ]; 
                
        
        User uMGR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR2@daltile.com.test'
        ]; 
        
        
        User uRVP = [   SELECT ID
                        FROM User
                        WHERE username = 'RVP@daltile.com.test'
	    ];
	    
		Test.startTest();
    
        // Sales Rep only change
        System.runAs(uRVP) {     
            try {
                
                Change_Request__c cr = new Change_Request__c(SBU__c = 'SC'
                                                                , IsNew__c = false
                                                                , RecordTypeId = Label.CR_Customer_Update_RT
                                                                , Account__c = a.Id
                                                                , Region__c = r.Id
                                                                , Sales_Representative__c = sr1.Id
                                                                , Customer_Class__c = cc1.Id                                                       
                                                                , Customer_Type__c = ct1.Id
                                                                , SSC__c = ssc1.Id
                                                                , Sales_Representative_n__c = sr2.id
                                                                , Status__c = 'Submitting for Approval');
                insert cr;
                cr.MGR_WF1__c = TRUE;
                cr.MGR_1_Approved__c = TRUE;
                Update cr;
                cr.MGR_2_Approved__c = TRUE;
                Update cr;
                
            }catch (Exception e) {
                System.debug('::::TestCaseTrigger + e : ' + e );
                
            }   
        }     
    }
         
    @isTest
    public static void testSalesRepChangeAsMGR2() {

        System.debug('testSalesRepChange:...');
        
        Account a = [   SELECT ID
                        FROM Account
                        WHERE NAME = 'TEST ACCOUNT 03'
        ];
        Region__c r = [ SELECT ID
                        FROM Region__c
                        WHERE Name = 'SOUTHERN CA REGION'
        ];
        Customer_Class__c cc1 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC1'
        ];
        Customer_Class__c cc2 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC2'
        ];
        Customer_Type__c ct1 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'DAL CT1'
        ];
        Customer_Type__c ct2 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'CANADIAN CT3'
        ];
        SSC__c ssc1 = [  SELECT ID , RVP__C , RSM__c
                        FROM SSC__c
                        WHERE DW_ID__c = '001'
        ];
        SSC__c ssc2 = [  SELECT ID , RVP__C , RSM__c
                        FROM SSC__c
                        WHERE DW_ID__c = '002'
        ];
        Sales_Representative__c sr1 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '001'
        ];
        Sales_Representative__c sr2 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '002'
        ];
        
        User uSR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR1@daltile.com.test'
        ]; 
        
        User uSR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR2@daltile.com.test'
        ]; 

        User MGR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR1@daltile.com.test'
        ]; 
                
        
        User uMGR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR2@daltile.com.test'
        ]; 
        
        
        User uRVP = [   SELECT ID
                        FROM User
                        WHERE username = 'RVP@daltile.com.test'
	    ];
	    
		Test.startTest();
    
        // Sales Rep only change
        System.runAs(uMGR2) {     
            try {
                
                Change_Request__c cr = new Change_Request__c(SBU__c = 'SC'
                                                                , IsNew__c = false
                                                                , RecordTypeId = Label.CR_Customer_Update_RT
                                                                , Account__c = a.Id
                                                                , Region__c = r.Id
                                                                , Sales_Representative__c = sr1.Id
                                                                , Customer_Class__c = cc1.Id                                                       
                                                                , Customer_Type__c = ct1.Id
                                                                , SSC__c = ssc1.Id
                                                                , New_ShipTo_Request__c = TRUE
                                                                , Reason_for_New_Suffix__c = 'Allllready'
                                                                , Status__c = 'Submitting for Approval');
                insert cr;
                cr.MGR_WF1__c = TRUE;
                cr.MGR_1_Approved__c = TRUE;
                Update cr;
                cr.MGR_2_Approved__c = TRUE;
                Update cr;
                
            }catch (Exception e) {
                System.debug('::::TestCaseTrigger + e : ' + e );
                
            }   
        }     
    }
         
    @isTest
    public static void testUpdateDelete() {

        System.debug('testSalesRepChange:...');
        
        Account a = [   SELECT ID
                        FROM Account
                        WHERE NAME = 'TEST ACCOUNT 03'
        ];
        Region__c r = [ SELECT ID
                        FROM Region__c
                        WHERE Name = 'SOUTHERN CA REGION'
        ];
        Customer_Class__c cc1 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC1'
        ];
        Customer_Class__c cc2 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC2'
        ];
        Customer_Type__c ct1 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'DAL CT1'
        ];
        Customer_Type__c ct2 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'CANADIAN CT3'
        ];
        SSC__c ssc1 = [  SELECT ID , RVP__C , RSM__c
                        FROM SSC__c
                        WHERE DW_ID__c = '001'
        ];
        SSC__c ssc2 = [  SELECT ID , RVP__C , RSM__c
                        FROM SSC__c
                        WHERE DW_ID__c = '002'
        ];
        Sales_Representative__c sr1 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '001'
        ];
        Sales_Representative__c sr2 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '002'
        ];
        
        User uSR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR1@daltile.com.test'
        ]; 
        
        User uSR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR2@daltile.com.test'
        ]; 

        User MGR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR1@daltile.com.test'
        ]; 
                
        
        User uMGR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR2@daltile.com.test'
        ]; 
        
        
        User uRVP = [   SELECT ID
                        FROM User
                        WHERE username = 'RVP@daltile.com.test'
	    ];
	    
		Test.startTest();
    
        // Sales Rep only change
        System.runAs(uMGR2) {     
            try {
                
                Change_Request__c cr = new Change_Request__c(SBU__c = 'SC'
                                                                , IsNew__c = false
                                                                , RecordTypeId = Label.CR_Customer_Update_RT
                                                                , Account__c = a.Id
                                                                , Region__c = r.Id
                                                                , Sales_Representative__c = sr1.Id
                                                                , Customer_Class__c = cc1.Id                                                       
                                                                , Customer_Type__c = ct1.Id
                                                                , SSC__c = ssc1.Id
                                                                , New_ShipTo_Request__c = TRUE
                                                                , Reason_for_New_Suffix__c = 'Allllready'
                                                                , Status__c = 'Not Submitted');
                insert cr;
                
                cr.Status__c = 'Submitted-Pending';
                cr.MGR_WF1__c = TRUE;
                cr.MGR_1_Approved__c = TRUE;
                cr.RVPWF1__c = true;
                CR.APPROVER1__C = uRVP.id;
                Update cr;

                Delete cr;
                
            }catch (Exception e) {
                System.debug('::::TestCaseTrigger + e : ' + e );
                
            }   
        }  
        Test.stopTest();   
    }

    @isTest static void testCRExtension() {

        System.debug('::::testCRExtension::::>');
//        setup();
        User uMGR = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR1@daltile.com.test'
        ]; 
        
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
                        WHERE Name='TEST ACCOUNT 01' LIMIT 1];
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
                        WHERE Name='TEST ACCOUNT DUPE' LIMIT 1];
        string updateDupeAccount = acctDUPE.id;
        Region__c r = [ SELECT ID
                        FROM Region__c
                        WHERE Name = 'SOUTHERN CA REGION'
        ];
        Customer_Class__c cc1 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC1'
        ];
        Customer_Class__c cc2 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC2'
        ];
        Customer_Type__c ct1 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'DAL CT1'
        ];
        Customer_Type__c ct2 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'CANADIAN CT3'
        ];
        SSC__c ssc1 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '001'
        ];
        SSC__c ssc2 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '002'
        ];
        Sales_Representative__c sr1 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '001'
        ];
        Sales_Representative__c sr2 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '002'
        ];
        
        System.debug('::::testCRExtension + got my acct , about to start::::>' + acct);
        
        Test.startTest();
        
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
                con.saveNewRequestData();
                con.doCancel();
            }   catch (Exception e) {
                System.debug('::::testChangeRequestValidation::::> ' + e.getMessage());
            } 
            
        Test.stopTest();
    }

    @isTest static void testDeleteRequest() {

        System.debug('::::testDeleteRequest::::>');

        
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
                        WHERE Name='TEST ACCOUNT 01' LIMIT 1];
        string updateAccount = acct.id;

        Test.startTest();
            try {
                pageRef1 = Page.CustomerDelRequest;
                pageRef1.getParameters().put('id',acct.id);
                System.debug('::::con.testDeleteRequest():::>1 ');
                Test.setCurrentPage(pageRef1);
                ApexPages.StandardController tstCls2 = new ApexPages.StandardController(acct);
                System.debug('::::con.createCR():::>3 ');
                conDEL = new CustomerDelRequestController(tstCls2);
                conDEL.saveDel();
                CustomerDelRequestController.saveNewDEL(updateAccount);

            }   catch (Exception e) {
                System.debug('::::testChangeRequestValidation::::> ' + e.getMessage());
            } 
            
        Test.stopTest();
    }


    static testMethod void testCRExtensionSalesRepDupes() {

        User uMGR = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR1@daltile.com.test'
        ]; 
    
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
                        WHERE Name='TEST ACCOUNT 01' LIMIT 1];
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
                        WHERE Name='TEST ACCOUNT DUPE' LIMIT 1];
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
                                    WHERE Name = 'CT EXT DI'];
       
       Customer_Type__c ctOldID = [SELECT ID
                                    FROM Customer_Type__c
                                    WHERE Name = 'CT EXT SC'];                                 
       
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

        User uMGR = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR1@daltile.com.test'
        ];            
    
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
                        WHERE Name='TEST ACCOUNT 01' LIMIT 1];
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
                        WHERE Name='TEST ACCOUNT DUPE' LIMIT 1];
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
                                    WHERE Name = 'CT EXT DI'];
       
       Customer_Type__c ctOldID = [SELECT ID
                                    FROM Customer_Type__c
                                    WHERE Name = 'CT EXT SC'];                                

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
    
    
   @isTest static void testCRExtensionRemoteActions1() {
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
                        WHERE Name='TEST ACCOUNT 01' LIMIT 1];
       
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

            Change_Request__c cr = [SELECT ID
                                   , Account__c
                                   FROM Change_Request__c
                                   WHERE Account__c = :updateAccount
                                   LIMIT 1];
            newCRId = cr.id;
        Test.startTest();
        try {
            CustomerRequestNewLightningExtension.createCR( updateAccount );

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
        Test.stopTest();
   }
 
    @isTest static void testCRExtensionRemoteActions2() {
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
                        WHERE Name='TEST ACCOUNT 01' LIMIT 1];
       
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

            Change_Request__c cr2 = [SELECT ID
                                   , Account__c
                                   FROM Change_Request__c
                                   WHERE Account__c = :updateAccount
                                   AND ID != :newCRId
                                   ORDER BY Created_Date__c DESC
                                   LIMIT 1];
            newCR2Id = cr2.id;                                                     

            pageRef1 = Page.CustomerChangeRequest;
            pageRef1.getParameters().put('id',acct.id);
            Test.setCurrentPage(pageRef1);
            ApexPages.StandardController tstCls2 = new ApexPages.StandardController(acct);
            con = new CustomerRequestNewLightningExtension(tstCls2);
            CustomerRequestNewLightningExtension.createCR(updateAccount);

        Test.startTest();    
        try {
            CustomerRequestNewLightningExtension.createCR( updateAccount );
   
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
        } catch (Exception e) {
            System.debug('::::createCR::::> ' + e.getMessage());
        }             
        Test.stopTest();
   }
 
    @isTest static void testCRExtensionRemoteActionsLookups() {
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
                        WHERE Name='TEST ACCOUNT 01' LIMIT 1];
       
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
 
     @isTest
    public static void testCRExtensionNewAccount() {
		 
        Region__c r1 = [ SELECT ID
                        FROM Region__c
                        WHERE Name = 'SOUTHERN CA REGION'
        ];
		
        Customer_Class__c cc1 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC1'
        ];
		
        Customer_Type__c ct1 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'DAL CT1'
        ];

        SSC__c ssc1 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '001'
        ];

        Sales_Representative__c sr1 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '001'
        ];

        User uSR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR1@daltile.com.test'
        ]; 
        
        User uMGR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR1@daltile.com.test'
        ]; 
        
        User uRSM1 = [   SELECT ID
                        FROM User
                        WHERE username = 'RSM@daltile.com.test'
	    ];
		
		string updateName = 'TESTING NEW ACCOUNT';
		string updateContact = 'TESTCONTACT';
		string updatePhone = '9724894406';
		string updateFax = '9724894407';
		string updateComments = 'nope';
		string updateDBAName = 'nah';
		string updateWebsite = 'nope.nah.edu';
		string updateNewRegion = r1.Id;
		string updateNewRep = sr1.Id;
		string updateNewSSC = ssc1.Id;
		string updateNewCusClass = cc1.Id;
		string updateNewReasonForClass = 'nope';
		string updateNewCusType = ct1.Id;
		string updateShipToCountryChange = 'US';
		string updateShipToAddress1Change = 'nope';
		string updateShipToAddress2Change = 'nope';
		string updateShipToCityChange = 'Dallas';
		string updateShipToZip = '75218';
		string updateShipToState   = 'TX';
		string updateBillToCountryChange = 'US';
		string updateBillToAddress1Change = 'nope';
		string updateBillToAddress2Change = 'nope';
		string updateBillToCityChange = 'Dallas';
		string updateBillToZip = '75218';
		string updateBillToState = 'TX';	
        Boolean updateCopyBillto = TRUE;
        Boolean updateContactProExch = true;
        string updateContactFirstName = 'TX';	
        string updateContactLastName = 'Oh TX';	
        string updateContactPhone = '2145557788';	
        string updateContactEmail = 'all.hail.the.mighty@state.io';

        Test.startTest();

		Change_Request__c cr = new Change_Request__c();
		List <Change_Request__c> listCR = new List <Change_Request__c>();
		
		pageRef1 = Page.CustomerRequestNewLightning;
		Test.setCurrentPage(pageRef1);
		ApexPages.StandardController testController = new ApexPages.StandardController(cr);
		con = new CustomerRequestNewLightningExtension(testController);
						 
		CustomerRequestNewLightningExtension.saveNewCustomer(       
		            updateName,
		            updateContact,
		            updatePhone,
		            updateFax,
		            updateComments,
		            updateDBAName,
		            updateWebsite,
		            updateNewRegion,
		            updateNewRep,
		            updateNewSSC,
		            updateNewCusClass,
		            updateNewReasonForClass,
		            updateNewCusType,
		            updateShipToCountryChange,
		            updateShipToAddress1Change,
		            updateShipToAddress2Change,
		            updateShipToCityChange,
		            updateShipToZip,
		            updateShipToState  ,
		            updateBillToCountryChange,
		            updateBillToAddress1Change,
		            updateBillToAddress2Change,
		            updateBillToCityChange,
		            updateBillToZip,
		            updateBillToState,
		            updateCopyBillto,
                    updateContactProExch,
                    updateContactFirstName,
                    updateContactLastName,
                    updateContactPhone,
                    updateContactEmail		            
		);
		
		listCR = [  SELECT 
		                Name
                        , Customer_Name_Change__c
                        , Rep_Change_Complete__c
                        , Suffix_N__c
                        , SSC_N__c
                        , Customer_Type_N__c
                        , Customer_Class_N__c
                        , Region_n__c
                        , Phone_N__c
                        , Fax_N__c
                        , SBU_N2__c
                        , Billing_Street_N__c
                        , Shipping_street__c
		            FROM Change_Request__c
		            LIMIT 20];
        
        // test print
        
        try {
            ApexPages.StandardSetController sc2 = new ApexPages.StandardSetController(listCR);
            ChangeViewExtension controllerPrint = new ChangeViewExtension(sc2);
            controllerPrint.oList = listCR;
            controllerPrint.setPrinted();        
        } catch (Exception e) {
            System.debug('::::cx1::::> ' + e.getMessage());
        }
        
        Test.stopTest();
    }

    @isTest
    public static void testProExchangeNewCustomer() {

        System.debug('testProExchangeNewCustomer:...');

        Account a = [   SELECT ID
                        FROM Account
                        WHERE NAME = 'TEST ACCOUNT 01'
        ];
        Region__c r = [ SELECT ID
                        FROM Region__c
                        WHERE Name = 'SOUTHERN CA REGION'
        ];
        Customer_Class__c cc1 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC1'
        ];
        Customer_Class__c cc2 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC2'
        ];
        Customer_Type__c ct1 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'DAL CT1'
        ];
        Customer_Type__c ct2 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'CANADIAN CT3'
        ];
        SSC__c ssc1 = [ SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '001'
        ];
        SSC__c ssc2 = [ SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '002'
        ];
        Sales_Representative__c sr1 = [ SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '001'
        ];
        Sales_Representative__c sr2 = [ SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '002'
        ];
        
        User uSR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR1@daltile.com.test'
        ]; 
        
        User uSR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR2@daltile.com.test'
        ]; 
        
        User MGR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR1@daltile.com.test'
        ]; 
        
        Case cs1 = [    SELECT ID
                        , AccountId
                        , ProExchange_Status__c
                        FROM Case
                        WHERE Subject = 'ProExchange New Account Test'
        ];
        
        Change_Request__c cr1 = [   SELECT ID
                                    , Name
                                    , CreatedById
                                    , Customer_Name__c
                                    , SSC__c
                                    , Created_Date__c
                                    , Sales_Representative__c
                                    , Customer_Class__c
                                    , Ship_To_Phone__c
                                    , Customer_Type__c
                                    , Region__c
                                    , Billing_Street_N__c
                                    , Address2__c
                                    , Bill_Country_N__c
                                    , Billing_City_N__c
                                    , Billing_State_N2__c
                                    , Billing_Zip_N__c
                                    , Contact__c
                                    , Status__c
                                    , Contact_First_Name__c
                                    , Contact_Last_Name__c
                                    , Contact_Email__c
                                    , Phone__C
                                    , Set_Up_In_ProExchange__c
                                    , Case__c
                                FROM Change_Request__c        
                                WHERE Customer_Name__c = 'Account For ProExchange'
        ];
        
        System.debug('testDuplicateCatcher + cr1:...' + cr1);
        
	    Test.startTest();	
           
        try {
            System.debug('testDuplicateCatcher + newCustomer:...');

            cr1.DM_New_Acct_Nbr__c = '321';
            update cr1; 
            
        }   catch (Exception e) {
            System.debug('::::newCustomer::::> ' + e.getMessage());
        }                   
        
        Test.stopTest();        
    }

    
}