@isTest
private class testInvoicesAndOrdersWebServiceStub {
     @isTest static void testCallout() {

     	Test.setMock(WebServiceMock.class, new WebServiceMockImpl());

        // Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
            InvoicesAndOrdersWebServiceStub.BasicHttpBinding_IInvoicesAndOrders stub 
             = new InvoicesAndOrdersWebServiceStub.BasicHttpBinding_IInvoicesAndOrders();    	
      	System.debug('::::TEST::::stub::::> ' + stub);

//initilize request
	InvoicesAndOrdersWebServiceStub.GetTLastFiveInvoiceAndOrders_element request=
    	new  InvoicesAndOrdersWebServiceStub.GetTLastFiveInvoiceAndOrders_element();
    System.debug('::::TEST::::request::::> ' + request);
//initialize response
	InvoicesAndOrdersWebServiceStub.GetTLastFiveInvoiceAndOrdersResponse_element response=
		new InvoicesAndOrdersWebServiceStub.GetTLastFiveInvoiceAndOrdersResponse_element();
	System.debug('::::TEST::::response::::> ' + response);    	

// getting error....
	String excelXMLString = stub.GetTLastFiveInvoiceAndOrders('CustomerBase','CustomerSuffix','strToken');

	}
}