/**
* Created by 7Summits on 3/15/18
*/
@isTest(seeAllData=false)
public with sharing class Dal_MySalesRepControllerTest {
    
    @testSetup
    static void testsetup(){
        UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType ='None' limit 1];
        update new User(Id=userInfo.getUserId(), UserRoleId = ur.Id);

        system.runAs(new User(Id=userInfo.getUserId())) {
        Contact con = Dal_TestUtils.createTestContact();  
        
        Sales_Representative__c salesRep = new Sales_Representative__c();
        salesRep.Name = 'Salesman';
        insert salesRep;
        
        Account account = new Account();
        account.Name = 'TestSales';
        account.Id = con.AccountId;
        account.Salesman__c = salesRep.Id;
        account.DW_ID__c = '008082001';
        update account; 
        
        UserContactDefaults__c userCont = new UserContactDefaults__c();
        userCont.Default_Account_Id__c = con.AccountId;
        userCont.Default_Contact_Record_Type_Id__c = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Daltile Internal Contact').getRecordTypeId();
        insert userCont; 
    }
    }
    
    static testmethod void SalesRep() { 
        Profile p = [select Id,name from Profile where name='Customer Community Plus Login User'];
        
        Contact contact = [SELECT Id, AccountId FROM Contact LIMIT 1];
        String uniqueName = Dal_TestUtils.getUserString(); 
        User newUser = new User(profileId = p.id, username = uniqueName + '@test.org' , email = 'pb@ff.com',
                                emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                timezonesidkey = 'America/Los_Angeles', alias='nuser',firstname='firstname', lastname='lastname', 
                                contactId = contact.id, Selected_Location__c = contact.AccountId
                               );
        insert newUser;   
        
        Test.startTest();    
        
        System.runAs(newUser){
            Peak_Response response = Dal_MySalesRepController.getMyCustomerCreditRep();
            System.assert(true, response);
            Peak_Response response1 = Dal_MySalesRepController.getMyCustomerSalesRep();
            System.assert(true, response1);
        }	 
        Test.stopTest();       
        
    }    
    static testmethod void SalesRep_Two() { 
        Profile p = [select Id,name from Profile where name='Customer Community Plus Login User'];
        Contact contact = [SELECT Id, AccountId FROM Contact LIMIT 1];
       String uniqueName = Dal_TestUtils.getUserString();
        User newUser = new User(profileId = p.id, username = uniqueName + '@test.org' , email = 'pb@ff.com',
                                emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                timezonesidkey = 'America/Los_Angeles', alias='nuser',firstname='firstname', lastname='lastname', 
                                contactId = contact.id
                               );
        insert newUser;   
        
        Test.startTest();    
        
        System.runAs(newUser){
            Peak_Response response = Dal_MySalesRepController.getMyCustomerCreditRep();
            System.assert(true, response);
            Peak_Response response1 = Dal_MySalesRepController.getMyCustomerSalesRep();
            System.assert(true, response1);
        }	 
        Test.stopTest();       
        
    }   
    
     static testmethod void SalesRep_Three() {
         Test.startTest();   
             Account acc = [Select id,Name from Account];
             Dal_MySalesRepController.selectedAccount = null;
             List<Peak_Response> peakLst = Dal_MySalesRepController.getMyCustomerCreditAndSalesRep(); 
         Test.stopTest();      
     }
    
     
}