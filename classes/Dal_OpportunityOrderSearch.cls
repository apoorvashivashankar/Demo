/**
 * Created by presh on 05-12-2018.
 */

public without sharing class Dal_OpportunityOrderSearch {

     @TestVisible
    private static list<DT_SYS_OrderList__x> mockallOrderLineList = new list<DT_SYS_OrderList__x>();

    public class OrderWrapper {
        @AuraEnabled
        public String SalesOrder;
        @AuraEnabled
        public String CreatedTime;
        @AuraEnabled
        public String CustomerPONo;
        @AuraEnabled
        public String JobName;
        @AuraEnabled
        public String Status;
        @AuraEnabled
        public String SSCLocation;
        @AuraEnabled
        public String FulfillmentMethod;
        @AuraEnabled
        public String OrderType;

        public OrderWrapper(DT_SYS_OrderList__x orderListRecord, string location){
            SalesOrder = orderListRecord.SalesOrder__c;
            CreatedTime = orderListRecord.CreatedTime__c;
            CustomerPONo = orderListRecord.CustomerPONo__c;
            JobName = orderListRecord.JobName__c;
            Status = orderListRecord.status__c;
            SSCLocation = location;
            FulfillmentMethod = orderListRecord.FulfillmentMethod__c;
            OrderType = orderListRecord.SalesOrderTypeDesc__c;
        }
    }



    /*
  * Method Name: searchOpportunityRelatedOrder
  * Description: Method to get OpportunityRelatedOrder Record List.
  * @param: Not Any
  * @return List of OpportunityRelatedOrder records.
  */
    @AuraEnabled
    public static List<Object> searchOpportunityRelatedOrder(String opportunityId) {
        System.debug('--opportunityId---'+opportunityId);
        // List<Opportunity_Order_Relationship__c> opportunityList = new List<Opportunity_Order_Relationship__c>();
        List<OrderWrapper> returnList = new List<OrderWrapper>();
        String userId = UserInfo.getUserId();
        List<String> orderListId = new List<String>();
        for(Opportunity_Order_Relationship__c opportunityList : [SELECT  Id, Order__c, Opportunity__c FROM Opportunity_Order_Relationship__c WHERE Opportunity__c =:opportunityId]){
            orderListId.add(opportunityList.Order__c);
        }

        returnList = getOrderList(orderListId);
        system.debug('-------orderId----' + orderListId);
        system.debug('-------returnList----' + returnList);

        return returnList;

    }

    private static List<OrderWrapper> getOrderList(List<String> orderId ){

        String customerId = getCustomerId();
        //String hostsystem = userType == 'SSC'? 'OASIS':'SAP';
        String hostSystem = 'OASIS';
        List<OrderWrapper> orderSearchList = new List<OrderWrapper>();
        List<DT_SYS_OrderList__x> orderListRecords = new List<DT_SYS_OrderList__x>();

        orderListRecords= [SELECT Id, CreatedTime__c,CustomerPONo__c,Customer__c, HostSystem__c, jobName__c, OrderPlantName__c,
                OrderPlant__c, SalesOrder__c, StatusDesc__c, Status__c,SalesOrderType__c,SalesOrderTypeDesc__c,
                FulfillmentMethod__c from DT_SYS_OrderList__x WHERE Id =:orderId AND Customer__c = :customerId AND HostSystem__c = :hostSystem];
        system.debug('---orderListRecords---'+orderListRecords);

        Set<String> locationset = new Set<String>();
        for(DT_SYS_OrderList__x orderList : orderListRecords){
            locationset.add(orderList.OrderPlant__c);
        }
        //creating map to store locationid and name
        Map<string, string> locationmap = new Map<string, string>();
        for(SSC__c location : [Select DW_ID__c,Name from SSC__c where DW_ID__c in: locationset]){
            locationmap.put(location.DW_ID__c,location.Name);
        }
        String location = null;
        //Fix order statuses to be community statuses
        for(DT_SYS_OrderList__x order : orderListRecords){
            location = locationmap.get(order.OrderPlant__c);
            OrderWrapper wrapper = new OrderWrapper(order, location);
            // System.debug('wrapper is '+wrapper);
            //wrapper.Status = Dal_Constants.COMMUNITY_STATUSES_BY_OASIS_NAME_MAP.get(order.Status__c);
            orderSearchList.add(wrapper);
        }

        //SSC__c location = [Select Name,City__c,Country__c,State__c,Street_Address__c,Zip_Code__c from SSC__c where DW_ID__c =: orderplantID limit 1];
        return orderSearchList;

    }


    @AuraEnabled
    public static List<OrderWrapper> geAllOrderList(String orderNumber, String purchaseOrder, String jobName, String orderDateFrom, String orderDateTo, String lineStatus, String opportunityId, Integer listLimit){
        String customerId = getCustomerId();
        String hostsystem = 'OASIS';
        system.debug('search date ----'+orderDateFrom+'---'+orderDateTo);
        List<String> orderListId = new List<String>();
        for(Opportunity_Order_Relationship__c opportunityList : [SELECT  Id, Order__c, Opportunity__c FROM Opportunity_Order_Relationship__c WHERE Opportunity__c =:opportunityId]){
            orderListId.add(opportunityList.Order__c);
        }

        List<OrderWrapper> orderSearchList = new List<OrderWrapper>();
        try{
            orderSearchList = queryOrderList(orderListId,orderNumber,'orderListType', purchaseOrder, jobName, orderDateFrom, orderDateTo, lineStatus, customerId,hostsystem, listLimit);
        } catch(Exception exp){
            System.debug('searchOrdersForPickup : An unexpected error has occurred: ' + exp.getMessage());
        }
        System.debug('--orderSearchList-----'+orderSearchList);
        return orderSearchList;
    }

    private static List<OrderWrapper> queryOrderList(List<String> orderListId, String orderNumber, String orderListType, String purchaseOrder, String jobName, String orderDateFromui, String orderDateToui, String lineStatus, String customerId, string hostsystem, Integer listLimit) {
        System.debug('Search params-->'+ ' '+orderNumber+''+orderListType+' '+ purchaseOrder +' '+  jobName+' '+ orderDateFromui+' '+ orderDateToui+' '+ lineStatus+' '+ customerId+' '+ hostsystem+' '+ listLimit);

        /* Set<String> CompletedOrderSet = new Set<String>{'Shipped','Picked Up','Return Processed'};
         Set<String> OpenOrderSet = new Set<String>();
         OpenOrderSet.addAll(getAllStatus('SSC','Open Orders'));

         if(String.isNotBlank(lineStatus)){
             if(lineStatus.contains(',')){

                 List<String> lstAlpha = lineStatus.split(',');
                 List<String> beta = new List<String>();
                 for(String s :lstAlpha){
                     beta.add( '\''+ s + '\'');
                 }
                 lineStatus = string.join(beta,',');
                 lineStatus = lineStatus.substring(1, lineStatus.length()-1);
             }
         }
 */

        string orderDateTo ='';
        string orderDateFrom='';
        if(!nullorempty(orderDateToui)){
            Date dt = date.valueof(orderDateToui);
            orderDateTo = string.valueof(dt);
        }
        if(!nullorempty(orderDateFromui)){
            Date dt1 = date.valueof(orderDateFromui);
            orderDateFrom = string.valueof(dt1);
        }


        listLimit = listLimit != null ? Integer.valueOf(listLimit) : 1000;

        List<OrderWrapper> orderSearchList = new List<OrderWrapper>();
        //string dformat = 'yyyy-MM-dd\'T\'hh:mm:ss\'.000+\'0000';
        string dformat = 'yyyy-MM-dd';

        try{
            String query = 'SELECT  CreatedTime__c, CustomerGrp__c, CustomerPONo__c,' +
                    ' Customer__c, HostSystem__c, jobName__c, OrderPlantName__c, OrderPlant__c, SalesOrder__c,' +
                    ' StatusDesc__c, Status__c,SalesOrderType__c,SalesOrderTypeDesc__c, FulfillmentMethod__c FROM DT_SYS_OrderList__x WHERE Id IN : orderListId AND Customer__c = \'' + customerId + '\' AND hostsystem__c = \'' + hostsystem +'\'';
            if(String.isNotBlank(orderNumber)){

                query += ' AND SalesOrder__c like \'%' + orderNumber + '%\'';
            }

            if(String.isNotBlank(purchaseOrder)){
                purchaseOrder = purchaseOrder.remove('*');
                purchaseOrder = purchaseOrder.toUpperCase();
                query += ' AND CustomerPoNo__c like \'%' + purchaseOrder + '%\'';
            }

            if(String.isNotBlank(jobName)){
                jobName = jobName.remove('*');
                jobName = jobName.toUpperCase();
                query += ' AND jobName__c like \'%' + jobName + '%\'';
            }

            system.debug('search params ----'+orderDateFrom+'---'+orderDateTo);

            if(!nullorempty(orderDateFrom) && orderDateTo == null){
                system.debug('orderDateFrom is '+orderDateFrom);

                query += ' AND CreatedTime__c >= \'' + orderDateFrom +'\'';
            }

            if(!nullorempty(orderDateTo) && orderDateFrom == null){
                system.debug('orderDateTo is '+orderDateTo);

                query += 'AND CreatedTime__c <= \'' + orderDateTo+'\'';
            }

            if(!nullorempty(orderDateTo) && !nullorempty(orderDateFrom)){
                system.debug('both are not null -- orderDateFrom -'+orderDateFrom+' -orderDateTo -'+orderDateTo);

                query += ' AND CreatedTime__c >= \'' + orderDateFrom + '\' AND CreatedTime__c <= \'' + orderDateTo+'\'';
            }

            if(orderDateTo ==null && orderDateFrom ==null && hostsystem =='SAP'){
                system.debug('orderDateTo is '+orderDateTo);
                query += ' AND CreatedTime__c >= \''+ orderDateFrom + '\' AND CreatedTime__c <= \''+ orderDateTo+'\'';
            }


            //if host system is SAp query on anyorderline status to get completed orders
            ////If it is OASIS and request is for comeplted orders then us Named criteri and ignore anyorderline statuss

            /*  if(statuses.size()>0) {
                  System.debug('IN__IF---->');
                  if (statuses[0] == 'Communities_ScheduledPickups') {
                      query += ' AND  NamedCriteria__c = ' + '\'' + statuses[0] + '\' ';
                  }
                  if (statuses[0] == 'Communities_ScheduledDeliveries') {
                      query += ' AND  NamedCriteria__c = ' + '\'' + statuses[0] + '\' ';
                  }
              }

              if(String.isNotBlank(lineStatus)){
                  System.debug('LineStatus: ' + lineStatus);
                  query += ' AND AnyOrderLineStatus__c IN (';

                  query += '\'' + lineStatus + '\', ';

                  query = query.substring(0, query.lastIndexOf(', ')) + ')';

              }
  */
            /*else if(statuses != null && statuses.size() > 0){
                if(statuses[0] != 'Communities_CompletedOrder' || statuses[0] != 'Communities_PickupsAndDeliveriesToBeScheduled' || statuses[0] != 'Communities_OpenOrders' || statuses[0] != 'Communities_ScheduledPickups'|| statuses[0] != 'Communities_ScheduledDeliveries' ){
                    query += ' AND NamedCriteria__c IN (';
                    for(String status : statuses){
                        query += '\'' + status + '\', ';
                    }
                    query = query.substring(0, query.lastIndexOf(', ')) + ')';
                }

            }*/

            query += ' ORDER BY CreatedTime__c DESC LIMIT ' + listLimit;

            System.debug('Query is --'+query);
            //orderSearchList = Database.query(query);
            List<DT_SYS_OrderList__x> orderListRecords = new List<DT_SYS_OrderList__x>();
            if(!Test.isRunningTest()){
                orderListRecords = Database.query(query);
            }else{
                orderListRecords = mockallOrderLineList;
            }

            //Getting SSC Location for all queried line items
            Set<String> locationset = new Set<String>();
            for(DT_SYS_OrderList__x orderList : orderListRecords){
                locationset.add(orderList.OrderPlant__c);
            }
            //creating map to store locationid and name
            Map<string, string> locationmap = new Map<string, string>();
            for(SSC__c location : [Select DW_ID__c,Name from SSC__c where DW_ID__c in: locationset]){
                locationmap.put(location.DW_ID__c,location.Name);
            }
            String location = null;
            //Fix order statuses to be community statuses
            for(DT_SYS_OrderList__x order : orderListRecords){
                location = locationmap.get(order.OrderPlant__c);
                OrderWrapper wrapper = new OrderWrapper(order, location);
                // System.debug('wrapper is '+wrapper);
                //wrapper.Status = Dal_Constants.COMMUNITY_STATUSES_BY_OASIS_NAME_MAP.get(order.Status__c);
                orderSearchList.add(wrapper);
            }

        } catch(Exception exp){
            System.debug('queryOrderList : An unexpected error has occurred: ' + exp.getMessage());
        }

        return orderSearchList;
    }

    private static Boolean nullorempty(String val) {
        system.debug('val is ' + val);
        Boolean nullempty = false;
        if (val == null || val == '') {
            nullempty = true;
        } else {
            nullempty = false;
        }
        system.debug('nullempty is ' + nullempty);
        return nullempty;
    }
    /*
     * Method Name: getCustomerId
     * Description: Method to get Customer Id
     * @param: Not Any
     * @return Customer Id
     */
    public static String getCustomerId(){
        String customerId;
        Account selectedAccount = Dal_BaseController.getUserSelectedLocation();
        customerId = selectedAccount.DW_ID__c;
        system.debug('customerId'+customerId);
        return customerId;
    }

}