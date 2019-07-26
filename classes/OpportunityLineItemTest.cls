@isTest
(SeeAllData=true)
private class  OpportunityLineItemTest {
	 
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
	
	static testMethod void tesSAPSampleOrder() {

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

    	try {
	        insert o;
            System.debug('::::OpportunityLineItemTest + o: ' + o);
    	} catch(System.Exception ex) {
    		system.debug(ex.getMessage());
    	}

       	Quote__c q = new Quote__c (
	    	Account__c = a.Id
	    	, Opportunity__c = o.Id
			, Oasis_Quote_Number__c = NULL
			, SAP_Order_Number__c = 'S123'
			, Status__c = 'Sample Order'
	    	);
	    insert q;

	            // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
	    System.debug('::::Order_TrackingTest + pricebookId ' + pricebookId);

        // First, set up test price book entries.
        // Insert a test product.
        Product2 prod = new Product2(Name = 'Free Frorm',IsActive = TRUE);
        insert prod;
        
        
        // 1. Insert a price book entry for the standard price book.
        // Standard price book entries require the standard price book ID we got earlier.
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, 
            Product2Id = prod.Id,
            UnitPrice = 1, 
            IsActive = true);
        insert standardPrice;
	    System.debug('::::Order_TrackingTest + standardPrice ' + standardPrice);

        opportunitylineitem oli = new opportunitylineitem(
	        opportunityid = o.id,
	        SAP_Order_Number__c = 'S123',
	        Item_Status__c = 'Fullfilled',
	        Oasis_Quote_Number__c = NULL,
	        Carrier_Tracking_Number__c = '111',
	        unitprice = 50,
	        quantity = 1,        // Don't reference product, but its pricebook entry
	        pricebookentryid = standardPrice.Id);
		insert oli;
	    System.debug('::::Order_TrackingTest + oli ' + oli);

	    update oli;
	    delete oli;

		}
	static testMethod void testOasisSampleOrder() {

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
        System.debug('::::Order_TrackingTest::::> ' + pageRef);

       	Quote__c q = new Quote__c (
	    	Account__c = a.Id
	    	, Opportunity__c = o.Id
			, Oasis_Quote_Number__c = 'O123'
			, SAP_Order_Number__c = NULL
			, Status__c = 'Sample Order'
	    	);
	    insert q;

	            // Get standard price book ID.
        // This is available irrespective of the state of SeeAllData.
        Id pricebookId = Test.getStandardPricebookId();
	    System.debug('::::Order_TrackingTest + pricebookId ' + pricebookId);

        // First, set up test price book entries.
        // Insert a test product.
        Product2 prod = new Product2(Name = 'Free Frorm',IsActive = TRUE);
        insert prod;
        
        
        // 1. Insert a price book entry for the standard price book.
        // Standard price book entries require the standard price book ID we got earlier.
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, 
            Product2Id = prod.Id,
            UnitPrice = 1, 
            IsActive = true);
        insert standardPrice;
	    System.debug('::::Order_TrackingTest + standardPrice ' + standardPrice);

        opportunitylineitem oli = new opportunitylineitem(
	        opportunityid = o.id,
	        SAP_Order_Number__c = null,
	        Item_Status__c = 'Fullfilled',
	        Carrier_Tracking_Number__c = '111',
	        Oasis_Quote_Number__c = 'O123',
	        unitprice = 50,
	        quantity = 1,        // Don't reference product, but its pricebook entry
	        pricebookentryid = standardPrice.Id);
		insert oli;
	    System.debug('::::Order_TrackingTest + oli ' + oli);

	    update oli;
	    delete oli;

		}
		
}