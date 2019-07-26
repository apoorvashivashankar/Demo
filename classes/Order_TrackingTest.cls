@isTest
(SeeAllData=true)
private class  Order_TrackingTest {
	 
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

    static void testSetup() {
        
        // USERS
        User uRSM;
        User uRVP;
        User uMGR1;
        User uMGR2;
        User uSR1;
        User uSR2;
        
        System.runAs(new User(Id=UserInfo.getUserId())) {
            Profile pRSM = [SELECT Id FROM Profile WHERE Name = 'MGMT'];
            UserRole rRSM = [SELECT Id, Name FROM UserRole WHERE Name LIKE '%RSM%' LIMIT 1];
            UserRole rRVP = [SELECT Id, Name FROM UserRole WHERE Name LIKE '%Mid Atlantic Region%' LIMIT 1];
            uRSM = new User(alias = 'RSM1'
                            , email= 'RSM@daltile.com'
                            , emailencodingkey='UTF-8'
                            , lastname='Manager'
                            , firstname='Regional Sales'
                            , languagelocalekey='en_US'
                            , localesidkey='en_US'
                            , timezonesidkey='GMT'
                            , ProfileId = pRSM.Id
                            , UserRoleId = rRSM.Id
                            , username = 'RSM@daltile.com.test');
            insert uRSM;                
            uRVP = new User(alias = 'RVP1'
                            , email= 'RVP@daltile.com'
                            , emailencodingkey='UTF-8'
                            , lastname='Manager'
                            , firstname='Regional Sales'
                            , languagelocalekey='en_US'
                            , localesidkey='en_US'
                            , timezonesidkey='GMT'
                            , ProfileId = pRSM.Id
                            , UserRoleId = rRVP.Id
                            , username = 'RVP@daltile.com.test');
            insert uRVP;                
            UserRole rMGR = [SELECT Id, Name FROM UserRole WHERE Name = 'MW SSC Manager'];    
            id pMGR = [Select id 
                            From Profile
                            where UserType = 'Standard'
                            and Name = 'SSC Manager'
                            limit 1].Id;        
            uMGR1 = new User(alias = 'MGR1'
                            , email= 'AccountOwnerGuy@daltile.com'
                            , emailencodingkey='UTF-8'
                            , lastname='Owner'
                            , firstname='Account'
                            , languagelocalekey='en_US'
                            , localesidkey='en_US'
                            , timezonesidkey='GMT'
                            , ProfileId = pMGR
                            , UserRoleId = rMGR.Id
                            , username = 'MGR1@daltile.com.test');
            insert uMGR1;                
            uMGR2 = new User(alias = 'MGR2'
                            , email= 'MGR@daltile.com'
                            , emailencodingkey='UTF-8'
                            , lastname='Two'
                            , firstname='Manager'
                            , languagelocalekey='en_US'
                            , localesidkey='en_US'
                            , timezonesidkey='GMT'
                            , ProfileId = pMGR
                            , UserRoleId = rMGR.Id
                            , username = 'MGR2@daltile.com.test');
            insert uMGR2;        
            Profile pSR = [SELECT Id FROM Profile WHERE Name = 'Sales Rep User'];
            UserRole rsr = [SELECT Id, Name FROM UserRole WHERE Name LIKE '%Sales Rep%' AND PortalRole = '' LIMIT 1];
            uSR1 = new User(alias = 'sr1'
                            , email= 'uSR1@daltile.com'
                            , emailencodingkey='UTF-8'
                            , lastname='Rep'
                            , firstname='Sales'
                            , languagelocalekey='en_US'
                            , localesidkey='en_US'
                            , timezonesidkey='GMT'
                            , ProfileId = pSR.Id
                            , UserRoleId = rMGR.Id
                            , username = 'uSR1@daltile.com.test');
            insert uSR1;        
            uSR2 = new User(alias = 'sr1'
                            , email= 'uSR2@daltile.com'
                            , emailencodingkey='UTF-8'
                            , lastname='Rep'
                            , firstname='Sales'
                            , languagelocalekey='en_US'
                            , localesidkey='en_US'
                            , timezonesidkey='GMT'
                            , ProfileId = pSR.Id
                            , UserRoleId = rMGR.Id
                            , username = 'uSR2@daltile.com.test');
            insert uSR2;        
        }
        
        // ACCOUNT DATA
        Region__c r1 = new Region__c(Select__c = true
                                     , SBU__c = 'SC'
                                     , DW_ID__c = '901'
                                     , Name = 'SOUTHERN CA REGION');
        insert r1;
        
        Region__c r2 = new Region__c(Select__c = true
                                     , SBU__c = 'DI'
                                     , DW_ID__c = '902'
                                     , Name = 'NORTHERN SOUTHERN CA REGION');
        insert r2;
        
        Sales_Representative__c sr1 = new Sales_Representative__c(SBU__c = 'sc'
                                                                    , DW_ID__c = '9001'
                                                                    , Region__c = r1.Id);
        insert sr1;
        
        Sales_Representative__c sr2 = new Sales_Representative__c(SBU__c = 'sc'
                                                                    , DW_ID__c = '9002'
                                                                    , Region__c = r1.Id);
        insert sr2;
        
        Sales_Representative__c sr3 = new Sales_Representative__c(SBU__c = 'DI'
                                                                    , DW_ID__c = '9003'
                                                                    , Region__c = r2.Id);
        insert sr3;


        Customer_Class__c cc1 = new Customer_Class__c(Active__c = true
                                                     , COS__c = 111
                                                     , CustClass__c = 'CC1'
                                                     , Cust_Count__c = 123
                                                     , Customer_Class_Details__c = 'CC1'
                                                     , CustomerCountry__c = 'US'
                                                     , CustomerSBU__c = 'SC'
                                                     , Duplicate__c = false
                                                     , Net_Sales__c = 111
                                                     , PPS_Rgn__c = 'SC');
        insert cc1;
        
        Customer_Class__c cc2 = new Customer_Class__c(Active__c = true
                                                     , COS__c = 111
                                                     , CustClass__c = 'CC2'
                                                     , Cust_Count__c = 123
                                                     , Customer_Class_Details__c = 'CC2'
                                                     , CustomerCountry__c = 'US'
                                                     , CustomerSBU__c = 'SC'
                                                     , Duplicate__c = false
                                                     , Net_Sales__c = 111
                                                     , PPS_Rgn__c = 'SC');
        insert cc2;

        Customer_Class__c cc3 = new Customer_Class__c(Active__c = true
                                                     , COS__c = 111
                                                     , CustClass__c = 'CC3'
                                                     , Cust_Count__c = 123
                                                     , Customer_Class_Details__c = 'CC3'
                                                     , CustomerCountry__c = 'US'
                                                     , CustomerSBU__c = 'DI'
                                                     , Duplicate__c = false
                                                     , Net_Sales__c = 111
                                                     , PPS_Rgn__c = 'DI');
        insert cc3;
        
        Customer_Class__c cc4 = new Customer_Class__c(Active__c = true
                                                     , COS__c = 111
                                                     , CustClass__c = 'DEL'
                                                     , Name = 'DEL'
                                                     , Cust_Count__c = 123
                                                     , Customer_Class_Details__c = 'DEL'
                                                     , CustomerCountry__c = 'US'
                                                     , CustomerSBU__c = 'SC'
                                                     , Duplicate__c = false
                                                     , Net_Sales__c = 111
                                                     , PPS_Rgn__c = 'SC');
        insert cc4;
        SSC__c ssc1 = new SSC__c(Closed__c = false
                                 , DW_ID__c = '9001'
                                 , Loc_Type__c = 'SSC'
                                 , Manager__c = uMGR1.id
                                 , Region__c = r1.Id
                                 , ROM__c = uMGR2.id
                                 , RSM__c = uRSM.id
                                 , RVP__c = uRVP.id
                                 , Sales_Region__c = '01'
                                 , SBU__c = 'SC'
                                 , Select__c = true
                                 , SSC_Fax_Number__c = '123-345-5567'
                                 , SSC_Phone_Number__c = '123-345-5567'
                                 , State__c = 'TX'
                                 , Street_Address__c = '12345 1st street'
                                 , Zip_Code__c = '12345');
        insert ssc1; 
        
        SSC__c ssc2 = new SSC__c(Closed__c = false
                                 , DW_ID__c = '9002'
                                 , Loc_Type__c = 'SSC'
                                 , Manager__c = uMGR1.id
                                 , Region__c = r1.Id
                                 , ROM__c = uMGR2.id
                                 , RSM__c = uRSM.id
                                 , RVP__c = uRVP.id
                                 , Sales_Region__c = '01'
                                 , SBU__c = 'SC'
                                 , Select__c = true
                                 , SSC_Fax_Number__c = '123-345-5567'
                                 , SSC_Phone_Number__c = '123-345-5567'
                                 , State__c = 'TX'
                                 , Street_Address__c = '12345 1st street'
                                 , Zip_Code__c = '12345');
        insert ssc2; 
        
        SSC__c ssc3 = new SSC__c(Closed__c = false
                                 , DW_ID__c = '9003'
                                 , Loc_Type__c = 'SSC'
                                 , Manager__c = uMGR1.id
                                 , Region__c = r2.Id
                                 , ROM__c = uMGR2.id
                                 , RSM__c = uRSM.id
                                 , RVP__c = uRVP.id
                                 , Sales_Region__c = '02'
                                 , SBU__c = 'DI'
                                 , Select__c = true
                                 , SSC_Fax_Number__c = '123-345-5567'
                                 , SSC_Phone_Number__c = '123-345-5567'
                                 , State__c = 'TX'
                                 , Street_Address__c = '12345 1st street'
                                 , Zip_Code__c = '12345');
        insert ssc3;
        
        SSC__c sscNULL = new SSC__c(Closed__c = false
                                 , DW_ID__c = '9004'
                                 , Loc_Type__c = 'SSC'
                                 , Manager__c = NULL
                                 , Region__c = r1.Id
                                 , ROM__c = NULL
                                 , RSM__c = NULL
                                 , RVP__c = NULL
                                 , Sales_Region__c = '01'
                                 , SBU__c = 'SC'
                                 , Select__c = true
                                 , SSC_Fax_Number__c = '123-345-5567'
                                 , SSC_Phone_Number__c = '123-345-5567'
                                 , State__c = 'TX'
                                 , Street_Address__c = '12345 1st street'
                                 , Zip_Code__c = '12345');
        insert sscNULL;
        
        Customer_Type__c ct1 = new Customer_Type__c( Name = 'CT1'
                                                   , Active__c = true
                                                   , Select__c = true
                                                   , SBU__c = 'SC'
                                                   , Region__c = r1.Id);
        insert ct1;
        
        Customer_Type__c ct2 = new Customer_Type__c( Name = 'CANAD CT2'
                                                   , Active__c = true 
                                                   , Select__c = true
                                                   , SBU__c = 'AS'
                                                   , Region__c = r1.Id);
        insert ct2;
        
        Account a1 = new Account ( NAME = 'TEST ACCOUNT 01'
                           , AccountNumber = '111111'
                           , Customer_Base__c = '111111'
                           , Customer_Class__c = cc1.id
                           , phone = '214-309-4193'
                           , Customer_Type__c = ct1.id
                           , DW_ID__c = '911111'
                           , GroupKey__c = '11111'
                           , SAP_Account_Id__c = '11111'
                           , Fax = '214-309-4193'
                           , Website = 'wwww.test.com'
                           , Require_PO__c = FALSE
                           , Region__c = r1.Id
                           , OwnerId = uSR2.id
                           , Salesman__c = sr1.id
                           , SSC__c = ssc1.id
                           , Customer_Suffix__c = '11'
                           , BillingStreet = '111111'
                           , BillingCity = 'DALLAS'
                           , BillingState = 'TX'
                           , BillingPostalCode = '75218'
                           , BillingCountry = 'US'
                           , ShippingStreet = '111111'
                           , ShippingCity = 'DALLAS'
                           , ShippingState = 'TX'
                           , ShippingPostalCode = '75218'
                           , ShippingCountry = 'DALLAS'
                           , Address_3__c = 'huh'
                           , SBU__C  = 'SC');
        insert a1;
        
        Account a2 = new Account ( NAME = 'Internal Account'
                           , AccountNumber = '111112'
                           , Customer_Base__c = '111111'
                           , OwnerId = uSR2.Id
                           , Customer_Class__c = cc1.id
                           , phone = '214-309-4193'
                           , Customer_Type__c = ct1.id
                           , DW_ID__c = '911112'
                           , GroupKey__c = '11111'
                           , SAP_Account_Id__c = '11111'
                           , Fax = '214-309-4193'
                           , Website = 'wwww.test.com'
                           , Require_PO__c = FALSE
                           , Region__c = r1.Id
                           , Salesman__c = sr1.id
                           , SSC__c = ssc1.id
                           , Customer_Suffix__c = '11'
                           , BillingStreet = '111111'
                           , BillingCity = 'DALLAS'
                           , BillingState = 'TX'
                           , BillingPostalCode = '75218'
                           , BillingCountry = 'US'
                           , ShippingStreet = '111111'
                           , ShippingCity = 'DALLAS'
                           , ShippingState = 'TX'
                           , ShippingPostalCode = '75218'
                           , ShippingCountry = 'DALLAS'
                           , Address_3__c = 'huh'
                           , SBU__C  = 'SC');
        insert a2;
        
        Account a3 = new Account ( NAME = 'TEST ACCOUNT 03'
                           , AccountNumber = '111113'
                           , OwnerId = uMGR1.Id
                           , Customer_Base__c = '111111'
                           , Customer_Class__c = cc1.id
                           , phone = '214-309-4193'
                           , Customer_Type__c = ct1.id
                           , DW_ID__c = '911113'
                           , GroupKey__c = '11111'
                           , SAP_Account_Id__c = '11111'
                           , Fax = '214-309-4193'
                           , Website = 'wwww.test.com'
                           , Require_PO__c = FALSE
                           , Region__c = r1.Id
                           , Salesman__c = sr1.id
                           , SSC__c = ssc1.id
                           , Customer_Suffix__c = '11'
                           , BillingStreet = '111111'
                           , BillingCity = 'DALLAS'
                           , BillingState = 'TX'
                           , BillingPostalCode = '75218'
                           , BillingCountry = 'US'
                           , ShippingStreet = '111111'
                           , ShippingCity = 'DALLAS'
                           , ShippingState = 'TX'
                           , ShippingPostalCode = '75218'
                           , ShippingCountry = 'DALLAS'
                           , Address_3__c = 'huh'
                           , SBU__C  = 'SC');
        insert a3;      
        
        Account a4 = new Account ( NAME = 'TEST ACCOUNT 04'
                                   , AccountNumber = '111114'
                                   , Customer_Base__c = '111114'
                                   , OwnerId = uSR2.Id
                                   , Customer_Class__c = cc3.id
                                   , phone = '214-309-4193'
                                   , Customer_Type__c = ct2.id
                                   , DW_ID__c = '9111114'
                                   , GroupKey__c = '111114'
                                   , SAP_Account_Id__c = '111114'
                                   , Fax = '214-309-4193'
                                   , Website = 'wwww.test.com'
                                   , Require_PO__c = FALSE
                                   , Region__c = r2.Id
                                   , Salesman__c = sr3.id
                                   , SSC__c = ssc3.id
                                   , Customer_Suffix__c = '11'
                                   , BillingStreet = '111111'
                                   , BillingCity = 'DALLAS'
                                   , BillingState = 'TX'
                                   , BillingPostalCode = '75218'
                                   , BillingCountry = 'US'
                                   , ShippingStreet = '111111'
                                   , ShippingCity = 'DALLAS'
                                   , ShippingState = 'TX'
                                   , ShippingPostalCode = '75218'
                                   , ShippingCountry = 'DALLAS'
                                   , Address_3__c = 'huh'
                                   , SBU__C  = 'SC');
        insert a4;   

	    Opportunity opp = new Opportunity (
    	AccountId = a1.Id
    	, Name = 'TEST Order_TrackingTest OPP'
        , Project_City__c = 'Dallas'
        , Project_State__c = 'TX'
        , OwnerId = uSR1.Id
		, CloseDate=  date.today()
		, StageName = '2 - Specification'
        , Sub_Stage__c = '1 - Prospect'
    	);
		insert opp; 
    }


	static testMethod void testOasisSampleOrderSecondShip() {

        testSetup();
        
        Account a = [   SELECT ID
                        FROM Account
                        WHERE NAME = 'TEST ACCOUNT 01'
        ];
        Region__c r = [ SELECT ID
                        FROM Region__c
                        WHERE Name = 'SOUTHERN CA REGION'
        ];
        Customer_Class__c cc1 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC1'
        ];
        Customer_Class__c cc2 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC2'
        ];
        Customer_Type__c ct1 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'CT1'
        ];
        Customer_Type__c ct2 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'CANAD CT2'
        ];
        SSC__c ssc1 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '9001'
        ];
        SSC__c ssc2 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '9002'
        ];
        Sales_Representative__c sr1 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '9001'
        ];
        Sales_Representative__c sr2 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '9002'
        ];
        
        User uSR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR1@daltile.com.test'
        ]; 
        
        User uSR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR2@daltile.com.test'
        ]; 

        User uMGR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR1@daltile.com.test'
        ]; 
        
        User uMGR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR2@daltile.com.test'
        ]; 
                
        User uRSM = [   SELECT ID
                        FROM User
                        WHERE username = 'RSM@daltile.com.test'
	    ];
	    
        User uRVP = [   SELECT ID
                        FROM User
                        WHERE username = 'RVP@daltile.com.test'
	    ];        
	    
	    Opportunity o = [   SELECT ID
                            FROM Opportunity
                            WHERE Name = 'TEST Order_TrackingTest OPP'
	    ];        

 		pageRef = Page.CPQQuoteNew;
		pageRef.getParameters().put('id',o.id);
		Test.setCurrentPage(pageRef);
	    ApexPages.StandardController tstCls = new ApexPages.StandardController(o);
	    ext = new CPQQuoteNewExtension(tstCls);
        System.debug('::::Order_TrackingTest::::> ' + pageRef);

       	Quote__c q = new Quote__c (
	    	Account__c = a.Id
	    	, Opportunity__c = o.Id
			, SAP_Order_Number__c = NULL
			, Oasis_Quote_Number__c = '111'
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
        
        Test.startTest();
        
        opportunitylineitem oli = new opportunitylineitem(
	        opportunityid = o.id,
	        SAP_Order_Number__c = NULL,
	        Oasis_Quote_Number__c = '111',
	        Item_Status__c = 'Fulfilled',
	        unitprice = 50,
	        quantity = 1,        // Don't reference product, but its pricebook entry
	        pricebookentryid = standardPrice.Id);
		insert oli;
	    System.debug('::::Order_TrackingTest.testOasisSampleOrder + oli ' + oli);

	    Order_Tracking__c ot = new Order_Tracking__c (
	    	Tracking__c = '555',
        	Quote_Sample__c = q.Id,
        	Account__c = a.id,
        	Opportunity__c = o.id
	    	);
	    insert ot;
	    
	    System.debug('::::Order_TrackingTest + oli ' + ot);
	    oli.Carrier_Tracking_Number__c = '555';
	    update oli;
	    	        
        opportunitylineitem oli2 = new opportunitylineitem(
	        opportunityid = o.id,
	        SAP_Order_Number__c = NULL,
	        Oasis_Quote_Number__c = '111',
	        Item_Status__c = 'BackOrdered',
	        unitprice = 50,
	        quantity = 2,        // Don't reference product, but its pricebook entry
	        pricebookentryid = standardPrice.Id);
		insert oli2;
	    System.debug('::::Order_TrackingTest.testOasisSampleOrder + oli2 ' + oli2);

	    Order_Tracking__c ot2 = new Order_Tracking__c (
	    	Tracking__c = '777',
        	Quote_Sample__c = q.Id,
        	Account__c = a.id,
        	Opportunity__c = o.id
	    	);
	    insert ot2;
	    System.debug('::::Order_TrackingTest + ot2 ' + ot2);	    	    


	    oli2.Carrier_Tracking_Number__c = '777';
	    update oli2;
        
        Test.stopTest();   
        
//		delete oli;
//	    update ot;
//	    delete ot;

		}

	static testMethod void testOasisSampleOrder() {

        testSetup();
        
        Account a = [   SELECT ID
                        FROM Account
                        WHERE NAME = 'TEST ACCOUNT 01'
        ];
        Region__c r = [ SELECT ID
                        FROM Region__c
                        WHERE Name = 'SOUTHERN CA REGION'
        ];
        Customer_Class__c cc1 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC1'
        ];
        Customer_Class__c cc2 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC2'
        ];
        Customer_Type__c ct1 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'CT1'
        ];
        Customer_Type__c ct2 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'CANAD CT2'
        ];
        SSC__c ssc1 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '9001'
        ];
        SSC__c ssc2 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '9002'
        ];
        Sales_Representative__c sr1 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '9001'
        ];
        Sales_Representative__c sr2 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '9002'
        ];
        
        User uSR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR1@daltile.com.test'
        ]; 
        
        User uSR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR2@daltile.com.test'
        ]; 

        User uMGR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR1@daltile.com.test'
        ]; 
        
        User uMGR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR2@daltile.com.test'
        ]; 
                
        User uRSM = [   SELECT ID
                        FROM User
                        WHERE username = 'RSM@daltile.com.test'
	    ];
	    
        User uRVP = [   SELECT ID
                        FROM User
                        WHERE username = 'RVP@daltile.com.test'
	    ];        
	    
	    Opportunity o = [   SELECT ID
                            FROM Opportunity
                            WHERE Name = 'TEST Order_TrackingTest OPP'
	    ];        

 		pageRef = Page.CPQQuoteNew;
		pageRef.getParameters().put('id',o.id);
		Test.setCurrentPage(pageRef);
	    ApexPages.StandardController tstCls = new ApexPages.StandardController(o);
	    ext = new CPQQuoteNewExtension(tstCls);
        System.debug('::::Order_TrackingTest::::> ' + pageRef);

       	Quote__c q = new Quote__c (
	    	Account__c = a.Id
	    	, Opportunity__c = o.Id
			, Oasis_Quote_Number__c = NULL
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
	        SAP_Order_Number__c = NULL,
	        Oasis_Quote_Number__c = '111',
	        unitprice = 50,
	        Item_Status__c = 'Fulfilled',
	        quantity = 1,        // Don't reference product, but its pricebook entry
	        pricebookentryid = standardPrice.Id);
		insert oli;
	    System.debug('::::Order_TrackingTest.testOasisSampleOrder + oli ' + oli);
	    	    
	    q.Oasis_Quote_Number__c = '111';
	    update q;
	    System.debug('::::Order_TrackingTest + oli ' + oli);

	    oli.Carrier_Tracking_Number__c = '555';
	    update oli;

	    Order_Tracking__c ot = new Order_Tracking__c (
	    	Tracking__c = '555',
        	Quote_Sample__c = q.Id,
        	Account__c = a.id,
        	Opportunity__c = o.id
	    	);
	    insert ot;
	    System.debug('::::Order_TrackingTest + oli ' + ot);  

	    delete oli;
//	    update ot;
//	    delete ot;

		}
		
	static testMethod void testSAPSampleOrder() {

        testSetup();
        
        Account a = [   SELECT ID
                        FROM Account
                        WHERE NAME = 'TEST ACCOUNT 01'
        ];
        Region__c r = [ SELECT ID
                        FROM Region__c
                        WHERE Name = 'SOUTHERN CA REGION'
        ];
        Customer_Class__c cc1 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC1'
        ];
        Customer_Class__c cc2 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC2'
        ];
        Customer_Type__c ct1 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'CT1'
        ];
        Customer_Type__c ct2 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'CANAD CT2'
        ];
        SSC__c ssc1 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '9001'
        ];
        SSC__c ssc2 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '9002'
        ];
        Sales_Representative__c sr1 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '9001'
        ];
        Sales_Representative__c sr2 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '9002'
        ];
        
        User uSR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR1@daltile.com.test'
        ]; 
        
        User uSR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR2@daltile.com.test'
        ]; 

        User uMGR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR1@daltile.com.test'
        ]; 
        
        User uMGR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR2@daltile.com.test'
        ]; 
                
        User uRSM = [   SELECT ID
                        FROM User
                        WHERE username = 'RSM@daltile.com.test'
	    ];
	    
        User uRVP = [   SELECT ID
                        FROM User
                        WHERE username = 'RVP@daltile.com.test'
	    ];        
	    
	    Opportunity o = [   SELECT ID
                            FROM Opportunity
                            WHERE Name = 'TEST Order_TrackingTest OPP'
	    ];        
        
 		pageRef = Page.CPQQuoteNew;
		pageRef.getParameters().put('id',o.id);
		Test.setCurrentPage(pageRef);
	    ApexPages.StandardController tstCls = new ApexPages.StandardController(o);
	    ext = new CPQQuoteNewExtension(tstCls);
        System.debug('::::Order_TrackingTest::::> ' + pageRef);

       	Quote__c q = new Quote__c (
	    	Account__c = a.Id
	    	, Opportunity__c = o.Id
			, Oasis_Quote_Number__c = NULL
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
	        SAP_Order_Number__c = '2675309',
	        Oasis_Quote_Number__c = NULL,
	        Item_Status__c = 'Fulfilled',
	        unitprice = 50,
	        quantity = 1,        // Don't reference product, but its pricebook entry
	        pricebookentryid = standardPrice.Id);
		insert oli;
	    System.debug('::::Order_TrackingTest + oli ' + oli);

	    q.SAP_Order_Number__c = '2675309';
	    update q;
	    System.debug('::::Order_TrackingTest + oli ' + oli);

	    oli.Carrier_Tracking_Number__c = '777';
	    update oli;

	    Order_Tracking__c ot = new Order_Tracking__c (
	    	Tracking__c = '777',
        	Quote_Sample__c = q.Id,
        	Account__c = a.id,
        	Opportunity__c = o.id
	    	);
	    insert ot;
	    System.debug('::::Order_TrackingTest + oli ' + ot);

//	    delete oli;
	    update ot;
	    delete ot;

		}				
		
	static testMethod void testOasisSampleOrderBulk() {

        testSetup();
        
        Account a = [   SELECT ID
                        FROM Account
                        WHERE NAME = 'TEST ACCOUNT 01'
        ];
        Region__c r = [ SELECT ID
                        FROM Region__c
                        WHERE Name = 'SOUTHERN CA REGION'
        ];
        Customer_Class__c cc1 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC1'
        ];
        Customer_Class__c cc2 = [    SELECT ID
                                    FROM Customer_Class__c
                                    WHERE Customer_Class_Details__c = 'CC2'
        ];
        Customer_Type__c ct1 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'CT1'
        ];
        Customer_Type__c ct2 = [ SELECT ID
                                FROM Customer_Type__c
                                WHERE Name = 'CANAD CT2'
        ];
        SSC__c ssc1 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '9001'
        ];
        SSC__c ssc2 = [  SELECT ID
                        FROM SSC__c
                        WHERE DW_ID__c = '9002'
        ];
        Sales_Representative__c sr1 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '9001'
        ];
        Sales_Representative__c sr2 = [  SELECT ID
                                        FROM Sales_Representative__c
                                        WHERE DW_ID__c = '9002'
        ];
        
        User uSR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR1@daltile.com.test'
        ]; 
        
        User uSR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'uSR2@daltile.com.test'
        ]; 

        User uMGR1 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR1@daltile.com.test'
        ]; 
        
        User uMGR2 = [   SELECT ID
                        FROM User
                        WHERE username = 'MGR2@daltile.com.test'
        ]; 
                
        User uRSM = [   SELECT ID
                        FROM User
                        WHERE username = 'RSM@daltile.com.test'
	    ];
	    
        User uRVP = [   SELECT ID
                        FROM User
                        WHERE username = 'RVP@daltile.com.test'
	    ];        
	    
	    Opportunity o = [   SELECT ID
                            FROM Opportunity
                            WHERE Name = 'TEST Order_TrackingTest OPP'
	    ];        

 		pageRef = Page.CPQQuoteNew;
		pageRef.getParameters().put('id',o.id);
		Test.setCurrentPage(pageRef);
	    ApexPages.StandardController tstCls = new ApexPages.StandardController(o);
	    ext = new CPQQuoteNewExtension(tstCls);
        System.debug('::::Order_TrackingTest::::> ' + pageRef);

       	Quote__c q = new Quote__c (
	    	Account__c = a.Id
	    	, Opportunity__c = o.Id
			, Oasis_Quote_Number__c = NULL
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
	        SAP_Order_Number__c = NULL,
	        Oasis_Quote_Number__c = '111',
	        unitprice = 50,
	        Item_Status__c = 'Fulfilled',
	        quantity = 1,        // Don't reference product, but its pricebook entry
	        pricebookentryid = standardPrice.Id);
		insert oli;
	    System.debug('::::Order_TrackingTest.testOasisSampleOrder + oli ' + oli);
	    	    
	    q.Oasis_Quote_Number__c = '111';
	    update q;
	    System.debug('::::Order_TrackingTest + oli ' + oli);

	    oli.Carrier_Tracking_Number__c = '555';
	    update oli;
        
        Integer numOrderTrack = 5;
        List <Order_Tracking__c> listOrderTracking = new List <Order_Tracking__c>();
        for(Integer i=0;i<numOrderTrack;i++) {
    	    Order_Tracking__c ot = new Order_Tracking__c (
    	    	Tracking__c = '555' + i,
            	Quote_Sample__c = q.Id,
            	Account__c = a.id,
            	Opportunity__c = o.id
    	    	);
    	    listOrderTracking.add(ot);
        }
        insert listOrderTracking;
	    System.debug('::::Order_TrackingTest + listOrderTracking ' + listOrderTracking);  

	    delete oli;

		}		
		
}