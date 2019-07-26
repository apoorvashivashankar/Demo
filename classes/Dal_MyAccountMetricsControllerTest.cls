/**
* Created by 7Summits on 3/2/18.
*/

@isTest(SeeAllData = false)
private without sharing class Dal_MyAccountMetricsControllerTest {
    @TestSetup
    private static void testSetup(){   
         UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType ='None' limit 1];
        update new User(Id=userInfo.getUserId(), UserRoleId = ur.Id);

        system.runAs(new User(Id=userInfo.getUserId())){
        Contact con = Dal_TestUtils.createTestContact();  
        
        List<SSC__c> sscList = new List<SSC__c>();
        SSC__c ssc = new SSC__c();
        ssc.Name = 'SSC Account';
        sscList.add(ssc);
        insert sscList;
        
        Account account = new Account();
        account.Id = con.AccountId;
        account.SSC__c = ssc.Id;        
        update account;
        
        UserContactDefaults__c userCont = new UserContactDefaults__c();
        userCont.Default_Account_Id__c = con.AccountId;
        userCont.Default_Contact_Record_Type_Id__c = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Daltile Internal Contact').getRecordTypeId();
        insert userCont;
    }
    }
    @isTest
    public static void testGetAccountSummary(){
        
        Profile p = [select Id,name from Profile where name='Customer Community Plus Login User'];
      
        Contact contact = [SELECT Id FROM Contact];
        Account account = [SELECT Id FROM Account];
        String uniqueName = Dal_TestUtils.getUserString();
        User newUser = new User(profileId = p.id, username = uniqueName + '@test.org' , email = 'pb@ff.com',
                                emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                timezonesidkey = 'America/Los_Angeles', alias='nuser', lastname='lastname', 
                                Selected_Location__c = account.Id, contactId = contact.id
                               );
        insert newUser;
        
        Test.startTest();
        System.runAs(newUser){
            Peak_Response response = Dal_MyAccountMetricsController.getAccountSummary();
            System.assert(response != null);
            System.assertEquals(false, response.success);
        } 
        Test.stopTest();
        
    }
    static testMethod void runNegativeGetAccountSummary(){
        Test.startTest(); 
        Peak_Response response = Dal_MyAccountMetricsController.getAccountSummary();
        System.assertEquals(false, response.success);
        Test.stopTest();
    }
}