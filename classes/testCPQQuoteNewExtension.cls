@isTest
private class testCPQQuoteNewExtension
{
	public Account acc {get;set;}
	public Contact cnt {get;set;}
	public Opportunity opp {get;set;}
	public Quote__c quote {get;set;}
	public Boolean needsOpp {get;set;}
	public String theRecord {get;set;}
	public String theRecordId {get;set;}  
    public Boolean cntCheck {get;set;}
    public Boolean acctCheck {get;set;}
    public Boolean oppCheck {get;set;}


    Static Quote__c qte;
    static CPQQuoteNewExtension ext;
    static PageReference pageRef;
    static {
 	UserRole rMGR = [SELECT Id, Name FROM UserRole WHERE Name = 'MW SSC Manager'];    
    User uMGR = [SELECT ID, Name FROM User where UserRoleID =  : rMGR.Id AND IsActive = TRUE LIMIT 1];
	}

	private static void initA() {
	    Account a = new Account(
	    	name = 'x'
	        , BillingStreet = 'XXX'
	        , BillingCity = 'XXX'
		    , BillingState = 'xx'
	        , BillingPostalCode = '72332'
	        ,  phone = '9722787827'
	    	); 
	    insert a;


 		pageRef = Page.CPQQuoteNew;

		pageRef.getParameters().put('id',a.id);
		Test.setCurrentPage(pageRef);
	    ApexPages.StandardController tstCls = new ApexPages.StandardController(a);
	    ext = new CPQQuoteNewExtension(tstCls);
//		ext.theRecord = a;
//		ext.theRecordId = a.Id;
        System.debug('::::testAccountQuote::::> ' + pageRef);

	}

	private static void initC() {
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

 		pageRef = Page.CPQQuoteNew;

		pageRef.getParameters().put('id',c.id);
		Test.setCurrentPage(pageRef);
	    ApexPages.StandardController tstCls = new ApexPages.StandardController(c);
	    ext = new CPQQuoteNewExtension(tstCls);

/*	    String theRecord =  String.valueof(tstCls.getRecord());
	    String theRecordtemp =  theRecord.removeEnd('}');
	    String theGenericRecordizerPt1 = theRecordtemp.right(18); 
	    String theRecordId = theGenericRecordizerPt1.removeStart('_c=');  
	    String theContact = String.valueof(c);
	    String theContactId = String.valueof(c.Id);	    
	    System.assertEquals(theRecord,theContact);
	    System.assertEquals(theRecordId,theContactId);
*/
        System.debug('::::testContactQuote::::> ' + pageRef);

	}

	private static void initO() {

 	UserRole rMGR = [SELECT Id, Name FROM UserRole WHERE Name = 'MW SSC Manager'];    
    User uMGR = [SELECT ID, Name FROM User where UserRoleID =  : rMGR.Id AND IsActive = TRUE LIMIT 1];

	    Account a = new Account(
	    	name = 'x'
	        , BillingStreet = 'XXX'
	        , BillingCity = 'XXX'
		    , BillingState = 'xx'
	        , BillingPostalCode = '72332'
	        ,  phone = '9722787827'
	    	); 
	    insert a;

	    Opportunity o = new Opportunity (
	    	AccountId = a.Id
	    	, Name = 'TEST OPP'
            , Project_City__c = 'Dallas'
            , Project_State__c = 'TX'
	    	, OwnerId = uMGR.Id
			, CloseDate=  date.today()
			, StageName = '2 - Specification'
            , Sub_Stage__c = '1 - Prospect'
	    	);
	    insert o;

 		pageRef = Page.CPQQuoteNew;
		pageRef.getParameters().put('id',o.id);
		Test.setCurrentPage(pageRef);
	    ApexPages.StandardController tstCls = new ApexPages.StandardController(o);
	    ext = new CPQQuoteNewExtension(tstCls);
        System.debug('::::testOppQuote::::> ' + pageRef);

	}

	static testMethod void testAccountQuote1() {		

    initA();

    Test.startTest();
		try {
				ext.acctCheck = TRUE;
	            ext.createOpp();
              	ext.getResult();	
			}   catch (Exception e) {
	        System.debug('::::testAccountQuote::::> ' + e.getMessage());
		    } 
	Test.stopTest();			    
	}

	static testMethod void testAccountQuote2() {		

    initA();

    Test.startTest();
		try {
				ext.acctCheck = FALSE;
	            ext.createOpp();
              	ext.getResult();	
			}   catch (Exception e) {
	        System.debug('::::testAccountQuote::::> ' + e.getMessage());
		    } 
	Test.stopTest();			    
	}


	static testMethod void testContactQuote() {		

    initC();

    Test.startTest();
		try {
				ext.cntCheck = TRUE;
	            ext.createOpp();
              	ext.getResult();	
			}   catch (Exception e) {
	        System.debug('::::testContactQuote::::> ' + e.getMessage());
		    } 
	Test.stopTest();			    
	}

	static testMethod void testOppQuote() {		

    initO();

    Test.startTest();
		try {
				ext.oppCheck = TRUE;
              	ext.getResult();	
			}   catch (Exception e) {
	        System.debug('::::testOppQuote::::> ' + e.getMessage());
		    } 
	Test.stopTest();			    
	}	
}