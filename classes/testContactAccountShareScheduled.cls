@isTest
private class testContactAccountShareScheduled {
    
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    static PageReference pageRef;
    
    @testSetup static void testSetup() { 
        
        TriggerControl__c settingUserTrigger = new TriggerControl__c();
            settingUserTrigger.Name = 'UserTrigger';
            settingUserTrigger.IsActive__c = TRUE;
        insert settingUserTrigger;        

        Account a = new Account();
        a.Name = 'test account';
        insert a;
        
        Account a1 = new Account();
        a1.Name = 'Daltile Internal Communications';
        insert a1;
        
        Account a2 = new Account();
        a2.Name = 'test groupkey account 1';
        a2.DW_ID__C = '321123';
        a2.GroupKey__C = '123';
        insert a2;
        
        Account a3 = new Account();
        a3.Name = 'test groupkey account 2';
        a2.DW_ID__C = '654123';
        a3.GroupKey__C = '123';
        insert a3;
        
        Contact ct = new Contact();
            ct.FirstName = 'Jon';
            ct.LastName = 'Test';
            ct.AccountId = a.Id;
            ct.Email = 'testingsome@tester.com.test';
            ct.Phone = '3216549871';
        insert ct;        
        
        Contact ctP = new Contact();
            ctP.FirstName = 'Jon';
            ctP.LastName = 'Partner';
            ctP.AccountId = a.Id;
            ctP.Email = 'Partner.test@tester.com.test';
            ctP.Phone = '3216549871';
        insert ctP;        
        
        Contact ct2 = new Contact();
            ct2.FirstName = 'GroupKey';
            ct2.LastName = 'TestGroupKey';
            ct2.AccountId = a2.Id;
            ct2.Email = 'testingsome@tester.com.test';
            ct2.Phone = '3216549871';
        insert ct2;        
        
        UserContactDefaults__c ucd = new UserContactDefaults__c(Default_Account_Id__c = a1.Id
                                                               ,Default_Contact_Record_Type_Id__c = '012F0000000msd2');
        insert ucd;        
        
        User uMGR1;
        User userP;
        System.runAs(new User(Id=UserInfo.getUserId())) {
            UserRole rMGR = [SELECT Id, Name FROM UserRole WHERE Name LIKE '%SSC Manager' LIMIT 1];           

            Profile pMGR = [Select id 
                            From Profile
                            where UserType = 'Standard'
                            and Name = 'SSC Manager'
                            limit 1];        
            uMGR1 = new User(alias = 'MGR1'
                            , email= 'AccountOwnerGuy@daltile.com'
                            , emailencodingkey='UTF-8'
                            , lastname='Owner'
                            , firstname='Account'
                            , languagelocalekey='en_US'
                            , localesidkey='en_US'
                            , timezonesidkey='GMT'
                            , ProfileId = pMGR.Id
                            , UserRoleId = rMGR.Id
                            , username = 'MGR1@daltile.com.test');
            insert uMGR1;       

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
    
    
    @isTest static void testAccountShareUserToLocationBatch() {
        
        System.debug('testAccountShareUserToLocationBatch:...');
        
        Account a = [   SELECT ID
                        FROM Account
                        WHERE NAME = 'test account'
        ];
        User u = [ SELECT ID
                        FROM User
                        WHERE LastName = 'Owner'
        ];
        
        Contact c = [ SELECT ID
                        FROM Contact
                        WHERE LastName = 'Partner'
        ];
        Test.startTest();   
        
        AccountShare accShare = new AccountShare(AccountId=a.Id, userorgroupid=u.Id, accountaccesslevel='Read', OpportunityAccessLevel='Read');
        insert accShare;
        
        List <AccountShare> listAccountShare = [ SELECT AccountId,Account.DW_ID__c,UserOrGroupId,UserOrGroup.Name,Id
                                                FROM AccountShare
                                                WHERE AccountId = : a.Id
                                                AND UserOrGroupId = : u.Id];
        
        System.debug('testAccountShareUserToLocationBatch + listAccountShare:...' + listAccountShare);
        
        //Call the static method directly
        String jobId = System.schedule('ScheduledApexTest', CRON_EXP, new ContactAccountShareScheduled());

        AccountShareUserToLocationBatch accShareBatch = new AccountShareUserToLocationBatch();
        Database.executeBatch(accShareBatch); 

        accShareBatch.execute(null,listAccountShare);
        pageRef = Page.ContactAccountSharing;
        pageRef.getParameters().put('id',c.id);
        Test.setCurrentPage(pageRef);       
        
        ApexPages.StandardController testController = new ApexPages.StandardController(c);
        ContactSharingController con = new ContactSharingController(testController);         
        
        Test.stopTest();        
        
        
    
    }
    
}