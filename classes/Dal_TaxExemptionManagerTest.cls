/**
 * Created by Preshit on 31-01-2019.
 */
@isTest
public with sharing class Dal_TaxExemptionManagerTest {

    @testSetup
    static void testSetup(){
        UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType ='None' limit 1];
        update new User(Id=userInfo.getUserId(), UserRoleId = ur.Id);


        System.runAs(new user(ID = UserInfo.getUserID())) {
            Contact con = Dal_TestUtils.createTestContact();

            Account account = new Account();
            account.Id = con.AccountId;
            account.DW_ID__c = '00880021';
            update account;

            UserContactDefaults__c userCont = new UserContactDefaults__c();
            userCont.Default_Account_Id__c = con.AccountId;
            userCont.Default_Contact_Record_Type_Id__c = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Daltile Internal Contact').getRecordTypeId();
            insert userCont;
            Profile p = [select Id,name from Profile where name='Customer Community Plus Login User'];

            User newUser = new User(profileId = p.id, username = 'newUser@yahoo.com', email = 'pb@ff.com',
                    emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                    timezonesidkey = 'America/Los_Angeles', alias='nuser', lastname='lastname',
                    Selected_Location__c = con.accountId, contactId = con.id
            );
            insert newUser;
        }

    }

    private static testMethod void Dal_getTaxExemptionTest(){

        User newUser = [SELECT Id,username FROM User WHERE Username = 'newUser@yahoo.com'];

        Test.startTest();
        System.runAs(newUser){

            Test.setMock(WebServiceMock.class, new WebServiceMockDalTaxExemption());

            String Customer = 'test';

            Dal_TaxExemptionManager dalTaxExemptionManager = new Dal_TaxExemptionManager(Customer);
            dalTaxExemptionManager.getTaxExemption();

        }
        Test.stopTest();
    }

}