@isTest
private class TestContactTrigger {
    
    @testSetup static void testSetup() {

        TriggerControl__c setting1 = new TriggerControl__c();
            setting1.Name = 'ContactTrigger';
            setting1.IsActive__c = TRUE;
        insert setting1;        
        
        TriggerControl__c setting2 = new TriggerControl__c();
        setting2.Name = 'UserTrigger';
        setting2.IsActive__c = TRUE;
        insert setting2;        

        Account a = new Account();
        a.Name = 'test account';
        insert a;
        
        Account a1 = new Account();
        a1.Name = 'Test Daltile Internal Account';
        insert a1;
        
        String contactRecordTypeID = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard Contact').getRecordTypeId();
        
        UserContactDefaults__c ucd = new UserContactDefaults__c(Default_Account_Id__c = a1.Id
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
            UserRole rMGR = [SELECT Id, Name FROM UserRole WHERE Name = 'MW SSC Manager'];    
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
        }        
        
        Contact cn1 = new Contact();
            cn1.FirstName = 'Jon 1';
            cn1.LastName = 'Test 1';
            cn1.AccountId = a.Id;
            cn1.MailingStreet = '7834 CF Hawn Fwy ';
            cn1.MailingCity = 'DALLAS';
            cn1.MailingState = 'TX';
            cn1.MailingPostalCode = '75217';
            cn1.MailingCountry = 'US';
        insert cn1;        
        
        String varProExchangeRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ProExchange').getRecordTypeId();
        Case cs = new Case (Origin = 'Email'
                            , Subject = 'Testing 1'
                            , Status = 'New'
                            , Type = 'Support'
                            , Address_Line_1__c	= 'Test 123'
                            , City__c = 'Dallas'	
                            , State__c = 'TX'	
                            , RecordTypeId = varProExchangeRecordType
                            , Zip__c = '75217'                         
                            , Description = 'test....');
        insert cs;

        Contact cn2 = new Contact();
            cn2.FirstName = 'Jon 2';
            cn2.LastName = 'Test 2';
            cn2.Case__c = cs.Id;
            cn2.AccountId = a.Id;
            cn2.MailingStreet = '7834 CF Hawn Fwy ';
            cn2.MailingCity = 'DALLAS';
            cn2.MailingState = 'TX';
            cn2.MailingPostalCode = '75217';
            cn2.MailingCountry = 'US';
        insert cn2;       
        
        Contact cn3 = new Contact();
            cn3.FirstName = 'Jonny';
            cn3.LastName = 'Contractor';
            cn3.Case__c = cs.Id;
            cn3.AccountId = a.Id;
            cn3.MailingStreet = '7834 CF Hawn Fwy ';
            cn3.MailingCity = 'DALLAS';
            cn3.MailingState = 'TX';
            cn3.MailingPostalCode = '75217';
            cn3.MailingCountry = 'US';
        insert cn3;    
        
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
                                                     , PPS_Rgn__c = 'SC');
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
                                                     , PPS_Rgn__c = 'SC');
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
                                                     , PPS_Rgn__c = 'DI');
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
                                                     , PPS_Rgn__c = 'SC');
        insert cc4;
        SSC__c ssc1 = new SSC__c(Closed__c = false
                                 , DW_ID__c = '001'
                                 , Loc_Type__c = 'SSC'
                                 , Manager__c = uMGR1.id
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
        insert ssc1; 
        
        SSC__c ssc2 = new SSC__c(Closed__c = false
                                 , DW_ID__c = '002'
                                 , Loc_Type__c = 'SSC'
                                 , Manager__c = uMGR1.id
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
        insert ssc2; 
        
        SSC__c ssc3 = new SSC__c(Closed__c = false
                                 , DW_ID__c = '003'
                                 , Loc_Type__c = 'SSC'
                                 , Manager__c = uMGR1.id
                                 , Region__c = r2.Id
                                 , ROM__c = NULL
                                 , RSM__c = NULL
                                 , RVP__c = NULL
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
        
        Customer_Type__c ct1 = new Customer_Type__c( Name = 'CT1'
                                                   , Active__c = true
                                                   , Select__c = true
                                                   , SBU__c = 'SC'
                                                   , Region__c = r1.Id);
        insert ct1;
        
        Customer_Type__c ct2 = new Customer_Type__c( Name = 'CANAD CT2'
                                                   , Active__c = true 
                                                   , Select__c = true
                                                   , SBU__c = 'AS'
                                                   , Region__c = r1.Id);
        insert ct2;
        
        RecordType varCustomerAccount = [SELECT Id,Name FROM RecordType WHERE Name = 'Customer Account'];
        
        Account aCusSC = new Account ( NAME = 'TEST ACCOUNT SC'
                           , AccountNumber = '111111'
                           , Customer_Base__c = '111111'
                           , Customer_Class__c = cc1.id
                           , phone = '214-309-4193'
                           , Customer_Type__c = ct1.id
                           , DW_ID__c = '32165487'
                           , GroupKey__c = '11111'
                           , SAP_Account_Id__c = '11111'
                           , Fax = '214-309-4193'
                           , Website = 'wwww.test.com'
                           , Require_PO__c = FALSE
                           , Region__c = r1.Id
                           , OwnerId = uMGR1.id
                           , Salesman__c = sr1.id
                           , SSC__c = ssc1.id
                           , Customer_Suffix__c = '11'
                           , BillingStreet = '7834 CF Hawn Fwy '
                           , BillingCity = 'DALLAS'
                           , BillingState = 'TX'
                           , BillingPostalCode = '75217'
                           , BillingCountry = 'US'
                           , ShippingStreet = '7834 CF Hawn Fwy '
                           , ShippingCity = 'DALLAS'
                           , ShippingState = 'TX'
                           , ShippingPostalCode = '75217'
                           , ShippingCountry = 'US'
                           , ShippingLongitude = 100
                           , ShippingLatitude = 30
                           , BillingLongitude = 100
                           , BillingLatitude = 30
                           , Address_3__c = 'huh'
                           , SBU__C  = 'SC');
        insert aCusSC;        

        Account aCusAS = new Account ( NAME = 'TEST ACCOUNT AS'
                           , AccountNumber = '111112'
                           , Customer_Base__c = '111112'
                           , Customer_Class__c = cc1.id
                           , phone = '214-309-4193'
                           , Customer_Type__c = ct1.id
                           , DW_ID__c = '2678433'
                           , GroupKey__c = '11111'
                           , SAP_Account_Id__c = '11111'
                           , Fax = '214-309-4193'
                           , Website = 'wwww.test.com'
                           , Require_PO__c = FALSE
                           , Region__c = r1.Id
                           , OwnerId = uMGR1.id
                           , Salesman__c = sr1.id
                           , SSC__c = ssc1.id
                           , Customer_Suffix__c = '11'
                           , BillingStreet = '7834 CF Hawn Fwy '
                           , BillingCity = 'DALLAS'
                           , BillingState = 'TX'
                           , BillingPostalCode = '75217'
                           , BillingCountry = 'US'
                           , ShippingStreet = '7834 CF Hawn Fwy '
                           , ShippingCity = 'DALLAS'
                           , ShippingState = 'TX'
                           , ShippingPostalCode = '75217'
                           , ShippingCountry = 'US'
                           , ShippingLongitude = -93.35229
                           , ShippingLatitude = 44.866448
                           , BillingLongitude = -93.35229
                           , BillingLatitude = 44.866448
                           , Address_3__c = 'huh'
                           , SBU__C  = 'AS');
        insert aCusAS;                
        
        Contact cn4 = new Contact();
            cn4.FirstName = 'JonBoi';
            cn4.LastName = 'TilerGuy';
            cn4.AccountId = aCusSC.Id;
            cn4.Email = 'valid.4email@tileguy.com.dttests';
            cn4.MailingStreet = '7834 CF Hawn Fwy ';
            cn4.MailingCity = 'DALLAS';
            cn4.MailingState = 'CA';
            cn4.MailingPostalCode = '75217';
            cn4.MailingCountry = 'US';
            cn4.MailingLongitude = 100;
            cn4.MailingLatitude = 30;
        insert cn4;        
        
        Account a054100 = new Account ( NAME = 'TEST ACCOUNT a054100'
                           , AccountNumber = '054100112'
                           , Customer_Base__c = '054100112'
                           , Customer_Class__c = cc1.id
                           , phone = '214-309-4193'
                           , Customer_Type__c = ct1.id
                           , DW_ID__c = '054100112'
                           , GroupKey__c = '111112'
                           , SAP_Account_Id__c = '111112'
                           , Fax = '214-309-4193'
                           , Website = 'wwww.test.com'
                           , Require_PO__c = FALSE
                           , Region__c = r1.Id
                           , OwnerId = uMGR1.id
                           , Salesman__c = sr1.id
                           , SSC__c = ssc1.id
                           , Customer_Suffix__c = '11'
                           , BillingStreet = '7834 CF Hawn Fwy '
                           , BillingCity = 'DALLAS'
                           , BillingState = 'TX'
                           , BillingPostalCode = '75217'
                           , BillingCountry = 'US'
                           , ShippingStreet = '7834 CF Hawn Fwy '
                           , ShippingCity = 'DALLAS'
                           , ShippingState = 'TX'
                           , ShippingPostalCode = '75217'
                           , ShippingCountry = 'US'
                           , ShippingLongitude = -93.35229
                           , ShippingLatitude = 44.866448
                           , BillingLongitude = -93.35229
                           , BillingLatitude = 44.866448
                           , Address_3__c = 'huh'
                           , SBU__C  = 'AS');
        insert a054100;                        
        
        Contact c054100 = new Contact();
            c054100.FirstName = 'JonBoi';
            c054100.LastName = 'TilerGuyc054100';
            c054100.AccountId = c054100.Id;
            c054100.Email = 'c054100.4email@tileguy.com.dttests';
            c054100.MailingStreet = '7834 CF Hawn Fwy ';
            c054100.MailingCity = 'DALLAS';
            c054100.MailingState = 'CA';
            c054100.MailingPostalCode = '75217';
            c054100.MailingCountry = 'US';
            c054100.MailingLongitude = 100;
            c054100.MailingLatitude = 30;
        insert c054100;          
        
        Contact cWebUser = new Contact();
            cWebUser.FirstName = 'ProExchange';
            cWebUser.LastName = 'WebUser';
            cWebUser.AccountId = a1.Id;
            cWebUser.Email = 'ProExchange.WebUser@guy.com.dttests';
        insert cWebUser;          
    }

    @isTest static void testNewContact() {

        Contact newContact2 = [ SELECT         
                                    Id
                                    , FirstName
                                    , LastName
                                    , Case__c
                                    , MailingCity
                                    , MailingCountry
                                    , MailingGeocodeAccuracy
                                    , MailingState
                                    , MailingStreet
                                    , MailingLongitude
                                    , MailingLatitude
                                From Contact
                                WHERE LastName = 'Contractor'];
        
        Case newCase = [ SELECT         
                            Id
                            , ContactId
                        From Case
                        WHERE Subject = 'Testing 1'];

        Account a1 = [SELECT ID
                    	,NAME
                    	,DBA_Name__c
                    	,AccountNumber
                    	,DW_ID__c
                    	,Customer_Base__c
                    	,Division_Name__r.Code__c
                    	,Customer_Class__r.CustClass__c
                    	,Customer_Type__r.Cust_Type__c 
                    	,Region__r.DW_ID__c
                    	,Salesman__r.DW_ID__c
                    	,SSC__r.DW_ID__c
                    	,Division_Name__c
                    	,Customer_Class__c
                    	,Customer_Type__c
                    	,Region__c
                    	,Salesman__c
                    	,SSC__c	
                    	,SSC__r.Select__c
                    	,SSC__r.Loc_Type__c
                    	,Customer_Suffix__c
                    	,phone
                    	,Fax
                    	,BillingStreet
                    	,BillingCity
                    	,BillingState
                    	,BillingPostalCode 
                    	,BillingCountry
                    	,BillingLatitude
                    	,BillingLongitude
                    	,ShippingStreet
                    	,ShippingCity
                    	,ShippingState
                    	,ShippingPostalCode 
                    	,ShippingCountry
                    	,BillingAddress
                    	,SBU__C
                    	,Mark_For_Deletion__c
                    FROM Account
                    WHERE NAME = 'TEST ACCOUNT SC'];
		System.debug('::::TestContactTrigger + a1.BillingAddress: ' + a1.BillingAddress);

        Account a2 = [SELECT ID
                    	,NAME
                    	,DBA_Name__c
                    	,AccountNumber
                    	,DW_ID__c
                    	,Customer_Base__c
                    	,Division_Name__r.Code__c
                    	,Customer_Class__r.CustClass__c
                    	,Customer_Type__r.Cust_Type__c 
                    	,Region__r.DW_ID__c
                    	,Salesman__r.DW_ID__c
                    	,SSC__r.DW_ID__c
                    	,Division_Name__c
                    	,Customer_Class__c
                    	,Customer_Type__c
                    	,Region__c
                    	,Salesman__c
                    	,SSC__c	
                    	,SSC__r.Select__c
                    	,SSC__r.Loc_Type__c
                    	,Customer_Suffix__c
                    	,phone
                    	,Fax
                    	,BillingStreet
                    	,BillingCity
                    	,BillingState
                    	,BillingPostalCode 
                    	,BillingCountry
                    	,BillingLatitude
                    	,BillingLongitude
                    	,ShippingStreet
                    	,ShippingCity
                    	,ShippingState
                    	,ShippingPostalCode 
                    	,ShippingCountry
                    	,SBU__C
                    	,BillingAddress
                    	,Mark_For_Deletion__c
                    FROM Account
                    WHERE NAME = 'TEST ACCOUNT AS'];
		System.debug('::::TestContactTrigger + a2.BillingAddress: ' + a2.BillingAddress);

        Test.startTest();
        newContact2.MailingLongitude = 100;
        newContact2.MailingLatitude = 30;
        newContact2.Ready_for_ProExchange_User__c = true;
        try {
            update newContact2;
        } catch (Exception e) {
            System.debug('::::TestContactTrigger + e : ' + e );
        }

        newCase.AccountID = a2.ID;
        newCase.ContactId = newContact2.id;
        try {
            update newCase;
        } catch (Exception e) {
            System.debug('::::TestContactTrigger + e : ' + e );
        }

        newContact2.AccountID = a2.ID;
        newContact2.Set_Up_As_Principal_ProExchange_User__c = true;
        newContact2.email = 'test.setup@proexchange.test.com';
        try {
            update newContact2;
        } catch (Exception e) {
            System.debug('::::TestContactTrigger + e : ' + e );
        }
        
        String varCaseID = newCase.Id;
        String varContactID = newContact2.Id;
        
        Decimal varMailingLongitude = newContact2.MailingLongitude;
        Decimal varMailingLatitude = newContact2.MailingLatitude;
        String varMailingCountry = newContact2.MailingCountry;
        
        // List<Account> findCashAccounts = ContactHandler.findCashAccounts(varMailingLongitude,varMailingLatitude,varMailingCountry);

        
        Test.stopTest();        
    }    
    
    @isTest static void testNewContactNewUser() {
        
        Contact newContact2 = [ SELECT         
                                    Id
                                    , FirstName
                                    , LastName
                                    , Case__c
                                    , Email
                                    , Phone
                                    , Ready_for_ProExchange_User__c
                                    , AccountId
                                    , MailingCity
                                    , MailingCountry
                                    , MailingGeocodeAccuracy
                                    , MailingState
                                    , MailingStreet
                                    , MailingLongitude
                                    , MailingLatitude
                                From Contact
                                WHERE LastName = 'TilerGuy'];
        
        Case newCase = [ SELECT         
                            Id
                            , ContactId
                            , ProExchange_Status__c
                            , Status
                        From Case
                        WHERE Subject = 'Testing 1'];

        Account a1 = [SELECT ID
                    	,NAME
                    	,DBA_Name__c
                    	,AccountNumber
                    	,DW_ID__c
                    	,Customer_Base__c
                    	,Division_Name__r.Code__c
                    	,Customer_Class__r.CustClass__c
                    	,Customer_Type__r.Cust_Type__c 
                    	,Region__r.DW_ID__c
                    	,Salesman__r.DW_ID__c
                    	,SSC__r.DW_ID__c
                    	,Division_Name__c
                    	,Customer_Class__c
                    	,Customer_Type__c
                    	,Region__c
                    	,Salesman__c
                    	,SSC__c	
                    	,SSC__r.Select__c
                    	,SSC__r.Loc_Type__c
                    	,Customer_Suffix__c
                    	,phone
                    	,Fax
                    	,BillingStreet
                    	,BillingCity
                    	,BillingState
                    	,BillingPostalCode 
                    	,BillingCountry
                    	,BillingLatitude
                    	,BillingLongitude
                    	,ShippingStreet
                    	,ShippingCity
                    	,ShippingState
                    	,ShippingPostalCode 
                    	,ShippingCountry
                    	,BillingAddress
                    	,SBU__C
                    	,Mark_For_Deletion__c
                    FROM Account
                    WHERE NAME = 'TEST ACCOUNT SC'];
		System.debug('::::TestContactTrigger + a1.BillingAddress: ' + a1.BillingAddress);

        Account a2 = [SELECT ID
                    	,NAME
                    	,DBA_Name__c
                    	,AccountNumber
                    	,DW_ID__c
                    	,Customer_Base__c
                    	,Division_Name__r.Code__c
                    	,Customer_Class__r.CustClass__c
                    	,Customer_Type__r.Cust_Type__c 
                    	,Region__r.DW_ID__c
                    	,Salesman__r.DW_ID__c
                    	,SSC__r.DW_ID__c
                    	,Division_Name__c
                    	,Customer_Class__c
                    	,Customer_Type__c
                    	,Region__c
                    	,Salesman__c
                    	,SSC__c	
                    	,SSC__r.Select__c
                    	,SSC__r.Loc_Type__c
                    	,Customer_Suffix__c
                    	,phone
                    	,Fax
                    	,BillingStreet
                    	,BillingCity
                    	,BillingState
                    	,BillingPostalCode 
                    	,BillingCountry
                    	,BillingLatitude
                    	,BillingLongitude
                    	,ShippingStreet
                    	,ShippingCity
                    	,ShippingState
                    	,ShippingPostalCode 
                    	,ShippingCountry
                    	,SBU__C
                    	,BillingAddress
                    	,Mark_For_Deletion__c
                    FROM Account
                    WHERE NAME = 'TEST ACCOUNT AS'];
		System.debug('::::TestContactTrigger + a2.BillingAddress: ' + a2.BillingAddress);

        Test.startTest();

        newContact2.MailingLongitude = 100;
        newContact2.MailingLatitude = 30;
        newContact2.Ready_for_ProExchange_User__c = true;
        newContact2.Case__c = newCase.id;
        update newContact2;

        newCase.AccountID = a2.ID;
        newCase.ContactId = newContact2.id;
        newCase.Add_New_Account__c = true;
        update newCase;        

        newContact2.AccountID = a2.ID;
        newContact2.Set_Up_As_Principal_ProExchange_User__c = true;
        newContact2.email = 'test22.setup@proexchange.test.com';
        update newContact2;

        newCase.ProExchange_Status__c = 'Ready for ProExchange User';
        update newCase;        
        
        String varCaseID = newCase.Id;
        String varContactID = newContact2.Id;
        
        Decimal varMailingLongitude = newContact2.MailingLongitude;
        Decimal varMailingLatitude = newContact2.MailingLatitude;
        String varMailingCountry = newContact2.MailingCountry;
        
        Test.stopTest();        
    } 
    
    @isTest static void testNewContactNewWebUser() {
        
        Contact newContactWeb = [ SELECT         
                                    Id
                                    , FirstName
                                    , LastName
                                    , Case__c
                                    , Email
                                    , Phone
                                    , AccountId
                                    , MailingCity
                                    , MailingCountry
                                    , MailingGeocodeAccuracy
                                    , MailingState
                                    , MailingStreet
                                    , MailingLongitude
                                    , MailingLatitude
                                From Contact
                                WHERE Email = 'ProExchange.WebUser@guy.com.dttests'];
        
        Case newCase = [ SELECT         
                            Id
                            , ContactId
                            , ProExchange_Status__c
                            , Status
                        From Case
                        WHERE Subject = 'Testing 1'];

        Account a1 = [SELECT ID
                    	,NAME
                    	,DBA_Name__c
                    	,AccountNumber
                    	,DW_ID__c
                    	,Customer_Base__c
                    	,Division_Name__r.Code__c
                    	,Customer_Class__r.CustClass__c
                    	,Customer_Type__r.Cust_Type__c 
                    	,Region__r.DW_ID__c
                    	,Salesman__r.DW_ID__c
                    	,SSC__r.DW_ID__c
                    	,Division_Name__c
                    	,Customer_Class__c
                    	,Customer_Type__c
                    	,Region__c
                    	,Salesman__c
                    	,SSC__c	
                    	,SSC__r.Select__c
                    	,SSC__r.Loc_Type__c
                    	,Customer_Suffix__c
                    	,phone
                    	,Fax
                    	,BillingStreet
                    	,BillingCity
                    	,BillingState
                    	,BillingPostalCode 
                    	,BillingCountry
                    	,BillingLatitude
                    	,BillingLongitude
                    	,ShippingStreet
                    	,ShippingCity
                    	,ShippingState
                    	,ShippingPostalCode 
                    	,ShippingCountry
                    	,BillingAddress
                    	,SBU__C
                    	,Mark_For_Deletion__c
                    FROM Account
                    WHERE NAME = 'TEST ACCOUNT SC'];

        Account a2 = [SELECT ID
                    	,NAME
                    	,DBA_Name__c
                    	,AccountNumber
                    	,DW_ID__c
                    	,Customer_Base__c
                    	,Division_Name__r.Code__c
                    	,Customer_Class__r.CustClass__c
                    	,Customer_Type__r.Cust_Type__c 
                    	,Region__r.DW_ID__c
                    	,Salesman__r.DW_ID__c
                    	,SSC__r.DW_ID__c
                    	,Division_Name__c
                    	,Customer_Class__c
                    	,Customer_Type__c
                    	,Region__c
                    	,Salesman__c
                    	,SSC__c	
                    	,SSC__r.Select__c
                    	,SSC__r.Loc_Type__c
                    	,Customer_Suffix__c
                    	,phone
                    	,Fax
                    	,BillingStreet
                    	,BillingCity
                    	,BillingState
                    	,BillingPostalCode 
                    	,BillingCountry
                    	,BillingLatitude
                    	,BillingLongitude
                    	,ShippingStreet
                    	,ShippingCity
                    	,ShippingState
                    	,ShippingPostalCode 
                    	,ShippingCountry
                    	,SBU__C
                    	,BillingAddress
                    	,Mark_For_Deletion__c
                    FROM Account
                    WHERE NAME = 'TEST ACCOUNT AS'];
		System.debug('::::TestContactTrigger + a2.BillingAddress: ' + a2.BillingAddress);

        Test.startTest();
        newContactWeb.MailingStreet = '7834 CF Hawn Fwy ';
        newContactWeb.MailingCity = 'DALLAS';
        newContactWeb.MailingState = 'CA';
        newContactWeb.MailingPostalCode = '75217';
        newContactWeb.MailingCountry = 'US';
        newContactWeb.MailingLongitude = -93.35229;
        newContactWeb.MailingLatitude = 44.866448;        
        newContactWeb.Ready_for_ProExchange_User__c = true;
        newContactWeb.Case__c = newCase.id;
        update newContactWeb;
        
		System.debug('::::TestContactTrigger + newContactWeb.MailingLongitude: ' + newContactWeb.MailingLongitude);
        
        try {
            ContactGateway.submitCustomerRequest(newCase.id,newContactWeb.Id);
        } catch (Exception e) {
            System.debug('::::TestContactTrigger + e : ' + e );
        }
		
        Test.stopTest();        
    } 
    
    @isTest static void testNewContactNewUserCheckbox() {
        
        Contact newContact2 = [ SELECT         
                                    Id
                                    , FirstName
                                    , LastName
                                    , Case__c
                                    , MailingCity
                                    , MailingCountry
                                    , MailingGeocodeAccuracy
                                    , MailingState
                                    , MailingStreet
                                    , MailingLongitude
                                    , MailingLatitude
                                From Contact
                                WHERE LastName = 'TilerGuy'];
        
        Case newCase = [ SELECT         
                            Id
                            , ContactId
                        From Case
                        WHERE Subject = 'Testing 1'];

        Account a1 = [SELECT ID
                    	,NAME
                    	,DBA_Name__c
                    	,AccountNumber
                    	,DW_ID__c
                    	,Customer_Base__c
                    	,Division_Name__r.Code__c
                    	,Customer_Class__r.CustClass__c
                    	,Customer_Type__r.Cust_Type__c 
                    	,Region__r.DW_ID__c
                    	,Salesman__r.DW_ID__c
                    	,SSC__r.DW_ID__c
                    	,Division_Name__c
                    	,Customer_Class__c
                    	,Customer_Type__c
                    	,Region__c
                    	,Salesman__c
                    	,SSC__c	
                    	,SSC__r.Select__c
                    	,SSC__r.Loc_Type__c
                    	,Customer_Suffix__c
                    	,phone
                    	,Fax
                    	,BillingStreet
                    	,BillingCity
                    	,BillingState
                    	,BillingPostalCode 
                    	,BillingCountry
                    	,BillingLatitude
                    	,BillingLongitude
                    	,ShippingStreet
                    	,ShippingCity
                    	,ShippingState
                    	,ShippingPostalCode 
                    	,ShippingCountry
                    	,BillingAddress
                    	,SBU__C
                    	,Mark_For_Deletion__c
                    FROM Account
                    WHERE NAME = 'TEST ACCOUNT SC'];
		System.debug('::::TestContactTrigger + a1.BillingAddress: ' + a1.BillingAddress);

        Test.startTest();

        newContact2.Set_Up_As_Principal_ProExchange_User__c = true;
        update newContact2;

        Test.stopTest();        
    }    
    
    @isTest static void testNewProExchExceptions() {
        Test.startTest();

        Contact newContact2 = [ SELECT         
                                    Id
                                    , FirstName
                                    , LastName
                                    , Case__c
                                    , MailingCity
                                    , MailingCountry
                                    , MailingGeocodeAccuracy
                                    , MailingState
                                    , MailingStreet
                                    , MailingLongitude
                                    , MailingLatitude
                                From Contact
                                WHERE LastName = 'Test 2'];
        
        Contact newContact1 = [ SELECT         
                                    Id
                                    , FirstName
                                    , LastName
                                    , Case__c
                                    , MailingCity
                                    , MailingCountry
                                    , MailingGeocodeAccuracy
                                    , MailingState
                                    , MailingStreet
                                    , MailingLongitude
                                    , MailingLatitude
                                    , MailingAddress
                                From Contact
                                WHERE LastName = 'Test 1'];
                                
        Contact newContact054100 = [ SELECT         
                                    Id
                                    , FirstName
                                    , LastName
                                    , Case__c
                                    , MailingCity
                                    , MailingCountry
                                    , MailingGeocodeAccuracy
                                    , MailingState
                                    , MailingStreet
                                    , MailingLongitude
                                    , MailingLatitude
                                    , MailingAddress
                                From Contact
                                WHERE Email = 'c054100.4email@tileguy.com.dttests'];

        Case newCase = [ SELECT         
                            Id
                            , ContactId
                        From Case
                        WHERE Subject = 'Testing 1'];

        Account a1 = [SELECT ID
                    	,NAME
                    	,DBA_Name__c
                    	,AccountNumber
                    	,DW_ID__c
                    	,Customer_Base__c
                    	,Division_Name__r.Code__c
                    	,Customer_Class__r.CustClass__c
                    	,Customer_Type__r.Cust_Type__c 
                    	,Region__r.DW_ID__c
                    	,Salesman__r.DW_ID__c
                    	,SSC__r.DW_ID__c
                    	,Division_Name__c
                    	,Customer_Class__c
                    	,Customer_Type__c
                    	,Region__c
                    	,Salesman__c
                    	,SSC__c	
                    	,SSC__r.Select__c
                    	,SSC__r.Loc_Type__c
                    	,Customer_Suffix__c
                    	,phone
                    	,Fax
                    	,BillingStreet
                    	,BillingCity
                    	,BillingState
                    	,BillingPostalCode 
                    	,BillingCountry
                    	,BillingLatitude
                    	,BillingLongitude
                    	,ShippingStreet
                    	,ShippingCity
                    	,ShippingState
                    	,ShippingPostalCode 
                    	,ShippingCountry
                    	,BillingAddress
                    	,SBU__C
                    	,Mark_For_Deletion__c
                    FROM Account
                    WHERE NAME = 'TEST ACCOUNT SC'];
		System.debug('::::TestContactTrigger + a1.BillingAddress: ' + a1.BillingAddress);

        Account a2 = [SELECT ID
                    	,NAME
                    	,DBA_Name__c
                    	,AccountNumber
                    	,DW_ID__c
                    	,Customer_Base__c
                    	,Division_Name__r.Code__c
                    	,Customer_Class__r.CustClass__c
                    	,Customer_Type__r.Cust_Type__c 
                    	,Region__r.DW_ID__c
                    	,Salesman__r.DW_ID__c
                    	,SSC__r.DW_ID__c
                    	,Division_Name__c
                    	,Customer_Class__c
                    	,Customer_Type__c
                    	,Region__c
                    	,Salesman__c
                    	,SSC__c	
                    	,SSC__r.Select__c
                    	,SSC__r.Loc_Type__c
                    	,Customer_Suffix__c
                    	,phone
                    	,Fax
                    	,BillingStreet
                    	,BillingCity
                    	,BillingState
                    	,BillingPostalCode 
                    	,BillingCountry
                    	,BillingLatitude
                    	,BillingLongitude
                    	,ShippingStreet
                    	,ShippingCity
                    	,ShippingState
                    	,ShippingPostalCode 
                    	,ShippingCountry
                    	,SBU__C
                    	,BillingAddress
                    	,Mark_For_Deletion__c
                    FROM Account
                    WHERE NAME = 'TEST ACCOUNT AS'];
		System.debug('::::TestContactTrigger + a2.BillingAddress: ' + a2.BillingAddress);

        newContact2.MailingLongitude = 100;
        newContact2.MailingLatitude = 30;
        newContact2.Ready_for_ProExchange_User__c = true;
        update newContact2;
        try { 
            newContact2.Set_Up_As_Principal_ProExchange_User__c = true;
            update newContact2;
        }   catch (Exception e) {
            System.debug('::::TestUserTrigger + createSSCPartnerUser::::> ' + e.getMessage());
        } 
        
        try { 
            newContact2.AccountId = a1.id;
            newContact2.Set_Up_As_Principal_ProExchange_User__c = true;
            update newContact2;
        }   catch (Exception e) {
            System.debug('::::TestUserTrigger + createSSCPartnerUser::::> ' + e.getMessage());
        } 
        
        try { 
            newContact2.AccountId = a2.id;
            newContact2.Set_Up_As_Principal_ProExchange_User__c = true;
            update newContact2;
        }   catch (Exception e) {
            System.debug('::::TestUserTrigger + createSSCPartnerUser::::> ' + e.getMessage());
        } 
        
        try { 
            newContact2.FirstName = 'a';
            newContact2.Email = 'newContact2.Email@newContact2.Email.com.dttest';
            newContact2.Set_Up_As_Principal_ProExchange_User__c = true;
            update newContact2;
        }   catch (Exception e) {
            System.debug('::::TestUserTrigger + createSSCPartnerUser::::> ' + e.getMessage());
        } 
        
        try { 
            newContact2.FirstName = 'a';
            newContact2.LastName = 'a';
            newContact2.Email = 'newContact2.Email@newContact2.Email.com.dttest';
            newContact2.Set_Up_As_Principal_ProExchange_User__c = true;
            update newContact2;
        }   catch (Exception e) {
            System.debug('::::TestUserTrigger + createSSCPartnerUser::::> ' + e.getMessage());
        } 
        
        try { 
            newContact2.FirstName = '';
            newContact2.Email = 'newContact2.Email@newContact2.Email.com.dttest';
            newContact2.Set_Up_As_Principal_ProExchange_User__c = true;
            update newContact2;
        }   catch (Exception e) {
            System.debug('::::TestUserTrigger + createSSCPartnerUser::::> ' + e.getMessage());
        } 
        
        try { 
            newContact2.LastName = 'a';
            newContact2.Email = 'newContact2.Email@newContact2.Email.com.dttest';
            newContact2.Set_Up_As_Principal_ProExchange_User__c = true;
            update newContact2;
        }   catch (Exception e) {
            System.debug('::::TestUserTrigger + createSSCPartnerUser::::> ' + e.getMessage());
        } 
        
        try { 
            newContact054100.Set_Up_As_Principal_ProExchange_User__c = true;
            update newContact2;
        }   catch (Exception e) {
            System.debug('::::TestUserTrigger + createSSCPartnerUser::::> ' + e.getMessage());
        } 
        
        Test.stopTest();        
    }        
    
    @isTest static void testNewContactDel() {
        Test.startTest();

        Account a1 = [SELECT ID
                    FROM Account
                    WHERE NAME = 'TEST ACCOUNT SC'];

        Contact cn2 = new Contact();
            cn2.FirstName = 'Jon New';
            cn2.LastName = 'Test New';
            cn2.AccountId = a1.Id;
            cn2.MailingCountry = 'US';
        insert cn2;      
        
        delete cn2;
        
        Test.stopTest();        
    }        
    

    
    // @isTest static void testContactGateway() {
        
    // }
    
}