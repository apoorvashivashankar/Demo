@isTest
private class TestCaseTrigger {
    
    @testSetup static void testSetup() {
        

        TriggerControl__c setting1 = new TriggerControl__c();
            setting1.Name = 'CaseTrigger';
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
            a1.Name = 'Daltile Internal Communications';
        insert a1;

        Region__c r1 = new Region__c(Select__c = true
                                     , SBU__c = 'SC'
                                     , DW_ID__c = '01'
                                     , Name = 'SOUTHERN CA REGION - 40');
        insert r1;        
        
        Account a2 = new Account();
            a2.Name = 'test groupkey account 1';
            a2.DW_ID__C = '321123';
            a2.GroupKey__C = '123';
            a2.Region__c = r1.id;
            a2.Division__c	= '40';
        insert a2;
        
        Account a3 = new Account();
            a3.Name = 'test groupkey account 2';
            a2.DW_ID__C = '654123';
            a3.GroupKey__C = '123';
        insert a3;

        Id profileDefaultProExch = [Select id 
                                    From Profile
                                    WHERE Name = 'SSC Leadership/Principle'
                                    limit 1].Id;  
    
        Id contactRecordTypeId = [Select id 
                                    From RecordType
                                    WHERE SObjectType = 'Contact'
                                    AND DeveloperName = 'Standard_Contact'
                                    limit 1].Id;
                                    // = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard_Contact').getRecordTypeId();
        
        UserContactDefaults__c setting3 = new UserContactDefaults__c();
            setting3.Default_Temp_Account_Id__c = a1.Id;
            setting3.Default_Contact_Record_Type_Id__c = contactRecordTypeId;
            setting3.Default_SSC_Community_Profile__c = profileDefaultProExch;
        insert setting3;
        
        Contact ct = new Contact();
            ct.FirstName = 'Jon';
            ct.LastName = 'Test';
            ct.AccountId = a.Id;
            ct.Email = 'testingsome@tester.com.test';
            ct.Phone = '3216549871';
            ct.MailingState = 'TX';
        insert ct;        
        
        Contact ct2 = new Contact();
            ct2.FirstName = 'GroupKey';
            ct2.LastName = 'TestGroupKey';
            ct2.AccountId = a2.Id;
            ct2.Email = 'testingsome@tester.com.test';
            ct2.Phone = '3216549871';
            ct2.MailingState = 'TX';
        insert ct2;        

        Contact ctPE = new Contact ( 
            AccountID = a2.Id
            , FirstName = 'NewPro'
            , LastName = 'Exchanger'
            , Email = 'new.pro.exchanger@tileguys.com.dttest'
            , Phone = '2147531122'
        );
        insert ctPE;

        // USERS
        User uRSM;
        User uRVP;
        User uMGR1;
        User uMGR2;
        User uSR1;
        User uSR2;
        User uPartner;
        System.runAs(new User(Id=UserInfo.getUserId())) {
            UserRole rMGR = [SELECT Id, Name FROM UserRole WHERE Name LIKE '%SSC Manager%' AND PortalRole = '' LIMIT 1];    
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

            Account aInt = new Account();
                aInt.Name = 'Test Daltile Internal Account';
                aInt.DW_ID__c = '5487';
                aInt.OwnerId = uMGR1.Id;
            insert aInt;
            
            Contact ctInternal = new Contact();
                ctInternal.FirstName = 'Account';
                ctInternal.LastName = 'Owner';
                ctInternal.AccountId = a1.Id;
                ctInternal.Email = 'AccountOwnerGuy@daltile.com';
                ctInternal.User__c = uMGR1.Id;
                ctInternal.Phone = '3216549871';
            insert ctInternal;      
            
            Contact ct3 = new Contact();
                ct3.FirstName = 'j2';
                ct3.LastName = 'Test2';
                ct3.AccountId = a2.Id;
                ct3.Email = 'testingsome2@tester2.com.test';
                ct3.Phone = '3216549871';
            insert ct3;      
            
           Id pPartner = [select id from profile where name='Partner Community User'].id;
           
           uPartner = new User(alias = 'test123'
                                , email='test123@noemail.com'
                                , emailencodingkey='UTF-8'
                                , lastname='Testing'
                                , languagelocalekey='en_US'
                                , localesidkey='en_US'
                                , profileid = pPartner
                                , country='United States'
                                , IsActive =true
                                , ContactId = ct3.Id
                                , timezonesidkey='America/Los_Angeles'
                                , username='parter.tester@daltile.com.tester');
           insert uPartner; 
            
        }        

    }

    @isTest static void testEmailToCaseContact() {

        Group owner = [ SELECT ID
                        FROM Group
                        WHERE DeveloperName = 'CS_Main'
                        ];
        Id varOwnerId = owner.Id;   

        Account a = [SELECT ID
                        FROM Account
                        WHERE NAME = 'test account'
        ];

        Contact ct = new Contact();
            ct.FirstName = 'Jon';
            ct.LastName = 'Test';
            ct.Contact_Type__c = 'Service';
            ct.AccountId = a.Id;
            ct.Email = 'testingsome@tester.com.test';
            ct.Phone = '3216549871';
        insert ct;     

        Contact ct2 = new Contact();
            ct2.FirstName = 'Jon';
            ct2.LastName = 'Test';
            ct2.AccountId = a.Id;
            ct2.Email = 'testingsome@tester.com.test';
            ct2.Phone = '3216549871';
        insert ct2;     

        Id varCSRCasesRecordType = SObjectType.Case.getRecordTypeInfosByName().get('CSR Case').getRecordTypeId(); 
        Id varSupportCasesRecordType = SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Cases').getRecordTypeId(); 

        Test.startTest();    
        try {            
            Case c1 = new Case();
            c1.SuppliedEmail = 'testingsome@tester.com.test';
            c1.Type = 'Claims';
            c1.Origin = 'Email';    
            c1.RecordTypeId = varCSRCasesRecordType;     
            c1.OwnerID = varOwnerId;
            insert c1;
        } catch (DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
        try {          
            Case c1 = new Case();
            c1.SuppliedEmail = 'salesforce@daltile.com';
            c1.Type = 'Claims';
            c1.Origin = 'Email';    
            c1.RecordTypeId = varSupportCasesRecordType;     
            c1.OwnerID = varOwnerId;
            insert c1;           
        } catch (DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
        Test.stopTest(); 

    }

    @isTest static void testPriceCheckRepTask() {
        
        System.debug('testNewShipTo:...');
        Account a = [   SELECT ID
                        FROM Account
                        WHERE NAME = 'test account'];
        System.debug('testNewShipTo + a :...' + a);
        
        Contact ct = [ SELECT ID
                        FROM Contact
                        WHERE LastName = 'Test2'];
        System.debug('testNewShipTo + ct :...' + ct);
        
        Test.startTest();    
        
        try {
            Case c = new Case();
            c.AccountId = a.ID;
            c.ContactId = ct.Id;
            c.Type = 'Check Pricing';
            c.Origin = 'Phone';
            c.ProExchange_Status__c = 'Completed';
            c.Status = 'Closed';
            insert c;
        } catch (Exception e) {
            System.debug('testNewShipTo + c + error :...' + e);
        }
        
        try {
            Case c1 = new Case();
            c1.AccountId = a.ID;
            c1.ContactId = ct.Id;
            c1.Type = 'Claims';
            c1.Origin = 'Phone';
            c1.ProExchange_Status__c = 'Completed';
            c1.Status = 'In Progress';
            insert c1;
                    
            try {
                c1.Status = 'Closed';
                update c1;
                delete c1;
            } catch (Exception e) {
                System.debug('testNewShipTo + c1 update + error :...' + e);
            }
        } catch (Exception e) {
            System.debug('testNewShipTo + c1 + error :...' + e);
        }
        

        Test.stopTest();
    }
    
    @isTest static void testProExchangeExistingAccountRequest() {
        
        RecordType rt = [   SELECT ID
                            FROM RecordType
                            WHERE Name = 'ProExchange'
                            AND SobjectType = 'Case'];
        Id varProExchangeRecordType = rt.Id;        

        Account a1 = [   SELECT ID, DW_ID__C
                        FROM Account
                        WHERE DW_ID__C = '321123'];
                        
        a1.IsPartner = true;
        update a1;
                        
        Contact ct = [ SELECT ID
                            , FirstName
                            , LastName
                            , Email
                            , Phone
                        FROM Contact
                        WHERE LastName = 'Test2'
        ];
        
        String conFirstName = ct.FirstName;
        String conLastName = ct.LastName;
        String conEmail = ct.Email;
        String conPhone = ct.Phone;
        
        ID accID = a1.Id;
        ID conID = ct.Id;
        
        User u = [  SELECT ID
                    , UserType 
                    FROM User
                    WHERE username='parter.tester@daltile.com.tester'
        ];
        
        Test.startTest();    
        // System.runAs(u) {
            Case c1 = new Case();
            c1.AccountId = accID;
            c1.ContactId = conID;
            c1.First_Name__c = conFirstName;
            c1.Title__c = 'captain of the team';
            c1.Last_Name__c = conLastName;
            c1.Email_Address__c = conEmail;
            c1.Phone_Number__c = conPhone;
            c1.Add_New_Account__c = true;
            c1.Type = 'Claims';
            c1.Origin = 'Phone';
            c1.Status = 'In Progress';
            c1.Address_Line_1__c    = 'Test 123';
            c1.City__c = 'Dallas';  
            c1.State__c = 'TX'; 
            c1.Zip__c = '75218';           
            c1.AccountNumber__c = a1.DW_ID__c;
            c1.RecordTypeId = varProExchangeRecordType;
            insert c1;
        // }
        Test.stopTest();
    }

    @isTest static void testProExchangeNewAccountRequest() {
        
        RecordType rt = [   SELECT ID
                            FROM RecordType
                            WHERE Name = 'ProExchange'
                            AND SobjectType = 'Case'];
        Id varProExchangeRecordType = rt.Id;        

        Account a1 = [   SELECT ID, DW_ID__C
                        FROM Account
                        WHERE DW_ID__C = '321123'];
                        
        a1.IsPartner = true;
        update a1;
                        
        Contact ct = [ SELECT ID
                            , FirstName
                            , LastName
                            , Email
                            , Phone
                        FROM Contact
                        WHERE LastName = 'Test2'
        ];
        
        String conFirstName = ct.FirstName;
        String conLastName = ct.LastName;
        String conEmail = ct.Email;
        String conPhone = ct.Phone;
        
        ID accID = a1.Id;
        ID conID = ct.Id;
        
        User u = [  SELECT ID
                    , UserType 
                    FROM User
                    WHERE username='parter.tester@daltile.com.tester'
        ];
        
        Test.startTest();    
        // System.runAs(u) {
            Case c1 = new Case();
            c1.AccountName__c	= 'Testing Account';
            c1.ContactId = conID;
            c1.First_Name__c = 'conFirstName';
            c1.Title__c = 'captain of the team';
            c1.Last_Name__c = 'conLastName';
            c1.Email_Address__c = 'conEmail@emails.com';
            c1.Phone_Number__c = '2148678433';
            c1.Add_New_Account__c = true;
            c1.Type = 'Claims';
            c1.Origin = 'Web';
            c1.Status = 'New';
            c1.Address_Line_1__c  = 'Test 123';
            c1.City__c = 'Dallas';  
            c1.State__c = 'TX'; 
            c1.Zip__c = '75218';           
            c1.RecordTypeId = varProExchangeRecordType;
            insert c1;
            
            c1.AccountNumber__c = '321123';
            update c1;
            

        // }
        Test.stopTest();
    }    

    @isTest static void testProExchangeDuplicateContactUser() {
        
        RecordType rt = [   SELECT ID
                            FROM RecordType
                            WHERE Name = 'ProExchange'
                            AND SobjectType = 'Case'];
        Id varProExchangeRecordType = rt.Id;        

        Account a1 = [   SELECT ID, DW_ID__C
                        FROM Account
                        WHERE DW_ID__C = '321123'];
                        
        a1.IsPartner = true;
        update a1;
                        
        Contact ct = [ SELECT ID
                            , FirstName
                            , LastName
                            , Email
                            , Phone
                            , AccountId
                        FROM Contact
                        WHERE LastName = 'Test2'
        ];
        
        String conFirstName = ct.FirstName;
        String conLastName = ct.LastName;
        String conEmail = ct.Email;
        String conPhone = ct.Phone;
        
        ID accID = a1.Id;
        ID conID = ct.Id;
        
        User u = [  SELECT ID
                    , UserType 
                    FROM User
                    WHERE username='parter.tester@daltile.com.tester'
        ];
        
        Test.startTest();    
        // System.runAs(u) {
            Case c1 = new Case();
            c1.AccountName__c	= 'Testing Account';
            c1.ContactId = conID;
            c1.First_Name__c = 'j2';
            c1.Title__c = 'test 2';
            c1.Last_Name__c = 'test 2';
            c1.Email_Address__c = 'testingsome2@tester2.com.test';
            c1.Phone_Number__c = '2148678433';
            c1.Add_New_Account__c = true;
            c1.Type = 'Claims';
            c1.Origin = 'Web';
            c1.Status = 'New';
            c1.Address_Line_1__c  = 'Test 123';
            c1.City__c = 'Dallas';  
            c1.State__c = 'TX'; 
            c1.Zip__c = '75218';           
            c1.RecordTypeId = varProExchangeRecordType;
            insert c1;
            
            c1.AccountNumber__c = '321123';
            update c1;
            
                
            try {
                Case c2 = new Case();
                c2.AccountName__c	= 'Testing Account';
                c2.First_Name__c = 'j2';
                c2.Title__c = 'captain of the team';
                c2.Last_Name__c = 'test 2';
                c2.Email_Address__c = 'testingsome2@tester2.com.test';
                c2.Phone_Number__c = '2148678433';
                c2.Add_New_Account__c = true;
                c2.Type = 'Claims';
                c2.Origin = 'Web';
                c2.Status = 'New';
                c2.AccountId  = a1.Id;
                c2.RecordTypeId = varProExchangeRecordType;
                insert c2;
            } catch (Exception e) {
                System.debug('::::TestCaseTrigger + e : ' + e );
            }
            try {
                Case c2 = new Case();
                c2.AccountName__c	= 'Testing Account';
                c2.First_Name__c = 'j2';
                c2.Title__c = 'captain of the team';
                c2.Last_Name__c = 'test2';
                c2.Email_Address__c = 'testingsome2@tester2.com.test';
                c2.Phone_Number__c = '2148678433';
                c2.Add_New_Account__c = true;
                c2.Type = 'Claims';
                c2.Origin = 'Web';
                c2.Status = 'New';
                c2.AccountId  = a1.Id;
                c2.RecordTypeId = varProExchangeRecordType;
                insert c2;
            } catch (Exception e) {
                System.debug('::::TestCaseTrigger + e : ' + e );
            }
            try {
                Case c2 = new Case();
                c2.AccountName__c	= 'Testing Account';
                c2.First_Name__c = 'j2';
                c2.Title__c = 'captain of the team';
                c2.Last_Name__c = 'test2';
                c2.Email_Address__c = 'test123@noemail.com';
                c2.Phone_Number__c = '2148678433';
                c2.Add_New_Account__c = true;
                c2.Type = 'Claims';
                c2.Origin = 'Web';
                c2.Status = 'New';
                c2.AccountId  = a1.Id;
                c2.RecordTypeId = varProExchangeRecordType;
                insert c2;
            } catch (Exception e) {
                System.debug('::::TestCaseTrigger + e : ' + e );
            }

        // }
        Test.stopTest();
    }    

    @isTest static void testProExchangeAccountContactRequest() {
        
        RecordType rt = [   SELECT ID
                            FROM RecordType
                            WHERE Name = 'ProExchange'
                            AND SobjectType = 'Case'];
        Id varProExchangeRecordType = rt.Id;        

        Account a1 = [   SELECT ID, DW_ID__C
                        FROM Account
                        WHERE DW_ID__C = '321123'];
                        
        a1.IsPartner = true;
        update a1;
                        
        Contact ct = [ SELECT ID
                            , FirstName
                            , LastName
                            , Email
                            , Phone
                        FROM Contact
                        WHERE LastName = 'Test2'
        ];
        
        String conFirstName = 'New First Name';
        String conLastName = 'New last Name';
        String conEmail = '124@123.com';
        String conPhone = '1234567891';
        
        ID accID = a1.Id;
        ID conID = ct.Id;
        
        User u = [  SELECT ID
                    , UserType 
                    FROM User
                    WHERE username='parter.tester@daltile.com.tester'
        ];
        
        Test.startTest();    
        
        Case c1 = new Case();
        c1.AccountId = accID;
        c1.ContactId = conID;
        c1.First_Name__c = conFirstName;
        c1.Last_Name__c = conLastName;
        c1.Email_Address__c = conEmail;
        c1.Phone_Number__c = conPhone;
        c1.Add_New_Account__c = true;
        c1.Type = 'Claims';
        c1.Origin = 'Phone';
        c1.Status = 'In Progress';
        c1.Address_Line_1__c    = 'Test 123';
        c1.City__c = 'Dallas';  
        c1.State__c = 'TX'; 
        c1.Zip__c = '75218';           
        c1.AccountNumber__c = a1.DW_ID__c;
        c1.RecordTypeId = varProExchangeRecordType;
        insert c1;
        
        Test.stopTest();
    }

    @isTest static void testProExchangeNewCaseRequest() {

        Account a1 = [   SELECT ID, DW_ID__C
                        FROM Account
                        WHERE DW_ID__C = '321123'];
                        
        a1.IsPartner = true;
        update a1;
                        
        Contact ct = [ SELECT ID
                            , FirstName
                            , LastName
                            , Email
                            , Phone
                        FROM Contact
                        WHERE Email = 'new.pro.exchanger@tileguys.com.dttest'
        ];
        
        String conFirstName = 'New First Name';
        String conLastName = 'New last Name';
        String conEmail = '124@123.com';
        String conPhone = '1234567891';
        
        ID accID = a1.Id;
        ID conID = ct.Id;
        
        User u = [  SELECT ID
                    , UserType 
                    FROM User
                    WHERE username='parter.tester@daltile.com.tester'
        ];
        
        String varProExchangeRecordType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('ProExchange').getRecordTypeId();

        Test.startTest();    
        
        try {

            System.debug('::::TestCaseGateway + creating case + varProExchangeRecordType:...' + varProExchangeRecordType);    

            Case c1 = new Case();
            c1.AccountId = accID;
            c1.ContactId = conID;
            c1.First_Name__c = conFirstName;
            c1.Last_Name__c = conLastName;
            c1.Email_Address__c = conEmail;
            c1.Phone_Number__c = conPhone;
            c1.Add_New_Account__c = true;
            c1.Type = 'Claims';
            c1.Origin = 'Phone';
            c1.Status = 'In Progress';
            c1.Address_Line_1__c    = 'Test 123';
            c1.City__c = 'Dallas';  
            c1.State__c = 'TX'; 
            c1.Zip__c = '75218';           
            c1.AccountNumber__c = a1.DW_ID__c;
            c1.ProExchange_Status__c = 'Ready for ProExchange User';
            c1.RecordTypeId = varProExchangeRecordType;
            insert c1;
        } catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }        
        Test.stopTest();
    }

    @isTest static void testUpdateUserFromEmail() {
        
        RecordType rt = [   SELECT ID
                            FROM RecordType
                            WHERE Name = 'ProExchange'
                            AND SobjectType = 'Case'];
        Id varProExchangeRecordType = rt.Id;        
        
        Account a1 = [   SELECT ID, GroupKey__C, DW_ID__C
                        FROM Account
                        WHERE Name = 'Daltile Internal Communications'];
        
        User u = [  SELECT ID
                    , email
                    , UserType 
                    , Name
                    , ContactId
                    
                    FROM User
                    WHERE username = 'MGR1@daltile.com.test'];
        
        Contact ct = [ SELECT ID
                            , AccountId
                            , Account.Name
                            , Account.GroupKey__c
                            , FirstName
                            , LastName
                            , Email
                            , Phone
                            , User__c
                            , User__r.email
                            , User__r.Name
                        FROM Contact
                        WHERE User__c = : u.Id
                        LIMIT 1];
                        
        String conFirstName = ct.FirstName;
        String conLastName = ct.LastName;
        String conEmail = ct.Email;
        String conPhone = ct.Phone;
        
        Test.startTest();    
        try {
            Case c = new Case (Origin = 'Email'
                             , SuppliedEmail = u.email
                             , SuppliedName = u.name
                             , Subject = 'Testing'
                             , ProExchange_Status__c = 'Completed'
                             , Description = 'Test email from : ' + u.email);
            insert c;
            
            // Verify against support email address
            System.AssertNotEquals(null,[Select Id from Case where user__c = :u.Id]);
        } catch (Exception e) {
            System.debug('::::TestCaseTrigger + e : ' + e );
        }        
               
        try {
            Case c1 = new Case (Origin = 'Email'
                             , SuppliedEmail = 'salesforce@daltile.com'
                             , SuppliedName = u.Name
                             , Subject = 'Testing'
                             , Description = 'Test email from : empower@daltile.com');
            insert c1;

            //Verify that the contact was inserted via the trigger on the user object
            System.AssertNotEquals(null,[Select Id from Case where user__c = :u.Id]);
        } catch (Exception e) {
            System.debug('::::TestCaseTrigger + e : ' + e );
        }        
        

        Test.stopTest(); 
    }    
    
    @isTest static void testUserTimezone() {
    
        CaseGateway.checkUserTimezone('CT');    
        CaseGateway.checkUserTimezone('AL');    
        CaseGateway.checkUserTimezone('AZ');    
        CaseGateway.checkUserTimezone('CA');    
        CaseGateway.checkUserTimezone('AK');    
        CaseGateway.checkUserTimezone('HI');
        
    }

    @isTest static void testUpdateCasecontact() {
        
        RecordType rt = [   SELECT ID
                            FROM RecordType
                            WHERE Name = 'ProExchange'
                            AND SobjectType = 'Case'];
        Id varProExchangeRecordType = rt.Id;        

        Account a1 = [   SELECT ID, DW_ID__C
                        FROM Account
                        WHERE DW_ID__C = '321123'];
                        
        a1.IsPartner = true;
        update a1;
                        
        Contact ct = [ SELECT ID
                            , FirstName
                            , LastName
                            , Email
                            , Phone
                        FROM Contact
                        WHERE LastName = 'Test2'
        ];
        
        String conFirstName = ct.FirstName;
        String conLastName = ct.LastName;
        String conEmail = ct.Email;
        String conPhone = ct.Phone;
        
        ID accID = a1.Id;
        ID conID = ct.Id;
        
        User u = [  SELECT ID
                    , UserType 
                    FROM User
                    WHERE username='parter.tester@daltile.com.tester'
        ];
        
    // System.runAs(u) {
        Case c1 = new Case();
        c1.AccountName__c	= 'Testing Account';
        c1.ContactId = conID;
        c1.AccountName__c = a1.id;
        c1.First_Name__c = 'conFirstName';
        c1.Title__c = 'captain of the team';
        c1.Last_Name__c = 'conLastName';
        c1.Email_Address__c = 'conEmail@emails.com';
        c1.Phone_Number__c = '2148678433';
        c1.Add_New_Account__c = true;
        c1.ProExchange_Status__c = 'Requested';
        c1.Type = 'Claims';
        c1.Origin = 'Web';
        c1.Status = 'New';
        c1.Address_Line_1__c  = 'Test 123';
        c1.City__c = 'Dallas';  
        c1.State__c = 'TX'; 
        c1.Zip__c = '75218';           
        c1.RecordTypeId = varProExchangeRecordType;
        insert c1;
        
        String varMessage1 = 'previous ProExchange User';
        String varMessage2 = 'Multiple Contacts';
        String varMessage3 = 'same Name and the same Email';
        String varMessage4 = 'same Name';
        
        Test.startTest();
        
        try {
            CaseGateway.helperUpdateCaseContact(c1.ID, varMessage1, ct.Id);
        } catch (Exception e) {
            System.debug('::::varMessage1 + e : ' + e );
        }
            
        try {
            CaseGateway.helperUpdateCaseContact(c1.ID, varMessage2, ct.Id);
        } catch (Exception e) {
            System.debug('::::varMessage2 + e : ' + e );
        }
            
        try {
            CaseGateway.helperUpdateCaseContact(c1.ID, varMessage3, ct.Id);
        } catch (Exception e) {
            System.debug('::::varMessage3 + e : ' + e );
        }
            
        try {
            CaseGateway.helperUpdateCaseContact(c1.ID, varMessage4, ct.Id);
        } catch (Exception e) {
            System.debug('::::varMessage4 + e : ' + e );
        }
        
        try {
            CaseGateway.helperUpdateCaseContact(c1.ID, null, ct.Id);
        } catch (Exception e) {
            System.debug('::::no message + e : ' + e );
        }
            

        // }
        Test.stopTest();
    }        
}