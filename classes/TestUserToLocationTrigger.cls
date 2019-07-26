@isTest
private class TestUserToLocationTrigger {


    @testSetup static void testSetup() { 
        
        TriggerControl__c settingUserTrigger = new TriggerControl__c();
            settingUserTrigger.Name = 'UserTrigger';
            settingUserTrigger.IsActive__c = TRUE;
        insert settingUserTrigger;        
        
        TriggerControl__c settingUserToLocationTrigger = new TriggerControl__c();
            settingUserToLocationTrigger.Name = 'UserToLocationTrigger';
            settingUserToLocationTrigger.IsActive__c = TRUE;
        insert settingUserToLocationTrigger;        

        Account a1 = new Account();
        a1.Name = 'Test Daltile Internal Account';
        insert a1;
        
        String contactRecordTypeID = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Standard Contact').getRecordTypeId();
        
        UserContactDefaults__c ucd = new UserContactDefaults__c(Default_Account_Id__c = a1.Id
                                                               ,Default_Contact_Record_Type_Id__c = contactRecordTypeID
                                                               ,Maximum_SSC_Distance__c = 200);
        insert ucd;

        Account a = new Account();
        a.Name = 'test account';
        a.GroupKey__C = '777';
        a.DW_ID__c = '777';
        insert a;
        
        Contact ctP = new Contact();
            ctP.FirstName = 'Jon';
            ctP.LastName = 'Partner';
            ctP.AccountId = a.Id;
            ctP.Email = 'Partner.test@tester.com.test';
            ctP.Phone = '3216549871';
        insert ctP;        
        
        User userP;
        System.runAs(new User(Id=UserInfo.getUserId())) {

            Profile pPart = [select id from Profile where name='Partner Community User' limit 1];
           
            userP = new User(alias = 'test123'
                                , email='Partner.test@tester.com.test'
                                , emailencodingkey='UTF-8'
                                , lastname='Partner'
                                , firstname = 'Jon'
                                , languagelocalekey='en_US'
                                , localesidkey='en_US'
                                , profileid = pPart.Id
                                , country='United States'
                                , IsActive =true
                                , ContactId = ctP.Id 
                                , timezonesidkey ='America/Los_Angeles'
                                , Share_All_Group_Accounts__c = true
                                , username='Partner.test@tester.com.test');
           
            insert userP;                
        }        
    }
    
    @isTest static void testUserToLocation() {
        
        Account a = [   SELECT ID
                        FROM Account
                        WHERE NAME = 'test account'
        ];

        
        User u = [ SELECT ID
                        FROM User
                        WHERE LastName = 'Partner'
        ];        
        
        Test.startTest();   
        
        User_to_Location__c ul = new User_to_Location__c (Account__c = a.id, User__c = u.Id, User_to_Location_Key__c = 'varKey');        
        insert ul;
        
        ul.User_to_Location_Key__c = 'new.varKey';
        update ul;
        
        delete ul;
        
        Test.stopTest();   
    }
            

}