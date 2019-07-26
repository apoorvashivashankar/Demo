@istest
private class LatestInvoicesAndOrdersControllerTest {
	@istest
	static void testgetDecimalFromText()
	{
		System.assertEquals(LatestInvoicesAndOrdersController.getDecimalFromText('5'),5.0);
		System.assertEquals(LatestInvoicesAndOrdersController.getDecimalFromText('-5'),5.0);
		System.assertEquals(LatestInvoicesAndOrdersController.getDecimalFromText('xyz'),0.0);
	} 
	@istest
	static void testgetDecimalIsNegative()
	{
		System.assertEquals(LatestInvoicesAndOrdersController.getDecimalIsNegative('5'),false);
		System.assertEquals(LatestInvoicesAndOrdersController.getDecimalIsNegative('-5'),true);
		System.assertEquals(LatestInvoicesAndOrdersController.getDecimalIsNegative('xyz'),false);
	} 
	@istest
	static void testControllerWithValidAccount()
	{
		//create test account
		Account testAccount=new Account(Name='Test Account',Customer_Base__c='999999',Customer_Suffix__C='000');
		insert testAccount;
		
		//set VF page and initialize controller 
		PageReference pageRef = Page.LatestInvoicesAndOrders;
		Test.setCurrentPage(pageRef);	
		LatestInvoicesAndOrdersController controller=new LatestInvoicesAndOrdersController(new 
		ApexPages.StandardController(testAccount));
		
		//try to get invoices and orders
		controller.getInvoicesAndOrders();
		
		//make sure there are invoices and orders as both Customer_Base__c and Customer_Suffix__C are provided
		System.assertEquals(controller.getHasOrders(), true);
		System.assertEquals(controller.getHasInvoices(), true);
		
		//check the total amount values and sign for the first order and invoice
		System.assertEquals(controller.invoices[0].getFormattedTotal(),15528.04);
		System.assertEquals(controller.invoices[0].getIsNegative(),false);
		System.assertEquals(controller.orders[0].getFormattedTotal(),176.04);
		System.assertEquals(controller.orders[0].getIsNegative(),false);
	}
	@istest
	static void testControllerWithAccountHavingNoCustomerSuffix()
	{
		//create test account
		Account testAccount=new Account(Name='Test Account',Customer_Base__c='999999');
		insert testAccount;
		
		//set VF page and initialize controller 
		PageReference pageRef = Page.LatestInvoicesAndOrders;
		Test.setCurrentPage(pageRef);		
		LatestInvoicesAndOrdersController controller=new LatestInvoicesAndOrdersController(new 
		ApexPages.StandardController(testAccount));
		
		//make sure an error message is added to the page	
		System.assert(ApexPages.hasMessages());
		
		//try to get invoices and orders
		controller.getInvoicesAndOrders();
		
		//make sure there are no invoices and orders as Customer_Suffix__c is missing
		System.assertEquals(controller.getHasOrders(), false);
		System.assertEquals(controller.getHasInvoices(), false);		
	}
}