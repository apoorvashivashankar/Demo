@isTest
private class TestUserTrigger {
    
    
    @testSetup static void testSetup() {
        
        TriggerControl__c setting1 = new TriggerControl__c();
        setting1.Name = 'UserTrigger';
        setting1.IsActive__c = TRUE;
        insert setting1;        
        
        TriggerControl__c setting2 = new TriggerControl__c();
        setting2.Name = 'ContactTrigger';
        setting2.IsActive__c = TRUE;
        insert setting2;   
        
        TriggerControl__c setting3 = new TriggerControl__c();
        setting3.Name = 'ContactTrigger';
        setting3.IsActive__c = TRUE;
        insert setting3;        
        
        User userOwner;
        Account a;
        
        Id contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Daltile Internal Contact').getRecordTypeId();
        Id rtCustomerAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer Account').getRecordTypeId();

        Account a1 = new Account(name = 'Test Internal Account');
        insert a1;
        
        //Create a user record ** Trigger relies on data in a custom setting called UserContactDefaults__c
        //Expecting the UserContactCreationTrigger trigger to fire and create a contact associated to the new user        
        UserContactDefaults__c ucd = new UserContactDefaults__c(Default_Account_Id__c = a1.Id
                                                                ,Default_Contact_Record_Type_Id__c = contactRecordTypeId);
        insert ucd;        
        
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
            
            UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
            insert r;
            
            id profileId = [Select id 
                            From Profile
                            where UserType = 'Standard'
                            and Name = 'Arch Rep User'
                            limit 1].Id;
            
            
            userOwner = new User(alias = 'aOwner'
                                 , email= 'AccountOwnerGuy@daltile.com.test'
                                 , emailencodingkey='UTF-8'
                                 , lastname='Owner'
                                 , firstname='Account'
                                 , languagelocalekey='en_US'
                                 , localesidkey='en_US'
                                 , timezonesidkey='GMT'
                                 , ProfileId =profileId
                                 , UserRoleId = r.id
                                 , username = 'AccountOwnerGuy@daltile.com.test');
            
            try {
                insert userOwner; 
                System.debug('::::insert userOwner : ' + userOwner );
            } catch (Exception e) {
                System.debug('::::insert userOwner + e : ' + e );
            }
            
            Account a2 = new Account(name = 'Test GroupKey Account', GroupKey__c = '777', DW_ID__C = '123654', RecordTypeID = rtCustomerAccount);
            insert a2;
            
            Account a3 = new Account(name = 'Test GroupKey Account 2', GroupKey__c = '777', DW_ID__C = '1236546', RecordTypeID = rtCustomerAccount);
            insert a3;
            
            Account ac = new Account(name ='Statement Guy', OwnerID = userOwner.id);
            insert ac; 
            
            Contact conUser = new Contact(lastname='Owner', firstname='Account', email='AccountOwnerGuy@daltile.com.test',AccountId = a1.Id, User__c = userOwner.Id);
            insert conUser;   
            
            Contact con = new Contact(LastName ='testCon',AccountId = ac.Id);
            insert con;  

            Case csT = new Case (First_Name__c = 'IsRequired', Last_Name__c = 'testConGK', Email_Address__c = 'test@email.test.com', Phone_Number__c = '2142678433');
            insert csT;        
            
            Contact conGK = new Contact(FirstName = 'IsRequired', LastName ='testConGK',AccountId = a2.Id, email = 'test@email.test.com', Case__c = csT.Id);
            insert conGK;  
            
            Case cs = new Case (ContactId = conGK.Id, First_Name__c = 'test1', Last_Name__c = 'test1', Email_Address__c = 'test1111@111testing.com', Phone_Number__c = '2142678433');
            insert cs;        
            
            Contact conEdit = new Contact(FirstName ='EditProFirst', LastName ='EditProLast', Email = 'editor.email@editPro.com.dtest', AccountId = a2.Id, Set_Up_As_Principal_ProExchange_User__c = true );
            insert conEdit;
            
            Case cs1 = new Case (ContactId = conEdit.Id, First_Name__c = 'test1', Last_Name__c = 'test1', Email_Address__c = 'test1111@111testing.com', Phone_Number__c = '2142678433', ProExchange_Status__c = 'Completed');
            insert cs1; 
            
            Contact con1 = new Contact(FirstName ='testSuperCon', LastName ='testCon', Email = 'sscTestUser@daltile.com.tester',AccountId = a2.Id);
        	insert con1;
            Id p = [select id,UserType from profile where name='SSC Statement Dealer Sales Rep'].id;
            User user = new User(alias = 'test1242'
                                 , email='sscTestUser@daltile.com.tester'
                                 , emailencodingkey='UTF-8'
                                 , firstName = 'testSuperCon'
                                 , lastname='testCon'
                                 , languagelocalekey='en_US'
                                 , localesidkey='en_US'
                                 , profileid = p
                                 , country='United States'
                                 , ContactId = con1.Id 
                                 , isActive = true
                                 , timezonesidkey ='America/Los_Angeles'
                                 , Share_All_Group_Accounts__c = true
                                 , username='sscTestUser@daltile.com.tester');
            
            insert user;
            
            conEdit.Case__c = cs1.Id;
            conEdit.User__c = user.Id;
            update conEdit;
            
            Id pPartner = [select id from profile where name='Partner Community User'].id;
            
            User userPro = new User(alias = 'test123'
                                 , email='editor.email@editPro.com.dtest'
                                 , emailencodingkey='UTF-8'
                                 , firstName = 'IsRequired'
                                 , lastname='testConGK'
                                 , languagelocalekey='en_US'
                                 , localesidkey='en_US'
                                 , profileid = pPartner
                                 , country='United States'
                                 , IsActive =true
                                 , ContactId = conEdit.Id 
                                //  , UserRoleId = r.id
                                 , timezonesidkey ='America/Los_Angeles'
                                 , Share_All_Group_Accounts__c = true
                                 , username='editor.email@editPro.com.dtest');
            
            insert userPro;                   

            Id pManager = [select id from profile where name='SSC Manager'].id;

            User userNoContact = new User(alias = 'noCon'
                                 , email='user.no.contact@daltile.com.tester'
                                 , emailencodingkey='UTF-8'
                                 , firstName = 'the.User'
                                 , lastname='no.contact'
                                 , languagelocalekey='en_US'
                                 , localesidkey='en_US'
                                 , profileid = pManager
                                 , country='United States'
                                 , isActive = true
                                 , timezonesidkey ='America/Los_Angeles'
                                 , Share_All_Group_Accounts__c = false
                                 , username='user.no.contact@daltile.com.tester');
            
            insert userNoContact;            
        }

    }              
    
    @isTest
    public static void createStandardUser() {
        
        Account a = [   SELECT ID, Name
                     FROM Account
                     WHERE Name = 'Test Internal Account'];
        
        UserContactDefaults__c ucd = [  SELECT Default_Account_Id__c, Default_Contact_Record_Type_Id__c
                                      FROM UserContactDefaults__c
                                      WHERE Default_Account_Id__c = :a.Id];
        
        Test.startTest();                         
        try {        
            id profileId = [Select id 
                            From Profile
                            where UserType = 'Standard'
                            and Name = 'System Administrator'
                            limit 1].Id;
            
            
            User u = new User(alias = 'standt'
                              , email= 'testingemailguy@daltile.com'
                              , emailencodingkey='UTF-8'
                              , lastname='Test2'
                              , firstname='Test1'
                              , languagelocalekey='en_US'
                              , localesidkey='en_US'
                              , timezonesidkey='GMT'
                              , ProfileId =profileId
                              , username = 'testingemailguy@daltile.com');
            
            
            System.debug('::::TestUserContactCreationTrigger + inserting u...::::> ' + u);
            insert u;    


            Contact updateContact = [ SELECT
                                    ID
                                    , FirstName
                                    , LastName
                                    , Email
                                    , Phone
                                    , User__c
                                FROM Contact
                                WHERE User__c = : u.Id];
            
            User updateUser = [ SELECT
                                    ID
                                    , FirstName
                                    , LastName
                                    , Email
                                    , Phone
                                    , ContactId
                                FROM User
                                WHERE id = : u.Id];
            
            try {     
                updateUser.FirstName = 'Test123';
                updateUser.LastName = 'Test321';
                updateUser.email = 'testingemailguy13@daltile.com';
                updateUser.phone = '9725555655';
                System.debug('::::TestUserContactCreationTrigger + updating updateUser...::::> ' + updateUser);
                update updateUser;            
            }   catch (Exception e) {
                System.debug('::::TestUserContactCreationTrigger + createStandardUser ::::> ' + e.getMessage());
            } 

            //Verify that the contact was inserted via the trigger on the user object
            System.AssertNotEquals(null,[Select Id from Contact where user__c = :u.Id]);
            System.AssertNotEquals(null,[Select Email_WF__c from User where Id = :u.Id]);
            
            System.debug('::::TestUserContactCreationTrigger + createStandardUser + u.firstname ::::> ' + u.firstname);
            
        }   catch (Exception e) {
            System.debug('::::TestUserContactCreationTrigger + createStandardUser ::::> ' + e.getMessage());
        } 
        
        Test.stopTest();
    }


    @isTest
    public static void updateStandardUser() {
        List <User> listUserTest = [  SELECT ID
                                        , Name
                                        , FirstName
                                        , LastName
                                        , Email
                                        , Phone
                                        , MobilePhone
                                        , ContactId
                                        , UserType
                                    From User
                                    WHERE UserType = 'Standard'
                                    LIMIT 1];
                                    
        System.debug('::::TestUserContactCreationTrigger + updateStandardUser + listUserTest ::::> ' + listUserTest);           
    
        User u = new User();
        for (User theUser: listUserTest) {
            u = theUser;
        }
                
        System.debug('::::TestUserContactCreationTrigger + updateStandardUser + u ::::> ' + u);
                
        Test.startTest();                         
        try {
            u.email = 'testing.update.email@daltile.com';
            u.FirstName = 'UpdateFirst';
            u.LastName = 'UpdateLast';
            u.Phone = '3216548971';
            u.MobilePhone = '3216548972';
            update u;            
        }   catch (Exception e) {
            System.debug('::::TestUserContactCreationTrigger + updateStandardUser ::::> ' + e.getMessage());
        }                      
        try {
            u.IsActive = false;
            update u;            
        }   catch (Exception e) {
            System.debug('::::TestUserContactCreationTrigger + updateStandardUser ::::> ' + e.getMessage());
        }
        Test.stopTest();   
    }
    
    @isTest
    public static void createPartnerUser() {
        Account a = [   SELECT ID, Name, GroupKey__c
                     FROM Account
                     WHERE Name = 'Test Internal Account'];
        // UserRole r = new UserRole(DeveloperName = 'MyPatnerCustomRole', Name = 'My Role');
        // insert r;
        UserContactDefaults__c ucd = [  SELECT Default_Account_Id__c, Default_Contact_Record_Type_Id__c
                                      FROM UserContactDefaults__c
                                      WHERE Default_Account_Id__c = :a.Id];
        
        Test.startTest();                         
        try {        
            
            Id p = [select id from profile where name='Partner Community User'].id;
            
            Contact con = [
                SELECT ID, FirstName, LastName, Email
                FROM Contact
                WHERE LastName ='testConGK'
            ];          
            User user = new User(alias = 'test123'
                                 , email='test123@noemail.com'
                                 , emailencodingkey='UTF-8'
                                 , lastname='Testing'
                                 , languagelocalekey='en_US'
                                 , localesidkey='en_US'
                                 , profileid = p
                                 , country='United States'
                                 , IsActive =true
                                 , ContactId = con.Id 
                                //  , UserRoleId = r.id
                                 , timezonesidkey ='America/Los_Angeles'
                                 , Share_All_Group_Accounts__c = true
                                 , username='tester@daltile.com.tester');
            
            insert user;        

        }   catch (Exception e) {
            System.debug('::::TestUserTrigger + createPartnerUser::::> ' + e.getMessage());
        } 
        Test.stopTest();
    }
        
    @isTest
    public static void createPartnerUserFromContact() {
        Account a = [   SELECT ID, Name, GroupKey__c
                     FROM Account
                     WHERE Name = 'Test Internal Account'];
        // UserRole r = new UserRole(DeveloperName = 'MyPatnerCustomRole', Name = 'My Role');
        // insert r;
        UserContactDefaults__c ucd = [  SELECT Default_Account_Id__c, Default_Contact_Record_Type_Id__c
                                      FROM UserContactDefaults__c
                                      WHERE Default_Account_Id__c = :a.Id];
        
        Id p = [select id from profile where name='Partner Community User'].id;
        
        Contact con = [
            SELECT ID, FirstName, LastName, Email, Case__c
            FROM Contact
            WHERE LastName ='testConGK'
        ];       
        
        Case cs = [ SELECT 
                        ID
                        , ContactId
                        , Status
                    From Case
                    WHERE Last_Name__c = 'testConGK'
                    AND Email_Address__c = 'test@email.test.com'
                    LIMIT 1 ];
                    
        Test.startTest();                         
        try {        
            con.Set_Up_As_Principal_ProExchange_User__c = true;
            update con;
            User user = new User(alias = 'test123'
                                 , email='test123@noemail.com'
                                 , emailencodingkey='UTF-8'
                                 , lastname='Testing'
                                 , languagelocalekey='en_US'
                                 , localesidkey='en_US'
                                 , profileid = p
                                 , country='United States'
                                 , IsActive =true
                                 , ContactId = con.Id 
                                //  , UserRoleId = r.id
                                 , timezonesidkey ='America/Los_Angeles'
                                 , Share_All_Group_Accounts__c = true
                                 , username='tester@daltile.com.tester');
            
            insert user;      

        }   catch (Exception e) {
            System.debug('::::TestUserTrigger + createPartnerUserFromContact::::> ' + e.getMessage());
        } 
        Test.stopTest();
    }
    
    @isTest
    public static void updatePartnerUser() {

        User u = [SELECT Id
                        , FirstName
                        , LastName
                        , Email
                        , Phone
                        , MobilePhone
                        , Primary_Account_Group_Key__c
                        , Primary_Account_Number__c
                        , Share_All_Group_Accounts__c
                        , IsActive
                        , UserType
                    FROM User
                    WHERE email = 'editor.email@editPro.com.dtest'];
               
        Contact c = [   SELECT ID
                        , FirstName
                        , LastName
                        , Email
                        , Phone
                        , MobilePhone
                        , User__c
                        From Contact
                        Where email = 'editor.email@editPro.com.dtest'];
                        
        Case cse = [SELECT ID
                    , User__c
                    , ContactId
                    , First_Name__c
                    , Last_Name__c
                    , Email_Address__c
                    , Phone_Number__c
                    FROM Case
                    WHERE ContactId = : c.Id
                    LIMIT 1];
                    
        System.debug('::::TestUserTrigger + updatePartnerUser + c::::> ' + c);                
        Test.startTest();                        
        System.runAs(new User(Id=UserInfo.getUserId())) {
                                    
            try {        
    
                u.email = 'newTest.email@editPro.com.dtest';
                update u;
            }   catch (Exception e) {
                System.debug('::::TestUserTrigger + updatePartnerUser::::> ' + e.getMessage());
            } 
        }
        Test.stopTest();
    }
    
    @isTest
    public static void updateAccountSharingQueued() {

        LIST <Account> a1 = [SELECT ID
                        , DW_ID__c
                        , GroupKey__c
                        , Name
                        FROM Account
                        WHERE GroupKey__c = '777'];

        User u = [SELECT Id
                        , FirstName
                        , LastName
                        , Email
                        , Phone
                        , MobilePhone
                        , Primary_Account_Group_Key__c
                        , Primary_Account_Number__c
                        , Share_All_Group_Accounts__c
                        , IsActive
                        , ContactId
                        , UserType
                        , Contact.Case__c
                        , Contact.Set_Up_As_Principal_ProExchange_User__c
                    FROM User
                    WHERE email = 'editor.email@editPro.com.dtest'];

        User u2 = [SELECT Id
                        , FirstName
                        , LastName
                        , Email
                        , Phone
                        , MobilePhone
                        , Primary_Account_Group_Key__c
                        , Primary_Account_Number__c
                        , Share_All_Group_Accounts__c
                        , IsActive
                        , ContactId
                        , UserType
                        , Contact.Case__c
                        , Contact.Set_Up_As_Principal_ProExchange_User__c
                    FROM User
                    WHERE email = 'user.no.contact@daltile.com.tester'];
               
        Contact c = [   SELECT ID
                        , FirstName
                        , LastName
                        , Email
                        , Phone
                        , MobilePhone
                        , User__c
                        , Account.GroupKey__c
                        From Contact
                        Where email = 'editor.email@editPro.com.dtest'];
                        
        Case cse = [SELECT ID
                    , User__c
                    , ContactId
                    , First_Name__c
                    , Last_Name__c
                    , Email_Address__c
                    , Phone_Number__c
                    FROM Case
                    WHERE ContactId = : c.Id
                    LIMIT 1];
                    
        System.debug('::::TestUserTrigger + updatePartnerUser + c::::> ' + c);                
        Test.startTest();                         
        System.runAs(new User(Id=UserInfo.getUserId())) {
            try {        
                List <User> listUser = new List <User>();
                listUser.add(u);
                try {  
                    UserGateway.queueUpdateCase updateContact = new UserGateway.queueUpdateCase(listUser);
                    ID jobContactID = System.enqueueJob(updateContact);       
                }   catch (Exception e) {
                    System.debug('::::TestUserTrigger + queueUpdateCase ::::> ' + e.getMessage());
                }         
                try {  
                    u.Share_All_Group_Accounts__c = true;
                    UserGateway.queueCreateUserToLocation updateCase = new UserGateway.queueCreateUserToLocation(listUser);
                    ID jobCaseID = System.enqueueJob(updateCase);       
                }   catch (Exception e) {
                    System.debug('::::TestUserTrigger + queueCreateUserToLocation::::> ' + e.getMessage());
                }             
                try {  
                    u.Share_All_Group_Accounts__c = false;
                    UserGateway.queueCreateUserToLocation updateCase = new UserGateway.queueCreateUserToLocation(listUser);
                    ID jobCaseID = System.enqueueJob(updateCase);       
                }   catch (Exception e) {
                    System.debug('::::TestUserTrigger + queueCreateUserToLocation::::> ' + e.getMessage());
                }                
            }   catch (Exception e) {
                System.debug('::::TestUserTrigger + updateAccountSharing::::> ' + e.getMessage());
            } 
        }
        Test.stopTest();
    }

    @isTest
    public static void updatePartnerUserContact() {

        LIST <Account> a1 = [SELECT ID
                        , DW_ID__c
                        , GroupKey__c
                        , Name
                        FROM Account
                        WHERE GroupKey__c = '777'];

        User u = [SELECT Id
                        , FirstName
                        , LastName
                        , Email
                        , Phone
                        , MobilePhone
                        , Primary_Account_Group_Key__c
                        , Primary_Account_Number__c
                        , Share_All_Group_Accounts__c
                        , IsActive
                        , ContactId
                        , UserType
                        , Contact.Case__c
                        , Contact.Set_Up_As_Principal_ProExchange_User__c
                    FROM User
                    WHERE email = 'editor.email@editPro.com.dtest'];

        User u2 = [  SELECT Id
                        	, FirstName
                        	, LastName
                        	, Email
                        	, Phone
                        	, MobilePhone
                        	, Primary_Account_Group_Key__c
                        	, Primary_Account_Number__c
                        	, Share_All_Group_Accounts__c
                        	, IsActive
                        	, ContactId
                        	, UserType
                        	, Contact.Case__c
                        	, Contact.Set_Up_As_Principal_ProExchange_User__c
                        FROM User
                        WHERE email = 'editor.email@editPro.com.dtest'];
               
        Contact c = [   SELECT ID
                        , FirstName
                        , LastName
                        , Email
                        , Phone
                        , MobilePhone
                        , User__c
                        , Account.GroupKey__c
                        From Contact
                        Where email = 'editor.email@editPro.com.dtest'];
                        
        Case cse = [SELECT ID
                    , User__c
                    , ContactId
                    , First_Name__c
                    , Last_Name__c
                    , Email_Address__c
                    , Phone_Number__c
                    FROM Case
                    WHERE ContactId = : c.Id
                    LIMIT 1];
                    
        System.debug('::::TestUserTrigger + updatePartnerUser + c::::> ' + c);                

        Id p = [select id from profile where name='Partner Community User'].id;
        
        Contact con = [
            SELECT ID, FirstName, LastName, Email
            FROM Contact
            WHERE LastName ='testConGK'
        ];          
        User user = new User(alias = 'test123'
                             , email='test123@noemail.com'
                             , emailencodingkey='UTF-8'
                             , lastname='Testing'
                             , languagelocalekey='en_US'
                             , localesidkey='en_US'
                             , profileid = p
                             , country='United States'
                             , IsActive =true
                             , ContactId = con.Id 
                            //  , UserRoleId = r.id
                             , timezonesidkey ='America/Los_Angeles'
                             , Share_All_Group_Accounts__c = true
                             , username='tester@daltile.com.tester');
        
        insert user;   

        Test.startTest();                         
        try {        
            List <User> listUser = new List <User>();
            listUser.add(u);
            List <User> listPartnerUser = new List <User>();
            listPartnerUser.add(user);
            // update partner
            try {  
                List <User> listPartnerUser2 = new List <User>();
                User up = user;
                up.email = 'newTestPartner.email@editPro.com.dtest';
                listPartnerUser2.add(up);            
                List <Contact> listUpdatePartnerContact = UserGateway.updateUserContact(listPartnerUser, listPartnerUser2);
                upsert listUpdatePartnerContact;
            }   catch (Exception e) {
                System.debug('::::TestUserTrigger + listUpdatePartnerContact ::::> ' + e.getMessage());
            }             
            // update standard
            try {  

                List <User> listUser2 = new List <User>();
                u2.email = 'newTest2.email@editPro.com.dtest';
                listUser2.add(u2);            
                system.debug('TestUserTrigger + updateUserContact + listUser2...: ' + listUser2);
                List <Contact> listUpdateContact = UserGateway.updateUserContact(listUser, listUser2);
                upsert listUpdateContact;
            }   catch (Exception e) {
                System.debug('::::TestUserTrigger + updateUserContact ::::> ' + e.getMessage());
            }                  
        }   catch (Exception e) {
            System.debug('::::TestUserTrigger + updateAccountSharing::::> ' + e.getMessage());
        } 
        Test.stopTest();
    }

   @isTest
    public static void updatePartnerUserContactQueue() {

        LIST <Account> a1 = [SELECT ID
                        , DW_ID__c
                        , GroupKey__c
                        , Name
                        FROM Account
                        WHERE GroupKey__c = '777'];

        User u = [SELECT Id
                        , FirstName
                        , LastName
                        , Email
                        , Phone
                        , MobilePhone
                        , Primary_Account_Group_Key__c
                        , Primary_Account_Number__c
                        , Share_All_Group_Accounts__c
                        , IsActive
                        , ContactId
                        , UserType
                        , Contact.Case__c
                        , Contact.Set_Up_As_Principal_ProExchange_User__c
                    FROM User
                    WHERE email = 'editor.email@editPro.com.dtest'];

        User u2 = [  SELECT Id
                        	, FirstName
                        	, LastName
                        	, Email
                        	, Phone
                        	, MobilePhone
                        	, Primary_Account_Group_Key__c
                        	, Primary_Account_Number__c
                        	, Share_All_Group_Accounts__c
                        	, IsActive
                        	, ContactId
                        	, UserType
                        	, Contact.Case__c
                        	, Contact.Set_Up_As_Principal_ProExchange_User__c
                        FROM User
                        WHERE email = 'editor.email@editPro.com.dtest'];
               
        Contact c = [   SELECT ID
                        , FirstName
                        , LastName
                        , Email
                        , Phone
                        , MobilePhone
                        , User__c
                        , Account.GroupKey__c
                        From Contact
                        Where email = 'editor.email@editPro.com.dtest'];
                        
        Case cse = [SELECT ID
                    , User__c
                    , ContactId
                    , First_Name__c
                    , Last_Name__c
                    , Email_Address__c
                    , Phone_Number__c
                    FROM Case
                    WHERE ContactId = : c.Id
                    LIMIT 1];
                    
        System.debug('::::TestUserTrigger + updatePartnerUser + c::::> ' + c);                

        Id p = [select id from profile where name='Partner Community User'].id;
        
        Contact con = [
            SELECT ID, FirstName, LastName, Email
            FROM Contact
            WHERE LastName ='testConGK'
        ];          
        User user = new User(alias = 'test123'
                             , email='test123@noemail.com'
                             , emailencodingkey='UTF-8'
                             , lastname='Testing'
                             , languagelocalekey='en_US'
                             , localesidkey='en_US'
                             , profileid = p
                             , country='United States'
                             , IsActive =true
                             , ContactId = con.Id 
                            //  , UserRoleId = r.id
                             , timezonesidkey ='America/Los_Angeles'
                             , Share_All_Group_Accounts__c = true
                             , username='tester@daltile.com.tester');
        
        insert user;   
        List <User> listUser = new List <User>();
        listUser.add(u);
        List <User> listPartnerUser = new List <User>();
        listPartnerUser.add(user);
        // update partner
        Test.startTest();                         
        try {  
            List <User> listUser2 = new List <User>();
            List <Contact> listContact2 = new List <Contact>();
            List <Case> listCase2 = new List <Case>();
            c.email = 'testing.update.email@daltile.com';
            c.FirstName = 'UpdateFirst';
            c.LastName = 'UpdateLast';
            c.Phone = '3216522971';
            c.MobilePhone = '3216548972';
            c.User__c = null;
            u2.IsActive = false;
            listUser.add(u2);       
            listContact2.add(c);       
            listCase2.add(cse);       
            UserGateway.queueUpdateUserContact updateCase = new UserGateway.queueUpdateUserContact(listContact2,listCase2,listUser, listUser2);
            ID jobCaseUserContactID = System.enqueueJob(updateCase);       
        }   catch (Exception e) {
            System.debug('::::TestUserTrigger + queueUpdateUserContact::::> ' + e.getMessage());
        }         
        try {  
            List <User> listUser2 = new List <User>();
            List <Contact> listContact2 = new List <Contact>();
            List <Case> listCase2 = new List <Case>();
            c.email = 'newTest2.email@editPro.com.dtest';
            listUser2.add(u2);       
            listContact2.add(c);       
            listCase2.add(cse);       
            UserGateway.queueUpdateUserContact updateCase = new UserGateway.queueUpdateUserContact(listContact2,listCase2,listUser, null);
            ID jobCaseUserContactID = System.enqueueJob(updateCase);       
        }   catch (Exception e) {
            System.debug('::::TestUserTrigger + queueUpdateUserContact::::> ' + e.getMessage());
        }            
        Test.stopTest();
    }


    @isTest
    public static void updateStandardUserContactQueue() {

        LIST <Account> a1 = [SELECT ID
                        , DW_ID__c
                        , GroupKey__c
                        , Name
                        FROM Account
                        WHERE GroupKey__c = '777'];

        User u = [SELECT Id
                        , FirstName
                        , LastName
                        , Email
                        , Phone
                        , MobilePhone
                        , Primary_Account_Group_Key__c
                        , Primary_Account_Number__c
                        , Share_All_Group_Accounts__c
                        , IsActive
                        , ContactId
                        , UserType
                        , Contact.Case__c
                        , Contact.Set_Up_As_Principal_ProExchange_User__c
                    FROM User
                    WHERE email = 'AccountOwnerGuy@daltile.com.test'];

        User u2 = [  SELECT Id
                        	, FirstName
                        	, LastName
                        	, Email
                        	, Phone
                        	, MobilePhone
                        	, Primary_Account_Group_Key__c
                        	, Primary_Account_Number__c
                        	, Share_All_Group_Accounts__c
                        	, IsActive
                        	, ContactId
                        	, UserType
                        	, Contact.Case__c
                        	, Contact.Set_Up_As_Principal_ProExchange_User__c
                        FROM User
                        WHERE email = 'AccountOwnerGuy@daltile.com.test'];
               
        Contact c = [   SELECT ID
                        , FirstName
                        , LastName
                        , Email
                        , Phone
                        , MobilePhone
                        , User__c
                        , Account.GroupKey__c
                        From Contact
                        Where email = 'AccountOwnerGuy@daltile.com.test'
                        LIMIT 1];
                        
        System.debug('::::TestUserTrigger + updateStandardUserContactQueue + c::::> ' + c);                


        Test.startTest();            
        List <User> listUser = new List <User>();
        listUser.add(u);    
        // update standard       
        try {  
            List <User> listUser2 = new List <User>();
            List <Contact> listContact2 = new List <Contact>();
            List <Case> listCase2 = new List <Case>();
            u2.email = 'testing.update.email@daltile.com';
            u2.FirstName = 'UpdateFirst';
            u2.LastName = 'UpdateLast';
            u2.Phone = '3216548971';
            u2.MobilePhone = '3216548972';
            listUser.add(u2);       
            listContact2.add(c);      
            UserGateway.queueUpdateUserContact updateCase = new UserGateway.queueUpdateUserContact(listContact2,listCase2,listUser, listUser2);
            ID jobCaseUserContactID = System.enqueueJob(updateCase);       
        }   catch (Exception e) {
            System.debug('::::TestUserTrigger + updateStandardUserContactQueue + queueUpdateUserContact::::> ' + e.getMessage());
        }         
        try {  
            List <User> listUser2 = new List <User>();
            List <Contact> listContact2 = new List <Contact>();
            List <Case> listCase2 = new List <Case>();
            u2.email = 'newTest2.email@editPro.com.dtest';
            listUser.add(u2);       
            listContact2.add(c);      
            UserGateway.queueUpdateUserContact updateCase = new UserGateway.queueUpdateUserContact(listContact2,listCase2,listUser, null);
            ID jobCaseUserContactID = System.enqueueJob(updateCase);       
        }   catch (Exception e) {
            System.debug('::::TestUserTrigger + updateStandardUserContactQueue + queueUpdateUserContact::::> ' + e.getMessage());
        }            

        Test.stopTest();
    }
    
    @isTest
    public static void updatePartnerUserFuture() {

        User u = [SELECT Id
                        , FirstName
                        , LastName
                        , Email
                        , Phone
                        , MobilePhone
                        , Primary_Account_Group_Key__c
                        , Primary_Account_Number__c
                        , Share_All_Group_Accounts__c
                        , IsActive
                    FROM User
                    WHERE email = 'editor.email@editPro.com.dtest'];
               
        Contact c = [   SELECT ID
                        , FirstName
                        , LastName
                        , Email
                        , Phone
                        , MobilePhone
                        , User__c
                        From Contact
                        Where email = 'editor.email@editPro.com.dtest'];
                        
        Case cse = [SELECT ID
                    , User__c
                    , ContactId
                    , First_Name__c
                    , Last_Name__c
                    , Email_Address__c
                    , Phone_Number__c
                    FROM Case
                    WHERE ContactId = : c.Id
                    LIMIT 1];
                    
        System.debug('::::TestUserTrigger + updatePartnerUser + c::::> ' + c);                
        Test.startTest();                         

        try {  
            Contact c2 = c;
            c2.email = 'updated.and.ready@test.com';
            CaseGateway.helperUpdateCaseContact(cse.Id, 'ready for ProExchange', c2.id);
        }   catch (Exception e) {
            System.debug('::::TestUserTrigger + helperUpdateCaseContact::::> ' + e.getMessage());
        }          
        Test.stopTest();
    }
    
    @isTest
    public static void deactivatePartnerUser() {

        User u = [SELECT Id
                        , FirstName
                        , LastName
                        , Email
                        , Phone
                        , MobilePhone
                    FROM User
                    WHERE email = 'editor.email@editPro.com.dtest'];
               
        Contact c = [   SELECT ID
                        , FirstName
                        , LastName
                        , Email
                        , Phone
                        , MobilePhone
                        , User__c
                        , Set_Up_As_Principal_ProExchange_User__c
                        From Contact
                        Where email = 'editor.email@editPro.com.dtest'];
                        
        Case cse = [SELECT ID
                    , User__c
                    , ContactId
                    , First_Name__c
                    , Last_Name__c
                    , Email_Address__c
                    , Phone_Number__c
                    FROM Case
                    WHERE ContactId = : c.Id
                    LIMIT 1];
                    
        System.debug('::::TestUserTrigger + updatePartnerUser + c::::> ' + c);                
        Test.startTest();                         
        System.runAs(new User(Id=UserInfo.getUserId())) {
            try {        
    
                u.IsActive = false;
                update u;
            }   catch (Exception e) {
                System.debug('::::TestUserTrigger + updatePartnerUser::::> ' + e.getMessage());
            } 
        }
        Test.stopTest();
    }
    
    
    @isTest
    public static void createDealerUser() {
        Account a = [   SELECT ID, Name, GroupKey__c
                     FROM Account
                     WHERE Name = 'Test Internal Account'];
        
        UserContactDefaults__c ucd = [  SELECT Default_Account_Id__c, Default_Contact_Record_Type_Id__c
                                      FROM UserContactDefaults__c
                                      WHERE Default_Account_Id__c = :a.Id];

        Test.startTest();                         
        System.runAs(new User(Id=UserInfo.getUserId())) {
            try {        
                
                Id p = [select id from profile where name='SSC Statement Dealer Leadership / Principle'].id;
                
                Contact con = [
                    SELECT ID
                    FROM Contact
                    WHERE LastName ='testConGK'
                ];     
                
                Case cse = [SELECT ID
                            , User__c
                            , ContactId
                            , First_Name__c
                            , Last_Name__c
                            , Email_Address__c
                            , Phone_Number__c
                            FROM Case
                            WHERE ContactId = : con.Id];
                
                User user = new User(alias = 'test123'
                                     , email='test123@noemail.com'
                                     , emailencodingkey='UTF-8'
                                     , lastname='Testing'
                                     , languagelocalekey='en_US'
                                     , localesidkey='en_US'
                                     , profileid = p
                                     , country='United States'
                                     , IsActive =true
                                     , ContactId = con.Id
                                     , timezonesidkey ='America/Los_Angeles'
                                     , Share_All_Group_Accounts__c = true
                                     , username='tester@daltile.com.tester');
                
                insert user;   
            }   catch (Exception e) {
                System.debug('::::TestUserTrigger + createPartnerUser::::> ' + e.getMessage());
            } 
        }
        Test.stopTest();
    }
    
    
    
    @isTest
    public static void deleteUser() {
        
        Account a = [   SELECT ID, Name
                     FROM Account
                     WHERE Name = 'Test Internal Account'];
        
        UserContactDefaults__c ucd = [  SELECT Default_Account_Id__c, Default_Contact_Record_Type_Id__c
                                      FROM UserContactDefaults__c
                                      WHERE Default_Account_Id__c = :a.Id];
        
        User u = [SELECT Id
                        , FirstName
                        , LastName
                        , Email
                        , Phone
                        , MobilePhone
                        , Primary_Account_Group_Key__c
                        , Primary_Account_Number__c
                        , Share_All_Group_Accounts__c
                        , IsActive
                    FROM User
                    WHERE email = 'editor.email@editPro.com.dtest'];        
        
        Test.startTest();                         
        

        System.runAs(new User(Id=UserInfo.getUserId())) {
            try {
                u.IsActive = false;
                update u;
                // 			delete 	u;
            }   catch (Exception e) {
                System.debug('::::TestUserTrigger + deleteUser ::::> ' + e.getMessage());
            } 
        }
        Test.stopTest();
    }
    
    @isTest
    public static void addUserInGroup(){
        Account a = [   SELECT ID, Name, GroupKey__c
                     FROM Account
                     WHERE Name = 'Test Internal Account'];
        
        UserContactDefaults__c ucd = [  SELECT Default_Account_Id__c, Default_Contact_Record_Type_Id__c
                                      FROM UserContactDefaults__c
                                      WHERE Default_Account_Id__c = :a.Id];
        
        Test.startTest();                         
        try {        
            
            Id p = [select id,UserType from profile where name='SSC Statement Dealer Sales Rep'].id;
            
            Contact con = [
                SELECT ID
                FROM Contact
                WHERE LastName ='testConGK'
            ];          
            User user = new User(alias = 'test1232'
                                 , IsActive = true
                                 , email='test1223@noemail.com'
                                 , emailencodingkey='UTF-8'
                                 , lastname='Testing'
                                 , languagelocalekey='en_US'
                                 , localesidkey='en_US'
                                 , profileid = p
                                 , country='United States'
                                 , ContactId = con.Id 
                                 , timezonesidkey ='America/Los_Angeles'
                                 , Share_All_Group_Accounts__c = true
                                 , username='sscUser@daltile.com.tester');
            
            insert user; 

        }   catch (Exception e) {
            System.debug('::::TestUserTrigger + addUserInGroup + createSSCPartnerUser::::> ' + e.getMessage());
        }    
        Test.stopTest();
    }                        
     
    @isTest
    public static void adHocUserInGroup(){

        List <User> listUser = [SELECT Id, Primary_Account_Group_Key__c, Share_All_Group_Accounts__c, Primary_Account_Number__c, isActive From User WHERE username='sscUser@daltile.com.tester'];
        System.debug('::::TestUserTrigger + adHocUserInGroup + listUser::::> ' + listUser);
    
        Test.startTest();                         
        try {        
            List <User_to_Location__c> listUserToLocation = new List <User_to_Location__c>();
            listUserToLocation = UserGateway.createUserToLocation(listUser);
            System.debug('::::TestUserTrigger + adHocUserInGroup + listUserToLocation::::> ' + listUserToLocation);
            
        }   catch (Exception e) {
            System.debug('::::TestUserTrigger + adHocUserInGroup + createSSCPartnerUser::::> ' + e.getMessage());
        } 
        Test.stopTest();
    }    
}