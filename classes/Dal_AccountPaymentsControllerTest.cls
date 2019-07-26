@isTest(seeAllData=false)
public class Dal_AccountPaymentsControllerTest {
    
    @testSetup
    static void testsetup(){ 
         UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType ='None' limit 1];
        update new User(Id=userInfo.getUserId(), UserRoleId = ur.Id);

        system.runAs(new User(Id=userInfo.getUserId())) {
        Contact con = Dal_TestUtils.createTestContact();  
        
        List<SSC__c> sscList = new List<SSC__c>();
        SSC__c ssc = new SSC__c();
        ssc.Name = 'SSC Account';
        sscList.add(ssc);
        insert sscList;
        
        Account account = new Account();
        account.Id = con.AccountId;
        account.SSC__c = ssc.Id;  
        account.DW_ID__c = '00880021';
        update account;
        
        
        
        
        UserContactDefaults__c userCont = new UserContactDefaults__c();
        userCont.Default_Account_Id__c = con.AccountId;
        userCont.Default_Contact_Record_Type_Id__c = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Daltile Internal Contact').getRecordTypeId();
        insert userCont;
        }
    }
    static testmethod void statementSummarybyCustomerTest(){
        
        Profile p = [select Id,name from Profile where name='Customer Community Plus Login User'];
        
        Contact contact = [SELECT Id FROM Contact];
        Account account = [SELECT Id FROM Account];
         String uniqueName = Dal_TestUtils.getUserString(); 
        
        User newUser = new User(profileId = p.id, username = uniqueName + '@test.org' , email = uniqueName + '@test.org',
                                emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                timezonesidkey = 'America/Los_Angeles', alias='nuser', lastname='lastname', 
                                Selected_Location__c = account.Id, contactId = contact.id
                               );
        insert newUser;
        
        DT_SYS_Account_Payment__x dtSAP = new DT_SYS_Account_Payment__x(
            Customer__c = '00880021',         
            GrossAmount__c = 123.00,
            ReferenceNo__c = '123456'
        );
        
        Dal_AccountPaymentsController.mockedAccountPayment.add(dtSAP);
        Test.startTest();
        System.runAs(newUser){
            Peak_Response response = Dal_AccountPaymentsController.getPaymentSummary(100); 
            System.assert(response != null);
            System.assertEquals(true, response.success);
        }        
        Test.stopTest();
    }
    static testmethod void runNegativeStatementSummarybyCustomerTest(){
        
        Profile p = [select Id,name from Profile where name='Customer Community Plus Login User'];
       
        Contact contact = [SELECT Id FROM Contact];
        Account account = [SELECT Id FROM Account];
         String uniqueName = Dal_TestUtils.getUserString(); 
        
        User newUser = new User(profileId = p.id, username = uniqueName + '@test.org' , email = uniqueName + '@test.org',
                                emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                timezonesidkey = 'America/Los_Angeles', alias='nuser', lastname='lastname', 
                                Selected_Location__c = account.Id, contactId = contact.id 
                               );
        insert newUser;
        
        Test.startTest();
        System.runAs(newUser){
            Peak_Response response = Dal_AccountPaymentsController.getPaymentSummary(100); 
            System.assert(response != null);
            System.assertEquals(false, response.success);
        } 
        Test.stopTest();
    }
}