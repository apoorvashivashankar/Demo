/**
* This class contains unit tests for validating the behavior of Apex classes
**/
@isTest(seeAllData=false)
public class Dal_LiveAgentControllerTest {
	@TestSetup
    static void datasetup(){
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
            
            Profile p = [select Id,name from Profile where name='Customer Community Plus Login User'];
            String uniqueName = Dal_TestUtils.getUserString(); 
            User newUser = new User(profileId = p.id, username = uniqueName + '@test.org', email = 'pb@ff.com',
                                    emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                    timezonesidkey = 'America/Los_Angeles', alias='nuser', lastname='lastname', 
                                    Selected_Location__c = con.accountId, contactId = con.id
                                   );
            insert newUser;
        }
    }
    static testMethod void getLiveAgent(){ 
      	User newUser = [SELECT Id,username,contactId,email FROM User WHERE email = 'pb@ff.com']; 
        System.runAs(newUser){
            Dal_LiveAgentController.getContact(newUser.contactId);
        }
    }
    static testMethod void getLiveAgent2(){ 
        Contact contact = [SELECT Id FROM Contact LIMIT 1];  
        Dal_LiveAgentController.getContact(contact.Id);
    }
}