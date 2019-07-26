@isTest
public with sharing class TestWebCustomerRequest {
	
	static PageReference pageRef;	
	static PageReference pageRef2;
	static PageReference pref;
	static PageReference pref2;
	private final Change_Request__c cr;
	static WebCustomerRequest leadExt;

	static testmethod void  testWebCustomerRequest (){    
	// SETUP TEST DATA
    boolean testRun = false;
    boolean hasErrors = false;    

    // REGIONS
  
    Region__c r04 = new Region__c(Select__c = true
  , SBU__c = 'SC'
  , DW_ID__c = '04'
  , Name = 'MIDWEST REGION');
    insert r04;

  // REPS
    Sales_Representative__c sr041 = new Sales_Representative__c(SBU__c = 'sc'
  , DW_ID__c = '041'
  , Region__c = r04.Id);
    insert sr041;

    Sales_Representative__c sr042 = new Sales_Representative__c(SBU__c = 'sc'
  , DW_ID__c = '042'
  , Region__c = r04.Id
  , Salesman_Last_Name__c = 'REGION');
    insert sr042;
  
    // CUSTOMER CLASS

    Customer_Class__c cc1 = new Customer_Class__c(Active__c = true
  , COS__c = 111
  , CustClass__c = 'S9Q'
  , Cust_Count__c = 123
  , Customer_Class_Details__c = 'TEST THIS'
  , CustomerCountry__c = 'US'
  , CustomerSBU__c = 'SC'
  , Duplicate__c = false
  , Net_Sales__c = 111
  , PPS_Rgn__c = 'SC MW');
    insert cc1;

    // SSC

    SSC__c ssc1 = new SSC__c(Closed__c = false
  , DW_ID__c = '000112'
  , Loc_Type__c = 'SSC'
  , Manager__c = UserInfo.getUserId()
  , ROM__c = UserInfo.getUserId()
  , RSM__c = UserInfo.getUserId()
  , RVP__c = UserInfo.getUserId()   
  , Region__c = r04.Id
  , Sales_Region__c = '04'
  , SBU__c = 'DI'
  , Select__c = true
  , SSC_Fax_Number__c = '123-345-5567'
  , SSC_Phone_Number__c = '123-345-5567'
  , State__c = 'TX'
  , Street_Address__c = '12345 1st street'
  , Zip_Code__c = '12345');
    insert ssc1;

    // CUSTOMER TYPE

    Customer_Type__c ct2 = new Customer_Type__c(Active__c = true
  , Select__c = true
  , SBU__c = 'SC'
  , Region__c = r04.Id);
    insert ct2;
	Test.startTest();


    Change_Request__c newCustomer = new Change_Request__c(SBU__c = 'SC'
    , IsNew__c = false
    , Suffix_N__c = 'NEW'
    , Reason_for_New_Suffix__c = 'cause'
    , Customer_Class_n__c = cc1.id
    , Business_Reason__c = 'TEST'
    , Sales_Representative__c = sr041.Id
    , Customer_Class__c = cc1.Id
    , Customer_Type__c = ct2.Id
    , RecordTypeId = Label.CR_New_Customer_RT
    , SSC__c = ssc1.Id
    , Name__c = NULL
    , Ship_To_Phone__c = '(972) 489-4406'
    , Fax__c = '(972) 489-4406'
    , Region__c = r04.Id);
		insert newCustomer; 


	pageRef = Page.WebCustomerRequest;
	pageRef2 = Page.WebCustomerRequestThanks;
	Test.setCurrentPage(pageRef);
	WebCustomerRequest controller = new WebCustomerRequest(new ApexPages.StandardController(newCustomer));
	pref = controller.save();
	Test.setCurrentPage(pageRef2);
    Test.stopTest();
	}
}