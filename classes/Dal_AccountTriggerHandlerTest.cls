@isTest
public with sharing class Dal_AccountTriggerHandlerTest {

    @testSetup
    static void testsetup(){
        
        UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType ='None' limit 1];
        update new User(Id=userInfo.getUserId(), UserRoleId = ur.Id);

        system.runAs(new User(Id=userInfo.getUserId())) {
        User testUser = Peak_TestUtils.createStandardUser();
        System.runAs(new User(Id = UserInfo.getUserId())) {

            list <Account> testAccounts = new list <Account>();

            insert testUser;

            Account acc = [Select Id, GroupKey__c FROM Account WHERE Name = 'Test Account'];
            acc.GroupKey__c = '111111';
            update acc;

            test.startTest();

            for (integer i=0; i<5; i++){
                Account testAcc = new Account(Name = 'Test Account2', GroupKey__c = '111111', Division__c = 'Test');
                testAccounts.add(testAcc);
            }

            insert testAccounts;

            UserContactDefaults__c testSetting = new UserContactDefaults__c(Default_Account_Id__c=testAccounts[0].Id, Default_Contact_Record_Type_Id__c='012F0000000msd2');
            insert testSetting;

            test.stopTest();

            list <AccountShare> accShares = [Select AccountId
            FROM AccountShare
            WHERE UserOrGroupId = :testUser.Id];

            //system.assert(accShares.size() == 5);
        }
    }
    }
    
    static testMethod void generateSharingMethod(){
              
        List<Account> accList = [Select Id,GroupKey__c from Account limit 1];
        
		Dal_AccountTriggerHandler.generateSharing(accList);
        
    }
   
}