@isTest(SeeAllData=true)
private class  TestRelated_CustomerTrigger {

	public Account acc {get;set;}
	public Contact cnt {get;set;}
	public Opportunity opp {get;set;}
	public Related_Customer__c relC {get;set;}

	static testMethod void TestRelated_CustomerTrigger() {
    Test.startTest();
		try {
	Account a = new Account(
	    	name = 'x'
	        , BillingStreet = 'XXX'
	        , BillingCity = 'XXX'
		    , BillingState = 'xx'
	        , BillingPostalCode = '72332'
	        ,  phone = '9722787827'
	    	); 
	    insert a;

	Contact c = new Contact (
	    	AccountId = a.Id
	    	, lastname = 'TEST'
	    	);
	    insert c;		
	
	Opportunity o = new Opportunity (
	    	AccountId = a.Id
	    	, Name = 'TEST OPP'
            , Project_City__c = 'Dallas'
            , Project_State__c = 'TX'
//	    	, OwnerId = uMGR.Id
			, CloseDate=  date.today()
			, StageName = '2 - Specification'
            , Sub_Stage__c = '1 - Prospect'
	    	);
	insert o;

	Related_Customer__c rc = new Related_Customer__c(
		Contact__c = c.Id
		, Related_Account__c = a.Id
		, Opportunity__c = o.Id
		, Shopping_Cart__c = TRUE
		);
	insert rc;


	Account a2 = new Account(
	    	name = 'x2'
	        , BillingStreet = 'XXX'
	        , BillingCity = 'XXX'
		    , BillingState = 'xx'
	        , BillingPostalCode = '72332'
	        ,  phone = '9722787827'
	    	); 
	insert a2;

	Contact c2 = new Contact (
	   	AccountId = a2.Id
	   	, lastname = 'TEST'
	   	);
	insert c2;		
	
	o.AccountId = a2.Id;
	update o;

	Related_Customer__c rc2 = new Related_Customer__c(
		Contact__c = c2.Id
		, Related_Account__c = a2.Id
		, Opportunity__c = o.Id
		, Shopping_Cart__c = TRUE
		);
	insert rc2;


			}   catch (Exception e) {
	        System.debug('::::testAccountQuote::::> ' + e.getMessage());
		    } 

	Test.stopTest();			    
	}

	static testMethod void TestRelated_CustomerTrigger2() {
    Test.startTest();
		try {
	Account a = new Account(
	    	name = 'x'
	        , BillingStreet = 'XXX'
	        , BillingCity = 'XXX'
		    , BillingState = 'xx'
	        , BillingPostalCode = '72332'
	        ,  phone = '9722787827'
	    	); 
	    insert a;

	Contact c = new Contact (
	    	AccountId = a.Id
	    	, lastname = 'TEST'
	    	);
	    insert c;		
	
	Opportunity o = new Opportunity (
	    	AccountId = a.Id
	    	, Name = 'TEST OPP'
            , Project_City__c = 'Dallas'
            , Project_State__c = 'TX'
//	    	, OwnerId = uMGR.Id
			, CloseDate=  date.today()
			, StageName = '2 - Specification'
            , Sub_Stage__c = '1 - Prospect'
	    	);
	insert o;

	Related_Customer__c rc = new Related_Customer__c(
		Contact__c = c.Id
		, Related_Account__c = a.Id
		, Opportunity__c = o.Id
		, Shopping_Cart__c = TRUE
		);
	insert rc;


	Account a2 = new Account(
	    	name = 'x2'
	        , BillingStreet = 'XXX'
	        , BillingCity = 'XXX'
		    , BillingState = 'xx'
	        , BillingPostalCode = '72332'
	        ,  phone = '9722787827'
	    	); 
	insert a2;

	Contact c2 = new Contact (
	   	AccountId = a2.Id
	   	, lastname = 'TEST'
	   	);
	insert c2;		
	
	o.AccountId = a2.Id;
	update o;

	Related_Customer__c rc2 = new Related_Customer__c(
		Contact__c = c2.Id
		, Related_Account__c = a2.Id
		, Opportunity__c = o.Id
		, Shopping_Cart__c = TRUE
		);
	insert rc2;

	rc.Shopping_Cart__c = TRUE;
	update rc;

	delete rc2;


			}   catch (Exception e) {
	        System.debug('::::testAccountQuote::::> ' + e.getMessage());
		    } 

	Test.stopTest();			    
	}


}