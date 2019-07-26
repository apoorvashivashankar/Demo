@isTest
public without sharing class Dal_UserTriggerHandlerTest {
    
    @isTest
    static void testInsert(){
        
        User objUser = [select Id from User where Profile.Name = 'System Administrator' and isActive = true and UserRoleId != null limit 1];
        
        System.runAs(objUser) {
        
        User testUser = Peak_TestUtils.createStandardUser();
        
        Account testAccount2 = new Account (Name='Test Account2', GroupKey__c='111111', Division__c='Test');
        insert testAccount2;
        
        UserContactDefaults__c testSetting = new UserContactDefaults__c(Default_Account_Id__c=testAccount2.Id, Default_Contact_Record_Type_Id__c='012F0000000msd2');
        insert testSetting;
        
        Account testAccount = [Select GroupKey__c
                               FROM Account
                               WHERE Name = 'Test Account'];
        testAccount.GroupKey__c = '111111';
        update testAccount; 
        
        
        
            test.startTest();
            testUser.Share_All_Group_Accounts__c = true;
            insert testUser;
            test.stopTest();
            
            list <AccountShare> accShares = [Select AccountId
                                             FROM AccountShare
                                             WHERE UserOrGroupId = :testUser.Id];
            
          //  system.assert(accShares.size() == 2); 
        }
    }
}