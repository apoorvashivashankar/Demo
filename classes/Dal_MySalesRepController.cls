/**
 * Created by 7Summits on 3/15/18.
 */
public without sharing class Dal_MySalesRepController {
    /**
    * This Class return selected Customer Sales & Credit Info. 
    * @return Peak Response
    */ 
    
    // Get Selected Account
    Public static Account selectedAccount = Dal_BaseController.getUserSelectedLocation();


	@auraEnabled
	public static List<Peak_Response> getMyCustomerCreditAndSalesRep(){
		List<Peak_Response> response = new List<Peak_Response>();

		Peak_Response myCustomerCreditRep = getMyCustomerCreditRep();
		Peak_Response mySalesRep = getMyCustomerSalesRep();

		response.add(myCustomerCreditRep);
		response.add(mySalesRep);

		return response;
	}

    // Method for distributor community which returns Customers Credit from Custom object 'Customer_Credit_Rep_Position__c'.
    @AuraEnabled
    public static Peak_Response getMyCustomerCreditRep(){
    	
    	Peak_Response response = new  Peak_Response();
    	List<Account> customerSalesRepList =new List<Account>();
        if(selectedAccount !=null) {
    	customerSalesRepList = [Select Customer_Credit_Rep_Position__r.First_Name__c ,Customer_Credit_Rep_Position__r.Last_Name__c,
    							Customer_Credit_Rep_Position__r.Type__c,Customer_Credit_Rep_Position__r.Phone__c,
    							Customer_Credit_Rep_Position__r.Email__c from Account where Id =: selectedAccount.Id];
    	 
    	   if(customerSalesRepList.size() > 0 && String.isNotBlank(customerSalesRepList[0].id)) {
    	   		
    	    		System.debug('in'+customerSalesRepList[0]);
                    response.messages.add('Record Found');
                    response.results.add(customerSalesRepList[0]);
                    response.peakResults = null;
                    
           }
        }
        else{
               	System.debug('Account not found with Seles Representative');
                response.success= false;
           		response.messages.add('Record not found');
           		response.results = null;
           		response.peakResults = null; 
           		return response; 
           }
    	
    	return response;
    }
    
    //Method for SSC community which returns Customers Sales from Custom object 'Sales_Representative__c'
    @AuraEnabled
    public static Peak_Response getMyCustomerSalesRep(){
    	
	
    	Peak_Response response = new  Peak_Response();
    	List<Account> customerSalesRepList =new List<Account>();
    	if(selectedAccount !=null) {
    	 	
    	customerSalesRepList = [Select Salesman__r.User__r.FirstName,Salesman__r.User__r.LastName,Salesman__r.User__r.Title,
    						Salesman__r.User__r.MobilePhone,Salesman__r.User__r.Email from Account where Id =: selectedAccount.Id];
    	 
    	   if(customerSalesRepList.size() > 0 && String.isNotBlank(customerSalesRepList[0].id)) {
    	   		
    	    		System.debug('in'+customerSalesRepList[0]);
                    response.messages.add('Record Found');
                    response.results.add(customerSalesRepList[0]);
                    response.peakResults = null;
                    
           }
        }
         else{
               	System.debug('Account not found with Seles Representative');
                response.success= false;
           		response.messages.add('Record not found');
           		response.results = null;
           		response.peakResults = null;
           		return response; 
         }
    	 
    	System.debug('CustomerSalesRep'+customerSalesRepList);	
    	    					
    	return response;
    	
    }
   
}