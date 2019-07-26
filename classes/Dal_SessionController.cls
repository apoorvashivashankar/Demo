/**
 * Created by 7Summits on 3/13/18.
 */

public with sharing class Dal_SessionController {
/*
    public static Peak_Response getSessionOrder(){
        String orderIdString;

        // If there's already an event/order in session, use it!
        if (Cache.Session.contains(Dal_Constants.SESSION_ORDER_NAME)) {
            orderIdString = (String)Cache.Session.get(Dal_Constants.SESSION_ORDER_NAME);
        } else {
            // List userOrders = Select ID from Dal_Order where Account_ID__c = :getSessionAcount() and TBD - likely by last mod date

            // If we found an Order, put it in session, return it
            if (!Peak_Utils.isNullOrEmpty(userOrders)){
                orderIdString = (String)userOrders[0].Id;
                Peak_Response response = setSessionOrder(orderIdString);
            } else {
                // create new order under the account getSessionAccount(),, put into session, return
            }
        }

        // Return result
        return orderIdString;

    }

    public static Peak_Response setSessionOrder(String sessionOrderId){
        // Init peak response
        Peak_Response peakResponse = new Peak_Response();

        // Put current order into session cache
        try{
            Cache.Session.put(Dal_Constants.SESSION_ORDER_NAME, orderIDString);
        } catch (exception e) {
            peakResponse.success = false;
            peakResponse.messages.add(e.getMessage());
        }

        // Return result and possible error messages
        return peakResponse;
    }

    public static Peak_Response getSessionAccount(){
        // similar to getSessionOrder
        // TBD business logic to determine which account to select if none is currently in session, likely querying User’s Selected_Location__c
        // However, do not create a new Account like getSessionOrder creates a new Order!
        // return Peak_Response with success/failure messaging
    }

    public static Peak_Response setSessionAccount(String sessionAccountId){
        // similar to setSessionOrder
        // also update current user’s Current_Location__c field. We won’t query this every time as session cache is quicker, but this is needed for branding set
    }
*/
//--------------------------------------------------------------------------------------------------------------------------------

	public static String sessionOrderName = 'local.DTSessionCache.'+Dal_Constants.SESSION_ORDER_NAME;
	
    /*
	* Method Name: getSessionOrder
	* Description: Purpose to get Order stored in Session
	* @param: Not Any
	* @return OrderId
	*/
	public static String getSessionOrder(){
		
		String recentOrderId;
		list<DT_Order__c> currentOrderList = new LIST<DT_Order__c>();
    	   // if -- Data was already in Cache 
        // else Query data from External object put it in Cache

        if (Cache.Org.contains(sessionOrderName)) {
            System.debug('InCACHE');
            System.debug('Data In Cache>'+ Cache.Session.get(sessionOrderName)); 
            
        }else{
        	  	// Get the user's selected location ID
	       		Account selectedAccount = Dal_BaseController.getUserSelectedLocation();
	            currentOrderList =  [Select Id from DT_Order__c where AccountName__c  =: selectedAccount.Id  order by LastModifiedDate desc];
	            recentOrderId = (currentOrderList != null && !currentOrderList.isEmpty()) ? currentOrderList[0].id : null;

	            if(currentOrderList.size() > 0 && String.isNotBlank(recentOrderId)) {
		            Cache.Session.put('local.DTSessionCache.CurrentOrder', recentOrderId);
		            System.debug('Cache Created----->'+Cache.Session.get(sessionOrderName)); 
	        	}
	        	else
	        	{
	        		DT_Order__c newOrder = new DT_Order__c();
	        		newOrder.Name = 'NewOrder';
					newOrder.AccountName__c = selectedAccount.Id;
	        		insert newOrder;
	        		currentOrderList = [Select Id from DT_Order__c where AccountName__c  =: selectedAccount.Id  order by LastModifiedDate desc ];

	        		recentOrderId = currentOrderList[0].id;
	        		setSessionOrder (recentOrderId);
	        	}
    		}
    	return recentOrderId;
	}
	
     /*
	* Method Name: setSessionOrder
	* Description: Purpose to set Order in Session
	* @param: Not orderId
	* @return Void 
	*/
	public static void setSessionOrder(String sessionOrderId){
		
		 Cache.Session.put(sessionOrderName , sessionOrderId);
		 System.debug('Cache Created----->'+Cache.Session.get(sessionOrderName)); 
	}
	
}