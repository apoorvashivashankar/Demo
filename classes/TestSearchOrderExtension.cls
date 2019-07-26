@isTest
private class TestSearchOrderExtension {

	@isTest static void test_method_one() {
		// Implement test code
		Account acc = Dal_TestUtils.createTestAccount();
		Contact con = Dal_TestUtils.createTestContact();
		con.AccountId = acc.Id;
		update con;

		Case cas = new Case();
		cas.AccountId = acc.Id;
		cas.ContactId = con.Id;
		cas.Subject = 'Test Case';
		cas.Status = 'New';
		cas.Type = 'NSPR';
		cas.Order_Number__c = '0000001452';
		Insert cas;

		DT_SYS_OrderHeader__x mockOrder = new DT_SYS_OrderHeader__x(HostSystem__c ='SAP', SalesOrder__c = '0000001452', CustomerPONo__c = '12345');
		SearchOrderExtension.mockOrders.add(mockOrder);
		SalesOrderList__x mockSalesOrder = new SalesOrderList__x(Customer__c = '600967001', CustomerPONo__c = '12345', SalesOrder__c = '0000001452');
		SearchOrderExtension.mockSalesOrders.add(mockSalesOrder);
        Test.starttest();
		ApexPages.StandardController sContrl = new ApexPages.StandardController(cas);
		SearchOrderExtension obj = new SearchOrderExtension(sContrl);
		SearchOrderExtension.searchResultWrap wrap = new SearchOrderExtension.searchResultWrap();
		obj.doSearch();
		Test.stoptest();
	}

	@isTest static void test_method_two() {
		// Implement test code
		Account acc = Dal_TestUtils.createTestAccount();
		Contact con = Dal_TestUtils.createTestContact();
		con.AccountId = acc.Id;
		update con;

		Case cas = new Case();
		cas.AccountId = acc.Id;
		cas.ContactId = con.Id;
		cas.Subject = 'Test Case';
		cas.Status = 'New';
		cas.Type = 'NSPR';
		Insert cas;

		DT_SYS_OrderHeader__x mockOrder = new DT_SYS_OrderHeader__x(HostSystem__c ='SAP', SalesOrder__c = '0000001452', CustomerPONo__c = '12345');
		SearchOrderExtension.mockOrders.add(mockOrder);
		SalesOrderList__x mockSalesOrder = new SalesOrderList__x(Customer__c = '600967001', CustomerPONo__c = '12345', SalesOrder__c = '0000001452',HostSystem__c ='SAP');
        SearchOrderExtension.mockSalesOrders.add(mockSalesOrder);
        Test.starttest();
		ApexPages.StandardController sContrl = new ApexPages.StandardController(cas);
		SearchOrderExtension obj = new SearchOrderExtension(sContrl);
		SearchOrderExtension.searchResultWrap wrap = new SearchOrderExtension.searchResultWrap();
		obj.searchString = '0000001452';
		obj.doSearch();
		obj.selectedSalesOrder = '0000001452';
		obj.selectedCustomerPo = '12345';
		obj.copyToCase();
		Test.stoptest();
	}

	@isTest static void test_method_three() {
		// Implement test code
		Account acc = Dal_TestUtils.createTestAccount();
		Contact con = Dal_TestUtils.createTestContact();
		con.AccountId = acc.Id;
		update con;

		Case cas = new Case();
		cas.AccountId = acc.Id;
		cas.ContactId = con.Id;
		cas.Subject = 'Test Case';
		cas.Status = 'New';
		cas.Type = 'NSPR';
		Insert cas;

		SalesOrderList__x mockSalesOrder = new SalesOrderList__x(Customer__c = '600967001', CustomerPONo__c = '12345', SalesOrder__c = '0000001452',HostSystem__c ='SAP');
        SearchOrderExtension.mockSalesOrders.add(mockSalesOrder);
        Test.starttest();
		ApexPages.StandardController sContrl = new ApexPages.StandardController(cas);
		SearchOrderExtension obj = new SearchOrderExtension(sContrl);
		SearchOrderExtension.searchResultWrap wrap = new SearchOrderExtension.searchResultWrap();
		obj.searchString = '12345';
		obj.doSearch();
		Test.stoptest();
	}

}