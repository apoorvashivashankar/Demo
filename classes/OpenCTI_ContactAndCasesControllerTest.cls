/** /** * * * * * * * * * * * *
*  Class Name:   OpenCTI_ContactAndCasesControllerTest
*  Purpose:      Test class for OpenCTI_ContactAndCasesController
*  Author:       Md Yaqub
*  Updated Date: Dec-28-2018
*  Type:         Test Class
** * * * * * * * * * * * */
@istest
public with sharing class OpenCTI_ContactAndCasesControllerTest {
    
    static final String CSR_CASE_RECORD_TYPE = 'CSR_Case';
    
    
    @testSetup
    static void dataSetup() {
        List<Account> accountList = new List<Account>();
        List<Contact> contactList = new List<Contact>();
        List<case> caseList = new List<case>();
        List<AccountContactRelation> ACRLisT = new List<AccountContactRelation>();
        
        //Account data
        Account accountObj = new Account();
        accountObj.Name = 'TestAccount';
        accountObj.BillingCity = 'TestCity';
        accountObj.AccountNumber = '0879290';
        accountObj.Customer_Base__c = '08792900';
        accountObj.BillingState = 'TestState';
        accountObj.BillingStreet = 'TestStreet';
        accountObj.BillingCountry = 'TestCountry';
        accountObj.BillingPostalCode = '12345';  
        accountList.add(accountObj);
        
        Account accountObj1 = new Account();
        accountObj1.Name = 'TestAccount1';
        accountObj1.BillingCity = 'TestCity1';
        accountObj1.BillingState = 'TestState1';
        accountObj1.BillingStreet = 'TestStreet1';
        accountObj1.BillingCountry = 'TestCountry1';
        accountObj1.BillingPostalCode = '12345'; 
        accountList.add(accountObj1);
        insert accountList;
        
        //contact data
        Contact contactObj = new Contact();
        contactObj.AccountId = accountObj.Id;
        contactObj.LastName = 'TestLastName';
        contactObj.Email =  'test@gmail.com';
        contactObj.Phone = '3013857474';
        contactObj.Contact_Type__c = 'Service';
        contactObj.OtherPhone ='3013857474';
        contactObj.MobilePhone = '3013857474';
        contactList.add(contactObj);
        //type 1
        Contact contactObj1 = new Contact();
        contactObj1.AccountId = accountObj.Id;
        contactObj1.LastName = 'TestLastName1';
        contactObj1.Email =  'test1@gmail.com';
        contactObj1.Phone = '3013857475';
        contactObj1.Contact_Type__c = 'Service';
        contactObj1.OtherPhone ='3013857475';
        contactObj1.MobilePhone = '3013857475';
        contactList.add(contactObj1);
        //type 2
        Contact contactObj2 = new Contact();
        contactObj2.AccountId = accountObj.Id;
        contactObj2.LastName = 'TestLastName';
        contactObj2.Email =  'test@gmail.com';
        contactObj2.Phone = '3013857476';
        contactObj2.Contact_Type__c = 'Other';
        contactObj2.OtherPhone ='3013857476';
        contactObj2.MobilePhone = '3013857476';
        contactList.add(contactObj2);
        insert contactList;
        
        //Account contact relation data
        AccountContactRelation ACRObject = new AccountContactRelation();
        ACRObject.ContactId =contactObj.id;
        ACRObject.AccountId = accountObj1.id;
        ACRLisT.add(ACRObject);
        //insert ACRLisT;
        
        //case data
        Case caseObj = new case();
        caseObj.AccountId = accountObj.id;
        caseObj.ContactId=contactObj.id;
        caseObj.subject='This test class';
        caseObj.Status ='New';
        caseObj.type = 'Customer Inquiry';
        caseObj.Sub_Type__c = 'Pricing';
        caseobj.RecordTypeId =Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CSR_Case').getRecordTypeId();
        caseList.add(caseObj);
        
        // type 2 
        Case caseObj1 = new case();
        caseObj1.AccountId = accountObj.id;
        caseObj1.ContactId=contactObj.id;
        caseObj1.subject='This test class';
        caseObj1.Status ='Closed';
        caseObj1.type = 'Customer Inquiry';
        caseObj1.Sub_Type__c = 'Pricing';
        caseobj.RecordTypeId =Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CSR_Case').getRecordTypeId();
        caseList.add(caseObj1);
        system.debug('caseList'+caseList);
        insert caseList;
        
        
    }
    
    static testMethod void testSearchPageController_Scenario1()
    {
        
        PageReference pageRef = Page.OpenCTI_ContactAndCases;
        list<contact> conlist = [Select id, Name from contact where phone = '3013857474'];
        Test.setCurrentPage(pageRef);
        
        String ANIValue = '3013857474';
        String DNISValue = '123450';
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('ANI', ANIValue);
        ApexPages.currentPage().getParameters().put('DNIS', DNISValue);
        
        Test.startTest();
        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = conlist[0].Id;
        Test.setFixedSearchResults(fixedSearchResults);
        OpenCTI_ContactAndCasesController controllerObj = new OpenCTI_ContactAndCasesController();
        controllerObj.ANI = ANIValue;
        Test.stopTest();
    }
     static testMethod void testSearchPageController_Scenario2()
    {
        
        PageReference pageRef = Page.OpenCTI_ContactAndCases;
        list<contact> conlist = [Select id, Name from contact where phone = '3013857475' ];
        
        Test.setCurrentPage(pageRef);
        
        String ANIValue = '3013857475';
        String DNISValue = '123450';
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('ANI', ANIValue);
        ApexPages.currentPage().getParameters().put('DNIS', DNISValue);
        
        Test.startTest();
        Id [] fixedSearchResults= new Id[1];
        fixedSearchResults[0] = conlist[0].Id;
        Test.setFixedSearchResults(fixedSearchResults);
        OpenCTI_ContactAndCasesController controllerObj = new OpenCTI_ContactAndCasesController();
        controllerObj.ANI = ANIValue;
        Test.stopTest();
    }
}