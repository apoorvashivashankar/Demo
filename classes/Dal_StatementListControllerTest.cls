@isTest(SeeAllData=false)
public class Dal_StatementListControllerTest {
    
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
        Account account = [SELECT Id,DW_ID__c FROM Account WHERE DW_ID__c != null];
        String uniqueName = Dal_TestUtils.getUserString();
        User newUser = new User(profileId = p.id, username = uniqueName + '@test.org', email = 'pb@ff.com',
                                emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                timezonesidkey = 'America/Los_Angeles', alias='nuser', lastname='lastname', 
                                Selected_Location__c = account.Id, contactId = contact.id
                               );
        insert newUser;
        
        DT_SYS_Account_Statement__x dtsys = new DT_SYS_Account_Statement__x(
       		FileName__c = 'test'
        );
        
        Dal_StatementListController.mockedAccountStatement.add(dtsys);
        
        Test.startTest();
          System.runAs(newUser){
            Date startDate = Date.newInstance(2018, 3, 8);
            Date endDate = Date.newInstance(2018, 3, 25);
            
            //Dal_StatementListController.StatementsWrapper resp = Dal_StatementListController.getStatementSummarybyCustomer(1000);
            //System.assert(true, resp);
            //Dal_StatementListController.StatementsWrapper response = Dal_StatementListController.getStatementSummarybyDate(startDate, endDate, 1000);
        	//System.assert(true, response);
          } 
        Test.stopTest();  	
    }
    static testmethod void runNegativestatementSummarybyCustomerTest(){

        Profile p = [select Id,name from Profile where name='Customer Community Plus Login User'];
        String uniqueName = Dal_TestUtils.getUserString();
        Contact contact = [SELECT Id FROM Contact];
        Account account = [SELECT Id,DW_ID__c,PayerAccount__c FROM Account WHERE DW_ID__c != null];
        Integer listLimit = 100;
        User newUser = new User(profileId = p.id, username = uniqueName + '@test.org', email = 'pb@ff.com',
                                emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                timezonesidkey = 'America/Los_Angeles', alias='nuser', lastname='lastname', 
                                Selected_Location__c = account.Id, contactId = contact.id
                               );
        insert newUser;
        
        Test.startTest();
          System.runAs(newUser){
            Date startDate = Date.newInstance(2018, 3, 8);
            Date endDate = Date.newInstance(2018, 3, 25);
            Dal_StatementListController.StatementsWrapper resp = Dal_StatementListController.getStatementSummarybyCustomer(listLimit);
            System.assert(true, resp);
            Dal_StatementListController.StatementsWrapper response =Dal_StatementListController.getStatementSummarybyDate(startDate, endDate, listLimit);
            System.assert(true, response);
          } 
        Test.stopTest();  	
    }
}