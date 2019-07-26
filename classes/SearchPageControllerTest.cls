/** * * * * * * * * * * * *
*  Class Name:   SearchPageControllerTest
*  Purpose:      Test class to SearchPageController controller
*  Author:       Srini Aluri
*  Created Date: March-17-2017
*  Type:         Test Class
** * * * * * * * * * * * */
@isTest
public class SearchPageControllerTest 
{   
    private static List<Account> accountList = new List<Account>();
    private static List<Contact> contactList = new List<Contact>();
    private static List<SSC__c> sscList = new List<SSC__c>();
    
    /* * * * * * * * * * * * *
    *  Method Name:  setup
    *  Purpose:      This method is used to create the test data.
    *  Author:       Srini Aluri
    *  Created Date: 17-March-2017
    * * * * * * * * * * * * */
    static void setup(Integer counter)
    {
        for(Integer i=0; i< counter ;i++)
        {
            Account accountObj = new Account();
            accountObj.Name = 'TestAccount'+i;
            accountObj.BillingCity = 'TestCity'+i;
            accountObj.BillingState = 'TestState'+i;
            accountObj.BillingStreet = 'TestStreet'+i;
            accountObj.BillingCountry = 'TestCountry'+i;
            accountObj.BillingPostalCode = '12345'+i;
            accountList.add(accountObj);
        }
        insert accountList;
        
        for(Integer i=0; i< counter ;i++)
        {
            Contact contactObj = new Contact();
            contactObj.AccountId = accountList[i].Id;
            contactObj.LastName = 'TestLastName'+i;
            contactObj.Email = i+'test@gmail.com';
            contactObj.Phone = '123456789'+i;
            contactList.add(contactObj);
        }
        insert contactList;
        
        for(Integer i=0; i< counter ;i++)
        {
            SSC__c sscObj = new SSC__c();
            sscObj.Name = 'TestSSC'+i;
            sscObj.VDN__c = Double.valueOf('12345'+i);
            sscList.add(sscObj);
        }
        
        insert sscList;
    }
    
    /* * * * * * * * * * * * *
    *  Method Name:  testSearchPageController_Scenario1
    *  Purpose:      This method is used to unit test functiolaity for SearchPageController
    * 				 for scenario 1 - Contact Phone Match	
    *  Author:       Srini Aluri
    *  Created Date: March-17-2017
    * * * * * * * * * * * * */
    static testMethod void testSearchPageController_Scenario1()
    {   
        Integer counter = 2;
        setup(counter);
        PageReference pageRef = Page.CustomScreenPopup;
        Test.setCurrentPage(pageRef);
        String ANIValue = '1234567890';
        String VDNValue = '123450';
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('ANI', ANIValue);
        ApexPages.currentPage().getParameters().put('VDN', VDNValue);

        Test.startTest();
            Id [] fixedSearchResults = new Id[counter];
            for(Integer i=0;i<counter;i++)
            {
                fixedSearchResults[i] = contactList[i].Id;
            }
            Test.setFixedSearchResults(fixedSearchResults);
            SearchPageController controllerObj = new SearchPageController();
        Test.stopTest();
        system.debug('controllerObj.contacts '+controllerObj.contacts);
        Map<Id,Contact> contactMap = new Map<Id,Contact>(controllerObj.contacts);
        for(Contact contactObj : [Select Id,Name,Email,Phone,AccountId from Contact where Phone =: ANIValue])
        {
            System.assertEquals(contactMap.get(contactObj.Id).Id,contactObj.Id);
            System.assertEquals(contactMap.get(contactObj.Id).Email,contactObj.Email);
            System.assertEquals(contactMap.get(contactObj.Id).Phone,contactObj.Phone);
            System.assertEquals(contactMap.get(contactObj.Id).AccountId,contactObj.AccountId);
        }
    }
    
    /* * * * * * * * * * * * *
    *  Method Name:  testSearchPageController_Scenario2
    *  Purpose:      This method is used to unit test functiolaity for SearchPageController
    * 				 for scenario 2 - Contact Phone not Matched and Account Phone Matched	
    *  Author:       Srini Aluri
    *  Created Date: March-22-2017
    *  Updated Date: March-22-2017
    * * * * * * * * * * * * */
    static testMethod void testSearchPageController_Scenario2()
    {   
        Integer counter = 2;
        setup(counter);
        //update inserted account Phone field
        for(Integer i=0;i<accountList.size();i++)
        {
            accountList[i].Phone = '987654321'+i;
        }
        update accountList;
        
        PageReference pageRef = Page.CustomScreenPopup;
        Test.setCurrentPage(pageRef);
        String ANIValue = '9876543210';
        String VDNValue = '123450';
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('ANI', ANIValue);
        ApexPages.currentPage().getParameters().put('VDN', VDNValue);

        Test.startTest();
            Id [] fixedSearchResults = new Id[counter];
            for(Integer i=0;i<counter;i++)
            {
                fixedSearchResults[i] = accountList[i].Id;
            }
            Test.setFixedSearchResults(fixedSearchResults);
            SearchPageController controllerObj = new SearchPageController();
        Test.stopTest();
        Map<Id,Account> accountMap = new Map<Id,Account>(controllerObj.accountsMatched);
        for(Account accountObj : [Select Id,Name,Phone,BillingCity,BillingState,BillingStreet,BillingCountry,BillingPostalCode,(Select Id, Name,Email,Phone,Account.Name,AccountId,MobilePhone,OtherPhone from Account.Contacts) from Account where Phone =: ANIValue])
        {
            System.assertEquals(accountMap.get(accountObj.Id).Id,accountObj.Id);
            System.assertEquals(accountMap.get(accountObj.Id).Name,accountObj.Name);
            System.assertEquals(accountMap.get(accountObj.Id).Phone,accountObj.Phone);
            System.assertEquals(accountMap.get(accountObj.Id).BillingCity,accountObj.BillingCity);
            System.assertEquals(accountMap.get(accountObj.Id).BillingState,accountObj.BillingState);
            System.assertEquals(accountMap.get(accountObj.Id).BillingStreet,accountObj.BillingStreet);
            System.assertEquals(accountMap.get(accountObj.Id).BillingCountry,accountObj.BillingCountry);
            System.assertEquals(accountMap.get(accountObj.Id).BillingPostalCode,accountObj.BillingPostalCode);
            System.assertEquals(accountMap.get(accountObj.Id).Contacts.size(),accountObj.Contacts.size());
        }
    }
    
    /* * * * * * * * * * * * *
    *  Method Name:  testSearchPageController_Redirect
    *  Purpose:      This method is used to unit test for SearchPageController for redirect functionality
    *  Author:       Srini Aluri
    *  Created Date: March-17-2017
    * * * * * * * * * * * * */
    static testMethod void testSearchPageController_Redirect()
    {
        Integer counter = 2;
        setup(counter);
        PageReference pageRef = Page.CustomScreenPopup;
        Test.setCurrentPage(pageRef);
        String ANIValue = '1234567890';
        String VDNValue = '123450';
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('ANI', ANIValue);
        ApexPages.currentPage().getParameters().put('VDN', VDNValue);
        

        Test.startTest();
            Id [] fixedSearchResults = new Id[counter];
            for(Integer i=0;i<counter;i++)
            {
                fixedSearchResults[i] = contactList[i].Id;
            }
            Test.setFixedSearchResults(fixedSearchResults);
            SearchPageController controllerObj = new SearchPageController();
            controllerObj.redirectToCreateCasePage();
        	controllerObj.redirectToContactAndCasePage();
        Test.stopTest();
    }
    
    /* * * * * * * * * * * * *
    *  Method Name:  testsearchAccountContacts_Positive
    *  Purpose:      This method is used to perform positive testing for searchAccountContacts() method.
    *  Author:       Srini Aluri
    *  Created Date: March-22-2017
    *  Updated Date: March-22-2017
    *  Type:		 Method
    * * * * * * * * * * * * */
    static testMethod void testsearchAccountContacts_Positive()
    {
        setup(2);
        PageReference pageRef = Page.CustomScreenPopup;
        Test.setCurrentPage(pageRef);
        String ANIValue = '1234567';
        String VDNValue = '123450';
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('ANI', ANIValue);
        ApexPages.currentPage().getParameters().put('VDN', VDNValue);
        String searchString = '';
        Test.startTest();
            SearchPageController controllerObj = new SearchPageController();
        	controllerObj.searchParam = 'Test';
        	searchString = '%'+controllerObj.searchParam+'%';
            controllerObj.searchAccountContacts();
        	controllerObj.first();
            controllerObj.next();
            controllerObj.previous();
            controllerObj.last();
        
        	system.assertEquals(controllerObj.setCon.getHasNext(),controllerObj.hasNext);
            system.assertEquals(controllerObj.setCon.getHasPrevious(),controllerObj.hasPrevious);
            system.assertEquals(controllerObj.setCon.getPageNumber(),controllerObj.pageNumber);
        Test.stopTest();
        
        List<Account> searchedAccountList = [Select id from Account where Name like : searchString];
        system.assertEquals(searchedAccountList.size(), controllerObj.searchedAccounts.size());
    }
    
    /* * * * * * * * * * * * *
    *  Method Name:  testsearchAccountContacts_negative
    *  Purpose:      This method is used to perform negative testing for searchAccountContacts() method.
    * 				 by sending empty search Text.
    *  Author:       Srini Aluri
    *  Created Date: March-22-2017
    *  Updated Date: March-22-2017
    *  Type:		 Method
    * * * * * * * * * * * * */
    static testMethod void testsearchAccountContacts_negative()
    {
        setup(2);
        PageReference pageRef = Page.CustomScreenPopup;
        Test.setCurrentPage(pageRef);
        String ANIValue = '1234567';
        String VDNValue = '123450';
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('ANI', ANIValue);
        ApexPages.currentPage().getParameters().put('VDN', VDNValue);
        String searchString = '';
        Test.startTest();
            SearchPageController controllerObj = new SearchPageController();
        	controllerObj.searchParam = '';
        	searchString = controllerObj.searchParam;
            controllerObj.searchAccountContacts();
        Test.stopTest();
        
        //system.assertEquals(0, controllerObj.searchedAccounts.size());
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        boolean b = false;
        for(Apexpages.Message msg:msgs){
            if (msg.getDetail().contains('Please enter search text.')) b = true;
        }
        system.assert(b);
    }
}