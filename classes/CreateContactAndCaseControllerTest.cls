/** * * * * * * * * * * * *
*  Class Name:   CreateContactAndCaseControllerTest
*  Purpose:      Test class to CreateContactAndCaseController controller
*  Author:       Srini Aluri
*  Created Date: March-21-2017
*  Updated Date: March-22-2017	 
*  Type:         Test Class
** * * * * * * * * * * * */
@isTest
private class CreateContactAndCaseControllerTest 
{
    private static Account accountObj = new Account();
    private static SSC__c sscObj = new SSC__c();
    
    /** * * * * * * * * * * * *
    *  Method Name:   setup
    *  Purpose:      Method used to setup test data for testmethods
    *  Author:       Srini Aluri
    *  Created Date: March-22-2017
    *  Updated Date: March-22-2017	 
    *  Type:         Method
    ** * * * * * * * * * * * */
    static void setup()
    {
        accountObj = new Account();
        accountObj.Name = 'TestAccountName';
        insert accountObj;
        
        sscObj = new SSC__c();
        sscObj.Name = 'TestSSC';
        sscObj.VDN__c = Double.valueOf('123450');
        insert sscObj;
    }
	
    /** * * * * * * * * * * * *
    *  Method Name:  testCreateCaseContact_Positive
    *  Purpose:      Method used to perform positive testing by creating contact 
    *  Author:       Srini Aluri
    *  Created Date: March-21-2017
    *  Updated Date: March-22-2017	 
    *  Type:         Method
    ** * * * * * * * * * * * */
    static testMethod void testCreateCaseContact_Positive()
    {	
        setup();
        PageReference pageRef = Page.CustomScreenPopup;
        Test.setCurrentPage(pageRef);
        String ANIValue = '1234567890';
        String VDNValue = '123450';
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('ANI', ANIValue);
        ApexPages.currentPage().getParameters().put('VDN', VDNValue);
        ApexPages.currentPage().getParameters().put('accId', accountObj.Id);
        
        Test.startTest();
        	CreateContactAndCaseController controllerObj = new CreateContactAndCaseController();
        	controllerObj.contactobj.LastName = 'TestLastName';	
        	controllerObj.contactobj.FirstName = 'TestFirstName';	
        	controllerObj.createCaseContact();
        	controllerObj.redirect();
        Test.stopTest();
        //fetched the fresh contact created
        Contact contactCreatedObj = [Select LastName from Contact];
        System.assertEquals(controllerObj.contactobj.LastName, contactCreatedObj.LastName);
    }
    
    /** * * * * * * * * * * * *
    *  Method Name:  testCreateCaseContact_Negative
    *  Purpose:      Method used to perform negative testing by creating contact with empty value for Lastname field
    * 				 which will generate exception.
    *  Author:       Srini Aluri
    *  Created Date: March-21-2017
    *  Updated Date: March-22-2017	 
    *  Type:         Method
    ** * * * * * * * * * * * */
    static testMethod void testCreateCaseContact_Negative()
    {	
        setup();
        PageReference pageRef = Page.CustomScreenPopup;
        Test.setCurrentPage(pageRef);
        String ANIValue = '1234567890';
        String VDNValue = '123450';
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('ANI', ANIValue);
        ApexPages.currentPage().getParameters().put('VDN', VDNValue);
        ApexPages.currentPage().getParameters().put('accId', accountObj.Id);
        
        Test.startTest();
        	CreateContactAndCaseController controllerObj = new CreateContactAndCaseController();
        	// negative test i.e providing empty value for lastname as it is required to it will generate exception
        	controllerObj.contactobj.LastName = '';	
        	controllerObj.createCaseContact();
        	controllerObj.redirect();
        Test.stopTest();
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        boolean b = false;
        for(Apexpages.Message msg:msgs){
            if (msg.getDetail().contains('Error')) b = true;
        }
        system.assert(b);
    }
}