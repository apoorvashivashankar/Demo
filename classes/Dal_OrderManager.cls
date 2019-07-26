/**
* Created by 7Summits on 3/27/18.
*/
public without sharing class Dal_OrderManager {
    
    @TestVisible
    private static DT_SYS_SSC_OrderStatusCount__x mockallOrderStatusCount = new DT_SYS_SSC_OrderStatusCount__x();
    
    /*
    * Method Name: getCurrentOrder
    * Description: Purpose to get order Id from Session cache and call method 'getOrderById' in this class to fetch order list
    * @param: Not Any
    * @return orderList of 'DT_Order__c' object
    */
    @AuraEnabled
    public static List<DT_Order__c> getCurrentOrder(){
        String orderId = Dal_SessionController.getSessionOrder();
        List<DT_Order__c> cacheOrders = getOrderById(orderId);
        return cacheOrders;
    }
    
    @AuraEnabled
    public static void setCurrentOrderInSession(String draftOrderId){
        Dal_SessionController.setSessionOrder(draftOrderId);
    }
    
    /*
    * Method Name: getOrderById
    * Description: Purpose to get List of order on basis of orderId
    * @param: orderId
    * @return orderList of 'DT_Order__c' object
    */
    @AuraEnabled
    public static List<DT_Order__c> getOrderById(Id orderId){
        
        List<DT_Order__c> orderList = [
            Select Address4__c,Address_Name__c, Address_Name2__c, City__c, State__c, Brand__c, Contact_Name__c, Contact_Phone__c, Country__c, Postal_Code__c,
            Delegate_Pickup__c, Delegate_First_Name__c, Delegate_Last_Name__c, Delegate_Mobile_Phone__c, AccountName__r.Freight_Term__c,
            Freight_Terms__c, Carrier__c, Group_Key__c, JobName__c, OrderID_External__c, AccountName__r.Freight_Term__r.Code__c, 
            Order_Origin_Salesforce__c, Order_Status_Code__c, Price_Record__c, Purchase_Order__c,
            Requested_Ship_date__c, Ship_Complete__c, Shipto_Name_1__c, Shipto_Name2__c,
            Small_Package_Carrier__c, Small_Package__c, SSC__c, Tax_Exempt_Code__c, Total_Extended_Weight__c,
            Total_Order_Amount__c, Status__c, Submit_Date__c, Id, Name, CreatedDate, AccountName__c,
            Address1__c, Address3__c, Address2__c, Default_Price_Code__c, Default_Requested_Ship_Date__c,
            ( select Override_Shipto_Address1__c, Carrier__c, Color__c, Extended_Price__c,
             Extended_Weight__c, Order_Line_Status__c, Price_Record__c, product_description__c,
             Product_Sku__c, SKU_Number__c, Quantity__c, Available_UOM__c, Unit_of_Measure__c, Requested_Ship_Date__c
             From DT_Order_Products__r
            )
            from DT_Order__c
            where Id =: orderId
        ];
        if(orderList.size() > 0 && String.isNotBlank(orderList[0].id)) {
            System.debug('ORDER_LIST:--'+orderList[0]);
        }
        return orderList;
    }
    
    /*
    * Method Name: createNewOrder
    * Description: Purpose to creating new order if not present in Session
    * @param: Not Any
    * @return 'DT_Order__c' object
    */
    @AuraEnabled
    public static DT_Order__c createNewOrder(){
        //TODO: Create a new order, and put it in the session cache
        DT_Order__c newOrder = new DT_Order__c();
        Account selectedAccount = Dal_BaseController.getUserSelectedLocation();
        if(selectedAccount != null) {
            newOrder.AccountName__c = selectedAccount.Id;
            if(selectedAccount.Freight_Term__c != null)
                newOrder.Freight_Terms__c = selectedAccount.Freight_Term__r.Code__c;
        }
        try{
            insert newOrder;
            Dal_SessionController.setSessionOrder(newOrder.Id);
            return newOrder;
        } catch(Exception ex){
            System.debug('Error while trying to create a new order! ' + ex);
        }
        
        return null;
    }
    
    /*
    * Method Name: saveCurrentOrder
    * Description: Purpose to upsert the current DT_Order_c within salesforce along with any of its child DT_Order_Product_c records.
    * @param: DT_Order(Object) , orderProduct(List of Object)
    * @return Void
    */
    @AuraEnabled
    public static String saveCurrentOrder(DT_Order__c DT_Order, List<DT_Order_Product__c> orderProduct){
        System.debug('Order while Save'+DT_Order);
        System.debug('OrderProduct while Save'+orderProduct);
        List<DT_Order_Product__c> productOrderList = new List<DT_Order_Product__c>();
        System.debug('productOrderList---->'+productOrderList);
        upsert DT_Order;
        if(DT_Order.Id != null)
        {
            
            //Ensure we set the Order Product lookup to the current order
            Set<Id> existingOrderProductIds = new Set<Id>();
            for(DT_Order_Product__c lineItem : orderProduct){
                
                lineItem.DT_Order_Id__c = DT_Order.Id;
                System.debug('lineItem >> '+lineItem.Id);
                //We also track the salesforce ids of existing order products so that we can then match them with any
                //extraneous order products in salesforce that need to be deleted/cleaned because they were removed from the order
                if(lineItem.Id != null){
                    
                    existingOrderProductIds.add(lineItem.Id);
                }
            }
            
            deleteExtraOrderProductlineItems(DT_Order.Id, existingOrderProductIds);
        }
        System.debug(''+productOrderList);
        /*if(productOrderList.size()>0)
        {
        //ToDO : We never get any value on this productOrderList,
        // So why we're using upsert operation on this list.
        //  upsert productOrderList;
        } */
        if(orderProduct.size()>0){
            
            upsert orderProduct;
        }
        
        return DT_Order.Id;
    }
    
    
    /*
    * Method Name: deleteOrderLineItem
    * Description: Purpose to delete the provided order product record.
    * @param: orderProduct object
    * @return Void
    */
    @AuraEnabled
    public static void deleteOrderLineItem(DT_Order_Product__c orderProduct){
        
        try{
            delete orderProduct;
        }catch(Exception exp){
            System.debug('Exception occurs while deleting Order Line Item-->'+exp);
        }
    }
    
    /*
    * Method Name: submitCurrentOrder
    * Description: Pending -- need more info on that
    * @param: orderProduct object
    * @return Void
    */
    @AuraEnabled
    public static void submitCurrentOrder(DT_Order__c DT_Order, List<DT_Order_Product__c> orderProduct){
        
    }
    
    /*
    * Method Name: cloneOrder
    * Description: Purpose -- Cloning external Object data to Custom Object.
    * @param: orderHeaderId
    * @return List of DT_SYS_OrderHeader__x
    */
    @AuraEnabled
    public static  List<DT_SYS_OrderHeader__x> cloneOrder(Id orderHeaderId){
        
        List<DT_SYS_OrderHeader__x> orderHeader = new List<DT_SYS_OrderHeader__x>();
        
        try{
            orderHeader = [SELECT Id, ExternalId, DisplayUrl, Account_Address_City__c, Account_Address_Country__c, Account_Address_Line1__c,
                           Account_Address_Line2__c, Account_Address_Line3__c, Account_Address_Name__c, Account_Address_PostalCode__c,
                           Total_Materials__c, Total_TaxAmt_City__c, Total_TaxAmt_County__c, Total_TaxAmt_District__c, Total_TaxAmt_State__c,
                           Total_TaxRate_City__c, Total_TaxRate_County__c, Total_TaxRate_District__c, Total_TaxRate_State__c, Total_TaxRate__c,
                           Total_Tax__c, Total_Total__c, Total_Weight__c, id__c FROM DT_SYS_OrderHeader__x WHERE Id =: orderHeaderId];
            
            for(DT_SYS_OrderHeader__x ordHeader : orderHeader) {
                DT_Order__c orders = new DT_Order__c();
            }
            
        } catch(Exception exp){
            System.debug('SalesOrderHeader__x: An unexpected error has occurred: ' + exp.getMessage());
        }
        return orderHeader;
    }
    
    
    public static void deleteOrderAndOrderProduct(){
        List<DT_Order__c> orderList = [Select Id,(select Id From DT_Order_Products__r) from DT_Order__c where CreatedDate > LAST_N_DAYS:7];
        delete orderList;
    }
    
    private static void deleteExtraOrderProductlineItems(String orderId, Set<Id> existingOrderProductLineIds){
        List<DT_Order_Product__c> removedOrderProducts = [
            SELECT Id
            FROM DT_Order_Product__c
            WHERE DT_Order_Id__c = :orderId AND Id NOT IN :existingOrderProductLineIds
        ];
        delete removedOrderProducts;
    }
    
    public static void cleanupDraftOrders(List<DT_Order__c> orderListToDelete){
        try{
            delete orderListToDelete;
        } catch(Exception exp){
            System.debug('SalesOrderHeader__x: An unexpected error has occurred: ' + exp.getMessage());
        }
    }
    
    public static OrderCountstatusWrapper getOrderStatusCount(){
        try{
            String customerId;
            String division;  
            Account selectedAccount = Dal_BaseController.getUserSelectedLocation();
            customerId = selectedAccount.DW_ID__c;
            division = selectedAccount.Division__c;
            System.debug('division--->'+division);
            OrderCountstatusWrapper dashCount = new OrderCountstatusWrapper();
            
            if(Dal_Constants.SSC_DIVISION.contains(selectedAccount.Division__c))  
            {
                DT_SYS_SSC_OrderStatusCount__x countobj = new DT_SYS_SSC_OrderStatusCount__x (); 
                if(!Test.isRunningTest()){  
                    countobj = [select Customer__c,OrderCountCompletedOrder__c,InvoiceCount__c,OrderCountWithLinesOpen__c,OrderCountWithLinesRdyForPickupDelivery__c,OrderCountWithLinesScheduledForDelivery__c,OrderCountWithLinesScheduledForPickup__c 
                                from DT_SYS_SSC_OrderStatusCount__x 
                                where Customer__c=: customerId limit 1];
                    System.debug('COuntOBJ---->'+countobj);
                }else{ 
                    countobj = mockallOrderStatusCount;    
                }
                dashCount.customer = countobj.Customer__c;
                dashCount.completedordercount = countobj.OrderCountCompletedOrder__c;
                dashCount.openordercount = countobj.OrderCountWithLinesOpen__c;
                dashCount.readyforpickupdeliverycount = countobj.OrderCountWithLinesRdyForPickupDelivery__c;
                dashCount.scheduledfordeliverycount = countobj.OrderCountWithLinesScheduledForDelivery__c;
                dashCount.scheduledforpickup = countobj.OrderCountWithLinesScheduledForPickup__c;
                dashCount.sscInvoicecount = countobj.InvoiceCount__c;
                
            }
            else{
                DT_SYS_DistributorCustomerDashboard__x countobj = new DT_SYS_DistributorCustomerDashboard__x();
                if(!Test.isRunningTest()){  
                    countobj = [SELECT Id, ExternalId, DisplayUrl, Customer__c, InvoiceCount_Last30_Days__c,
                                OrderCountWithLinesOpen__c, ShipmentCount_Last90_Days__c
                                FROM DT_SYS_DistributorCustomerDashboard__x 
                                where Customer__c =: customerId limit 1];
                    System.debug('COuntOBJ---->'+countobj);
                }else{ 
                    //countobj = mockallOrderStatusCount;    TODO. Need A MOck For This New Else Code
                }
                dashCount.customer = countobj.Customer__c; 
                dashCount.InvoiceCountLast30Days = countobj.InvoiceCount_Last30_Days__c;
                dashCount.OrderCountWithLinesOpen = countobj.OrderCountWithLinesOpen__c;
                dashCount.ShipmentCountLast90Days = countobj.ShipmentCount_Last90_Days__c;
            }
            
            System.debug('Count:---->'+dashCount);
            return dashCount;
        }
        catch(Exception exp){
            system.debug('Exception has occured'+exp.getMessage());
            return null; 
        } 
        
    }
    /*
    * Method Name: getDraftedOrders
    * Description: Purpose -- Query for all DT_Order__c records that I own for the selected account.
    * @param: N/A
    * @return List of DT_Order__c
    */
    public static List<DT_Order__c> getDraftedOrders(Integer listLimit){
        listLimit = listLimit != null ? Integer.valueOf(listLimit) : 1000;
        
        Account selectedAccount = Dal_BaseController.getUserSelectedLocation();
        system.debug('selectedAccount: ' + selectedAccount);
        List<DT_Order__c> orderList = new List<DT_Order__c>();
        
        try{
            orderList = [SELECT Address4__c, City__c, State__c, Brand__c, Contact_Phone__c, Country__c, Postal_Code__c,
                         Delegate_Pickup__c, Delegate_First_Name__c, Delegate_Last_Name__c, Delegate_Mobile_Phone__c,
                         Freight_Terms__c, Carrier__c, Group_Key__c, JobName__c, OrderID_External__c,
                         Order_Origin_Salesforce__c, Order_Status_Code__c, Price_Record__c, Purchase_Order__c,
                         Requested_Ship_date__c, Ship_Complete__c, Shipto_Name_1__c, Shipto_Name2__c,
                         Small_Package_Carrier__c, Small_Package__c, SSC__c, Tax_Exempt_Code__c, Total_Extended_Weight__c,
                         Total_Order_Amount__c, Status__c, Submit_Date__c, Id, Name, CreatedDate, AccountName__c,
                         Address1__c, Address3__c, Address2__c
                         FROM DT_Order__c
                         WHERE AccountName__c =: selectedAccount.Id AND Status__c = 'Draft' AND Purchase_Order__c != null 
                         AND CreatedById =: UserInfo.getUserId() 
                         ORDER BY CreatedDate DESC 
                         LIMIT :listLimit
                        ];
        }catch(Exception exp){
            System.debug('SalesOrderHeader__x: An unexpected error has occurred: ' + exp.getMessage());
        }
        
        return orderList;
        
    }
    public class OrderCountstatusWrapper{
        @AuraEnabled public string customer {get;set;}
        @AuraEnabled public Decimal completedordercount {get;set;}
        @AuraEnabled public Decimal openordercount {get;set;}
        @AuraEnabled public Decimal readyforpickupdeliverycount {get;set;}
        @AuraEnabled public Decimal scheduledfordeliverycount {get;set;}
        @AuraEnabled public Decimal scheduledforpickup {get;set;}     
        @AuraEnabled public Decimal	InvoiceCountLast30Days {get;set;}
        @AuraEnabled public Decimal OrderCountWithLinesOpen {get;set;}
        @AuraEnabled public Decimal ShipmentCountLast90Days {get;set;}
        @AuraEnabled public Decimal sscInvoicecount {get;set;}
    }
    
    
}