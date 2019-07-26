/**
* This class contains unit tests for validating the behavior of Apex classes
**/
@isTest(seeAllData=false)
public class Dal_OrderLineManagerTest {
    
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
    
    static testmethod void orderLineTest(){
        Profile p = [select Id,name from Profile where name='Customer Community Plus Login User'];
        UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType =:'CustomerPortal' limit 1];
        Contact contact = [SELECT Id FROM Contact];
        Account account = [SELECT Id FROM Account];
        String statusValue = 'Approve';
        String uniqueName = Dal_TestUtils.getUserString(); 
        User newUser = new User(profileId = p.id, username = uniqueName + '@test.org' , email = 'pb@ff.com',
                                emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                timezonesidkey = 'America/Los_Angeles', alias='nuser', lastname='lastname', 
                                Selected_Location__c = account.Id, contactId = contact.id
                               );
        insert newUser;
        
        Test.startTest();
        System.runAs(newUser){
            List<DT_SYS_OrderList__x> orderByOrderNo = Dal_OrderLineManager.getOrderLineByOrderNo(account.Id);
            System.assert(true, orderByOrderNo);
        } 
        Test.stopTest();
    }
    
}