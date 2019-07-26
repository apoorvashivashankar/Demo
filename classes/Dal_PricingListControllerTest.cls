/**
* This class contains unit tests for validating the behavior of Apex classes
**/
@isTest(seeAllData=false)
public class Dal_PricingListControllerTest {
    
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
        account.DW_ID__c = null;
        update account;
        
        UserContactDefaults__c userCont = new UserContactDefaults__c();
        userCont.Default_Account_Id__c = con.AccountId;
        userCont.Default_Contact_Record_Type_Id__c = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Daltile Internal Contact').getRecordTypeId();
        insert userCont;
        }
	}
    static testmethod void getPriceRecordsByDateTest(){
        
        Profile p = [select Id,name from Profile where name='Customer Community Plus Login User'];
        String uniqueName = Dal_TestUtils.getUserString();
        Contact contact = [SELECT Id FROM Contact];
        Account account = [SELECT Id,DW_ID__c FROM Account];
        DateTime datetimes = null;
        DateTime dateValue = datetime.newInstance(2014, 9, 15, 12, 30, 0);
        String promotionId = 'A88912242P6';
        String description = 'description for test';
        Integer recordLimit = 100;
        User newUser = new User(profileId = p.id, username = uniqueName + '@test.org', email = 'pb@ff.com',
                                emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                timezonesidkey = 'America/Los_Angeles', alias='nuser', lastname='lastname', 
                                Selected_Location__c = account.Id, contactId = contact.id
                               );
        insert newUser;
        
        Test.startTest();
        System.runAs(newUser){
            List<DT_SYS_PriceRecord__x> getAllPriceRecord =  Dal_PricingListController.getAllPriceRecord(null, recordLimit);
            System.assert(true, getAllPriceRecord);
            List<DT_SYS_PriceRecord__x> priceRecordList =  Dal_PricingListController.getPriceRecordsForCustomerByDate(account.DW_ID__c, datetimes, recordLimit);
            System.assert(true, priceRecordList);   
            List<DT_SYS_PriceConditionDetails__x> getMaterialByDate = Dal_PricingListController.getMaterialRecordsByDate(promotionId, dateValue, recordLimit);
            System.assert(true, getMaterialByDate); 
            List<DT_SYS_PriceConditionDetails__x> searchMaterial = Dal_PricingListController.searchMaterialRecords(promotionId, dateValue, promotionId, description, recordLimit);
       		System.assert(true, searchMaterial); 
        } 
        Test.stopTest();
    }
}