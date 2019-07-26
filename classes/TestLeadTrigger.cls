@isTest
private class TestLeadTrigger {

	@testSetup static void testSetup() {

        TriggerControl__c setting1 = new TriggerControl__c();
            setting1.Name = 'LeadTrigger';
            setting1.IsActive__c = TRUE;
        insert setting1;        

        TriggerControl__c setting2 = new TriggerControl__c();
            setting2.Name = 'UserTrigger';
            setting2.IsActive__c = TRUE;
        insert setting2;        

        Account a1 = new Account();
            a1.Name = 'Test Daltile Internal Account';
        insert a1;
        
        Account a2 = new Account();
            a2.Name = 'Test Big Account';
            a2.DW_ID__c = '2675309';
            a2.GroupKey__c = '123';
        insert a2;
        
        Account a3 = new Account();
            a3.Name = 'Test Big Account 2';
            a3.DW_ID__c = '26753092';
            a3.GroupKey__c = '123';
        insert a3;

        Contact ct = new Contact();
            ct.FirstName = 'STATEMENTS CONTACT';
            ct.LastName = 'DEALERTEST CONTACT';
            ct.AccountId = a2.Id;
            ct.Email = 'StatementsDealer@daltile.com';
            ct.Phone = '3216549871';
        insert ct;        
        
        // Group g1 = new Group();
        //     g1.Name = 'Website Leads';
        //     g1.DeveloperName = 'Website_Leads';
        // insert g1;
        
        UserContactDefaults__c ucd = new UserContactDefaults__c(Default_Account_Id__c = a1.Id
                                                               ,Default_Contact_Record_Type_Id__c = '012F0000000msd2');
        insert ucd;
                
        // USERS
        User uMGR1;
        User uPartner;
        System.runAs(new User(Id=UserInfo.getUserId())) {
            UserRole rMGR = [SELECT Id, Name FROM UserRole WHERE Name = 'MW SSC Manager'];    
            id pMGR = [Select id 
                            From Profile
                            where UserType = 'Standard'
                            and Name = 'SSC Manager'
                            limit 1].Id;        
            Id pPartner = [select id from profile where name='SSC Statement Dealer Leadership / Principle'].id;
            uMGR1 = new User(alias = 'MGR1'
                            , email= 'StatementsDealer@daltile.com'
                            , emailencodingkey='UTF-8'
                            , lastname='DEALERTEST'
                            , firstname='STATEMENTS USER'
                            , languagelocalekey='en_US'
                            , localesidkey='en_US'
                            , timezonesidkey='GMT'
                            , ProfileId = pPartner
                            , ContactID = ct.id
                            , username = 'StatementsDealer@daltile.com.test');
            insert uMGR1;   
            
        }
        
        ct.User__c = uMGR1.id;
        update ct;
	}

    @isTest static void testWebAssignmentByName() {
        
        Account a = [   SELECT ID, DW_ID__c
                        FROM Account
                        WHERE NAME = 'Test Big Account'
        ];
        
        Contact ct = [ SELECT ID, FirstName, LastName, Email
                        FROM Contact
                        WHERE email = 'StatementsDealer@daltile.com'
        ];
        
        User u = [   SELECT ID, Email
                        FROM User
                        WHERE email = 'StatementsDealer@daltile.com'
        ]; 
        
        Test.startTest();    
                
        Lead l1 = new Lead (
            FirstName = 'LeadTest'
            , LastName = 'LastName'  
            , Company = 'TestCo'
            , phone = '214-777-7771'
            , did__c = '2675309'
            , Dealer_Email__c = 'StatementsDealer@daltile.com'
            , IsConverted = FALSE
            , LeadSource = 'Website'
            , Visitor_Type__c = 'HomeOwner'
        );
        insert l1;
        
        Test.stopTest();
    }
    
    @isTest static void testWebAssignmentByUserEmail() {
        
        Account a = [   SELECT ID, DW_ID__c
                        FROM Account
                        WHERE NAME = 'Test Big Account'
        ];
        
        Contact ct = [ SELECT ID , FirstName, LastName, Email
                        FROM Contact
                        WHERE LastName = 'DEALERTEST CONTACT'
                        AND FirstName = 'STATEMENTS CONTACT'
        ];
        
        
        User u = [   SELECT ID, Email
                        FROM User
                        WHERE email = 'StatementsDealer@daltile.com'
        ]; 
        
        Test.startTest();    
        
        Lead l1 = new Lead (
            FirstName = 'STATEMENTS'
            , LastName = 'DEALERTEST'  
            , Company = 'TestCo'
            , phone = '214-777-7771'
            , did__c = '2675309'
            , Dealer_Email__c = 'StatementsDealer@daltile.com'
            , email = 'testwhatmay@test.com'
            , IsConverted = FALSE
            , LeadSource = 'Website'
            , Visitor_Type__c = 'HomeOwner'
        );
        insert l1;
        
        Test.stopTest();
    }
    
    @isTest static void testWebAssignmentByContactEmail() {
        
        Account a = [   SELECT ID, DW_ID__c
                        FROM Account
                        WHERE NAME = 'Test Big Account'
        ];
        
        Contact ct = [ SELECT ID , FirstName, LastName, Email, User__c
                        FROM Contact
                        WHERE FirstName = 'STATEMENTS CONTACT'
                        AND LastName = 'DEALERTEST CONTACT'
        ];
        
        ct.Email = 'Updated.StatementsDealer@daltile.com';
        update ct;
        
        User u = [   SELECT ID, Email
                        FROM User
                        WHERE email = 'StatementsDealer@daltile.com'
        ]; 
        
        Test.startTest();    
        
        Lead l1 = new Lead (
            FirstName = 'STATEMENTS'
            , LastName = 'DEALERTEST'  
            , Company = 'TestCo'
            , phone = '214-777-7771'
            , did__c = '2675309'
            , Dealer_Email__c = 'Updated.StatementsDealer@daltile.com'
            , email = 'testwhatmay@test.com'
            , IsConverted = FALSE
            , LeadSource = 'Website'
            , Visitor_Type__c = 'HomeOwner'
        );
        insert l1;
        
        Test.stopTest();
    }    
    
    @isTest static void testWebAssignmentByGroupKey() {
        
        Account a = [   SELECT ID, DW_ID__c, GroupKey__c
                        FROM Account
                        WHERE NAME = 'Test Big Account'
                        AND GroupKey__c = '123'
        ];
        
        Account a2 = [   SELECT ID, DW_ID__c, GroupKey__c
                        FROM Account
                        WHERE NAME = 'Test Big Account 2'
                        AND GroupKey__c = '123'
        ];
        
        Contact ct = [ SELECT ID , FirstName, LastName, Email, User__c
                        FROM Contact
                        WHERE FirstName = 'STATEMENTS CONTACT'
                        AND LastName = 'DEALERTEST CONTACT'
        ];
        
        User u = [   SELECT ID, Email
                        FROM User
                        WHERE email = 'StatementsDealer@daltile.com'
        ]; 
        
        Test.startTest();    
        
        Lead l1 = new Lead (
            FirstName = 'STATEMENTS'
            , LastName = 'DEALERTEST'  
            , Company = 'TestCo'
            , phone = '214-777-7771'
            , did__c = '26753092'
            , Dealer_Email__c = 'YepStatementsDealer@daltile.com'
            , email = 'testwhatmay@test.com'
            , IsConverted = FALSE
            , LeadSource = 'Website'
            , Visitor_Type__c = 'HomeOwner'
        );
        insert l1;
        
        Test.stopTest();
    }
    
    @isTest static void testWebAssignmentByAccountID() {
        
        Account a = [   SELECT ID, DW_ID__c, GroupKey__c
                        FROM Account
                        WHERE NAME = 'Test Big Account'
                        AND GroupKey__c = '123'
        ];
        
        Account a2 = [   SELECT ID, DW_ID__c, GroupKey__c
                        FROM Account
                        WHERE NAME = 'Test Big Account 2'
                        AND GroupKey__c = '123'
        ];
        
        Contact ct = [ SELECT ID , FirstName, LastName, Email, User__c
                        FROM Contact
                        WHERE FirstName = 'STATEMENTS CONTACT'
                        AND LastName = 'DEALERTEST CONTACT'
        ];
        
        User u = [   SELECT ID, Email
                        FROM User
                        WHERE email = 'StatementsDealer@daltile.com'
        ]; 
        
        Test.startTest();    
        
        Lead l1 = new Lead (
            FirstName = 'STATEMENTS'
            , LastName = 'DEALERTEST'  
            , Company = 'TestCo'
            , phone = '214-777-7771'
            , did__c = '2675309'
            , Dealer_Email__c = 'ADifferentStatementsDealer@daltile.com'
            , email = 'testwhatmay@test.com'
            , IsConverted = FALSE
            , LeadSource = 'Website'
            , Visitor_Type__c = 'HomeOwner'
        );
        insert l1;
        
        Test.stopTest();
    }
    
    @isTest static void testWebAssignmentNotFound() {
        
        Account a = [   SELECT ID, DW_ID__c
                        FROM Account
                        WHERE NAME = 'Test Big Account'
        ];
        
        Contact ct = [ SELECT ID , FirstName, LastName, Email, User__c
                        FROM Contact
                        WHERE FirstName = 'STATEMENTS CONTACT'
                        AND LastName = 'DEALERTEST CONTACT'
        ];
        
        User u = [   SELECT ID, Email
                        FROM User
                        WHERE email = 'StatementsDealer@daltile.com'
        ]; 

        Group g = [   SELECT ID, DeveloperName
                        FROM Group
                        WHERE DeveloperName = 'Website_Leads'
        ]; 
        
        Test.startTest();    
        
        Lead l1 = new Lead (
            FirstName = 'STATEMENTS'
            , LastName = 'DEALERTEST'  
            , Company = 'TestCo'
            , phone = '214-777-7771'
            , did__c = '2675309777'
            , Dealer_Email__c = 'YepStatementsDealer777@daltile.com'
            , email = 'testwhatmay777@test.com'
            , IsConverted = FALSE
            , LeadSource = 'Website'
            , Visitor_Type__c = 'HomeOwner'
        );
        insert l1;
        
        delete l1;
        
        Test.stopTest();
    }
    
    
}