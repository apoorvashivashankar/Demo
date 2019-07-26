/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class OpenCTI_SFDCScriptControllerTest {
	
    private static List<Account> accountList = new List<Account>();
    private static List<Contact> contactList = new List<Contact>();
    private static List<SSC__c> sscList = new List<SSC__c>();

    static void setup(Integer accountCounter,Integer contactCounter, Integer sscCounter)
    {
        for(Integer i=0; i< accountCounter ;i++)
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
        
        for(Integer j=0; j< contactCounter ;j++)
        {        
            for(Integer i=0; i< accountCounter ;i++)
            {
                Contact contactObj = new Contact();
                contactObj.AccountId = accountList[i].Id;
                contactObj.LastName = 'TestLastName'+j;
                contactObj.Email = j+'test@gmail.com';
                contactObj.Phone = '123456789'+j;
                contactList.add(contactObj);
            }
        }
        insert contactList;
        
        for(Integer k=0; k< sscCounter ;k++)
        {
            SSC__c sscObj = new SSC__c();
            sscObj.Name = 'TestSSC'+k;
            sscObj.VDN__c = Double.valueOf('12345'+k);
            sscList.add(sscObj);
        }
        
        insert sscList;
    }

    static testMethod void testSearchPageController_Scenario1()
    {   
        Integer accountCounter = 2;
        Integer contactCounter = 1100;
        Integer sscCounter = 2;
        setup(accountCounter,contactCounter,sscCounter);
        PageReference pageRef = Page.CustomScreenPopup;
        Test.setCurrentPage(pageRef);
        String ANIValue = '1234567890';
        String VDNValue = '123450';
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('ANI', ANIValue);
        ApexPages.currentPage().getParameters().put('VDN', VDNValue);

        Test.startTest();
            Id [] fixedSearchResults = new Id[contactCounter];
            for(Integer i=0;i<contactCounter;i++)
            {
                fixedSearchResults[i] = contactList[i].Id;
            }
            Test.setFixedSearchResults(fixedSearchResults);
            System.debug('fixedSearchResults'+fixedSearchResults);
            OpenCTI_SFDCScriptController controllerObj = new OpenCTI_SFDCScriptController();
            controllerObj.sscName = VDNValue;
            List<SSC__c> sscL = OpenCTI_SFDCScriptController.getSSCData( VDNValue );
            OpenCTI_SFDCScriptController.ContactAccountLookupResult  res = OpenCTI_SFDCScriptController.getContactAccountData(ANIValue);
        Test.stopTest();
    }

    static testMethod void testSearchPageController_Scenario2()
    {   
        Integer accountCounter = 2;
        Integer contactCounter = 150;
        Integer sscCounter = 2;
        setup(accountCounter,contactCounter,sscCounter);
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
            Id [] fixedSearchResults = new Id[accountCounter];
            for(Integer i=0;i<accountCounter;i++)
            {
                fixedSearchResults[i] = accountList[i].Id;
            }
            Test.setFixedSearchResults(fixedSearchResults);
            OpenCTI_SFDCScriptController controllerObj = new OpenCTI_SFDCScriptController();
            OpenCTI_SFDCScriptController.ContactAccountLookupResult  res = OpenCTI_SFDCScriptController.getContactAccountData(ANIValue);
        Test.stopTest();
    }

    static testMethod void testsearchAccountContacts_Positive()
    {
        setup(2,150,2);
        PageReference pageRef = Page.CustomScreenPopup;
        Test.setCurrentPage(pageRef);
        String ANIValue = '1234567';
        String VDNValue = '123450';
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('ANI', ANIValue);
        ApexPages.currentPage().getParameters().put('VDN', VDNValue);
        String searchString = '';
        Test.startTest();
            OpenCTI_SFDCScriptController controllerObj = new OpenCTI_SFDCScriptController();
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

    static testMethod void testsearchAccountContacts_NoMatch(){
    	OpenCTI_SFDCScriptController.ContactAccountLookupResult  res = OpenCTI_SFDCScriptController.getContactAccountData('1233214567');
    }
    
    static testMethod void testsearchAccountContacts_negative()
    {
        setup(2,150,2);
        PageReference pageRef = Page.CustomScreenPopup;
        Test.setCurrentPage(pageRef);
        String ANIValue = '1234567';
        String VDNValue = '123450';
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('ANI', ANIValue);
        ApexPages.currentPage().getParameters().put('VDN', VDNValue);
        String searchString = '';
        Test.startTest();
            OpenCTI_SFDCScriptController controllerObj = new OpenCTI_SFDCScriptController();
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