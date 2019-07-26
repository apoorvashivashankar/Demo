/**
* This class contains unit tests for validating the behavior of Apex classes
**/
@isTest(SeeAllData=false)
public with sharing class Dal_PriceRecordManagerTest {
    
    @testSetup
    static void testSetup(){
          UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType ='None' limit 1];
        update new User(Id=userInfo.getUserId(), UserRoleId = ur.Id);

        system.runAs(new User(Id=userInfo.getUserId())) {
        Contact con = Dal_TestUtils.createTestContact();  
        
        DT_Order__c  order = new DT_Order__c ();
        order.Name = 'FirstOrder';
        insert order;
        
        Account account = new Account();
        account.Id = con.AccountId;
        account.DW_ID__c = '00880021';
        update account;
        
        UserContactDefaults__c userCont = new UserContactDefaults__c();
        userCont.Default_Account_Id__c = con.AccountId;
        userCont.Default_Contact_Record_Type_Id__c = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Daltile Internal Contact').getRecordTypeId();
        insert userCont;
    }
        
    }
    
    static testMethod void priceRecordTest() {
        Profile p = [select Id,name from Profile where name='Customer Community Plus Login User'];
        
        Contact contact = [SELECT Id FROM Contact];
        Account account = [SELECT Id,DW_ID__c FROM Account];
        DateTime datetimes = datetime.newInstance(2014, 9, 15, 12, 30, 0);
          String uniqueName = Dal_TestUtils.getUserString(); 
        User newUser = new User(profileId = p.id, username = uniqueName + '@test.org' , email = 'pb@ff.com',
                                emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                timezonesidkey = 'America/Los_Angeles', alias='nuser', lastname='lastname', 
                                Selected_Location__c = account.Id, contactId = contact.id
                               );
        insert newUser;
        
        Test.startTest();
        System.runAs(newUser){
            List<DT_SYS_PriceRecord__x> allPriceRecord = Dal_PriceRecordManager.getAllPriceRecord(account.DW_ID__c, 1000);
            System.assert(true, allPriceRecord);
            List<DT_SYS_PriceRecord__x> priceRecordByDate = Dal_PriceRecordManager.getPriceRecordByDate(account.DW_ID__c, datetimes, 1000);
            System.assert(true, priceRecordByDate);
            List<DT_SYS_PriceConditionDetails__x> searchPromotionDetails = Dal_PriceRecordManager.searchPromotionDetails('A88912242P6', datetimes, 'A88912242P6', 'AOLAMADELN', 1000);
            System.assert(true, searchPromotionDetails);
            List<DT_SYS_PriceConditionDetails__x> priceDetail = Dal_PriceRecordManager.getPromotionDetail('AOLAMADELN', 1000);
            System.assert(true, priceDetail);
        } 
        Test.stopTest();       
    } 
}