@ isTest
public with sharing class TestNewAccount {


	public String uiTheme {get; set;}
	static PageReference pageRef;
	static CustomerRequestNewLightningExtension leadExt;
	public static boolean testRun = false;

private static void initL() {

		RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Person Account' Limit 1];
            
            Region__c r1 = new Region__c(Select__c = true
				, SBU__c = 'SC'
				, DW_ID__c = '01'
				, Name = 'SOUTHERN CA REGION');
			insert r1;

        Lead testLead = new Lead ( 
        					FirstName = 'XXX',
        					LastName = 'XXX',
								Company = 'XXX',
								Country = 'US',
								Street = 'XXX',
								City = 'XXX',
								State = 'XXX',
								PostalCode = '75218',
								Phone = '972-489-4406',
								Fax = '972-489-4406',
								Email = 'XXX@daltile.com',
								Website = 'XXX.com',
								ST_Street__c = 'XXX',
								ST_City__c = 'XXX',
								ST_State__c = 'tx',
								ST_Zip__c = '75218',
								Comments__c = 'XXX',
								LeadSource = 'Customer Website Request',
								PO_Required__c  = TRUE,
								DBA_Name__c = 'XXX',
								SSC_Nbr__c = '999');
        insert testLead;

//        Change_Request__c testCR = new Change_Request__c(  Customer_Base__c = '111111');
//        insert testCR;

		// uiTheme = UserInfo.getUiTheme();
	    // SETUP TEST DATA
	    boolean testRun = false;
	    boolean hasErrors = false;    
	    // USERS / PROFILES

	    Region__c r04 = new Region__c(Select__c = true
	    , SBU__c = 'SC'
	    , DW_ID__c = '04'
	    , Name = 'DT Mid-West');
	    insert r04;

	    Customer_Class__c cc1 = new Customer_Class__c(Active__c = true
	    , COS__c = 111
	    , CustClass__c = 'S8Q'
	    , Cust_Count__c = 123
	    , Customer_Class_Details__c = 'TEST THIS'
	    , CustomerCountry__c = 'US'
	    , CustomerSBU__c = 'SC'
	    , Duplicate__c = false
	    , Net_Sales__c = 111
	    , Price_Region__c = r04.Id
	    , PPS_Rgn__c = '04');
	    insert cc1;

	    SSC__c ssc = new SSC__c(Closed__c = false
	    , DW_ID__c = '000111'    
	    , Loc_Type__c = 'SSC'
	    , Manager__c = UserInfo.getUserId()
	    , Region__c = r04.Id
	    , ROM__c = UserInfo.getUserId()
	    , RSM__c = UserInfo.getUserId()
	    , RVP__c = UserInfo.getUserId()     
	    , Sales_Region__c = '04'
	    , SBU__c = 'SC'
	    , Select__c = true
	    , SSC_Fax_Number__c = '123-345-5567'
	    , SSC_Phone_Number__c = '123-345-5567'
	    , State__c = 'TX'
	    , Street_Address__c = '12345 1st street'
	    , Zip_Code__c = '12345');
	    insert ssc;

	    Sales_Representative__c sr041 = new Sales_Representative__c(SBU__c = 'sc'
	    , DW_ID__c = '041'
	    , Region__c = r04.Id);
	    insert sr041;        

	    Customer_Type__c ct2 = new Customer_Type__c(Active__c = true
	    , Select__c = true
	    , SBU__c = 'SC'
	    , Region__c = r04.Id);
	    insert ct2;

		Change_Request__c testCR = new Change_Request__c(
										Customer_Name__c = 'Test New Account Request'
										, SBU__c = 'SC'
										, Business_Reason__c = 'TEST'
										, Sales_Representative__c = sr041.Id
										, Customer_Class__c = cc1.Id
										, Customer_Type__c = ct2.Id
										, RecordTypeId = Label.CR_New_Customer_RT
										, SSC__c = ssc.Id
										, Name__c = 'New Test'
										, Ship_To_Phone__c = '(972) 489-4406'
										, Fax__c = '(972) 489-4406'
										, Region__c = r04.Id
										, Billing_Street_N__c = 'test'
										, Address2__c = 'test'
										, Bill_Country_N__c = 'US'
										, Billing_City_N__c = 'Test'
										, Billing_State_N2__c = 'TX'
										, Billing_Zip_N__c = '75218'
										, Copy_Bill_To_Address__c = TRUE
		);
		insert testCR;

 		pageRef = Page.CustomerRequestNew;
		pageRef.getParameters().put('id',testLead.id);
		Test.setCurrentPage(pageRef);
	    ApexPages.StandardController tstCls = new ApexPages.StandardController(testLead);
	    leadExt = new CustomerRequestNewLightningExtension(tstCls);
        System.debug('::::testLeadNewRequest::::> ' + pageRef); 

	}


	private static void initL1() {
            
            Region__c r1 = new Region__c(Select__c = true
				, SBU__c = 'SC'
				, DW_ID__c = '01'
				, Name = 'SOUTHERN CA REGION');
			insert r1;

        Lead testLead = new Lead ( 
        					FirstName = 'XXX',
        					LastName = 'XXX',
								Company = 'XXX',
								Country = 'US',
								Street = 'XXX',
								City = 'XXX',
								State = 'XXX',
								PostalCode = '75218',
								Phone = '972-489-4406',
								Fax = '972-489-4406',
								Email = 'XXX@daltile.com',
								Website = 'XXX.com',
								ST_Street__c = 'XXX',
								ST_City__c = 'XXX',
								ST_State__c = 'tx',
								ST_Zip__c = '75218',
								Comments__c = 'XXX',
								LeadSource = 'Customer Website Request',
								PO_Required__c  = TRUE,
								DBA_Name__c = 'XXX',
								SSC_Nbr__c = '999');
        insert testLead;

        testLead.Q1__c = 'RSM Assigned';
        update testLead;

		// uiTheme = UserInfo.getUiTheme();
	    // SETUP TEST DATA
	    boolean testRun = false;
	    boolean hasErrors = false;    
	    // USERS / PROFILES

	    Region__c r04 = new Region__c(Select__c = true
	    , SBU__c = 'SC'
	    , DW_ID__c = '04'
	    , Name = 'DT Mid-West');
	    insert r04;

	    Customer_Class__c cc1 = new Customer_Class__c(Active__c = true
	    , COS__c = 111
	    , CustClass__c = 'S8Q'
	    , Cust_Count__c = 123
	    , Customer_Class_Details__c = 'TEST THIS'
	    , CustomerCountry__c = 'US'
	    , CustomerSBU__c = 'SC'
	    , Duplicate__c = false
	    , Net_Sales__c = 111
	    , Price_Region__c = r04.Id
	    , PPS_Rgn__c = '04');
	    insert cc1;

	    SSC__c ssc = new SSC__c(Closed__c = false
	    , DW_ID__c = '000111'    
	    , Loc_Type__c = 'SSC'
	    , Manager__c = UserInfo.getUserId()
	    , Region__c = r04.Id
	    , ROM__c = UserInfo.getUserId()
	    , RSM__c = UserInfo.getUserId()
	    , RVP__c = UserInfo.getUserId()     
	    , Sales_Region__c = '04'
	    , SBU__c = 'SC'
	    , Select__c = true
	    , SSC_Fax_Number__c = '123-345-5567'
	    , SSC_Phone_Number__c = '123-345-5567'
	    , State__c = 'TX'
	    , Street_Address__c = '12345 1st street'
	    , Zip_Code__c = '12345');
	    insert ssc;

	    Sales_Representative__c sr041 = new Sales_Representative__c(SBU__c = 'sc'
	    , DW_ID__c = '041'
	    , Region__c = r04.Id);
	    insert sr041;        

	    Customer_Type__c ct2 = new Customer_Type__c(Active__c = true
	    , Select__c = true
	    , SBU__c = 'SC'
	    , Region__c = r04.Id);
	    insert ct2;

		RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Person Account' Limit 1];
		Change_Request__c testCR = new Change_Request__c(
										Customer_Name__c = 'Test New Account Request'
										, SBU__c = 'SC'
										, Business_Reason__c = 'TEST'
										, Sales_Representative__c = sr041.Id
										, Customer_Class__c = cc1.Id
										, Customer_Type__c = ct2.Id
										, RecordTypeId = Label.CR_New_Customer_RT
										, SSC__c = ssc.Id
										, Name__c = 'New Test'
										, Ship_To_Phone__c = '(972) 489-4406'
										, Fax__c = '(972) 489-4406'
										, Region__c = r04.Id
										, Billing_Street_N__c = 'test'
										, Address2__c = 'test'
										, Bill_Country_N__c = 'US'
										, Billing_City_N__c = 'Test'
										, Billing_State_N2__c = 'TX'
										, Billing_Zip_N__c = '75218'
										, Copy_Bill_To_Address__c = TRUE
		);
		insert testCR;

 		pageRef = Page.CustomerRequestNew;
		pageRef.getParameters().put('id',testLead.id);
		Test.setCurrentPage(pageRef);
	    ApexPages.StandardController tstCls = new ApexPages.StandardController(testLead);
	    leadExt = new CustomerRequestNewLightningExtension(tstCls);
        System.debug('::::testLeadNewRequest::::> ' + pageRef);

	}

	private static void initL2() {

        Lead testLead = new Lead ( 
        					FirstName = 'XXX',
        					LastName = 'XXX',
								Company = 'XXX',
								Country = 'US',
								Street = 'XXX',
								City = 'XXX',
								State = 'XXX',
								PostalCode = '75218',
								LeadSource = 'Customer Website Request',
								Phone = '972-489-4406',
								Fax = '972-489-4406',
								Email = 'XXX@daltile.com',
								Website = 'XXX.com',
								ST_Street__c = 'XXX',
								ST_City__c = 'XXX',
								ST_State__c = 'tx',
								ST_Zip__c = '75218',
								Comments__c = 'XXX',
								PO_Required__c  = TRUE,
								DBA_Name__c = 'XXX',
								SSC_Nbr__c = '111',
								Q1__c = 'REP Assigned');
        insert testLead;



		// uiTheme = UserInfo.getUiTheme();
	    // SETUP TEST DATA
	    boolean testRun = false;
	    boolean hasErrors = false;    
	    // USERS / PROFILES

	    Region__c r04 = new Region__c(Select__c = true
	    , SBU__c = 'SC'
	    , DW_ID__c = '04'
	    , Name = 'DT Mid-West');
	    insert r04;

	    Customer_Class__c cc1 = new Customer_Class__c(Active__c = true
	    , COS__c = 111
	    , CustClass__c = 'S8Q'
	    , Cust_Count__c = 123
	    , Customer_Class_Details__c = 'TEST THIS'
	    , CustomerCountry__c = 'US'
	    , CustomerSBU__c = 'SC'
	    , Duplicate__c = false
	    , Net_Sales__c = 111
	    , Price_Region__c = r04.Id
	    , PPS_Rgn__c = '04');
	    insert cc1;

	    SSC__c ssc = new SSC__c(Closed__c = false
	    , DW_ID__c = '000111'    
	    , Loc_Type__c = 'SSC'
	    , Manager__c = UserInfo.getUserId()
	    , Region__c = r04.Id
	    , ROM__c = UserInfo.getUserId()
	    , RSM__c = UserInfo.getUserId()
	    , RVP__c = UserInfo.getUserId()     
	    , Sales_Region__c = '04'
	    , SBU__c = 'SC'
	    , Select__c = true
	    , SSC_Fax_Number__c = '123-345-5567'
	    , SSC_Phone_Number__c = '123-345-5567'
	    , State__c = 'TX'
	    , Street_Address__c = '12345 1st street'
	    , Zip_Code__c = '12345');
	    insert ssc;

	    Sales_Representative__c sr041 = new Sales_Representative__c(SBU__c = 'sc'
	    , DW_ID__c = '041'
	    , Region__c = r04.Id);
	    insert sr041;        

	    Customer_Type__c ct2 = new Customer_Type__c(Active__c = true
	    , Select__c = true
	    , SBU__c = 'SC'
	    , Region__c = r04.Id);
	    insert ct2;

		RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Person Account' Limit 1];
		Change_Request__c testCR = new Change_Request__c(
										Customer_Name__c = 'Test New Account Request'
										, SBU__c = 'SC'
										, Business_Reason__c = 'TEST'
										, Sales_Representative__c = sr041.Id
										, Customer_Class__c = cc1.Id
										, Customer_Type__c = ct2.Id
										, RecordTypeId = Label.CR_New_Customer_RT
										, SSC__c = ssc.Id
										, Name__c = 'New Test'
										, Ship_To_Phone__c = '(972) 489-4406'
										, Fax__c = '(972) 489-4406'
										, Region__c = r04.Id
										, Billing_Street_N__c = 'test'
										, Address2__c = 'test'
										, Bill_Country_N__c = 'US'
										, Billing_City_N__c = 'Test'
										, Billing_State_N2__c = 'TX'
										, Billing_Zip_N__c = '75218'
										, Copy_Bill_To_Address__c = TRUE
		);
		insert testCR;

 		pageRef = Page.CustomerRequestNew;
		pageRef.getParameters().put('id',testLead.id);
		Test.setCurrentPage(pageRef);
	    ApexPages.StandardController tstCls = new ApexPages.StandardController(testLead);
	    leadExt = new CustomerRequestNewLightningExtension(tstCls);
        System.debug('::::testLeadNewRequest::::> ' + pageRef);

	}

	private static void initL3() {
    
        Lead testLead = new Lead ( 
        					FirstName = 'XXX',
        					LastName = 'XXX',
								Company = 'XXX',
								Country = 'US',
								Street = 'XXX',
								City = 'XXX',
								State = 'XXX',
								PostalCode = '75218',
								LeadSource = 'Customer Website Request',
								Phone = '972-489-4406',
								Fax = '972-489-4406',
								Email = 'XXX@daltile.com',
								Website = 'XXX.com',
								ST_Street__c = 'XXX',
								ST_City__c = 'XXX',
								ST_State__c = 'tx',
								ST_Zip__c = '75218',
								Comments__c = 'XXX',
								SSC_Nbr__c = '',
								PO_Required__c  = TRUE,
								DBA_Name__c = 'XXX');
        insert testLead;



		// uiTheme = UserInfo.getUiTheme();
	    // SETUP TEST DATA
	    boolean testRun = false;
	    boolean hasErrors = false;    
	    // USERS / PROFILES

	    Region__c r04 = new Region__c(Select__c = true
	    , SBU__c = 'SC'
	    , DW_ID__c = '04'
	    , Name = 'DT Mid-West');
	    insert r04;

	    Customer_Class__c cc1 = new Customer_Class__c(Active__c = true
	    , COS__c = 111
	    , CustClass__c = 'S8Q'
	    , Cust_Count__c = 123
	    , Customer_Class_Details__c = 'TEST THIS'
	    , CustomerCountry__c = 'US'
	    , CustomerSBU__c = 'SC'
	    , Duplicate__c = false
	    , Net_Sales__c = 111
	    , Price_Region__c = r04.Id
	    , PPS_Rgn__c = '04');
	    insert cc1;

	    SSC__c ssc = new SSC__c(Closed__c = false
	    , DW_ID__c = '000111'    
	    , Loc_Type__c = 'SSC'
	    , Manager__c = UserInfo.getUserId()
	    , Region__c = r04.Id
	    , ROM__c = UserInfo.getUserId()
	    , RSM__c = UserInfo.getUserId()
	    , RVP__c = UserInfo.getUserId()     
	    , Sales_Region__c = '04'
	    , SBU__c = 'SC'
	    , Select__c = true
	    , SSC_Fax_Number__c = '123-345-5567'
	    , SSC_Phone_Number__c = '123-345-5567'
	    , State__c = 'TX'
	    , Street_Address__c = '12345 1st street'
	    , Zip_Code__c = '12345');
	    insert ssc;

	    Sales_Representative__c sr041 = new Sales_Representative__c(SBU__c = 'sc'
	    , DW_ID__c = '041'
	    , Region__c = r04.Id);
	    insert sr041;        

	    Customer_Type__c ct2 = new Customer_Type__c(Active__c = true
	    , Select__c = true
	    , SBU__c = 'SC'
	    , Region__c = r04.Id);
	    insert ct2;

		RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Person Account' Limit 1];
		Change_Request__c testCR = new Change_Request__c(
										Customer_Name__c = 'Test New Account Request'
										, SBU__c = 'SC'
										, Business_Reason__c = 'TEST'
										, Sales_Representative__c = sr041.Id
										, Customer_Class__c = cc1.Id
										, Customer_Type__c = ct2.Id
										, RecordTypeId = Label.CR_New_Customer_RT
										, SSC__c = ssc.Id
										, Name__c = 'New Test'
										, Ship_To_Phone__c = '(972) 489-4406'
										, Fax__c = '(972) 489-4406'
										, Region__c = r04.Id
										, Billing_Street_N__c = 'test'
										, Address2__c = 'test'
										, Bill_Country_N__c = 'US'
										, Billing_City_N__c = 'Test'
										, Billing_State_N2__c = 'TX'
										, Billing_Zip_N__c = '75218'
										, Copy_Bill_To_Address__c = TRUE
		);
		insert testCR;

 		pageRef = Page.CustomerRequestNew;
		pageRef.getParameters().put('id',testLead.id);
		Test.setCurrentPage(pageRef);
	    ApexPages.StandardController tstCls = new ApexPages.StandardController(testLead);
	    leadExt = new CustomerRequestNewLightningExtension(tstCls);
        System.debug('::::testLeadNewRequest::::> ' + pageRef);

	}

	static testmethod void testnewPersonAccountExt(){   
		RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Person Account' Limit 1];
	    
	    Region__c r04 = new Region__c(Select__c = true
	    , SBU__c = 'SC'
	    , DW_ID__c = '04'
	    , Name = 'DT Mid-West');
	    insert r04;

	    Customer_Class__c cc1 = new Customer_Class__c(Active__c = true
	    , COS__c = 111
	    , CustClass__c = 'S8Q'
	    , Cust_Count__c = 123
	    , Customer_Class_Details__c = 'TEST THIS'
	    , CustomerCountry__c = 'US'
	    , CustomerSBU__c = 'SC'
	    , Duplicate__c = false
	    , Net_Sales__c = 111
	    , Price_Region__c = r04.Id
	    , PPS_Rgn__c = '04');
	    insert cc1;

	    SSC__c ssc = new SSC__c(Closed__c = false
	    , DW_ID__c = '000111'    
	    , Loc_Type__c = 'SSC'
	    , Manager__c = UserInfo.getUserId()
	    , Region__c = r04.Id
	    , ROM__c = UserInfo.getUserId()
	    , RSM__c = UserInfo.getUserId()
	    , RVP__c = UserInfo.getUserId()     
	    , Sales_Region__c = '04'
	    , SBU__c = 'SC'
	    , Select__c = true
	    , SSC_Fax_Number__c = '123-345-5567'
	    , SSC_Phone_Number__c = '123-345-5567'
	    , State__c = 'TX'
	    , Street_Address__c = '12345 1st street'
	    , Zip_Code__c = '12345');
	    insert ssc;  
        
        Account testAccount = new Account(Name='Person Account Test123',
        RecordTypeId = rt.id, 
        Region__c = r04.id, 
        SSC__c = ssc.id);
        
        insert testAccount;
        
        Test.startTest();
        newPersonAccountExt controller = new newPersonAccountExt(new ApexPages.StandardController(testAccount));
		controller.getRecordTypes();
        Test.stopTest();
    }

	static testmethod void testCRNLExtNewAccountRemote(){
		 
		// uiTheme = UserInfo.getUiTheme();
	    // SETUP TEST DATA
	    boolean testRun = false;
	    boolean hasErrors = false;    
	    // USERS / PROFILES

	    Region__c r04 = new Region__c(Select__c = true
	    , SBU__c = 'SC'
	    , DW_ID__c = '04'
	    , Name = 'DT Mid-West');
	    insert r04;

	    Customer_Class__c cc1 = new Customer_Class__c(Active__c = true
	    , COS__c = 111
	    , CustClass__c = 'S8Q'
	    , Cust_Count__c = 123
	    , Customer_Class_Details__c = 'TEST THIS'
	    , CustomerCountry__c = 'US'
	    , CustomerSBU__c = 'SC'
	    , Duplicate__c = false
	    , Net_Sales__c = 111
	    , Price_Region__c = r04.Id
	    , PPS_Rgn__c = '04');
	    insert cc1;

	    SSC__c ssc = new SSC__c(Closed__c = false
	    , DW_ID__c = '000111'    
	    , Loc_Type__c = 'SSC'
	    , Manager__c = UserInfo.getUserId()
	    , Region__c = r04.Id
	    , ROM__c = UserInfo.getUserId()
	    , RSM__c = UserInfo.getUserId()
	    , RVP__c = UserInfo.getUserId()     
	    , Sales_Region__c = '04'
	    , SBU__c = 'SC'
	    , Select__c = true
	    , SSC_Fax_Number__c = '123-345-5567'
	    , SSC_Phone_Number__c = '123-345-5567'
	    , State__c = 'TX'
	    , Street_Address__c = '12345 1st street'
	    , Zip_Code__c = '12345');
	    insert ssc;

	    Sales_Representative__c sr041 = new Sales_Representative__c(SBU__c = 'sc'
	    , DW_ID__c = '041'
	    , Region__c = r04.Id);
	    insert sr041;        

	    Customer_Type__c ct2 = new Customer_Type__c(Active__c = true
	    , Select__c = true
	    , SBU__c = 'SC'
	    , Region__c = r04.Id);
	    insert ct2;

		RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Person Account' Limit 1];
		
		string updateName = 'testststst';
		string updateContact = 'testtest';
		string updatePhone = '9724894406';
		string updateFax = '9724894407';
		string updateComments = 'nope';
		string updateDBAName = 'nah';
		string updateWebsite = 'nope.nah.edu';
		string updateNewRegion = r04.Id;
		string updateNewRep = sr041.Id;
		string updateNewSSC = ssc.Id;
		string updateNewCusClass = cc1.Id;
		string updateNewReasonForClass = 'nope';
		string updateNewCusType = ct2.Id;
		string updateShipToCountryChange = 'US';
		string updateShipToAddress1Change = 'nope';
		string updateShipToAddress2Change = 'nope';
		string updateShipToCityChange = 'Dallas';
		string updateShipToZip = '75218';
		string updateShipToState   = 'TX';
		string updateBillToCountryChange = 'US';
		string updateBillToAddress1Change = 'nope';
		string updateBillToAddress2Change = 'nope';
		string updateBillToCityChange = 'Dallas';
		string updateBillToZip = '75218';
		string updateBillToState = 'TX';	
        Boolean updateCopyBillto = TRUE;
        Boolean updateContactProExch = true;
        string updateContactFirstName = 'TX';	
        string updateContactLastName = 'Oh TX';	
        string updateContactPhone = '2145557788';	
        string updateContactEmail = 'all.hail.the.mighty@state.io';
                                        
		CustomerRequestNewLightningExtension.saveNewCustomer(       
		            updateName,
		            updateContact,
		            updatePhone,
		            updateFax,
		            updateComments,
		            updateDBAName,
		            updateWebsite,
		            updateNewRegion,
		            updateNewRep,
		            updateNewSSC,
		            updateNewCusClass,
		            updateNewReasonForClass,
		            updateNewCusType,
		            updateShipToCountryChange,
		            updateShipToAddress1Change,
		            updateShipToAddress2Change,
		            updateShipToCityChange,
		            updateShipToZip,
		            updateShipToState  ,
		            updateBillToCountryChange,
		            updateBillToAddress1Change,
		            updateBillToAddress2Change,
		            updateBillToCityChange,
		            updateBillToZip,
		            updateBillToState,
		            updateCopyBillto,
                    updateContactProExch,
                    updateContactFirstName,
                    updateContactLastName,
                    updateContactPhone,
                    updateContactEmail	
		);
		
		Change_Request__c testCR = new Change_Request__c(
										Customer_Name__c = 'Test New Account Request'
										, SBU__c = 'SC'
										, Business_Reason__c = 'TEST'
										, Sales_Representative__c = sr041.Id
										, Customer_Class__c = cc1.Id
										, Customer_Type__c = ct2.Id
										, RecordTypeId = Label.CR_New_Customer_RT
										, SSC__c = ssc.Id
										, Name__c = 'New Test'
										, Ship_To_Phone__c = '(972) 489-4406'
										, Fax__c = '(972) 489-4406'
										, Region__c = r04.Id
										, Billing_Street_N__c = 'test'
										, Address2__c = 'test'
										, Bill_Country_N__c = 'US'
										, Billing_City_N__c = 'Test'
										, Billing_State_N2__c = 'TX'
										, Billing_Zip_N__c = '75218'
										, Copy_Bill_To_Address__c = TRUE
		);
		insert testCR;
        
        Test.startTest();

 		pageRef = Page.CustomerRequestNew;
		Test.setCurrentPage(pageRef);

        CustomerRequestNewLightningExtension controller = new CustomerRequestNewLightningExtension(new ApexPages.StandardController(testCR));
		controller.getContextUserUiTheme();
		controller.doCheckForUX();
		controller.getRecordTypes();
		controller.doCheckForUX();
		controller.doCancel();
        Test.stopTest();
    }

	static testmethod void testCustomerRequestNewLightningExtension(){
		 
		// uiTheme = UserInfo.getUiTheme();
	    // SETUP TEST DATA
	    boolean testRun = false;
	    boolean hasErrors = false;    
	    // USERS / PROFILES

	    Region__c r04 = new Region__c(Select__c = true
	    , SBU__c = 'SC'
	    , DW_ID__c = '04'
	    , Name = 'DT Mid-West');
	    insert r04;

	    Customer_Class__c cc1 = new Customer_Class__c(Active__c = true
	    , COS__c = 111
	    , CustClass__c = 'S8Q'
	    , Cust_Count__c = 123
	    , Customer_Class_Details__c = 'TEST THIS'
	    , CustomerCountry__c = 'US'
	    , CustomerSBU__c = 'SC'
	    , Duplicate__c = false
	    , Net_Sales__c = 111
	    , Price_Region__c = r04.Id
	    , PPS_Rgn__c = '04');
	    insert cc1;

	    SSC__c ssc = new SSC__c(Closed__c = false
	    , DW_ID__c = '000111'    
	    , Loc_Type__c = 'SSC'
	    , Manager__c = UserInfo.getUserId()
	    , Region__c = r04.Id
	    , ROM__c = UserInfo.getUserId()
	    , RSM__c = UserInfo.getUserId()
	    , RVP__c = UserInfo.getUserId()     
	    , Sales_Region__c = '04'
	    , SBU__c = 'SC'
	    , Select__c = true
	    , SSC_Fax_Number__c = '123-345-5567'
	    , SSC_Phone_Number__c = '123-345-5567'
	    , State__c = 'TX'
	    , Street_Address__c = '12345 1st street'
	    , Zip_Code__c = '12345');
	    insert ssc;

	    Sales_Representative__c sr041 = new Sales_Representative__c(SBU__c = 'sc'
	    , DW_ID__c = '041'
	    , Region__c = r04.Id);
	    insert sr041;        

	    Customer_Type__c ct2 = new Customer_Type__c(Active__c = true
	    , Select__c = true
	    , SBU__c = 'SC'
	    , Region__c = r04.Id);
	    insert ct2;

		RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Person Account' Limit 1];
		Change_Request__c testCR = new Change_Request__c(
										Customer_Name__c = 'Test New Account Request'
										, SBU__c = 'SC'
										, Business_Reason__c = 'TEST'
										, Sales_Representative__c = sr041.Id
										, Customer_Class__c = cc1.Id
										, Customer_Type__c = ct2.Id
										, RecordTypeId = Label.CR_New_Customer_RT
										, SSC__c = ssc.Id
										, Name__c = 'New Test'
										, Ship_To_Phone__c = '(972) 489-4406'
										, Fax__c = '(972) 489-4406'
										, Region__c = r04.Id
										, Billing_Street_N__c = 'test'
										, Address2__c = 'test'
										, Bill_Country_N__c = 'US'
										, Billing_City_N__c = 'Test'
										, Billing_State_N2__c = 'TX'
										, Billing_Zip_N__c = '75218'
										, Copy_Bill_To_Address__c = TRUE
		);
		insert testCR;
        
        Test.startTest();

 		pageRef = Page.CustomerRequestNew;
		Test.setCurrentPage(pageRef);

        CustomerRequestNewLightningExtension controller = new CustomerRequestNewLightningExtension(new ApexPages.StandardController(testCR));
		controller.getContextUserUiTheme();
		// controller.saveData();
		controller.doCheckForUX();
		controller.getRecordTypes();
		controller.doCheckForUX();
		controller.doCancel();
        Test.stopTest();
    }
    
	static testmethod void testCustomerRequestNewLightningExtension2(){    


		// uiTheme = UserInfo.getUiTheme();
	    // SETUP TEST DATA
	    boolean testRun = false;
	    boolean hasErrors = false;    
	    // USERS / PROFILES

	    Region__c r04 = new Region__c(Select__c = true
	    , SBU__c = 'SC'
	    , DW_ID__c = '04'
	    , Name = 'DT Mid-West');
	    insert r04;

	    Customer_Class__c cc1 = new Customer_Class__c(Active__c = true
	    , COS__c = 111
	    , CustClass__c = 'S8Q'
	    , Cust_Count__c = 123
	    , Customer_Class_Details__c = 'TEST THIS'
	    , CustomerCountry__c = 'US'
	    , CustomerSBU__c = 'SC'
	    , Duplicate__c = false
	    , Net_Sales__c = 111
	    , Price_Region__c = r04.Id
	    , PPS_Rgn__c = '04');
	    insert cc1;

	    SSC__c ssc = new SSC__c(Closed__c = false
	    , DW_ID__c = '000111'    
	    , Loc_Type__c = 'SSC'
	    , Manager__c = UserInfo.getUserId()
	    , Region__c = r04.Id
	    , ROM__c = UserInfo.getUserId()
	    , RSM__c = UserInfo.getUserId()
	    , RVP__c = UserInfo.getUserId()     
	    , Sales_Region__c = '04'
	    , SBU__c = 'SC'
	    , Select__c = true
	    , SSC_Fax_Number__c = '123-345-5567'
	    , SSC_Phone_Number__c = '123-345-5567'
	    , State__c = 'TX'
	    , Street_Address__c = '12345 1st street'
	    , Zip_Code__c = '12345');
	    insert ssc;

	    Sales_Representative__c sr041 = new Sales_Representative__c(SBU__c = 'sc'
	    , DW_ID__c = '041'
	    , Region__c = r04.Id);
	    insert sr041;        

	    Customer_Type__c ct2 = new Customer_Type__c(Active__c = true
	    , Select__c = true
	    , SBU__c = 'SC'
	    , Region__c = r04.Id);
	    insert ct2;

		RecordType rt = [select id,Name from RecordType where SobjectType='Account' and Name='Person Account' Limit 1];
		Change_Request__c testCR = new Change_Request__c(
										Customer_Name__c = 'Test New Account Request'
										, SBU__c = 'SC'
										, Business_Reason__c = 'TEST'
										, Sales_Representative__c = sr041.Id
										, Customer_Class__c = cc1.Id
										, Customer_Type__c = ct2.Id
										, RecordTypeId = Label.CR_New_Customer_RT
										, SSC__c = ssc.Id
										, Name__c = 'New Test'
										, Ship_To_Phone__c = '(972) 489-4406'
										, Fax__c = '(972) 489-4406'
										, Region__c = r04.Id
										, Billing_Street_N__c = 'test'
										, Address2__c = 'test'
										, Bill_Country_N__c = 'US'
										, Billing_City_N__c = 'Test'
										, Billing_State_N2__c = 'TX'
										, Billing_Zip_N__c = '75218'
										, Copy_Bill_To_Address__c = TRUE
		);
		insert testCR;
        Test.startTest();
        CustomerRequestNewLightningExtension controller2 = new CustomerRequestNewLightningExtension(new ApexPages.StandardController(testCR));
	    String uiTheme3D = 'TestTheme3D';
		string uiTheme = uiTheme3D;
		System.debug('testCustomerRequestNewLightningExtension2....uiTheme!!!!' + uiTheme);
		controller2.doCheckForUX(); 		
 		pageRef = Page.CustomerRequestNew;
		Test.setCurrentPage(pageRef);
		controller2.getRecordTypes();
		controller2.doCheckForUX();
		controller2.doCancel();
        Test.stopTest();

    }
	static testmethod void testLeadNewRequest(){
		 
		// uiTheme = UserInfo.getUiTheme();
		initL();

        
        Test.startTest();

 		pageRef = Page.CustomerRequestNew;
		Test.setCurrentPage(pageRef);
		leadExt.getContextUserUiTheme();
		leadExt.doCheckForUX();
		leadExt.getRecordTypes();
		leadExt.doCheckForUX();
		leadExt.doCancel();
        Test.stopTest();
    }

    static testmethod void testLeadNewRequest1(){
		 
		// uiTheme = UserInfo.getUiTheme();
		initL1();

        
        Test.startTest();

 		pageRef = Page.CustomerRequestNew;
		Test.setCurrentPage(pageRef);
		leadExt.getContextUserUiTheme();

		leadExt.getRecordTypes();

		leadExt.doCancel();
        Test.stopTest();
    }

	static testmethod void testLeadNewRequest2(){
		 
		// uiTheme = UserInfo.getUiTheme();
		initL2();

        
        Test.startTest();

 		pageRef = Page.CustomerRequestNew;
		Test.setCurrentPage(pageRef);
		leadExt.getContextUserUiTheme();

		leadExt.getRecordTypes();

		leadExt.doCancel();
        Test.stopTest();
    }

    	static testmethod void testLeadNewRequest3(){
		 
		// uiTheme = UserInfo.getUiTheme();
		initL3();

        
        Test.startTest();

 		pageRef = Page.CustomerRequestNew;
		Test.setCurrentPage(pageRef);
		leadExt.getContextUserUiTheme();
		leadExt.doCheckForUX();
		leadExt.getRecordTypes();

		leadExt.doCancel();
        Test.stopTest();
    }


}