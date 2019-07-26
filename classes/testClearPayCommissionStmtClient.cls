@isTest
private class testClearPayCommissionStmtClient {

     @isTest static void testCallout() {
     	Test.setMock(WebServiceMock.class, new WebServiceMockImpl());

        // Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
            ClearPayCommissionStmtClient.BasicHttpBinding_IClearPayCommissionStmt stub 
             = new ClearPayCommissionStmtClient.BasicHttpBinding_IClearPayCommissionStmt();    	

      	System.debug('::::TEST::::stub::::> ' + stub);

        List<SecurityToken__c> token = SecurityToken__c.getAll().values();  
        String secureToken = '';
        
        if(token.size() > 0) {
            secureToken = token[0].SecurityToken__c;
        }

        ClearPayCommissionStmtClient.GetCommissionStmt_element request_x 
            = new ClearPayCommissionStmtClient.GetCommissionStmt_element();
        request_x.strEmployeeId = '56202';
        request_x.strMonth = '10';
        request_x.strYear = '2015';
        request_x.strToken = secureToken;

		System.debug('::::TEST::::request_x::::> ' + request_x);   



        ClearPayCommissionStmtClient.GetCommissionStmtResponse_element response_x 
            = new ClearPayCommissionStmtClient.GetCommissionStmtResponse_element();        
        
		System.debug('::::TEST::::response_x::::> ' + response_x);  
	    

        String response = response_x.GetCommissionStmtResult;

	    System.debug('::::TEST::::response::::> ' + response); 


        String excelXMLString = stub.GetCommissionStmt('56202', '10', '2011', secureToken);  

}
}