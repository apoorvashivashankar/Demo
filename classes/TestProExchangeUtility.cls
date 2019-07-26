@isTest
private class TestProExchangeUtility {

	@isTest static void  testGetAccountByCustomerNumber() {
	    
	    Account a = new Account();
        a.Name = 'test account';
        a.DW_ID__c = '321';
        insert a;
	    
        ProExchangeUtility.getAccountByCustomerNumber('321');
	}	
	
	@isTest static void  testGetAccountByCustomerNumberNotFound() {
	    
	    Account a = new Account();
        a.Name = 'test account';
        a.DW_ID__c = '321';
        insert a;
	    
	    try {
	        ProExchangeUtility.getAccountByCustomerNumber('3211');    
		}catch (Exception e) {
	        Boolean expectedExceptionThrown =  e.getMessage().contains('We could not find an account that matched that number.  Please check your latest sales slip, or ask your account representative.  If you do not have an account select the No Account Number checkbox.') ? true : false;
	    }
        
	}	
	
	@isTest static void  testGetAccountByCustomerNumberNotFound2() {
	    
	    Account a = new Account();
        a.Name = 'test account';
        a.DW_ID__c = '321';
        insert a;
	    
	    try {
	        ProExchangeUtility.getAccountByCustomerNumber(' -');    
		}catch (Exception e) {
	        Boolean expectedExceptionThrown =  e.getMessage().contains('Sorry! Something went wrong:') ? true : false;
	    }
        
	}

	@isTest static void  testCreateCase() {
	    
        Account a = new Account();
        a.Name = 'test account';
        insert a;
        
        Contact ct = new Contact();
            ct.FirstName = 'Jon';
            ct.LastName = 'Test';
            ct.AccountId = a.Id;
            ct.Email = 'testingsome@tester.com.test';
            ct.Phone = '3216549871';
        insert ct;        
        
        Case c = new Case();
        c.AccountId = a.ID;
        c.ContactId = ct.Id;
        c.Type = 'Check Pricing';
        c.Origin = 'Phone';
        c.Status = 'Closed';
        insert c;	    
	    
        ProExchangeUtility.createCase(c);
	}
	
	@isTest static void  testGetCountries() {
        ProExchangeUtility.getCountries();
	}
	
	@isTest static void  getStates() {
        ProExchangeUtility.getStates('US');
	}
	
	@isTest static void  testGetCaseRecordTypeID() {
        ProExchangeUtility.getCaseRecordTypeID();
	}
    
	@isTest static void  testFetchUser() {
        ProExchangeUtility.fetchUser();
	}

}