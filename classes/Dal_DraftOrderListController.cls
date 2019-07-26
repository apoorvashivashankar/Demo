/**
 * Created by 7Summits on 5/1/18.
 */

public with sharing class Dal_DraftOrderListController {
    @AuraEnabled
    public static List<DT_Order__c> getDraftOrders(Integer listLimit){
        return Dal_OrderManager.getDraftedOrders(listLimit);
    }

    @AuraEnabled
    public static boolean deleteDraftOrder(String draftOrderId){
        List<DT_Order__c> orderToDelete = Dal_OrderManager.getOrderById(draftOrderId);

        if(orderToDelete != null && orderToDelete.size() > 0) {
            Dal_OrderManager.cleanupDraftOrders(orderToDelete);
            return true;
        }

        return false;
    }

    @AuraEnabled
    public static void resumeDraftOrder(String draftOrderId){
        Dal_OrderManager.setCurrentOrderInSession(draftOrderId);
    }
}