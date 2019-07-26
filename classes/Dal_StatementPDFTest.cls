@isTest
public class Dal_StatementPDFTest {
    
    @testSetup
    static void testSetup(){
        UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType ='None' limit 1];
        update new User(Id=userInfo.getUserId(), UserRoleId = ur.Id);
        
         System.runAs(new user(ID = UserInfo.getUserID())) {
      	Contact con = Dal_TestUtils.createTestContact();  
        
        Account account = new Account();
        account.Id = con.AccountId;
        account.DW_ID__c = '008082001';
        account.SAP_Account_Id__c = '000000002';
        update account;
        
        UserContactDefaults__c userCont = new UserContactDefaults__c();
        userCont.Default_Account_Id__c = con.AccountId;
        userCont.Default_Contact_Record_Type_Id__c = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Daltile Internal Contact').getRecordTypeId();
        insert userCont;  
         }
    }
    static testmethod void statementpdftest() {
        Profile p = [select Id,name from Profile where name='Customer Community Plus Login User'];
        
        Contact contact = [SELECT Id FROM Contact];
        System.assertNotEquals(null, contact);
        Account account = [SELECT Id,DW_ID__c FROM Account WHERE DW_ID__c != null];
        System.assertNotEquals(null, account);
        String uniqueName = Dal_TestUtils.getUserString();
        User newUser = new User(profileId = p.id, username = uniqueName + '@test.org', email = 'pb@ff.com',
                                emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                timezonesidkey = 'America/Los_Angeles', alias='nuser', lastname='lastname', 
                                Selected_Location__c = account.Id, contactId = contact.id
                               );
        insert newUser;
        
        Test.startTest();
        System.runAs(newUser){
            String files = '000000002_8055_20140303';
            String sdate = 'date';
          
            ApexPages.currentPage().getParameters().put('filename', files);
            ApexPages.currentPage().getParameters().put('sdate', sdate);
            Dal_StatementPDF dal_statement = new Dal_StatementPDF(); 
            System.assertEquals('000000002', dal_statement.payer);            
        } 
        Test.stopTest();
    }  

}