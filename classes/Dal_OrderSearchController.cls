/**
 * Created by 7Summits on 3/27/18.
 */
public without sharing class Dal_OrderSearchController {


    public static List<DT_SYS_OrderList__x> openOrderlist;
    public static List<DT_SYS_OrderList__x> orderHistorylist;

    @TestVisible
    private static list<DT_SYS_OrderList__x> mockallOrderLineList = new list<DT_SYS_OrderList__x>();


    public class StatusOption {
        @AuraEnabled
        public String label { get;set; }
        @AuraEnabled
        public String value { get;set; }

        public StatusOption(String value, String label) {
            this.value = value;
            this.label = label;
        }
    }

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

    @AuraEnabled
    public static List<StatusOption> getLineStatuses(String userType, String orderType){
        System.debug(userType);
        System.debug(orderType);
        List<String> statuses = new List<String>();
        if(userType == 'Distributor' && orderType == 'Orders List'){
            statuses =  getAllStatus('Distributor','Open Orders');//Dal_Constants.DISTRIBUTOR_OPEN_ORDER_STATUSES;
        } else if(userType == 'Distributor' && orderType == 'History List') {
            statuses = getAllStatus('Distributor','Order History');//Dal_Constants.DISTRIBUTOR_ORDER_HISTORY_STATUSES;
        } else if(userType == 'Distributor' && orderType == 'All Orders List') {
            statuses =  getAllStatus('Distributor','All Orders');//Dal_Constants.DISTRIBUTOR_All_ORDER_STATUSES;
        }else if(userType == 'SSC' && orderType == 'All Orders List') {
            statuses =  getAllStatus('SSC','All Orders');//Dal_Constants.SSC_All_ORDER_STATUSES;
        }else if(userType == 'SSC' && orderType == 'Orders List') {
            statuses =  getAllStatus('SSC','Open Orders');//Dal_Constants.SSC_OPEN_STATUSES;
        }

        List<StatusOption> statusSelectOptions = new List<StatusOption>();
        Set<String> addedStatuses = new Set<String>{''};
        for(String status : statuses){
            if(!addedStatuses.contains(status)) {
                statusSelectOptions.add(new StatusOption(status, status));
                addedStatuses.add(status);
            }
        }
        System.debug('statusSelectOptions'+statusSelectOptions);
        return statusSelectOptions;
    }
    
        @AuraEnabled
    public static List<StatusOption> getShipfromLoc(){


        List<StatusOption> shipSelectOptions = new List<StatusOption>();

        for(String code : Dal_Constants.SHIPFROM_LOCATION.keySet()){
               shipSelectOptions.add(new StatusOption(code, Dal_Constants.SHIPFROM_LOCATION.get(code)));
        }
        System.debug('shipSelectOptions'+shipSelectOptions);
        return shipSelectOptions;
    }

    /*
  * Method Name: searchOpenOrders
  * Description: Method to get all Open Order from external Object 'DT_SYS_OrderList__x'.
  * @param: userType, orderNumber, purchaseOrder, jobName, orderDateFrom, orderDateTo, lineStatus
  * @return List of Open Order from 'DT_SYS_OrderList__x'
  */

    @AuraEnabled
    public static List<Object> searchAllOrders(String userType, String orderNumber, String purchaseOrder, String jobName, String orderDateFrom, String orderDateTo, String lineStatus, Integer listLimit) {
        System.debug('All orders params' +' '+userType+' '+orderNumber+' '+purchaseOrder+' '+jobName+' '+orderDateFrom+' '+orderDateTo+' '+lineStatus+' '+listLimit);
       
        String customerId = getCustomerId();
        String hostsystem = null;
        String orderCount ;
        List<Object> returnList = new List<Object>();
        List<String> statuses = new List<String>();
        List<String> allStatusValue =  getAllStatus('Distributor','All Orders');
        List<OrderWrapper> orderSearchList = new List<OrderWrapper>();
        List<String> openOrder = new List<String>{'Communities_OpenOrders'};
        //System.debug('Usertype---->'+userType);
        if(userType == 'Distributor'){
            statuses = allStatusValue;
            hostsystem = 'SAP';
        } else {
           // statuses = getAllStatus('SSC','All Orders');
            hostsystem = 'OASIS';
        }

        try{
            //System.debug('linestatus ' + lineStatus);
            //System.debug('Params' + orderNumber+' '+purchaseOrder+' '+jobName+' '+orderDateFrom+' '+orderDateTo+' '+lineStatus+' '+statuses+' '+customerId+' '+hostsystem+' '+listLimit);
            orderSearchList = queryOrderList(orderNumber,'allOrder', purchaseOrder, jobName, orderDateFrom, orderDateTo, lineStatus, statuses, customerId, hostsystem, listLimit);
            List<String> formattedDate = Dal_OrderSearchController.forDateValue(orderDateFrom,orderDateTo);
            if(hostsystem == 'SAP'){
                if(Integer.valueOf(orderSearchList.size()) < Integer.valueOf(listLimit))
                {
                    System.debug('orderSearchList.size-1if'+orderSearchList.size());
                    orderCount = String.valueOf(orderSearchList.size());
                }else{
                    System.debug('orderSearchList.size()in else'+orderSearchList.size());
                    orderCount = String.valueOf([Select COUNT() from DT_SYS_OrderList__x WHERE Customer__c =: customerId AND HostSystem__c =: hostsystem AND CreatedTime__c >=:formattedDate[1]  AND CreatedTime__c <=: formattedDate[0] AND AnyOrderLineStatus__c IN: allStatusValue] );
                }
            }
            else{
                if(String.isNotBlank(lineStatus))
                {
                    if(Integer.valueOf(orderSearchList.size()) < Integer.valueOf(listLimit))
                    {
                        orderCount = String.valueOf(orderSearchList.size());
                    }else {
                        List<String> allStatus = getAllStatus('SSC','All Orders');
                        orderCount = String.valueOf([Select COUNT() from DT_SYS_OrderList__x WHERE Customer__c = :customerId AND HostSystem__c = :hostsystem AND CreatedTime__c >= :formattedDate[1] AND CreatedTime__c <= :formattedDate[0] AND AnyOrderLineStatus__c IN: allStatus ]);
                    }
                }else{
                    if(Integer.valueOf(orderSearchList.size()) < Integer.valueOf(listLimit))
                    {
                        orderCount = String.valueOf(orderSearchList.size());
                    }else {
                        orderCount = String.valueOf([Select COUNT() from DT_SYS_OrderList__x WHERE Customer__c = :customerId AND HostSystem__c = :hostsystem AND CreatedTime__c >= :formattedDate[1] AND CreatedTime__c <= :formattedDate[0]]);
                    } 
                }

            }
            returnList.add(orderSearchList);
            returnList.add(orderCount);
            system.debug('orderSearchList-----'+orderSearchList);
            system.debug('orderCount-----'+orderCount);
        } catch(Exception exp){
            System.debug('getOpenOrder : An unexpected error has occurred: ' + exp.getMessage());
        }
        return returnList;
    }


    @AuraEnabled
    public static List<Object> searchOpenOrders(String userType, String orderNumber, String purchaseOrder, String jobName, String orderDateFrom, String orderDateTo, String lineStatus, Integer listLimit){   
        System.debug('open orders params' +' '+userType+' '+orderNumber+' '+purchaseOrder+' '+jobName+' '+orderDateFrom+' '+orderDateTo+' '+lineStatus+' '+listLimit);

        String customerId = getCustomerId();
        String hostsystem = null;
        String orderCount ;
        List<Object> returnList = new List<Object>();
        List<String> statuses = new List<String>();
        List<String> allOpenordervalues = getAllStatus('Distributor','Open Orders');
        List<String> openOrder = new List<String>{'Communities_OpenOrders'};
        List<OrderWrapper> orderSearchList = new List<OrderWrapper>();
        //System.debug('Usertype---->'+userType);
        if(userType == 'Distributor'){
            statuses = allOpenordervalues;
            hostsystem = 'SAP';
        } else {
             statuses = openOrder;
             hostsystem = 'OASIS';
        }

        try{
            //System.debug('linestatus ' + lineStatus);
            //System.debug('Params' + orderNumber+' '+purchaseOrder+' '+jobName+' '+orderDateFrom+' '+orderDateTo+' '+lineStatus+' '+statuses+' '+customerId+' '+hostsystem+' '+listLimit);
            orderSearchList = queryOrderList(orderNumber, 'openOrder',purchaseOrder, jobName, orderDateFrom, orderDateTo, lineStatus, statuses, customerId, hostsystem, listLimit);
            List<String> formattedDate = Dal_OrderSearchController.forDateValue(orderDateFrom,orderDateTo);
            if(hostsystem == 'SAP'){
                if(Integer.valueOf(orderSearchList.size()) < Integer.valueOf(listLimit)) {
                    orderCount = String.valueOf(orderSearchList.size());
                }else{
                    orderCount = String.valueOf([Select COUNT() from DT_SYS_OrderList__x WHERE Customer__c =: customerId AND HostSystem__c =: hostsystem AND CreatedTime__c >=:formattedDate[1]  AND CreatedTime__c <=: formattedDate[0] AND AnyOrderLineStatus__c IN:allOpenordervalues] );
                }
            }     
            else{  

                 if(Integer.valueOf(orderSearchList.size()) < Integer.valueOf(listLimit)) {
                     orderCount = String.valueOf(orderSearchList.size());
                 }else {
                     orderCount = String.valueOf([Select COUNT() from DT_SYS_OrderList__x WHERE Customer__c = :customerId AND HostSystem__c = :hostsystem AND CreatedTime__c >= :formattedDate[1] AND CreatedTime__c <= :formattedDate[0] AND AnyOrderLineStatus__c = 'Communities_OpenOrders']);
                 }

            }
      		   returnList.add(orderSearchList);
            returnList.add(orderCount);
            system.debug('orderSearchList-----'+orderSearchList);
            system.debug('orderCount-----'+orderCount);
        } catch(Exception exp){
            System.debug('getOpenOrder : An unexpected error has occurred: ' + exp.getMessage());
        }
      	return returnList;
    }


    /*
  * Method Name: searchOrderHistory
  * Description: Method to get Order history from external Object 'DT_SYS_OrderList__x'.
  * @param: orderNumber, purchaseOrder, jobName, Date orderDateFrom, Date orderDateTo, lineStatus
  * @return List of Order from 'DT_SYS_OrderList__x'
  */
    @AuraEnabled
    public static List<Object> searchOrderHistory(String userType, String orderNumber, String purchaseOrder, String jobName, String orderDateFrom, String orderDateTo, String lineStatus, Integer listLimit){
        System.debug('order history params' +' '+userType+' '+orderNumber+' '+purchaseOrder+' '+jobName+' '+orderDateFrom+' '+orderDateTo+' '+lineStatus+' '+listLimit);
        String orderCount ;
        List<Object> returnList = new List<Object>();      
        String customerId = getCustomerId();
        String hostsystem = userType == 'SSC'? 'OASIS':'SAP';
        List<String> allHistoryValue = getAllStatus('Distributor','Order History');
        List<OrderWrapper> orderSearchList = new List<OrderWrapper>();
        try{
            orderSearchList = queryOrderList(orderNumber,'orderHistory', purchaseOrder, jobName, orderDateFrom, orderDateTo, lineStatus,getAllStatus('Distributor','Order History'), customerId, hostsystem, listLimit);
            List<String> formattedDate = Dal_OrderSearchController.forDateValue(orderDateFrom,orderDateTo);
            if(Integer.valueOf(orderSearchList.size()) < Integer.valueOf(listLimit))
            {
                orderCount = String.valueOf(orderSearchList.size());
            }else {
                orderCount = String.valueOf([Select COUNT() from DT_SYS_OrderList__x WHERE Customer__c = :customerId AND HostSystem__c = :hostsystem AND CreatedTime__c >= :formattedDate[1] AND CreatedTime__c <= :formattedDate[0] AND AnyOrderLineStatus__c IN : allHistoryValue]);
            }
            returnList.add(orderSearchList);
            returnList.add(orderCount);
        } catch(Exception exp){
            System.debug('searchOrderHistory : An unexpected error has occurred: ' + exp.getMessage());
        }
        return returnList;

    }

    @AuraEnabled
    public static List<Object> searchCompletedOrders(String userType, String orderNumber, String purchaseOrder, String jobName, String orderDateFrom, String orderDateTo, String lineStatus, Integer listLimit){
        System.debug('Completed Order Params' +' '+userType+' '+orderNumber+' '+purchaseOrder+' '+jobName+' '+orderDateFrom+' '+orderDateTo+' '+lineStatus+' '+listLimit);
        List<String> closedorder = new List<String>{'Communities_CompletedOrder'};
        String orderCount ;
        List<Object> returnList = new List<Object>(); 
        String customerId = getCustomerId();
        String hostsystem = userType == 'SSC'? 'OASIS':'SAP';
        List<OrderWrapper> orderSearchList = new List<OrderWrapper>();
        try{
            orderSearchList = queryOrderList(orderNumber,'completedOrder', purchaseOrder, jobName, orderDateFrom, orderDateTo, lineStatus, closedorder, customerId,hostsystem, listLimit);
            List<String> formattedDate = Dal_OrderSearchController.forDateValue(orderDateFrom,orderDateTo);
            if(Integer.valueOf(orderSearchList.size()) < Integer.valueOf(listLimit))
            {
                orderCount = String.valueOf(orderSearchList.size());
            }else {
                orderCount = String.valueOf([Select COUNT() from DT_SYS_OrderList__x WHERE Customer__c = :customerId AND HostSystem__c = :hostsystem AND CreatedTime__c >= :formattedDate[1] AND CreatedTime__c <= :formattedDate[0] AND AnyOrderLineStatus__c = 'Communities_CompletedOrder']);
            }
            returnList.add(orderSearchList);
            returnList.add(orderCount);
        } catch(Exception exp){
            System.debug('searchCompletedOrders : An unexpected error has occurred: ' + exp.getMessage());
        }
        return returnList;

    }

    @AuraEnabled
    public static List<Object> searchOrdersForPickup(String userType, String orderNumber, String purchaseOrder, String jobName, string orderDateFrom, string orderDateTo, String lineStatus, Integer listLimit){
        System.debug('Orders for Schedule params' +' '+userType+' '+orderNumber+' '+purchaseOrder+' '+jobName+' '+orderDateFrom+' '+orderDateTo+' '+lineStatus+' '+listLimit);
        String orderCount ;
        List<String> scheduleOrder = new List<String>{'Communities_PickupsAndDeliveriesToBeScheduled'};
        List<String> allScheduleOrdervalues = getAllStatus('SSC','Pickup And Delivery');

        List<Object> returnList = new List<Object>();
        String customerId = getCustomerId();
        String hostsystem = userType == 'SSC'? 'OASIS':'SAP';
        List<OrderWrapper> orderSearchList = new List<OrderWrapper>();
        try{
            orderSearchList = queryOrderList(orderNumber,'orderForPickup', purchaseOrder, jobName, orderDateFrom, orderDateTo, lineStatus, scheduleOrder, customerId,hostsystem, listLimit);
            List<String> formattedDate = Dal_OrderSearchController.forDateValue(orderDateFrom,orderDateTo);
            if(Integer.valueOf(orderSearchList.size()) < Integer.valueOf(listLimit)) 
            {
                orderCount = String.valueOf(orderSearchList.size());
            }else {
                orderCount = String.valueOf([Select COUNT() from DT_SYS_OrderList__x WHERE Customer__c = :customerId AND HostSystem__c = :hostsystem AND CreatedTime__c >= :formattedDate[1] AND CreatedTime__c <= :formattedDate[0] AND AnyOrderLineStatus__c IN:allScheduleOrdervalues]);
            }
            returnList.add(orderSearchList);
            returnList.add(orderCount);
        } catch(Exception exp){
            System.debug('searchOrdersForPickup : An unexpected error has occurred: ' + exp.getMessage());
        }
        return returnList;

    }

    @AuraEnabled
    public static List<OrderWrapper> getOrdersToBeScheduled(Integer listLimit){

        String customerId = getCustomerId();
        String hostsystem = 'OASIS';
        List<String> scheduleOrder = new List<String>{'Communities_PickupsAndDeliveriesToBeScheduled'};
        //List<String> scheduleOrder = new List<String>();
        List<OrderWrapper> orderSearchList = new List<OrderWrapper>();
        try{
            orderSearchList = queryOrderList(null,'SchedulePickAndDelivery', null, null, null, null, null, scheduleOrder, customerId,hostsystem, listLimit);
        } catch(Exception exp){
            System.debug('searchOrdersForPickup : An unexpected error has occurred: ' + exp.getMessage());
        }
        return orderSearchList;

    }

    @AuraEnabled
    public static List<OrderWrapper> getScheduledPickups(Integer listLimit){
       

        String customerId = getCustomerId();
        String hostsystem = 'OASIS';
        List<String> scheduleOrder = new List<String>{'Communities_ScheduledPickups'};
        List<OrderWrapper> orderSearchList = new List<OrderWrapper>();
        try{
            orderSearchList = queryOrderList(null,null, null, null, null, null, null, scheduleOrder, customerId,hostsystem, listLimit);
        } catch(Exception exp){
            System.debug('searchOrdersForPickup : An unexpected error has occurred: ' + exp.getMessage());
        }
        return orderSearchList;

    }

    @AuraEnabled
    public static List<OrderWrapper> getScheduledDeliveries(Integer listLimit){
        String customerId = getCustomerId();
        String hostsystem = 'OASIS';
        List<String> scheduleOrder = new List<String>{'Communities_ScheduledDeliveries'};
        List<OrderWrapper> orderSearchList = new List<OrderWrapper>();
        try{
            orderSearchList = queryOrderList(null,'ScheduleDelivery', null, null, null, null, null,scheduleOrder, customerId,hostsystem, listLimit);
        } catch(Exception exp){
            System.debug('searchOrdersForPickup : An unexpected error has occurred: ' + exp.getMessage());
        }
        return orderSearchList;
    }

    private static List<OrderWrapper> queryOrderList(String orderNumber,String orderListType, String purchaseOrder, String jobName, String orderDateFromui, String orderDateToui, String lineStatus, List<String> statuses, String customerId, string hostsystem, Integer listLimit) {
        System.debug('Search params-->'+ ' '+orderNumber+''+orderListType+' '+ purchaseOrder +' '+  jobName+' '+ orderDateFromui+' '+ orderDateToui+' '+ lineStatus+' '+ statuses+' '+ customerId+' '+ hostsystem+' '+ listLimit);
        Set<String> CompletedOrderSet = new Set<String>{'Shipped','Picked Up','Return Processed'};
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
                    ' StatusDesc__c, Status__c,SalesOrderType__c,SalesOrderTypeDesc__c, FulfillmentMethod__c FROM DT_SYS_OrderList__x WHERE Customer__c = \'' + customerId + '\' AND hostsystem__c = \'' + hostsystem +'\'';
            if(String.isNotBlank(orderNumber)){
                
                query += ' AND SalesOrder__c like \'%' + orderNumber.toUpperCase() + '%\'';
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
/*
             if(statuses.size()>0) {
                 System.debug('IN__IF---->');
                 if (statuses[0] == 'Communities_ScheduledPickups') {
                     query += ' AND  NamedCriteria__c = ' + '\'' + statuses[0] + '\' ';
                 }
                 if (statuses[0] == 'Communities_ScheduledDeliveries') {
                     query += ' AND  NamedCriteria__c = ' + '\'' + statuses[0] + '\' ';
                 }
             }*/
         
            if(String.isNotBlank(lineStatus)){
                    System.debug('LineStatus: ' + lineStatus);
                        query += ' AND AnyOrderLineStatus__c IN (';
                      
                            query += '\'' + lineStatus + '\', ';
                       
                        query = query.substring(0, query.lastIndexOf(', ')) + ')';
                    
            }else if(statuses.size()>0 && hostsystem == 'OASIS') {
                System.debug('statuses-for-OASIS-->: ' + statuses);
                if (statuses[0] == 'Communities_CompletedOrder') {
                    query += ' AND  NamedCriteria__c IN (' + '\'' + statuses[0] + '\') ';
                }
                if (statuses[0] == 'Communities_OpenOrders') {
                    query += ' AND  NamedCriteria__c IN (' + '\'' + statuses[0] + '\') ';
                }
                if (statuses[0] == 'Communities_PickupsAndDeliveriesToBeScheduled') {
                    query += ' AND  NamedCriteria__c IN (' + '\'' + statuses[0] + '\') ';
                }
                if (statuses[0] == 'Communities_ScheduledPickups') {
                    query += ' AND  NamedCriteria__c IN (' + '\'' + statuses[0] + '\') ';
                }
                if (statuses[0] == 'Communities_ScheduledDeliveries') {
                    query += ' AND  NamedCriteria__c IN (' + '\'' + statuses[0] + '\') ';
                }
            }else if(hostsystem != 'OASIS' && statuses.size()>0){
                System.debug('statuses-for-SAP->: ' + statuses);
                query += ' AND AnyOrderLineStatus__c IN (';
                for(String status : statuses){
                    query += '\'' + status + '\', ';
                }
                query = query.substring(0, query.lastIndexOf(', ')) + ')';
            }

          /*
            else if(statuses != null && statuses.size() > 0){
                System.debug('statuses--->: ' + statuses);
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
    
     /*
  * Method Name: getCarrier
  * Description: Method to get Carrier Code
  * @param: Not Any
  * @return List of statusOption
  */
    public static List<StatusOption> getCarrier(){
	 List<StatusOption> carrierOptions = new List<StatusOption>();

        for(String code : Dal_Constants.CARRIER.keySet()){
               carrierOptions.add(new StatusOption(code, Dal_Constants.CARRIER.get(code)));
        }
        System.debug('carrierOptions'+carrierOptions);
        return carrierOptions;
    }

    public static Boolean nullorempty(String val){
		system.debug('val is '+val);
        Boolean nullempty = false;
        if(val == null || val ==''){
            nullempty = true;
        }else{
        nullempty = false;
        }
        system.debug('nullempty is '+nullempty);
        return nullempty;
    }
    
    public static List<String> forDateValue(String orderDateToui,String orderDateFromui){
        List<String> dateListValue = new List<String>();
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
        dateListValue.add(orderDateFrom);
        dateListValue.add(orderDateTo);
        return dateListValue;
    }

    public static list<String> getAllStatus(String type, String category){

        list<String> statusList = new list<String>();
        for(DT_SYS_Order_Status_Configuration__mdt orderStatus : [select id,type__c,status__c,category__c from DT_SYS_Order_Status_Configuration__mdt where type__c =:type AND category__c =:category ORDER BY status__c ASC ]){

            statusList.add(orderStatus.status__c);
        }
        system.debug('------Status>>'+statusList);
        return statusList;
    }

    @AuraEnabled
    public static void mapOppToOrders(List<Id> listOfOppIds, List<Id> lstOforderIds) {
        Boolean flag = true;
        List<Opportunity_Order_Relationship__c> oppOrderRelList = new List<Opportunity_Order_Relationship__c>();

        Map<Id,List<Id>> mapOfIds = new Map<Id, List<Id>>();
        for (Opportunity_Order_Relationship__c oppOrd : [SELECT Name, Id, Order__c, Opportunity__c FROM Opportunity_Order_Relationship__c] ) {
            if (mapOfIds.containsKey(oppOrd.Opportunity__c)) {
                mapOfIds.get(oppOrd.Opportunity__c).add(oppOrd.Order__c);
            } else {
                mapOfIds.put(oppOrd.Opportunity__c, new List<Id>{oppOrd.Order__c});
            }
        }

        System.debug('mapOfIds: ' + mapOfIds);

        List<DT_SYS_OrderList__x> orderList = [Select Id from DT_SYS_OrderList__x WHERE SalesOrder__c IN : lstOforderIds
                                                AND Customer__c =: getCustomerId()  AND HostSystem__c = 'OASIS'];

        for(Id opp : listOfOppIds) {
            for(DT_SYS_OrderList__x ord : orderList) {
                flag = true;

                if(mapOfIds.containsKey(opp)) {
                    for(Id ordId : mapOfIds.get(opp)) {
                        if(ordId == ord.Id) {
                            flag = false;
                        }
                    }
                }
                if(flag) {
                    Opportunity_Order_Relationship__c oppOrderRel = new Opportunity_Order_Relationship__c();
                    oppOrderRel.Opportunity__c = opp;
                    oppOrderRel.Order__c = ord.Id;
                    oppOrderRelList.add(oppOrderRel);
                }
            }
        }

        upsert oppOrderRelList;
    }

    @AuraEnabled
    public static List<String> getListOfOrderFromOpp(List<Id> oppIds) {

        Set<String> setOfIds = new Set<String>();
        List<String> orderIds = new List<String>();
        for (Opportunity_Order_Relationship__c oppOrder : [SELECT Name, Id, Order__c, Opportunity__c FROM Opportunity_Order_Relationship__c]) {
            setOfIds.add(oppOrder.Order__c);
        }
        List<DT_SYS_OrderList__x> orderList = [Select Id,SalesOrder__c from DT_SYS_OrderList__x WHERE Id IN : setOfIds AND Customer__c =: getCustomerId()  AND HostSystem__c = 'OASIS'];

        for(DT_SYS_OrderList__x order :orderList){
            orderIds.add(order.SalesOrder__c);
        }
        return orderIds;

    }

}