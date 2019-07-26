/**
 * Created by 7Summits on 3/27/18.
 */
public with sharing class Dal_Dist_OrderProcessController {
 
  /**
    * This Class update DT_Order__c object record"  
    * @return Peak Response
    */
    
    
   @AuraEnabled
   public static void saveOrderDetails(DT_Order__c orderDetail){   
   	
    	try{
    			update orderDetail;
    	}catch(DmlException exp){
    		System.debug('Dal_Dist_OrderProcessController--update error -- '+ exp.getMessage());
    	}
   }
   
}