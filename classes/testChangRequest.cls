@ isTest
public class testChangRequest {
    private static void init() {
        
    }
    
    static testMethod void testStuff1() {
    //     ChangeRequestTriggerHandler tstCls = new ChangeRequestTriggerHandler ();
    //     // SETUP TEST DATA
        
    //     // USERS / PROFILES
    //     boolean testRun = false;
    //     boolean hasErrors = false;    
    //     testRun = true;
        
    //     String jrust = [Select Id, Name, Alias from User where Alias = 'jrust' limit 1].ID;
    //     Profile p = [SELECT Id FROM Profile WHERE Name = 'Executive'];
    //     Profile px2 = [SELECT Id FROM Profile WHERE Name = 'Support'];
    //     Profile pAdmin = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
    //     String snort = [Select Id, Name, Alias from User where ProfileId = :pAdmin.Id AND LastName != 'Rust' limit 1].ID;
    //     UserRole r = [SELECT Id, Name FROM UserRole WHERE Name = 'Northwest Sales Rep 1'];
    //     UserRole rMGR = [SELECT Id, Name FROM UserRole WHERE Name = 'MW SSC Manager'];    
    //     User uMGR = [SELECT ID, Name FROM User where UserRoleID =  : rMGR.Id AND IsActive = TRUE LIMIT 1];
    //     User u1 = [SELECT ID, Name FROM User where ProfileID =  : p.Id AND IsActive = TRUE LIMIT 1];    
    //     User ux2 = [SELECT ID, Name FROM User where ProfileID =  : px2.Id AND IsActive = TRUE LIMIT 1];
    //     User uSR1 = [SELECT ID, Name FROM User where UserRoleId =  : r.Id AND IsActive = TRUE LIMIT 1];               
    //     System.debug('::::User Selected::::> ' + u1.NAme);
    //     System.debug('::::User Selected::::> ' + ux2.NAme);
        
    //     // REGIONS
        
    //     Region__c r1 = new Region__c(Select__c = true
    //                                  , SBU__c = 'SC'
    //                                  , DW_ID__c = '01'
    //                                  , Name = 'SOUTHERN CA REGION');
    //     insert r1;
        
    //     Region__c r04 = new Region__c(Select__c = true
    //                                   , SBU__c = 'SC'
    //                                   , DW_ID__c = '04'
    //                                   , Name = 'MIDWEST REGION');
    //     insert r04;
        
    //     Region__c r2 = new Region__c(Select__c = true
    //                                  , SBU__c = 'DI'
    //                                  , DW_ID__c = '000111222'
    //                                  , Name = 'AO Region');
        
    //     insert r2;
    //     Region__c r3 = new Region__c(Select__c = true
    //                                  , SBU__c = 'SC'
    //                                  , DW_ID__c = '34'
    //                                  , Name = 'CANADIAN REGION');
        
    //     insert r3;
        
    //     Region__c r100 = new Region__c(Select__c = true
    //                                   , SBU__c = 'SC'
    //                                   , DW_ID__c = '99'
    //                                   , Name = 'SOUTHERN CA REGION');
    //     insert r100;
        
    //     Region__c rx1 = new Region__c(Select__c = true
    //                                   , SBU__c = 'SC'
    //                                   , DW_ID__c = '000111'
    //                                   , Name = 'SOUTHERN CA REGION');
    //     insert rx1;
        
    //     // CUSTOMER CLASS
        
    //     Customer_Class__c cc = new Customer_Class__c(Active__c = true
    //                                                  , COS__c = 111
    //                                                  , CustClass__c = 'S4Q'
    //                                                  , Cust_Count__c = 123
    //                                                  , Customer_Class_Details__c = 'TEST THIS'
    //                                                  , CustomerCountry__c = 'US'
    //                                                  , CustomerSBU__c = 'DI'
    //                                                  , Duplicate__c = false
    //                                                  , Net_Sales__c = 111
    //                                                  , PPS_Rgn__c = 'SC');
    //     insert cc;
        
    //     Customer_Class__c cc1 = new Customer_Class__c(Active__c = true
    //                                                   , COS__c = 111
    //                                                   , CustClass__c = 'S8Q'
    //                                                   , Cust_Count__c = 123
    //                                                   , Customer_Class_Details__c = 'TEST THIS'
    //                                                   , CustomerCountry__c = 'US'
    //                                                   , CustomerSBU__c = 'SC'
    //                                                   , Duplicate__c = false
    //                                                   , Net_Sales__c = 111
    //                                                   , PPS_Rgn__c = 'SC MW');
    //     insert cc1;
        
    //     Customer_Class__c ccDEL = new Customer_Class__c(Active__c = true
    //                                                     , COS__c = 111
    //                                                     , CustClass__c = 'DEL'
    //                                                     , Cust_Count__c = 123
    //                                                     , Customer_Class_Details__c = 'DEL THIS'
    //                                                     , CustomerCountry__c = 'US'
    //                                                     , CustomerSBU__c = 'SC'
    //                                                     , Duplicate__c = false
    //                                                     , Net_Sales__c = 111
    //                                                     , PPS_Rgn__c = 'SC');
    //     insert ccDEL;
        
    //     Customer_Class__c cc100 = new Customer_Class__c(Active__c = true
    //                                                     , COS__c = 111
    //                                                     , CustClass__c = 'S9Q'
    //                                                     , Cust_Count__c = 123
    //                                                     , Customer_Class_Details__c = 'TEST THIS'
    //                                                     , CustomerCountry__c = 'US'
    //                                                     , CustomerSBU__c = 'SC'
    //                                                     , Duplicate__c = false
    //                                                     , Net_Sales__c = 111
    //                                                     , PPS_Rgn__c = 'SC MW');
    //     insert cc100;
        
    //     // SSC
        
    //     SSC__c ssc = new SSC__c(Closed__c = false
    //                             , DW_ID__c = '000111'    
    //                             , Loc_Type__c = 'SSC'
    //                             , Manager__c = UserInfo.getUserId()
    //                             , Region__c = r1.Id
    //                             , ROM__c = UserInfo.getUserId()
    //                             , RSM__c = UserInfo.getUserId()
    //                             , RVP__c = UserInfo.getUserId()     
    //                             , Sales_Region__c = '04'
    //                             , SBU__c = 'DI'
    //                             , Select__c = true
    //                             , SSC_Fax_Number__c = '123-345-5567'
    //                             , SSC_Phone_Number__c = '123-345-5567'
    //                             , State__c = 'TX'
    //                             , Street_Address__c = '12345 1st street'
    //                             , Zip_Code__c = '12345');
    //     insert ssc;
        
    //     SSC__c ssc1 = new SSC__c(Closed__c = false
    //                              , DW_ID__c = '000112'
    //                              , Loc_Type__c = 'SSC'
    //                              , Manager__c = Null
    //                              , Region__c = r2.Id
    //                              , ROM__c = Null
    //                              , RSM__c = Null
    //                              , RVP__c = Null
    //                              , Sales_Region__c = '04'
    //                              , SBU__c = 'DI'
    //                              , Select__c = true
    //                              , SSC_Fax_Number__c = '123-345-5567'
    //                              , SSC_Phone_Number__c = '123-345-5567'
    //                              , State__c = 'TX'
    //                              , Street_Address__c = '12345 1st street'
    //                              , Zip_Code__c = '12345');
    //     insert ssc1;
        
    //     SSC__c ssc2 = new SSC__c(Closed__c = false
    //                              , DW_ID__c = '000119'
    //                              , Loc_Type__c = 'SSC'
    //                              , Manager__c = UserInfo.getUserId()
    //                              , Region__c = r2.Id
    //                              , ROM__c = UserInfo.getUserId()
    //                              , RSM__c = UserInfo.getUserId()
    //                              , RVP__c = UserInfo.getUserId()
    //                              , Sales_Region__c = '04'
    //                              , SBU__c = 'DI'
    //                              , Select__c = true
    //                              , SSC_Fax_Number__c = '123-345-5567'
    //                              , SSC_Phone_Number__c = '123-345-5567'
    //                              , State__c = 'TX'
    //                              , Street_Address__c = '12345 1st street'
    //                              , Zip_Code__c = '12345');
    //     insert ssc2;
        
    //     SSC__c ssc500 = new SSC__c(Closed__c = false
    //                               , DW_ID__c = '500111'
    //                               , Loc_Type__c = 'SSC'
    //                               , Manager__c = jrust
    //                               , Region__c = r100.id
    //                               , ROM__c = jrust
    //                               , RSM__c = jrust
    //                               , RVP__c = jrust
    //                               , Sales_Region__c = '04'
    //                               , SBU__c = 'SC'
    //                               , Select__c = true
    //                               , SSC_Fax_Number__c = '123-345-5567'
    //                               , SSC_Phone_Number__c = '123-345-5567'
    //                               , State__c = 'TX'
    //                               , Street_Address__c = '12345 1st street'
    //                               , Zip_Code__c = '12345');
    //     insert ssc500;
        
    //     SSC__c ssc505 = new SSC__c(Closed__c = false
    //                               , DW_ID__c = '908111'
    //                               , Loc_Type__c = 'SSC'
    //                               , Region__c = r100.id
    //                               , Manager__c = NULL
    //                               , Sales_Region__c = '04'
    //                               , SBU__c = 'SC'
    //                               , Select__c = true
    //                               , SSC_Fax_Number__c = '123-345-5567'
    //                               , SSC_Phone_Number__c = '123-345-5567'
    //                               , State__c = 'TX'
    //                               , Street_Address__c = '12345 1st street'
    //                               , Zip_Code__c = '12345');
    //     insert ssc505;
        
    //     SSC__c ssc501 = new SSC__c(Closed__c = false
    //                               , DW_ID__c = '902111'
    //                               , Loc_Type__c = 'SSC'
    //                               , Manager__c = UserInfo.getUserId()
    //                               , Region__c = r100.id
    //                               , ROM__c = UserInfo.getUserId()
    //                               , RSM__c = UserInfo.getUserId()
    //                               , RVP__c = UserInfo.getUserId()
    //                               , Sales_Region__c = '04'
    //                               , SBU__c = 'SC'
    //                               , Select__c = true
    //                               , SSC_Fax_Number__c = '123-345-5567'
    //                               , SSC_Phone_Number__c = '123-345-5567'
    //                               , State__c = 'TX'
    //                               , Street_Address__c = '12345 1st street'
    //                               , Zip_Code__c = '12345');
    //     insert ssc501;
        
    //     SSC__c ssc503 = new SSC__c(Closed__c = false
    //                               , DW_ID__c = '903111'
    //                               , Loc_Type__c = 'SSC'
    //                               , Manager__c = snort
    //                               , Region__c = r04.Id
    //                               , ROM__c = snort
    //                               , RSM__c = snort
    //                               , RVP__c = snort
    //                               , Sales_Region__c = '04'
    //                               , SBU__c = 'SC'
    //                               , Select__c = true
    //                               , SSC_Fax_Number__c = '123-345-5567'
    //                               , SSC_Phone_Number__c = '123-345-5567'
    //                               , State__c = 'TX'
    //                               , Street_Address__c = '12345 1st street'
    //                               , Zip_Code__c = '12345');
    //     insert ssc503;
        
        
        
    //     SSC__c ssc600 = new SSC__c(Closed__c = false
    //                               , DW_ID__c = '600'
    //                               , Loc_Type__c = 'SSC'
    //                               , Manager__c = uMGR.Id
    //                               , Region__c = r04.id
    //                               , ROM__c = uMGR.Id
    //                               , RSM__c = uMGR.Id
    //                               , RVP__c = uMGR.Id
    //                               , Sales_Region__c = '04'
    //                               , SBU__c = 'SC'
    //                               , Select__c = true
    //                               , SSC_Fax_Number__c = '123-345-5567'
    //                               , SSC_Phone_Number__c = '123-345-5567'
    //                               , State__c = 'TX'
    //                               , Street_Address__c = '12345 1st street'
    //                               , Zip_Code__c = '12345');
    //     insert ssc600;
        
        
    //     SSC__c sscCA = new SSC__c(Closed__c = false
    //                               , DW_ID__c = '3434'
    //                               , Loc_Type__c = 'SSC'
    //                               , Manager__c = snort
    //                               , Region__c = r100.id
    //                               , ROM__c = snort
    //                               , RSM__c = snort
    //                               , RVP__c = snort
    //                               , Sales_Region__c = '34'
    //                               , SBU__c = 'SC'
    //                               , Select__c = true
    //                               , SSC_Fax_Number__c = '123-345-5567'
    //                               , SSC_Phone_Number__c = '123-345-5567'
    //                               , State__c = 'TX'
    //                               , Street_Address__c = '12345 1st street'
    //                               , Zip_Code__c = '12345');
    //     insert sscCA;
    //     System.debug('::::SSC CA Country::::> ' + sscCA.Country__c);
        
    //     // CUSTOMER TYPE
        
    //     Customer_Type__c ct = new Customer_Type__c(Active__c = true
    //                                               , Select__c = true
    //                                               , SBU__c = 'DI'
    //                                               , Region__c = r100.Id);
    //     insert ct;
        
    //     Customer_Type__c ct2 = new Customer_Type__c(Active__c = true
    //                                                 , Select__c = true
    //                                                 , SBU__c = 'SC'
    //                                                 , Region__c = r04.Id);
    //     insert ct2;
        
        
    //     Customer_Type__c ct3 = new Customer_Type__c(Active__c = true
    //                                                 , Select__c = true
    //                                                 , SBU__c = 'SC'
    //                                                 , Region__c = r04.Id);
    //     insert ct3;
        
    //     Customer_Type__c ct500 = new Customer_Type__c(Active__c = true
    //                                                   , Select__c = true
    //                                                   , SBU__c = 'SC'
    //                                                   , Region__c = r100.Id);
    //     insert ct500;
        
    //     // SALES REPS
        
    //     Sales_Representative__c sr = new Sales_Representative__c(SBU__c = 'DI'
    //                                                              , DW_ID__c = '7'
    //                                                              , Region__c = r1.Id);
    //     insert sr;
        
    //     Sales_Representative__c sr1 = new Sales_Representative__c(SBU__c = 'sc'
    //                                                               , DW_ID__c = '97'
    //                                                               , Region__c = r1.Id);
    //     insert sr1;
        
    //     Sales_Representative__c sr2 = new Sales_Representative__c(SBU__c = 'sc'
    //                                                               , DW_ID__c = '95'
    //                                                               , Region__c = r1.Id
    //                                                               , Salesman_Last_Name__c = 'REGION');
    //     insert sr2;
        
    //     Sales_Representative__c sr041 = new Sales_Representative__c(SBU__c = 'sc'
    //                                                                 , DW_ID__c = '041'
    //                                                                 , Region__c = r04.Id);
    //     insert sr041;
        
    //     Sales_Representative__c sr042 = new Sales_Representative__c(SBU__c = 'sc'
    //                                                                 , DW_ID__c = '042'
    //                                                                 , Region__c = r04.Id
    //                                                                 , Salesman_Last_Name__c = 'REGION');
    //     insert sr042;
        
    //     Sales_Representative__c sr3 = new Sales_Representative__c(SBU__c = 'sc'
    //                                                               , DW_ID__c = '93'
    //                                                               , Region__c = r1.Id
    //                                                               , Salesman_Last_Name__c = 'test');
    //     insert sr3;
        
    //     Sales_Representative__c sr500 = new Sales_Representative__c(SBU__c = 'SC'
    //                                                                 , DW_ID__c = '99'
    //                                                                 , Salesman_First_Name__c = 'REGION'
    //                                                                 , Salesman_Last_Name__c = 'REGION'
    //                                                                 , Region__c = r100.id);
    //     insert sr500;
        
    //     Sales_Representative__c sr501 = new Sales_Representative__c(SBU__c = 'SC'
    //                                                                 , DW_ID__c = '91'
    //                                                                 , Salesman_First_Name__c = 'Jake'
    //                                                                 , Salesman_Last_Name__c = 'Test'
    //                                                                 , Region__c = r100.id);
    //     insert sr501;
        
    //     Sales_Representative__c srx500 = new Sales_Representative__c(SBU__c = 'SC'
    //                                                                  , DW_ID__c = '67'
    //                                                                  , Salesman_First_Name__c = 'REGION'
    //                                                                  , Salesman_Last_Name__c = 'REGION'
    //                                                                  , Region__c = rx1.id);
    //     insert srx500;
        
    //     Sales_Representative__c srx501 = new Sales_Representative__c(SBU__c = 'SC'
    //                                                                  , DW_ID__c = '98'
    //                                                                  , Salesman_First_Name__c = 'Jake'
    //                                                                  , Salesman_Last_Name__c = 'Test'
    //                                                                  , Region__c = rx1.id);
    //     insert srx501;
        
    //     // ACCOUNT
        
    //     Account a100 = new Account(Name = 'Test');
    //     insert a100;
        
    //     Test.startTest();
    //     testRun = true;
        
    //     System.runAs(uSR1) {     
    //         try {
                
    //             Account aZipError = new Account(Name = 'Test');
    //             insert aZipError;          
                
    //             Change_Request__c c4Zip = new Change_Request__c(SBU__c = 'SC'
    //                                                             , IsNew__c = false
    //                                                             , Account__c = aZipError.Id
    //                                                             , Sales_Representative__c = sr2.Id
    //                                                             , Bill_Country_N__c = 'US'
    //                                                             , Customer_Class__c = cc.Id
    //                                                             , Business_Reason__c = 'testing...'                                                        
    //                                                             , Customer_Type__c = ct.Id
    //                                                             , Copy_Bill_To_Address__c = TRUE
    //                                                             , RecordTypeId = Label.CR_Customer_Update_RT
    //                                                             , SSC__c = ssc.Id
    //                                                             , Name__c = NULL
    //                                                             , Customer_Name__c = 'NULL Customer Name' 
    //                                                             , Shipping_Zip_N__c = null
    //                                                             , Billing_City__c = 'test city'
    //                                                             , Region__c = r1.Id);
    //             insert c4Zip;
    //             System.debug('::::c4Zip CreatedBy::::> ' + c4Zip.CreatedBy.NAme);
    //             System.debug('::::c4Zip REP_Approver_2__c::::> ' + c4Zip.REP_Approver_2__r.NAme);
    //             c4Zip.MGR_WF1__c = TRUE;
    //             c4Zip.MGR_1_Approved__c = TRUE;
    //             Update c4Zip;
    //             c4Zip.MGR_2_Approved__c = TRUE;
    //             Update c4Zip;
                
    //         }catch (Exception e) {
    //             System.debug('::::c4Zip::::> ' + e.getMessage());
    //             System.debug('::::Has Errors?::::> ' + tstCls.hasErrors);
    //             //        System.AssertEquals(tstCls.hasErrors, false);
    //             Boolean expectedExceptionThrown1 =  e.getMessage().contains(Label.Shipping_Zip_Required) ? true : false;
    //             //        System.AssertEquals(expectedExceptionThrown1, true);
    //             Boolean expectedExceptionThrown2 =  e.getMessage().contains(Label.Shipping_City_Required) ? true : false;
    //             //        System.AssertEquals(expectedExceptionThrown2, true);
    //         }   
    //     }      
    //     Test.stopTest();
    // }
    // static testMethod void testChangeRequestExtension() {
    //     // SETUP TEST DATA
    //     boolean testRun = false;
    //     boolean hasErrors = false;    
        
    //     // REGIONS
        
    //     Region__c r04 = new Region__c(Select__c = true
    //                                   , SBU__c = 'SC'
    //                                   , DW_ID__c = '04'
    //                                   , Name = 'MIDWEST REGION');
    //     insert r04;
        
    //     // REPS
    //     Sales_Representative__c sr041 = new Sales_Representative__c(SBU__c = 'sc'
    //                                                                 , DW_ID__c = '041'
    //                                                                 , Region__c = r04.Id);
    //     insert sr041;
        
    //     Sales_Representative__c sr042 = new Sales_Representative__c(SBU__c = 'sc'
    //                                                                 , DW_ID__c = '042'
    //                                                                 , Region__c = r04.Id
    //                                                                 , Salesman_Last_Name__c = 'REGION');
    //     insert sr042;
        
    //     // CUSTOMER CLASS
        
    //     Customer_Class__c cc1 = new Customer_Class__c(Active__c = true
    //                                                   , COS__c = 111
    //                                                   , CustClass__c = 'S9Q'
    //                                                   , Cust_Count__c = 123
    //                                                   , Customer_Class_Details__c = 'TEST THIS'
    //                                                   , CustomerCountry__c = 'US'
    //                                                   , CustomerSBU__c = 'SC'
    //                                                   , Duplicate__c = false
    //                                                   , Net_Sales__c = 111
    //                                                   , PPS_Rgn__c = 'SC MW');
    //     insert cc1;
        
    //     // SSC
        
    //     SSC__c ssc1 = new SSC__c(Closed__c = false
    //                              , DW_ID__c = '000112'
    //                              , Loc_Type__c = 'SSC'
    //                              , Manager__c = Null
    //                              , Region__c = r04.Id
    //                              , ROM__c = Null
    //                              , RSM__c = Null
    //                              , RVP__c = Null
    //                              , Sales_Region__c = '04'
    //                              , SBU__c = 'DI'
    //                              , Select__c = true
    //                              , SSC_Fax_Number__c = '123-345-5567'
    //                              , SSC_Phone_Number__c = '123-345-5567'
    //                              , State__c = 'TX'
    //                              , Street_Address__c = '12345 1st street'
    //                              , Zip_Code__c = '12345');
    //     insert ssc1;
        
    //     // CUSTOMER TYPE
        
    //     Customer_Type__c ct2 = new Customer_Type__c(Active__c = true
    //                                                 , Select__c = true
    //                                                 , SBU__c = 'SC'
    //                                                 , Region__c = r04.Id);
    //     insert ct2;
        
    //     // CREATE ACCOUNTS
        
    //     Account acc = new Account ( NAME = 'TEST ACCOUNT 01'
    //                               , AccountNumber = '111111'
    //                               , Customer_Base__c = '111111'
    //                               , Customer_Class__c = cc1.id
    //                               , phone = '214-309-4193'
    //                               , Customer_Type__c = ct2.id
    //                               , DW_ID__c = '11111'
    //                               , GroupKey__c = '11111'
    //                               , SAP_Account_Id__c = '11111'
    //                               , Fax = '214-309-4193'
    //                               , Website = 'wwww.test.com'
    //                               , Require_PO__c = FALSE
    //                               , Region__c = r04.Id
    //                               , Salesman__c = sr041.id
    //                               , SSC__c = ssc1.id
    //                               , Customer_Suffix__c = '11'
    //                               , BillingStreet = '111111'
    //                               , BillingCity = 'DALLAS'
    //                               , BillingState = 'TX'
    //                               , BillingPostalCode = '75218'
    //                               , BillingCountry = 'US'
    //                               , ShippingStreet = '111111'
    //                               , ShippingCity = 'DALLAS'
    //                               , ShippingState = 'TX'
    //                               , ShippingPostalCode = '75218'
    //                               , ShippingCountry = 'DALLAS'
    //                               , Address_3__c = 'huh'
    //                               , SBU__C  = 'SC');
    //     insert acc;
        
    //     Test.startTest();
    //     testRun = true;
        
    //     // NEW CUSTOMER
    //     try {
    //         Change_Request__c newCustomer = new Change_Request__c(SBU__c = 'SC'
    //                                                               , IsNew__c = false
    //                                                               , Suffix_N__c = 'NEW'
    //                                                               , Reason_for_New_Suffix__c = 'cause'
    //                                                               , Customer_Class_n__c = cc1.id
    //                                                               , Business_Reason__c = 'TEST'
    //                                                               , Sales_Representative__c = sr041.Id
    //                                                               , Customer_Class__c = cc1.Id
    //                                                               , Customer_Type__c = ct2.Id
    //                                                               , RecordTypeId = Label.CR_New_Customer_RT
    //                                                               , SSC__c = ssc1.Id
    //                                                               , Name__c = NULL
    //                                                               , Ship_To_Phone__c = '(972) 489-4406'
    //                                                               , Fax__c = '(972) 489-4406'
    //                                                               , Region__c = r04.Id);
    //         insert newCustomer; 
    //         ChangeRequestExtension tstCls = new ChangeRequestExtension (new ApexPages.StandardController(newCustomer));
    //     }   catch (Exception e) {
    //         System.debug('::::newCustomer::::> ' + e.getMessage());
    //     }
    //     // CUSTOMER CHANGE
    //     try {
    //         ChangeRequestExtension tstCls = new ChangeRequestExtension (new ApexPages.StandardController(acc));
    //         tstCls.createCR();
    //     }   catch (Exception e) {
    //         System.debug('::::customerUpdate::::> ' + e.getMessage());
    //     } 
        
        
    //     try {
    //         Change_Request__c customerUpdate = new Change_Request__c(SBU__c = 'SC'
    //                                                                  , IsNew__c = false
    //                                                                  , Suffix_N__c = 'NEW'
    //                                                                  , Reason_for_New_Suffix__c = 'cause'
    //                                                                  , Customer_Class_n__c = cc1.id
    //                                                                  , Business_Reason__c = 'TEST'
    //                                                                  , Sales_Representative__c = sr041.Id
    //                                                                  , Sales_Representative_n__c = sr042.id
    //                                                                  , Customer_Class__c = cc1.Id
    //                                                                  , Customer_Type__c = ct2.Id
    //                                                                  , RecordTypeId = Label.CR_Customer_Update_RT
    //                                                                  , SSC__c = ssc1.Id
    //                                                                  , Name__c = NULL
    //                                                                  , Ship_To_Phone__c = '(972) 489-4406'
    //                                                                  , Fax__c = '(972) 489-4406'
    //                                                                  , Region__c = r04.Id);
    //         insert customerUpdate;          
    //         System.debug('::::customerUpdate Status 2::::> ' + customerUpdate.Status__c);
    //         ChangeRequestExtension tstCls = new ChangeRequestExtension (new ApexPages.StandardController(customerUpdate));
    //     }   catch (Exception e) {
    //         System.debug('::::customerUpdate::::> ' + e.getMessage());
    //     } 
    //     Test.stopTest();
    // }  
    
    
    // static testMethod void testNewAccountErrors() {
        
    //     // SETUP TEST DATA
    //     boolean testRun = false;
    //     boolean hasErrors = false;    
    //     UserRole rMGR = [SELECT Id, Name FROM UserRole WHERE Name = 'MW SSC Manager'];    
    //     User uMGR = [SELECT ID, Name FROM User where UserRoleID =  : rMGR.Id AND IsActive = TRUE LIMIT 1];
    //     Region__c r04 = new Region__c(Select__c = true
    //                                   , SBU__c = 'SC'
    //                                   , DW_ID__c = '04'
    //                                   , Name = 'MIDWEST REGION');
    //     insert r04;
        
    //     Customer_Class__c cc100 = new Customer_Class__c(Active__c = true
    //                                                     , COS__c = 111
    //                                                     , CustClass__c = 'S9Q'
    //                                                     , Cust_Count__c = 123
    //                                                     , Customer_Class_Details__c = 'TEST THIS'
    //                                                     , CustomerCountry__c = 'US'
    //                                                     , CustomerSBU__c = 'SC'
    //                                                     , Duplicate__c = false
    //                                                     , Net_Sales__c = 111
    //                                                     , PPS_Rgn__c = 'SC MW');
    //     insert cc100;
        
    //     Sales_Representative__c sr041 = new Sales_Representative__c(SBU__c = 'sc'
    //                                                                 , DW_ID__c = '041'
    //                                                                 , Region__c = r04.Id);
    //     insert sr041;
        
    //     SSC__c ssc = new SSC__c(Closed__c = false
    //                             , DW_ID__c = '000111'    
    //                             , Loc_Type__c = 'SSC'
    //                             , Manager__c = UserInfo.getUserId()
    //                             , Region__c = r04.Id
    //                             , ROM__c = UserInfo.getUserId()
    //                             , RSM__c = UserInfo.getUserId()
    //                             , RVP__c = UserInfo.getUserId()     
    //                             , Sales_Region__c = '04'
    //                             , SBU__c = 'DI'
    //                             , Select__c = true
    //                             , SSC_Fax_Number__c = '123-345-5567'
    //                             , SSC_Phone_Number__c = '123-345-5567'
    //                             , State__c = 'TX'
    //                             , Street_Address__c = '12345 1st street'
    //                             , Zip_Code__c = '12345');
    //     insert ssc;
        
    //     Customer_Class__c cc = new Customer_Class__c(Active__c = true
    //                                                  , COS__c = 111
    //                                                  , CustClass__c = 'S4Q'
    //                                                  , Cust_Count__c = 123
    //                                                  , Customer_Class_Details__c = 'TEST THIS'
    //                                                  , CustomerCountry__c = 'US'
    //                                                  , CustomerSBU__c = 'SC'
    //                                                  , Duplicate__c = false
    //                                                  , Net_Sales__c = 111
    //                                                  , PPS_Rgn__c = 'SC');
    //     insert cc;
        
    //     Customer_Type__c ct2 = new Customer_Type__c(Active__c = true
    //                                                 , Select__c = true
    //                                                 , SBU__c = 'SC'
    //                                                 , Region__c = r04.Id);
    //     insert ct2;
        
    //     ChangeRequestTriggerHandler tstCls = new ChangeRequestTriggerHandler ();
    //     testRun = true;
    //     Test.startTest();
    //     ////// All Approvals
    //     // New Account with errors
        
    //     System.runAs(uMGR) {
    //         try {
    //             Change_Request__c newCR = new Change_Request__c(
    //                 SBU__c = 'SC'
    //                 , Country_N2__c = 'RS'
    //                 , Billing_Street__c = ''
    //                 , Billing_City__c = ''
    //                 , Shipping_State_N2__c = ''
    //                 , Shipping_Zip_N__c = ''
    //                 , Customer_Class_n__c = cc100.id
    //                 , Business_Reason__c = 'TEST'
    //                 , Sales_Representative__c = sr041.Id
    //                 , Customer_Class__c = cc100.Id
    //                 , Customer_Type__c = ct2.Id
    //                 , RecordTypeId = Label.CR_New_Customer_RT
    //                 , SSC__c = ssc.Id
    //                 , Name__c = 'New Test'
    //                 , Ship_To_Phone__c = '(972) 489-4406'
    //                 , Fax__c = '(972) 489-4406'
    //                 , Region__c = r04.Id);
    //             insert newCR;
    //             newCr.Status__c = 'Submitted-Pending';
    //             update newCR;
    //             newCr.MGR_WF1__c = TRUE;
    //             newCr.RSM_WF1__c = TRUE;
    //             newCr.ROM_WF1__c = TRUE;
    //             newCr.Status__c = 'Submitted-Pending MGR Approval';
    //             update newCR;
    //             newCr.Status__c = 'Submitted-Pending MGR Approval';
    //             newCr.MGR_1_Approved__c = TRUE;
    //             update newCR;
    //             newCr.Status__c = 'Submitted-Pending RSM Approval';
    //             newCr.RSM_Approved__c = TRUE;
    //             update newCR;
    //             newCr.Status__c = 'Submitted-Pending ROM Approval';
    //             newCr.ROM_Approved__c = TRUE;
    //             update newCR;
                
    //             System.debug('::::newCR + Status__c::::> ' + newCr.Status__c);
    //             update newCR;
    //             newCr.MGR_1_Approved__c = TRUE;
    //             update newCR;
    //             System.debug('::::newCR + Status__c::::> ' + newCr.Status__c);
    //         } catch (Exception e) {
    //             System.debug('::::newCR::::> ' + e.getMessage());
    //         } }  
    //     Test.stopTest();
    // }
    // static testMethod void testNewAccountCusTypeErrors() {
        
    //     // SETUP TEST DATA
    //     boolean testRun = false;
    //     boolean hasErrors = false;    
    //     UserRole rMGR = [SELECT Id, Name FROM UserRole WHERE Name = 'MW SSC Manager'];    
    //     User uMGR = [SELECT ID, Name FROM User where UserRoleID =  : rMGR.Id AND IsActive = TRUE LIMIT 1];
    //     Region__c r04 = new Region__c(Select__c = true
    //                                   , SBU__c = 'SC'
    //                                   , DW_ID__c = '04'
    //                                   , Name = 'DT Mid-West');
    //     insert r04;
        
    //     Region__c r05 = new Region__c(Select__c = true
    //                                   , SBU__c = 'SC'
    //                                   , DW_ID__c = '05'
    //                                   , Name = 'DT Midder-West');
    //     insert r05;        
        
    //     Customer_Class__c cc100 = new Customer_Class__c(Active__c = true
    //                                                     , COS__c = 111
    //                                                     , CustClass__c = 'S9Q'
    //                                                     , Cust_Count__c = 123
    //                                                     , Customer_Class_Details__c = 'TEST THIS'
    //                                                     , CustomerCountry__c = 'US'
    //                                                     , CustomerSBU__c = 'SC'
    //                                                     , Duplicate__c = false
    //                                                     , Net_Sales__c = 111
    //                                                     , PPS_Rgn__c = '04');
    //     insert cc100;
        
    //     Sales_Representative__c sr041 = new Sales_Representative__c(SBU__c = 'sc'
    //                                                                 , DW_ID__c = '041'
    //                                                                 , Region__c = r04.Id);
    //     insert sr041;
        
    //     SSC__c ssc = new SSC__c(Closed__c = false
    //                             , DW_ID__c = '000111'    
    //                             , Loc_Type__c = 'SSC'
    //                             , Manager__c = UserInfo.getUserId()
    //                             , Region__c = r04.Id
    //                             , ROM__c = UserInfo.getUserId()
    //                             , RSM__c = UserInfo.getUserId()
    //                             , RVP__c = UserInfo.getUserId()     
    //                             , Sales_Region__c = '04'
    //                             , SBU__c = 'DI'
    //                             , Select__c = true
    //                             , SSC_Fax_Number__c = '123-345-5567'
    //                             , SSC_Phone_Number__c = '123-345-5567'
    //                             , State__c = 'TX'
    //                             , Street_Address__c = '12345 1st street'
    //                             , Zip_Code__c = '12345');
    //     insert ssc;
        
    //     Customer_Class__c cc = new Customer_Class__c(Active__c = true
    //                                                  , COS__c = 111
    //                                                  , CustClass__c = 'S4Q'
    //                                                  , Cust_Count__c = 123
    //                                                  , Customer_Class_Details__c = 'TEST THIS'
    //                                                  , CustomerCountry__c = 'US'
    //                                                  , CustomerSBU__c = 'SC'
    //                                                  , Duplicate__c = false
    //                                                  , Net_Sales__c = 111
    //                                                  , PPS_Rgn__c = 'SC');
    //     insert cc;
        
    //     Customer_Type__c ct1 = new Customer_Type__c(Active__c = true
    //                                                 , Select__c = true
    //                                                 , Name = 'US'
    //                                                 , SBU__c = 'SC'
    //                                                 , Region__c = r04.Id);
    //     insert ct1;
        
    //     Customer_Type__c ct2 = new Customer_Type__c(Active__c = true
    //                                                 , Select__c = true
    //                                                 , Name = 'CANAD'
    //                                                 , SBU__c = 'SC'
    //                                                 , Region__c = r04.Id);
    //     insert ct2;     
        
    //     ChangeRequestTriggerHandler tstCls = new ChangeRequestTriggerHandler ();
    //     testRun = true;
    //     Test.startTest();
    //     ////// All Approvals
    //     // New Account with errors
        
    //     System.runAs(uMGR) {
    //         try {
    //             Change_Request__c newCR = new Change_Request__c(
    //                 SBU__c = 'SC'
    //                 , Country_N2__c = 'US'
    //                 , Bill_Country__c = 'US'
    //                 , Billing_Street__c = '12'
    //                 , Bill_Country_N__c = 'US'
    //                 , Billing_City__c = '12'
    //                 , Billing_State_N2__c = 'TX'
    //                 , Shipping_State_N2__c = '12'
    //                 , Shipping_Zip_N__c = '75248'
    //                 , Customer_Name__c = 'TEST'
    //                 , Business_Reason__c = 'TEST'
    //                 , Sales_Representative__c = sr041.Id
    //                 , Customer_Class__c = cc100.Id
    //                 , Customer_Type__c = ct1.Id
    //                 , Customer_Type_n__c = ct2.Id
    //                 , Region_n__c = r05.id
    //                 , RecordTypeId = Label.CR_New_Customer_RT
    //                 , SSC__c = ssc.Id
    //                 , Name__c = 'New Test'
    //                 , Ship_To_Phone__c = '(972) 489-4406'
    //                 , Fax__c = '(972) 489-4406'
    //                 , Region__c = r04.Id);
    //             insert newCR;
    //         } catch (Exception e) {
    //             System.debug('::::newCR::::> ' + e.getMessage());
    //             //        System.AssertEquals(tstCls.hasErrors, false);
    //             Boolean expectedExceptionThrown =  e.getMessage().contains(Label.Customer_Type_must_match) ? true : false;
    //             System.AssertEquals(expectedExceptionThrown, false);
    //         } }  
    //     Test.stopTest();
    // }
    
    // static testMethod void testNewAccountSSCErrors() {
        
    //     // SETUP TEST DATA
    //     boolean testRun = false;
    //     boolean hasErrors = false;    
    //     UserRole rMGR = [SELECT Id, Name FROM UserRole WHERE Name = 'MW SSC Manager'];    
    //     User uMGR = [SELECT ID, Name FROM User where UserRoleID =  : rMGR.Id AND IsActive = TRUE LIMIT 1];
    //     Region__c r04 = new Region__c(Select__c = true
    //                                   , SBU__c = 'SC'
    //                                   , DW_ID__c = '04'
    //                                   , Name = 'MIDWEST REGION');
    //     insert r04;
        
    //     Customer_Class__c cc100 = new Customer_Class__c(Active__c = true
    //                                                     , COS__c = 111
    //                                                     , CustClass__c = 'S9Q'
    //                                                     , Cust_Count__c = 123
    //                                                     , Customer_Class_Details__c = 'TEST THIS'
    //                                                     , CustomerCountry__c = 'US'
    //                                                     , CustomerSBU__c = 'SC'
    //                                                     , Duplicate__c = false
    //                                                     , Net_Sales__c = 111
    //                                                     , PPS_Rgn__c = 'SC MW');
    //     insert cc100;
        
    //     Sales_Representative__c sr041 = new Sales_Representative__c(SBU__c = 'sc'
    //                                                                 , DW_ID__c = '041'
    //                                                                 , Region__c = r04.Id);
    //     insert sr041;
        
    //     SSC__c ssc = new SSC__c(Closed__c = false
    //                             , DW_ID__c = '000111'    
    //                             , Loc_Type__c = 'SSC'
    //                             , Sales_Region__c = '34'
    //                             , Manager__c = UserInfo.getUserId()
    //                             , Region__c = r04.Id
    //                             , ROM__c = UserInfo.getUserId()
    //                             , RSM__c = UserInfo.getUserId()
    //                             , RVP__c = UserInfo.getUserId()     
    //                             , SBU__c = 'DI'
    //                             , Select__c = true
    //                             , SSC_Fax_Number__c = '123-345-5567'
    //                             , SSC_Phone_Number__c = '123-345-5567'
    //                             , State__c = 'TX'
    //                             , Street_Address__c = '12345 1st street'
    //                             , Zip_Code__c = '12345');
    //     insert ssc;
        
    //     Customer_Class__c cc = new Customer_Class__c(Active__c = true
    //                                                  , COS__c = 111
    //                                                  , CustClass__c = 'S4Q'
    //                                                  , Cust_Count__c = 123
    //                                                  , Customer_Class_Details__c = 'TEST THIS'
    //                                                  , CustomerCountry__c = 'US'
    //                                                  , CustomerSBU__c = 'SC'
    //                                                  , Duplicate__c = false
    //                                                  , Net_Sales__c = 111
    //                                                  , PPS_Rgn__c = 'SC');
    //     insert cc;
        
    //     Customer_Type__c ct2 = new Customer_Type__c(Active__c = true
    //                                                 , Select__c = true
    //                                                 , SBU__c = 'SC'
    //                                                 , Region__c = r04.Id);
    //     insert ct2;
        
    //     ChangeRequestTriggerHandler tstCls = new ChangeRequestTriggerHandler ();
    //     testRun = true;
    //     Test.startTest();
    //     ////// All Approvals
    //     // New Account with errors
        
    //     System.runAs(uMGR) {
    //         try {
    //             Change_Request__c newCR = new Change_Request__c(
    //                 SBU__c = 'SC'
    //                 , Country_N2__c = 'US'
    //                 , Billing_Street__c = ''
    //                 , Billing_City__c = ''
    //                 , Shipping_State_N2__c = ''
    //                 , Shipping_Zip_N__c = ''
    //                 , Customer_Class_n__c = cc100.id
    //                 , Business_Reason__c = 'TEST'
    //                 , Sales_Representative__c = sr041.Id
    //                 , Customer_Class__c = cc100.Id
    //                 , Customer_Type__c = ct2.Id
    //                 , RecordTypeId = Label.CR_New_Customer_RT
    //                 , SSC__c = ssc.Id
    //                 , Name__c = 'New Test'
    //                 , Ship_To_Phone__c = '(972) 489-4406'
    //                 , Fax__c = '(972) 489-4406'
    //                 , Region__c = r04.Id);
    //             insert newCR;
    //             newCr.Status__c = 'Submitted-Pending';
    //             hasErrors = true;
    //             update newCR;
    //             newCr.MGR_WF1__c = TRUE;
    //             newCr.RSM_WF1__c = TRUE;
    //             newCr.ROM_WF1__c = TRUE;
    //             newCr.Status__c = 'Submitted-Pending MGR Approval';
    //             update newCR;
    //             newCr.Status__c = 'Submitted-Pending MGR Approval';
    //             newCr.MGR_1_Approved__c = TRUE;
    //             update newCR;
    //             newCr.Status__c = 'Submitted-Pending RSM Approval';
    //             newCr.RSM_Approved__c = TRUE;
    //             update newCR;
    //             newCr.Status__c = 'Submitted-Pending ROM Approval';
    //             newCr.ROM_Approved__c = TRUE;
    //             update newCR;
                
    //             System.debug('::::newCR + Status__c::::> ' + newCr.Status__c);
    //             update newCR;
    //             newCr.MGR_1_Approved__c = TRUE;
    //             update newCR;
    //             System.debug('::::newCR + Status__c::::> ' + newCr.Status__c);
    //         } catch (Exception e) {
    //             System.debug('::::newCR::::> ' + e.getMessage());
    //         } }  
    //     Test.stopTest();
    // }   
    
    // static testMethod void testErrorExcspetionAtStart() {
        
    //     // SETUP TEST DATA
    //     boolean testRun = false;
    //     boolean hasErrors = false;    
    //     UserRole rMGR = [SELECT Id, Name FROM UserRole WHERE Name = 'MW SSC Manager'];    
    //     User uMGR = [SELECT ID, Name FROM User where UserRoleID =  : rMGR.Id AND IsActive = TRUE LIMIT 1];
    //     Region__c r04 = new Region__c(Select__c = true
    //                                   , SBU__c = 'SC'
    //                                   , DW_ID__c = '04'
    //                                   , Name = 'MIDWEST REGION');
    //     insert r04;
        
    //     Customer_Class__c cc100 = new Customer_Class__c(Active__c = true
    //                                                     , COS__c = 111
    //                                                     , CustClass__c = 'S9Q'
    //                                                     , Cust_Count__c = 123
    //                                                     , Customer_Class_Details__c = 'TEST THIS'
    //                                                     , CustomerCountry__c = 'US'
    //                                                     , CustomerSBU__c = 'SC'
    //                                                     , Duplicate__c = false
    //                                                     , Net_Sales__c = 111
    //                                                     , PPS_Rgn__c = 'SC MW');
    //     insert cc100;
        
    //     Sales_Representative__c sr1 = new Sales_Representative__c(SBU__c = 'sc'
    //                                                               , DW_ID__c = '041'
    //                                                               , Region__c = r04.Id);
    //     insert sr1;
        
    //     SSC__c ssc = new SSC__c(Closed__c = false
    //                             , DW_ID__c = '000111'    
    //                             , Loc_Type__c = 'SSC'
    //                             , Sales_Region__c = '34'
    //                             , Manager__c = UserInfo.getUserId()
    //                             , Region__c = r04.Id
    //                             , ROM__c = UserInfo.getUserId()
    //                             , RSM__c = UserInfo.getUserId()
    //                             , RVP__c = UserInfo.getUserId()     
    //                             , SBU__c = 'DI'
    //                             , Select__c = true
    //                             , SSC_Fax_Number__c = '123-345-5567'
    //                             , SSC_Phone_Number__c = '123-345-5567'
    //                             , State__c = 'TX'
    //                             , Street_Address__c = '12345 1st street'
    //                             , Zip_Code__c = '12345');
    //     insert ssc;
        
    //     Customer_Class__c cc1 = new Customer_Class__c(Active__c = true
    //                                                   , COS__c = 111
    //                                                   , CustClass__c = 'S4Q'
    //                                                   , Cust_Count__c = 123
    //                                                   , Customer_Class_Details__c = 'TEST THIS'
    //                                                   , CustomerCountry__c = 'US'
    //                                                   , CustomerSBU__c = 'SC'
    //                                                   , Duplicate__c = false
    //                                                   , Net_Sales__c = 111
    //                                                   , PPS_Rgn__c = 'SC MW');
    //     insert cc1;
        
    //     Customer_Type__c ct2 = new Customer_Type__c(Active__c = true
    //                                                 , Select__c = true
    //                                                 , SBU__c = 'SC'
    //                                                 , Region__c = r04.Id);
    //     insert ct2;
        
    //     Account a = new Account(Name = 'Test');
    //     insert a;
        
    //     ChangeRequestTriggerHandler tstCls = new ChangeRequestTriggerHandler ();
    //     testRun = true;
    //     Test.startTest();
    //     ////// All Approvals
    //     // New Account with errors
        
    //     try {
    //         Change_Request__c c40 = new Change_Request__c(SBU__c = 'SC'
    //                                                       , Suffix_N__c = 'NEW'
    //                                                       , Reason_for_New_Suffix__c = 'cause'
    //                                                       , Account__c = a.Id
    //                                                       , New_ShipTo_Request__c = TRUE
    //                                                       , Sales_Representative__c = sr1.Id
    //                                                       , Customer_Class__c = cc1.Id
    //                                                       , Customer_Type__c = ct2.Id
    //                                                       , RecordTypeId = Label.CR_Customer_Update_RT
    //                                                       , SSC__c = ssc.Id
    //                                                       , SSC_n__c = ssc.Id
    //                                                       , Ship_To_Phone__c = '(972) 489-4406'
    //                                                       , Fax__c = '(972) 489-4406'
    //                                                       , Status__c = 'Submitted-Pending'
    //                                                       , Region__c = r04.Id);
    //         insert c40;
    //         System.debug('::::c40 Status 1::::> ' + c40.Status__c);
    //         c40.RVPWF1__c = TRUE;
    //         update c40;
    //         c40.Status__c = 'Submitted-Pending RVP Approval';
    //         update c40;
    //         System.debug('::::c40 Status 2::::> ' + c40.Status__c);
    //     } catch (Exception e) {
    //         System.debug('::::c40::::> ' + e.getMessage());
    //     }
        
    //     Test.stopTest();
    // }     
    
    // static testMethod void noSSCListed() {
        
    //     // SETUP TEST DATA
    //     boolean testRun = false;
    //     boolean hasErrors = false;    
    //     UserRole rMGR = [SELECT Id, Name FROM UserRole WHERE Name = 'MW SSC Manager'];    
    //     User uMGR = [SELECT ID, Name FROM User where UserRoleID =  : rMGR.Id AND IsActive = TRUE LIMIT 1];
    //     Region__c r04 = new Region__c(Select__c = true
    //                                   , SBU__c = 'SC'
    //                                   , DW_ID__c = '04'
    //                                   , Name = 'MIDWEST REGION');
    //     insert r04;
        
    //     Customer_Class__c cc100 = new Customer_Class__c(Active__c = true
    //                                                     , COS__c = 111
    //                                                     , CustClass__c = 'S9Q'
    //                                                     , Cust_Count__c = 123
    //                                                     , Customer_Class_Details__c = 'TEST THIS'
    //                                                     , CustomerCountry__c = 'US'
    //                                                     , CustomerSBU__c = 'SC'
    //                                                     , Duplicate__c = false
    //                                                     , Net_Sales__c = 111
    //                                                     , PPS_Rgn__c = 'SC MW');
    //     insert cc100;
        
    //     Sales_Representative__c sr1 = new Sales_Representative__c(SBU__c = 'sc'
    //                                                               , DW_ID__c = '041'
    //                                                               , Region__c = r04.Id);
    //     insert sr1;
        
    //     SSC__c ssc = new SSC__c(Closed__c = false
    //                             , DW_ID__c = '000111'    
    //                             , Loc_Type__c = 'SSC'
    //                             , Sales_Region__c = '34'
    //                             , Manager__c = UserInfo.getUserId()
    //                             , Region__c = r04.Id
    //                             , ROM__c = UserInfo.getUserId()
    //                             , RSM__c = UserInfo.getUserId()
    //                             , RVP__c = UserInfo.getUserId()     
    //                             , SBU__c = 'DI'
    //                             , Select__c = true
    //                             , SSC_Fax_Number__c = '123-345-5567'
    //                             , SSC_Phone_Number__c = '123-345-5567'
    //                             , State__c = 'TX'
    //                             , Street_Address__c = '12345 1st street'
    //                             , Zip_Code__c = '12345');
    //     insert ssc;
        
    //     Customer_Class__c cc1 = new Customer_Class__c(Active__c = true
    //                                                   , COS__c = 111
    //                                                   , CustClass__c = 'S4Q'
    //                                                   , Cust_Count__c = 123
    //                                                   , Customer_Class_Details__c = 'TEST THIS'
    //                                                   , CustomerCountry__c = 'US'
    //                                                   , CustomerSBU__c = 'SC'
    //                                                   , Duplicate__c = false
    //                                                   , Net_Sales__c = 111
    //                                                   , PPS_Rgn__c = 'SC MW');
    //     insert cc1;
        
    //     Customer_Type__c ct2 = new Customer_Type__c(Active__c = true
    //                                                 , Select__c = true
    //                                                 , SBU__c = 'SC'
    //                                                 , Region__c = r04.Id);
    //     insert ct2;
        
    //     Account a = new Account(Name = 'Test');
    //     insert a;
        
    //     ChangeRequestTriggerHandler tstCls = new ChangeRequestTriggerHandler ();
    //     testRun = true;
    //     Test.startTest();
    //     ////// All Approvals
    //     // New Account with errors
        
    //     try {
    //         Change_Request__c c40 = new Change_Request__c(SBU__c = 'SC'
    //                                                       , Suffix_N__c = 'NEW'
    //                                                       , Reason_for_New_Suffix__c = 'cause'
    //                                                       , Account__c = a.Id
    //                                                       , New_ShipTo_Request__c = TRUE
    //                                                       , Sales_Representative__c = sr1.Id
    //                                                       , Customer_Class__c = cc1.Id
    //                                                       , Customer_Type__c = ct2.Id
    //                                                       , RecordTypeId = Label.CR_Customer_Update_RT
    //                                                       , SSC__c = ssc.Id
    //                                                       , SSC_n__c = ssc.id
    //                                                       , Ship_To_Phone__c = '(972) 489-4406'
    //                                                       , Fax__c = '(972) 489-4406'
    //                                                       , Status__c = 'Submitted-Pending'
    //                                                       , Region__c = r04.Id);
    //         insert c40;
    //         System.debug('::::c40 Status 1::::> ' + c40.Status__c);
    //         c40.RVPWF1__c = TRUE;
    //         update c40;
    //         c40.Status__c = 'Submitted-Pending RVP Approval';
    //         update c40;
    //         System.debug('::::c40 Status 2::::> ' + c40.Status__c);
    //     } catch (Exception e) {
    //         System.debug('::::c40::::> ' + e.getMessage());
    //     }
        
    //     Test.stopTest();
    // }     
    
    // static testMethod void testNewAccountApproverIssues() {
        
    //     // SETUP TEST DATA
    //     boolean testRun = false;
    //     boolean hasErrors = false;    
    //     UserRole rMGR = [SELECT Id, Name FROM UserRole WHERE Name = 'MW SSC Manager'];    
    //     User uMGR = [SELECT ID, Name FROM User where UserRoleID =  : rMGR.Id AND IsActive = TRUE LIMIT 1];
    //     Region__c r04 = new Region__c(Select__c = true
    //                                   , SBU__c = 'SC'
    //                                   , DW_ID__c = '04'
    //                                   , Name = 'MIDWEST REGION');
    //     insert r04;
        
    //     Customer_Class__c cc100 = new Customer_Class__c(Active__c = true
    //                                                     , COS__c = 111
    //                                                     , CustClass__c = 'S9Q'
    //                                                     , Cust_Count__c = 123
    //                                                     , Customer_Class_Details__c = 'TEST THIS'
    //                                                     , CustomerCountry__c = 'US'
    //                                                     , CustomerSBU__c = 'SC'
    //                                                     , Duplicate__c = false
    //                                                     , Net_Sales__c = 111
    //                                                     , PPS_Rgn__c = 'SC MW');
    //     insert cc100;
        
    //     Sales_Representative__c sr041 = new Sales_Representative__c(SBU__c = 'sc'
    //                                                                 , DW_ID__c = '041'
    //                                                                 , Region__c = r04.Id);
    //     insert sr041;
        
    //     SSC__c ssc = new SSC__c(Closed__c = false
    //                             , DW_ID__c = '000111'    
    //                             , Loc_Type__c = 'SSC'
    //                             , Sales_Region__c = '34'
    //                             , Manager__c = UserInfo.getUserId()
    //                             , Region__c = r04.Id
    //                             , ROM__c = NULL
    //                             , RSM__c = NULL
    //                             , RVP__c = NULL
    //                             , SBU__c = 'DI'
    //                             , Select__c = true
    //                             , SSC_Fax_Number__c = '123-345-5567'
    //                             , SSC_Phone_Number__c = '123-345-5567'
    //                             , State__c = 'TX'
    //                             , Street_Address__c = '12345 1st street'
    //                             , Zip_Code__c = '12345');
    //     insert ssc;
        
    //     Customer_Class__c cc = new Customer_Class__c(Active__c = true
    //                                                  , COS__c = 111
    //                                                  , CustClass__c = 'S4Q'
    //                                                  , Cust_Count__c = 123
    //                                                  , Customer_Class_Details__c = 'TEST THIS'
    //                                                  , CustomerCountry__c = 'US'
    //                                                  , CustomerSBU__c = 'SC'
    //                                                  , Duplicate__c = false
    //                                                  , Net_Sales__c = 111
    //                                                  , PPS_Rgn__c = 'SC');
    //     insert cc;
        
    //     Customer_Type__c ct2 = new Customer_Type__c(Active__c = true
    //                                                 , Select__c = true
    //                                                 , SBU__c = 'SC'
    //                                                 , Region__c = r04.Id);
    //     insert ct2;
        
    //     ChangeRequestTriggerHandler tstCls = new ChangeRequestTriggerHandler ();
    //     testRun = true;
    //     Test.startTest();
    //     ////// All Approvals
    //     // New Account with errors
        
    //     System.runAs(uMGR) {
    //         try {
    //             Change_Request__c newCR = new Change_Request__c(
    //                 SBU__c = 'SC'
    //                 , Country_N2__c = 'US'
    //                 , Billing_Street__c = ''
    //                 , Billing_City__c = ''
    //                 , Shipping_State_N2__c = ''
    //                 , Shipping_Zip_N__c = ''
    //                 , Customer_Class_n__c = cc100.id
    //                 , Business_Reason__c = 'TEST'
    //                 , Sales_Representative__c = sr041.Id
    //                 , Customer_Class__c = cc100.Id
    //                 , Customer_Type__c = ct2.Id
    //                 , RecordTypeId = Label.CR_New_Customer_RT
    //                 , SSC__c = ssc.Id
    //                 , Name__c = 'New Test'
    //                 , Ship_To_Phone__c = '(972) 489-4406'
    //                 , Fax__c = '(972) 489-4406'
    //                 , Region__c = r04.Id);
    //             insert newCR;
    //             newCr.Status__c = 'Submitted-Pending';
    //             update newCR;
    //             newCr.MGR_WF1__c = TRUE;
    //             newCr.RSM_WF1__c = TRUE;
    //             newCr.ROM_WF1__c = TRUE;
    //             newCr.Status__c = 'Submitted-Pending MGR Approval';
    //             update newCR;
    //             newCr.Status__c = 'Submitted-Pending MGR Approval';
    //             newCr.MGR_1_Approved__c = TRUE;
    //             update newCR;
    //             newCr.Status__c = 'Submitted-Pending RSM Approval';
    //             newCr.RSM_Approved__c = TRUE;
    //             update newCR;
    //             newCr.Status__c = 'Submitted-Pending ROM Approval';
    //             newCr.ROM_Approved__c = TRUE;
    //             update newCR;
                
    //             System.debug('::::newCR + Status__c::::> ' + newCr.Status__c);
    //             update newCR;
    //             newCr.MGR_1_Approved__c = TRUE;
    //             update newCR;
    //             System.debug('::::newCR + Status__c::::> ' + newCr.Status__c);
    //         } catch (Exception e) {
    //             System.debug('::::newCR::::> ' + e.getMessage());
    //         } }  
    //     Test.stopTest();
    // } 
    // static testMethod void salesRepChangeOnly() {
        
    //     // SETUP TEST DATA
    //     boolean testRun = false;
    //     boolean hasErrors = false;    
    //     UserRole rMGR = [SELECT Id, Name FROM UserRole WHERE Name = 'MW SSC Manager'];    
    //     User uMGR = [SELECT ID, Name FROM User where UserRoleID =  : rMGR.Id AND IsActive = TRUE LIMIT 1];
    //     Profile pAdmin = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
    //     String snort = [Select Id, Name, Alias from User where ProfileId = :pAdmin.Id AND LastName != 'Rust' limit 1].ID;
        
    //     Region__c r04 = new Region__c(Select__c = true, SBU__c = 'SC', DW_ID__c = '04', Name = 'MIDWEST REGION');
    //     insert r04;
        
    //     Customer_Class__c cc100 = new Customer_Class__c(Active__c = true
    //                                                     , COS__c = 111
    //                                                     , CustClass__c = 'S9Q'
    //                                                     , Cust_Count__c = 123
    //                                                     , Customer_Class_Details__c = 'TEST THIS'
    //                                                     , CustomerCountry__c = 'US'
    //                                                     , CustomerSBU__c = 'SC'
    //                                                     , Duplicate__c = false
    //                                                     , Net_Sales__c = 111
    //                                                     , PPS_Rgn__c = 'SC MW');
    //     insert cc100;
        
    //     Sales_Representative__c sr1 = new Sales_Representative__c(SBU__c = 'sc'
    //                                                               , DW_ID__c = '041'
    //                                                               , Region__c = r04.Id);
    //     insert sr1;
        
    //     SSC__c ssc = new SSC__c(Closed__c = false
    //                             , DW_ID__c = '000111'    
    //                             , Loc_Type__c = 'SSC'
    //                             , Sales_Region__c = '34'
    //                             , Manager__c = UserInfo.getUserId()
    //                             , Region__c = r04.Id
    //                             , ROM__c = UserInfo.getUserId()
    //                             , RSM__c = uMgr.Id
    //                             , RVP__c = sNort     
    //                             , SBU__c = 'DI'
    //                             , Select__c = true
    //                             , SSC_Fax_Number__c = '123-345-5567'
    //                             , SSC_Phone_Number__c = '123-345-5567'
    //                             , State__c = 'TX'
    //                             , Street_Address__c = '12345 1st street'
    //                             , Zip_Code__c = '12345');
    //     insert ssc;
        
    //     Customer_Class__c cc1 = new Customer_Class__c(Active__c = true
    //                                                   , COS__c = 111
    //                                                   , CustClass__c = 'S4Q'
    //                                                   , Cust_Count__c = 123
    //                                                   , Customer_Class_Details__c = 'TEST THIS'
    //                                                   , CustomerCountry__c = 'US'
    //                                                   , CustomerSBU__c = 'SC'
    //                                                   , Duplicate__c = false
    //                                                   , Net_Sales__c = 111
    //                                                   , PPS_Rgn__c = 'SC MW');
    //     insert cc1;
        
    //     Customer_Type__c ct2 = new Customer_Type__c(Active__c = true
    //                                                 , Select__c = true
    //                                                 , SBU__c = 'SC'
    //                                                 , Region__c = r04.Id);
    //     insert ct2;
        
    //     Account a = new Account(Name = 'Test');
    //     insert a;
        
    //     ChangeRequestTriggerHandler tstCls = new ChangeRequestTriggerHandler ();
    //     testRun = true;
    //     Test.startTest();
    //     ////// All Approvals
    //     // New Account with errors
        
    //     try {
    //         Change_Request__c c40 = new Change_Request__c(SBU__c = 'SC'
    //                                                       , Account__c = a.Id
    //                                                       , Sales_Representative_n__c = sr1.Id
    //                                                       , Sales_Representative__c = sr1.Id
    //                                                       , Customer_Class__c = cc1.Id
    //                                                       , Customer_Type__c = ct2.Id
    //                                                       , RecordTypeId = Label.CR_Customer_Update_RT
    //                                                       , SSC__c = ssc.Id
    //                                                       , Status__c = 'Submitted-Pending'
    //                                                       , Region__c = r04.Id);
    //         insert c40;
    //         c40.Territory_Assignment_Change_Only__c = TRUE;
    //         System.debug('::::salesRepChangeOnly: c40 Status 1::::> ' + c40.Status__c);
    //         c40.MGR_WF1__c = TRUE;
    //         c40.RVPWF1__c = TRUE;
    //         c40.RSM_WF1__c = TRUE;
    //         update c40;
    //         c40.MGR_1_Approved__c = TRUE;
    //         update c40;       
    //         c40.Status__c = 'Submitted-Pending RSM Approval';
    //         update c40;
    //         c40.RSM_Approved__c = TRUE;
    //         System.debug('::::salesRepChangeOnly: c40 RVP_Approved__c?::::> ' + c40.RVP_Approved__c);        
    //         update c40;       
    //         c40.Status__c = 'Submitted-Pending RVP Approval';
    //         update c40;
    //         c40.RVP_Approved__c = TRUE;
    //         update c40;           
    //         c40.Status__c = 'Source System Updated';		     
    //         update c40;        
    //         System.debug('::::c40 Status 2::::> ' + c40.Status__c);
    //     } catch (Exception e) {
    //         System.debug('::::c40::::> ' + e.getMessage());
    //     }
        
    //     Test.stopTest();
    // }     
    
    
    // static testMethod void testNewAccountNoApprovers() {
        
    //     // SETUP TEST DATA
    //     boolean testRun = false;
    //     boolean hasErrors = false;    
    //     UserRole rMGR = [SELECT Id, Name FROM UserRole WHERE Name = 'MW SSC Manager'];    
    //     User uMGR = [SELECT ID, Name FROM User where UserRoleID =  : rMGR.Id AND IsActive = TRUE LIMIT 1];
    //     Region__c r04 = new Region__c(Select__c = true
    //                                   , SBU__c = 'SC'
    //                                   , DW_ID__c = '04'
    //                                   , Name = 'MIDWEST REGION');
    //     insert r04;
        
    //     Customer_Class__c cc100 = new Customer_Class__c(Active__c = true
    //                                                     , COS__c = 111
    //                                                     , CustClass__c = 'S9Q'
    //                                                     , Cust_Count__c = 123
    //                                                     , Customer_Class_Details__c = 'TEST THIS'
    //                                                     , CustomerCountry__c = 'US'
    //                                                     , CustomerSBU__c = 'SC'
    //                                                     , Duplicate__c = false
    //                                                     , Net_Sales__c = 111
    //                                                     , PPS_Rgn__c = 'SC MW');
    //     insert cc100;
        
    //     Sales_Representative__c sr1 = new Sales_Representative__c(SBU__c = 'sc'
    //                                                               , DW_ID__c = '041'
    //                                                               , Region__c = r04.Id);
    //     insert sr1;
        
    //     SSC__c ssc = new SSC__c(Closed__c = false
    //                             , DW_ID__c = '000111'    
    //                             , Loc_Type__c = 'SSC'
    //                             , Sales_Region__c = '34'
    //                             , Manager__c = UserInfo.getUserId()
    //                             , Region__c = r04.Id
    //                             , ROM__c = UserInfo.getUserId()
    //                             , RSM__c = UserInfo.getUserId()
    //                             , RVP__c = UserInfo.getUserId()     
    //                             , SBU__c = 'DI'
    //                             , Select__c = true
    //                             , SSC_Fax_Number__c = '123-345-5567'
    //                             , SSC_Phone_Number__c = '123-345-5567'
    //                             , State__c = 'TX'
    //                             , Street_Address__c = '12345 1st street'
    //                             , Zip_Code__c = '12345');
    //     insert ssc;
        
    //     Customer_Class__c cc1 = new Customer_Class__c(Active__c = true
    //                                                   , COS__c = 111
    //                                                   , CustClass__c = 'S4Q'
    //                                                   , Cust_Count__c = 123
    //                                                   , Customer_Class_Details__c = 'TEST THIS'
    //                                                   , CustomerCountry__c = 'US'
    //                                                   , CustomerSBU__c = 'SC'
    //                                                   , Duplicate__c = false
    //                                                   , Net_Sales__c = 111
    //                                                   , PPS_Rgn__c = 'SC MW');
    //     insert cc1;
        
    //     Customer_Type__c ct2 = new Customer_Type__c(Active__c = true
    //                                                 , Select__c = true
    //                                                 , SBU__c = 'SC'
    //                                                 , Region__c = r04.Id);
    //     insert ct2;
        
    //     Account a = new Account(Name = 'Test');
    //     insert a;
        
    //     ChangeRequestTriggerHandler tstCls = new ChangeRequestTriggerHandler ();
    //     testRun = true;
    //     Test.startTest();   
    //     try {
    //         Change_Request__c newCR = new Change_Request__c(
    //             SBU__c = 'SC'
    //             , Customer_Class_n__c = cc100.id
    //             , Business_Reason__c = 'TEST'
    //             , Sales_Representative__c = sr1.Id
    //             , Customer_Class__c = cc1.Id
    //             , Customer_Type__c = ct2.Id
    //             , RecordTypeId = Label.CR_New_Customer_RT
    //             , Name__c = 'New Test'
    //             , Ship_To_Phone__c = '(972) 489-4406'
    //             , Region__c = r04.Id);
    //         insert newCR;
            
    //     } catch (Exception e) {
    //         System.debug('::::c40::::> ' + e.getMessage());
    //     }
        
    //     Test.stopTest();
    // }    
    
    // static testMethod void testAccountUpdateCopyBillTo() {
        
    //     // SETUP TEST DATA
    //     boolean testRun = false;
    //     boolean hasErrors = false;    
    //     UserRole rMGR = [SELECT Id, Name FROM UserRole WHERE Name = 'MW SSC Manager'];    
    //     User uMGR = [SELECT ID, Name FROM User where UserRoleID =  : rMGR.Id AND IsActive = TRUE LIMIT 1];
    //     Region__c r04 = new Region__c(Select__c = true
    //                                   , SBU__c = 'SC'
    //                                   , DW_ID__c = '04'
    //                                   , Name = 'MIDWEST REGION');
    //     insert r04;
        
    //     Customer_Class__c cc100 = new Customer_Class__c(Active__c = true
    //                                                     , COS__c = 111
    //                                                     , CustClass__c = 'S9Q'
    //                                                     , Cust_Count__c = 123
    //                                                     , Customer_Class_Details__c = 'TEST THIS'
    //                                                     , CustomerCountry__c = 'US'
    //                                                     , CustomerSBU__c = 'SC'
    //                                                     , Duplicate__c = false
    //                                                     , Net_Sales__c = 111
    //                                                     , PPS_Rgn__c = 'SC MW');
    //     insert cc100;
        
    //     Sales_Representative__c sr1 = new Sales_Representative__c(SBU__c = 'sc'
    //                                                               , DW_ID__c = '041'
    //                                                               , Region__c = r04.Id);
    //     insert sr1;
        
    //     SSC__c ssc = new SSC__c(Closed__c = false
    //                             , DW_ID__c = '000111'    
    //                             , Loc_Type__c = 'SSC'
    //                             , Sales_Region__c = '34'
    //                             , Manager__c = UserInfo.getUserId()
    //                             , Region__c = r04.Id
    //                             , ROM__c = UserInfo.getUserId()
    //                             , RSM__c = UserInfo.getUserId()
    //                             , RVP__c = UserInfo.getUserId()     
    //                             , SBU__c = 'DI'
    //                             , Select__c = true
    //                             , SSC_Fax_Number__c = '123-345-5567'
    //                             , SSC_Phone_Number__c = '123-345-5567'
    //                             , State__c = 'TX'
    //                             , Street_Address__c = '12345 1st street'
    //                             , Zip_Code__c = '12345');
    //     insert ssc;
        
    //     Customer_Class__c cc1 = new Customer_Class__c(Active__c = true
    //                                                   , COS__c = 111
    //                                                   , CustClass__c = 'S4Q'
    //                                                   , Cust_Count__c = 123
    //                                                   , Customer_Class_Details__c = 'TEST THIS'
    //                                                   , CustomerCountry__c = 'US'
    //                                                   , CustomerSBU__c = 'SC'
    //                                                   , Duplicate__c = false
    //                                                   , Net_Sales__c = 111
    //                                                   , PPS_Rgn__c = 'SC MW');
    //     insert cc1;
        
    //     Customer_Type__c ct2 = new Customer_Type__c(Active__c = true
    //                                                 , Select__c = true
    //                                                 , SBU__c = 'SC'
    //                                                 , Region__c = r04.Id);
    //     insert ct2;
        
    //     Account a = new Account(
    //         Name = 'Test'
    //         ,DBA_Name__c = 'Test'
    //         ,AccountNumber = '123'
    //         ,Customer_Base__c = '321'
    //         ,Customer_Class__c = cc1.id
    //         ,phone = 'Test'
    //         ,Customer_Type__c = ct2.id
    //         ,DW_ID__c = '2145755'
    //         ,Fax = '972-489-4406'
    //         ,Require_PO__c = FALSE
    //         ,Region__c = r04.id      
    //         ,Salesman__c = sr1.id
    //         ,SSC__c = ssc.id
    //         ,Customer_Suffix__c = '321'
    //         ,BillingStreet = 'Test'
    //         ,BillingCity = 'Test'
    //         ,BillingState = 'tx'
    //         ,BillingPostalCode  = '75218'
    //         ,BillingCountry = 'us'
    //         ,SBU__C = 'SC'
    //     );
    //     insert a;
        
    //     //    ChangeRequest tstCls = new ChangeRequest ();
    //     testRun = true;
    //     Test.startTest();   
    //     try {
    //         string newCus = ChangeRequest.newCustomerRequest(a.Id);
    //         string newChangeCheck = ChangeRequest.checkExistingCR(a.Id,'update');
    //         string newChange = ChangeRequest.newChangeRequest(a.Id,'update');
    //         Change_Request__c newCR = new Change_Request__c(
    //             SBU__c = 'SC'
    //             , Account__c = a.Id
    //             , SSC__c = ssc.Id
    //             , Customer_Class_n__c = cc100.id
    //             , Business_Reason__c = 'TEST'
    //             , Sales_Representative__c = sr1.Id
    //             , Customer_Class__c = cc1.Id
    //             , Customer_Type__c = ct2.Id
    //             , RecordTypeId = Label.CR_New_Customer_RT
    //             , Name__c = 'New Test'
    //             , Ship_To_Phone__c = '(972) 489-4406'
    //             , Region__c = r04.Id
    //             , Country_N2__c = 'US'
    //             , Billing_Street__c = 'TEST'
    //             , Shipping_Address_2__c = 'TEST'
    //             , Billing_City__c = 'TEST'
    //             , Shipping_State_N2__c = 'TX'
    //             , Shipping_Zip_N__c = '75218'
    //             , Copy_Bill_To_Address__c = true);
    //         insert newCR;
    //         newCR.Status__c = 'Submitted-Pending MGR Approval';
    //         update newCR;
    //     } catch (Exception e) {
    //         System.debug('::::c40::::> ' + e.getMessage());
    //     }
        
    //     Test.stopTest();
    // }    
    
    // static testMethod void TestCustChangeShippingthing () {
    //     ChangeRequestTriggerHandler tstCls = new ChangeRequestTriggerHandler ();
    //     // SETUP TEST DATA
        
    //     // USERS / PROFILES
    //     boolean testRun = false;
    //     boolean hasErrors = false;    
    //     testRun = true;
        
    //     String jrust = [Select Id, Name, Alias from User where Alias = 'jrust' limit 1].ID;
    //     Profile pAdmin = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
    //     String snort = [Select Id, Name, Alias from User where ProfileId = :pAdmin.Id AND LastName != 'Rust' limit 1].ID;
        
    //     Profile p = [SELECT Id FROM Profile WHERE Name = 'Executive'];
    //     Profile px2 = [SELECT Id FROM Profile WHERE Name = 'Support'];
    //     UserRole r = [SELECT Id, Name FROM UserRole WHERE Name = 'Northwest Sales Rep 1'];
    //     UserRole rMGR = [SELECT Id, Name FROM UserRole WHERE Name = 'MW SSC Manager'];    
    //     User uMGR = [SELECT ID, Name FROM User where UserRoleID =  : rMGR.Id AND IsActive = TRUE LIMIT 1];
    //     User u1 = [SELECT ID, Name FROM User where ProfileID =  : p.Id AND IsActive = TRUE LIMIT 1];    
    //     User ux2 = [SELECT ID, Name FROM User where ProfileID =  : px2.Id AND IsActive = TRUE LIMIT 1];
    //     User uSR1 = [SELECT ID, Name FROM User where UserRoleId =  : r.Id AND IsActive = TRUE LIMIT 1];               
    //     System.debug('::::User Selected::::> ' + u1.NAme);
    //     System.debug('::::User Selected::::> ' + ux2.NAme);
        
    //     // REGIONS
        
    //     Region__c r1 = new Region__c(Select__c = true
    //                                  , SBU__c = 'SC'
    //                                  , DW_ID__c = '01'
    //                                  , Name = 'SOUTHERN CA REGION');
    //     insert r1;
        
    //     Region__c r04 = new Region__c(Select__c = true
    //                                   , SBU__c = 'SC'
    //                                   , DW_ID__c = '04'
    //                                   , Name = 'MIDWEST REGION');
    //     insert r04;
        
    //     Region__c r2 = new Region__c(Select__c = true
    //                                  , SBU__c = 'DI'
    //                                  , DW_ID__c = '000111222'
    //                                  , Name = 'AO Region');
        
    //     insert r2;
    //     Region__c r3 = new Region__c(Select__c = true
    //                                  , SBU__c = 'SC'
    //                                  , DW_ID__c = '34'
    //                                  , Name = 'CANADIAN REGION');
        
    //     insert r3;
        
    //     Region__c r100 = new Region__c(Select__c = true
    //                                   , SBU__c = 'SC'
    //                                   , DW_ID__c = '99'
    //                                   , Name = 'SOUTHERN CA REGION');
    //     insert r100;
        
    //     Region__c rx1 = new Region__c(Select__c = true
    //                                   , SBU__c = 'SC'
    //                                   , DW_ID__c = '000111'
    //                                   , Name = 'SOUTHERN CA REGION');
    //     insert rx1;
        
    //     // CUSTOMER CLASS
        
    //     Customer_Class__c cc = new Customer_Class__c(Active__c = true
    //                                                  , COS__c = 111
    //                                                  , CustClass__c = 'S4Q'
    //                                                  , Cust_Count__c = 123
    //                                                  , Customer_Class_Details__c = 'TEST THIS'
    //                                                  , CustomerCountry__c = 'US'
    //                                                  , CustomerSBU__c = 'DI'
    //                                                  , Duplicate__c = false
    //                                                  , Net_Sales__c = 111
    //                                                  , PPS_Rgn__c = 'SC');
    //     insert cc;
        
    //     Customer_Class__c cc1 = new Customer_Class__c(Active__c = true
    //                                                   , COS__c = 111
    //                                                   , CustClass__c = 'S8Q'
    //                                                   , Cust_Count__c = 123
    //                                                   , Customer_Class_Details__c = 'TEST THIS'
    //                                                   , CustomerCountry__c = 'US'
    //                                                   , CustomerSBU__c = 'SC'
    //                                                   , Duplicate__c = false
    //                                                   , Net_Sales__c = 111
    //                                                   , PPS_Rgn__c = 'SC MW');
    //     insert cc1;
        
    //     Customer_Class__c ccDEL = new Customer_Class__c(Active__c = true
    //                                                     , COS__c = 111
    //                                                     , CustClass__c = 'DEL'
    //                                                     , Cust_Count__c = 123
    //                                                     , Customer_Class_Details__c = 'DEL THIS'
    //                                                     , CustomerCountry__c = 'US'
    //                                                     , CustomerSBU__c = 'SC'
    //                                                     , Duplicate__c = false
    //                                                     , Net_Sales__c = 111
    //                                                     , PPS_Rgn__c = 'SC');
    //     insert ccDEL;
        
    //     Customer_Class__c cc100 = new Customer_Class__c(Active__c = true
    //                                                     , COS__c = 111
    //                                                     , CustClass__c = 'S9Q'
    //                                                     , Cust_Count__c = 123
    //                                                     , Customer_Class_Details__c = 'TEST THIS'
    //                                                     , CustomerCountry__c = 'US'
    //                                                     , CustomerSBU__c = 'SC'
    //                                                     , Duplicate__c = false
    //                                                     , Net_Sales__c = 111
    //                                                     , PPS_Rgn__c = 'SC MW');
    //     insert cc100;
        
    //     // SSC
        
    //     SSC__c ssc = new SSC__c(Closed__c = false
    //                             , DW_ID__c = '000111'    
    //                             , Loc_Type__c = 'SSC'
    //                             , Manager__c = UserInfo.getUserId()
    //                             , Region__c = r1.Id
    //                             , ROM__c = UserInfo.getUserId()
    //                             , RSM__c = UserInfo.getUserId()
    //                             , RVP__c = UserInfo.getUserId()     
    //                             , Sales_Region__c = '04'
    //                             , SBU__c = 'DI'
    //                             , Select__c = true
    //                             , SSC_Fax_Number__c = '123-345-5567'
    //                             , SSC_Phone_Number__c = '123-345-5567'
    //                             , State__c = 'TX'
    //                             , Street_Address__c = '12345 1st street'
    //                             , Zip_Code__c = '12345');
    //     insert ssc;
        
    //     SSC__c ssc1 = new SSC__c(Closed__c = false
    //                              , DW_ID__c = '000112'
    //                              , Loc_Type__c = 'SSC'
    //                              , Manager__c = Null
    //                              , Region__c = r2.Id
    //                              , ROM__c = Null
    //                              , RSM__c = Null
    //                              , RVP__c = Null
    //                              , Sales_Region__c = '04'
    //                              , SBU__c = 'DI'
    //                              , Select__c = true
    //                              , SSC_Fax_Number__c = '123-345-5567'
    //                              , SSC_Phone_Number__c = '123-345-5567'
    //                              , State__c = 'TX'
    //                              , Street_Address__c = '12345 1st street'
    //                              , Zip_Code__c = '12345');
    //     insert ssc1;
        
    //     SSC__c ssc2 = new SSC__c(Closed__c = false
    //                              , DW_ID__c = '000119'
    //                              , Loc_Type__c = 'SSC'
    //                              , Manager__c = UserInfo.getUserId()
    //                              , Region__c = r2.Id
    //                              , ROM__c = UserInfo.getUserId()
    //                              , RSM__c = UserInfo.getUserId()
    //                              , RVP__c = UserInfo.getUserId()
    //                              , Sales_Region__c = '04'
    //                              , SBU__c = 'DI'
    //                              , Select__c = true
    //                              , SSC_Fax_Number__c = '123-345-5567'
    //                              , SSC_Phone_Number__c = '123-345-5567'
    //                              , State__c = 'TX'
    //                              , Street_Address__c = '12345 1st street'
    //                              , Zip_Code__c = '12345');
    //     insert ssc2;
        
    //     SSC__c ssc500 = new SSC__c(Closed__c = false
    //                               , DW_ID__c = '500111'
    //                               , Loc_Type__c = 'SSC'
    //                               , Manager__c = jrust
    //                               , Region__c = r100.id
    //                               , ROM__c = jrust
    //                               , RSM__c = jrust
    //                               , RVP__c = jrust
    //                               , Sales_Region__c = '04'
    //                               , SBU__c = 'SC'
    //                               , Select__c = true
    //                               , SSC_Fax_Number__c = '123-345-5567'
    //                               , SSC_Phone_Number__c = '123-345-5567'
    //                               , State__c = 'TX'
    //                               , Street_Address__c = '12345 1st street'
    //                               , Zip_Code__c = '12345');
    //     insert ssc500;
        
    //     SSC__c ssc505 = new SSC__c(Closed__c = false
    //                               , DW_ID__c = '908111'
    //                               , Loc_Type__c = 'SSC'
    //                               , Region__c = r100.id
    //                               , Manager__c = NULL
    //                               , Sales_Region__c = '04'
    //                               , SBU__c = 'SC'
    //                               , Select__c = true
    //                               , SSC_Fax_Number__c = '123-345-5567'
    //                               , SSC_Phone_Number__c = '123-345-5567'
    //                               , State__c = 'TX'
    //                               , Street_Address__c = '12345 1st street'
    //                               , Zip_Code__c = '12345');
    //     insert ssc505;
        
    //     SSC__c ssc501 = new SSC__c(Closed__c = false
    //                               , DW_ID__c = '902111'
    //                               , Loc_Type__c = 'SSC'
    //                               , Manager__c = UserInfo.getUserId()
    //                               , Region__c = r100.id
    //                               , ROM__c = UserInfo.getUserId()
    //                               , RSM__c = UserInfo.getUserId()
    //                               , RVP__c = UserInfo.getUserId()
    //                               , Sales_Region__c = '04'
    //                               , SBU__c = 'SC'
    //                               , Select__c = true
    //                               , SSC_Fax_Number__c = '123-345-5567'
    //                               , SSC_Phone_Number__c = '123-345-5567'
    //                               , State__c = 'TX'
    //                               , Street_Address__c = '12345 1st street'
    //                               , Zip_Code__c = '12345');
    //     insert ssc501;
        
    //     SSC__c ssc503 = new SSC__c(Closed__c = false
    //                               , DW_ID__c = '903111'
    //                               , Loc_Type__c = 'SSC'
    //                               , Manager__c = snort
    //                               , Region__c = r04.Id
    //                               , ROM__c = snort
    //                               , RSM__c = snort
    //                               , RVP__c = snort
    //                               , Sales_Region__c = '04'
    //                               , SBU__c = 'SC'
    //                               , Select__c = true
    //                               , SSC_Fax_Number__c = '123-345-5567'
    //                               , SSC_Phone_Number__c = '123-345-5567'
    //                               , State__c = 'TX'
    //                               , Street_Address__c = '12345 1st street'
    //                               , Zip_Code__c = '12345');
    //     insert ssc503;
        
        
        
    //     SSC__c ssc600 = new SSC__c(Closed__c = false
    //                               , DW_ID__c = '600'
    //                               , Loc_Type__c = 'SSC'
    //                               , Manager__c = uMGR.Id
    //                               , Region__c = r04.id
    //                               , ROM__c = uMGR.Id
    //                               , RSM__c = uMGR.Id
    //                               , RVP__c = uMGR.Id
    //                               , Sales_Region__c = '04'
    //                               , SBU__c = 'SC'
    //                               , Select__c = true
    //                               , SSC_Fax_Number__c = '123-345-5567'
    //                               , SSC_Phone_Number__c = '123-345-5567'
    //                               , State__c = 'TX'
    //                               , Street_Address__c = '12345 1st street'
    //                               , Zip_Code__c = '12345');
    //     insert ssc600;
        
        
    //     SSC__c sscCA = new SSC__c(Closed__c = false
    //                               , DW_ID__c = '3434'
    //                               , Loc_Type__c = 'SSC'
    //                               , Manager__c = snort
    //                               , Region__c = r100.id
    //                               , ROM__c = snort
    //                               , RSM__c = snort
    //                               , RVP__c = snort
    //                               , Sales_Region__c = '34'
    //                               , SBU__c = 'SC'
    //                               , Select__c = true
    //                               , SSC_Fax_Number__c = '123-345-5567'
    //                               , SSC_Phone_Number__c = '123-345-5567'
    //                               , State__c = 'TX'
    //                               , Street_Address__c = '12345 1st street'
    //                               , Zip_Code__c = '12345');
    //     insert sscCA;
    //     System.debug('::::SSC CA Country::::> ' + sscCA.Country__c);
        
    //     // CUSTOMER TYPE
        
    //     Customer_Type__c ct = new Customer_Type__c(Active__c = true
    //                                               , Select__c = true
    //                                               , SBU__c = 'DI'
    //                                               , Region__c = r100.Id);
    //     insert ct;
        
    //     Customer_Type__c ct2 = new Customer_Type__c(Active__c = true
    //                                                 , Select__c = true
    //                                                 , SBU__c = 'SC'
    //                                                 , Region__c = r04.Id);
    //     insert ct2;
        
        
    //     Customer_Type__c ct3 = new Customer_Type__c(Active__c = true
    //                                                 , Select__c = true
    //                                                 , SBU__c = 'SC'
    //                                                 , Region__c = r04.Id);
    //     insert ct3;
        
    //     Customer_Type__c ct500 = new Customer_Type__c(Active__c = true
    //                                                   , Select__c = true
    //                                                   , SBU__c = 'SC'
    //                                                   , Region__c = r100.Id);
    //     insert ct500;
        
    //     // SALES REPS
        
    //     Sales_Representative__c sr = new Sales_Representative__c(SBU__c = 'DI'
    //                                                              , DW_ID__c = '7'
    //                                                              , Region__c = r1.Id);
    //     insert sr;
        
    //     Sales_Representative__c sr1 = new Sales_Representative__c(SBU__c = 'sc'
    //                                                               , DW_ID__c = '97'
    //                                                               , Region__c = r1.Id);
    //     insert sr1;
        
    //     Sales_Representative__c sr2 = new Sales_Representative__c(SBU__c = 'sc'
    //                                                               , DW_ID__c = '95'
    //                                                               , Region__c = r1.Id
    //                                                               , Salesman_Last_Name__c = 'REGION');
    //     insert sr2;
        
    //     Sales_Representative__c sr041 = new Sales_Representative__c(SBU__c = 'sc'
    //                                                                 , DW_ID__c = '041'
    //                                                                 , Region__c = r04.Id);
    //     insert sr041;
        
    //     Sales_Representative__c sr042 = new Sales_Representative__c(SBU__c = 'sc'
    //                                                                 , DW_ID__c = '042'
    //                                                                 , Region__c = r04.Id
    //                                                                 , Salesman_Last_Name__c = 'REGION');
    //     insert sr042;
        
    //     Sales_Representative__c sr3 = new Sales_Representative__c(SBU__c = 'sc'
    //                                                               , DW_ID__c = '93'
    //                                                               , Region__c = r1.Id
    //                                                               , Salesman_Last_Name__c = 'test');
    //     insert sr3;
        
    //     Sales_Representative__c sr500 = new Sales_Representative__c(SBU__c = 'SC'
    //                                                                 , DW_ID__c = '99'
    //                                                                 , Salesman_First_Name__c = 'REGION'
    //                                                                 , Salesman_Last_Name__c = 'REGION'
    //                                                                 , Region__c = r100.id);
    //     insert sr500;
        
    //     Sales_Representative__c sr501 = new Sales_Representative__c(SBU__c = 'SC'
    //                                                                 , DW_ID__c = '91'
    //                                                                 , Salesman_First_Name__c = 'Jake'
    //                                                                 , Salesman_Last_Name__c = 'Test'
    //                                                                 , Region__c = r100.id);
    //     insert sr501;
        
    //     Sales_Representative__c srx500 = new Sales_Representative__c(SBU__c = 'SC'
    //                                                                  , DW_ID__c = '67'
    //                                                                  , Salesman_First_Name__c = 'REGION'
    //                                                                  , Salesman_Last_Name__c = 'REGION'
    //                                                                  , Region__c = rx1.id);
    //     insert srx500;
        
    //     Sales_Representative__c srx501 = new Sales_Representative__c(SBU__c = 'SC'
    //                                                                  , DW_ID__c = '98' 
    //                                                                  , Salesman_First_Name__c = 'Jake'
    //                                                                  , Salesman_Last_Name__c = 'Test'
    //                                                                  , Region__c = rx1.id);
    //     insert srx501;
        
    //     // ACCOUNT
        
    //     Account a = new Account(Name = 'Test');
    //     insert a;
        
    //     Test.startTest();
    //     //  testRun = true;
        
    //     try {
    //         Change_Request__c c30 = new Change_Request__c(
    //             SBU__c = 'SC'
    //             , IsNew__c = false
    //             , Account__c = a.Id
    //             , Sales_Representative__c = sr1.Id
    //             , Customer_Class__c = cc1.Id
    //             , Customer_Type__c = ct2.Id
    //             , RecordTypeId = Label.CR_Customer_Update_RT
    //             , SSC__c = ssc.Id
    //             , Name__c = NULL
    //             , Ship_To_Phone__c = '(972) 489-4406'
    //             , Fax__c = '(972) 489-4406'
    //             , RVPWF1__c = TRUE
    //             , RSM_WF1__c = TRUE
    //             , Region__c = r1.Id);
    //         insert c30;
            
    //         c30.Sales_Representative_n__c = sr1.Id;
    //         c30.Customer_Class_N__c = cc1.Id;
    //         c30.Business_Reason__c = 'Testing';
    //         c30.Customer_Type_n__c = ct2.Id;
    //         c30.SSC_N__c = NULL;
    //         c30.Billing_State_N2__c = 'TX';
    //         c30.Country_N2__c = 'US';
    //         c30.Region_n__c = r1.Id;
    //         c30.Shipping_Zip_N__c = '';
    //         c30.Shipping_State_N2__c = NULL;
    //         c30.Phone_N__c = '(972) 489-4406';
    //         c30.Fax_N__c = '(972) 489-4406';
    //         c30.Shipping_City__c = 'Dallas';
    //         c30.Shipping_Zip_N__c = '75218';
    //         c30.Shipping_street__c = 'PO BOX 123';
    //         update c30;
    //         c30.Shipping_street__c = 'P.O. BOX 123';
    //         update c30;
    //         c30.Shipping_street__c = 'P .O . BOX 123';
    //         update c30;
    //         c30.Shipping_street__c = 'P. O. BOX 123';
    //         update c30;
    //         System.debug('::::USER ?? 30::::> ' + c30.CreatedBy);
            
    //     } catch (Exception e) {
    //         System.debug('::::30::::> ' + e.getMessage());
    //         System.debug('::::30 Has Errors?::::> ' + tstCls.hasErrors);
    //         Boolean expectedExceptionThrown =  e.getMessage().contains(Label.No_PO_Box_in_Shipping_Address) ? true : false;
    //         System.AssertEquals(expectedExceptionThrown, false);
    //     }
        
    //     Test.stopTest();
    }
}