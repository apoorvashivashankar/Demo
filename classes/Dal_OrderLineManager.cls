/**
* Created by 7Summits on 3/27/18.
*/
public class Dal_OrderLineManager {
    
    /*
	* Method Name: getOrderLineByOrderNo
	* Description: Purpose to data from external object 'DT_SYS_OrderList__x' on the basis of orderNumber.
	* @param: Order number
	* @return List Of External Object
	*/ 
    @AuraEnabled
    public static List<DT_SYS_OrderList__x> getOrderLineByOrderNo(Id orderNumber){
        String customerId; 
        Account selectedAccount = Dal_BaseController.getUserSelectedLocation();
        customerId = selectedAccount.DW_ID__c;
        List<DT_SYS_OrderList__x> orderLineItem = new List<DT_SYS_OrderList__x>();
        try{
            orderLineItem = [SELECT Id, ExternalId, DisplayUrl,  CustomerGrp__c, CustomerPONo__c, Customer__c, HostSystem__c,
                             JobName__c, OrderPlantName__c, OrderPlant__c, SalesOrder__c, StatusDesc__c, Status__c, id__c
                             FROM DT_SYS_OrderList__x WHERE Id =: orderNumber AND Customer__c =: customerId ];
        } catch(Exception exp){
            System.debug('SalesOrderHeader__x: An unexpected error has occurred: ' + exp.getMessage());
        }
        return orderLineItem;
    }
    
}