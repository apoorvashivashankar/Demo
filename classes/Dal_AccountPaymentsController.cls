/**
* Created by 7Summits on 3/5/18.
*/

public with sharing class Dal_AccountPaymentsController {
	
    /**
    * This Class return all the data required from External Object "DT_SYS_Account_Payment__x" 
    * @return Peak Response
    */ 
    
    @TestVisible 
    private static list<DT_SYS_Account_Payment__x> mockedAccountPayment = new List<DT_SYS_Account_Payment__x>();

    public static List<DT_SYS_Account_Payment__x> paymentSummary  = new List<DT_SYS_Account_Payment__x>();
    
    @AuraEnabled
    public static Peak_Response getPaymentSummary(Integer listLimit) {

        Peak_Response response = new Peak_Response();
        
        // Get the user's selected location ID
        User currentUser = Dal_BaseController.getUser();

        // Get selected Account
        Account selectedAccount = Dal_BaseController.getUserSelectedLocation();

        if(!Test.isRunningTest()){
            // get account Payment data
            paymentSummary = Dal_AccountPaymentsManager.getPaymentSummary(selectedAccount.DW_ID__c, listLimit);
        }
        else
        {
            paymentSummary.addAll(mockedAccountPayment);
        }

        // check the results and set the peak response
        if(paymentSummary.size() > 0){
            response.messages.add('Account Payment Available');
            response.results = paymentSummary;
        } else {
            System.debug('Dal_AccountPaymentsController: No Data');
            response.success = false;
            response.messages.add('No Account Payment Available');
        }
        system.debug('Dal_AccountPaymentsController: response ' +response);
        return response;
    }
    
}