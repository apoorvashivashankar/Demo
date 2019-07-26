/**
 * Created by 7Summits on 3/2/18. 
 */

public class Dal_MyAccountMetricsController {
	/**  
    * This Class return all the data required from External Object "DT_SYS_Account_Summary__x" 
    * @return Peak Response
    */ 
    @AuraEnabled
    public static Peak_Response getAccountSummary() {
        Peak_Response response = new Peak_Response();

        // Get the user's selected location ID
        Account selectedAccount = Dal_BaseController.getUserSelectedLocation();
		
        try{
            // get account summary data
            List<DT_SYS_Account_Summary__x> accountSummary = Dal_AccountSummaryManager.getAccountSummary(selectedAccount.DW_ID__c);

            // check the results and set the peak response
            if(accountSummary.size() > 0){
                response.results = accountSummary;
            } else {
                System.debug('Dal_MyAccountMetricsController: No Data');
                response.success = false;
                response.messages.add('No Account Summary Available');
            }

        } catch(exception e){
            response.success = false;
            response.messages.add(e.getMessage());
        }
		system.debug('response is '+response);
        return response;
    }
      
}