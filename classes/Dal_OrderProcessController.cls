/**
* Created by 7Summits on 3/27/18.
**/
public without sharing class Dal_OrderProcessController{
    
    @TestVisible
    private static list<DT_SYS_OrderHeader__x> mockallOpenItemsList = new list<DT_SYS_OrderHeader__x>();
    @TestVisible
    private static list<DT_SYS_OrderLine__x> mockallOrderLineList = new list<DT_SYS_OrderLine__x>();
    // OrderWrapper for Order header object
    public class OrderWrapper{
        public OrderWrapper(){
            List <OrderLineWrapper> lineWrapperList = new List<OrderLineWrapper>();
            this.orderLineList = lineWrapperList;
        }
        
        @AuraEnabled public List<OrderLineWrapper> orderLineList;
        @AuraEnabled public string defaultPriceCode;
        @AuraEnabled public Datetime defaultRequestedShipDate;
        @AuraEnabled public string Account_Address_Name;
        @AuraEnabled public string Account_Address_Name2;
        @AuraEnabled public String Account_Address_Line1;
        @AuraEnabled public String Account_Address_Line2;
        @AuraEnabled public String Account_Address_Line3;
        @AuraEnabled public String Account_Address_City;
        @AuraEnabled public String Account_Address_StateProvince;
        @AuraEnabled public String Account_Address_PostalCode;
        @AuraEnabled public String Account_Address_Country;
        @AuraEnabled public String Account_From_Address_Name;
        @AuraEnabled public String Account_From_Address_Line1;
        @AuraEnabled public String Account_From_Address_City;
        @AuraEnabled public String Account_From_Address_StateProvince;
        @AuraEnabled public String Account_From_Address_PostalCode;
        @AuraEnabled public String Account_From_Address_Country;
        @AuraEnabled public String FreightTerms;
        @AuraEnabled public String FulfilmentMethod;
        @AuraEnabled public String Carrier;
        @AuraEnabled public Boolean smallPackage;
        @AuraEnabled public String isShipComplete;
        @AuraEnabled public DateTime plannedShipmentCompletionDate;
        @AuraEnabled public Decimal cumulativeShipmentWeight;
        @AuraEnabled public Decimal orderSubTotal;
        @AuraEnabled public String PONumber;
        @AuraEnabled public String ordernumber;
        @AuraEnabled public String contactName = null;
        @AuraEnabled public String jobName;
        @AuraEnabled public String contactNumber;
        //new fields
        @AuraEnabled public String specialInstructions;
        @AuraEnabled public Decimal energySurcharge;
        @AuraEnabled public Decimal taxes;
        @AuraEnabled public Decimal shippingandhandling;
        @AuraEnabled public String taxstatus;
        @AuraEnabled public Decimal outstandingtotal;
        @AuraEnabled public String cashpayment;
        @AuraEnabled public String totalpayment;
        @AuraEnabled public String status;
        @AuraEnabled public Decimal orderTotal;
        @AuraEnabled public String BDC;
        //new id field
        @AuraEnabled public Id orderId;
        @AuraEnabled public String salesOrderTypeDesc;
        @AuraEnabled public String profileName;
		//@AuraEnabled public string Total_SlabCount;

        public OrderWrapper(DT_SYS_OrderHeader__x orderHeader ,List <OrderLineWrapper> lineWrapperList, SSC__c shipfrom,String LocType){
            
            this.orderId = Orderheader.Id;
            this.BDC = LocType;
            this.orderLineList = lineWrapperList ;
            this.Account_Address_Name = Orderheader.Fulfilment_ShipToAddress_Address_Name__c;
            this.Account_Address_Name2 = Orderheader.Fulfilment_ShipToAddress_Address_Name2__c;
            this.Account_Address_Line1 = orderHeader.Fulfilment_ShipToAddress_Address_Line1__c;
            this.Account_Address_Line2 = orderHeader.Fulfilment_ShipToAddress_Address_Line2__c;
            this.Account_Address_Line3 = orderHeader.Fulfilment_ShipToAddress_Address_Line3__c;
            this.Account_Address_City = orderHeader.Fulfilment_ShipToAddress_Address_City__c;
            this.Account_Address_StateProvince = orderHeader.Fulfilment_ShipToAddress_Address_StatePr__c;
            this.Account_Address_PostalCode = orderHeader.Fulfilment_ShipToAddress_Address_PostalC__c;
            this.Account_Address_Country = orderHeader.Fulfilment_ShipToAddress_Address_Country__c;
            this.FreightTerms = Dal_Constants.COMMUNITY_FRIEGHT_TERMS.get(orderHeader.Fulfilment_FreightTerms__c);
            this.FulfilmentMethod = orderHeader.Fulfilment_Method__c;
            this.isShipComplete = orderHeader.Fulfilment_ShipComplete__c == 'N'? 'No':'Yes';
            this.PONumber = orderHeader.CustomerPONo__c;
            if(orderHeader.Account_Contact_FirstName__c != null && orderHeader.Account_Contact_LastName__c!= null){
                this.contactName =  orderHeader.Account_Contact_FirstName__c+' '+orderHeader.Account_Contact_LastName__c;
            }else if(orderHeader.Account_Contact_FirstName__c == null && orderHeader.Account_Contact_LastName__c!= null){
                this.contactName = orderHeader.Account_Contact_LastName__c;
            }else if(orderHeader.Account_Contact_FirstName__c != null && orderHeader.Account_Contact_LastName__c == null){
                this.contactName = orderHeader.Account_Contact_FirstName__c;
            }
            this.jobName = orderHeader.JobName__c;
            this.contactNumber = orderHeader.Account_Contact_Phone__c;
            this.cumulativeShipmentWeight = orderHeader.Total_Weight__c;
            this.orderNumber = orderHeader.SalesOrder__c;
            this.energySurcharge = orderHeader.Total_Charge_ESC__c;
            this.shippingandhandling = orderHeader.Total_ShippingHandling__c;
            this.cashpayment = orderHeader.CashOnDeliveryInd__c;
            this.taxstatus = orderHeader.TaxStatus__c;
            this.totalpayment = orderHeader.Total_Payment__c;
            this.specialInstructions = orderHeader.Notes__c;
            this.orderSubTotal = orderHeader.Total_SubTotal__c;
            this.status = orderHeader.statusdesc2__c;
            String address = null;
            if(shipfrom != null)
            {
                Account_From_Address_Name = shipfrom.Name;
                Account_From_Address_Line1 = shipfrom.Street_Address__c;
                Account_From_Address_City = shipfrom.City__c;
                Account_From_Address_StateProvince = shipfrom.State__c;
                Account_From_Address_PostalCode = shipfrom.Zip_Code__c;
                Account_From_Address_Country = shipfrom.Country__c;
            }
            this.orderTotal = orderHeader.Total_Total__c;
            //this.Total_SlabCount = orderHeader.Total_Slab_Count__c;
            this.outstandingtotal = orderHeader.Total_Due__c;
            this.taxes = orderHeader.Total_Tax__c;
            this.salesOrderTypeDesc = orderHeader.SalesOrderTypeDesc__c;
            User user = [SELECT Profile.Name FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
            this.profileName = user.Profile.Name;
        }
        
        public OrderWrapper(DT_Order__c orderHeader){
            
            this.orderId = Orderheader.Id;
            this.Account_Address_Name = Orderheader.Address_Name__c;
            this.Account_Address_Name2 = Orderheader.Address_Name2__c;
            this.Account_Address_Line1 = orderHeader.Address1__c;
            this.Account_Address_Line2 = orderHeader.Address2__c;
            this.Account_Address_Line3 = orderHeader.Address3__c;
            this.Account_Address_City = orderHeader.City__c;
            this.Account_Address_StateProvince = orderHeader.State__c;
            this.Account_Address_PostalCode = orderHeader.Postal_Code__c;
            this.Account_Address_Country = orderHeader.Country__c;
            if(String.isBlank(orderHeader.Freight_Terms__c) && orderHeader.AccountName__r.Freight_Term__c != null)
                this.FreightTerms =orderHeader.AccountName__r.Freight_Term__c;
            
            else
                this.FreightTerms = orderHeader.Freight_Terms__c;
            this.Carrier = orderHeader.Carrier__c;
            this.smallPackage = orderHeader.Small_Package__c;
            this.isShipComplete = String.valueOf(orderHeader.Ship_Complete__c);
            this.PONumber = orderHeader.Purchase_Order__c;
            this.jobName = orderHeader.JobName__c;
            this.contactName = orderHeader.Contact_Name__c;
            this.contactNumber = orderHeader.Contact_Phone__c;
            this.defaultRequestedShipDate = orderHeader.Default_Requested_Ship_Date__c;
            this.defaultPriceCode = orderHeader.Default_Price_Code__c;
            
            List<OrderLineWrapper> orderProducts = new List<OrderLineWrapper>();
            
            for(DT_Order_Product__c orderProduct : orderHeader.DT_Order_Products__r){
                OrderLineWrapper orderProductLineWrapper = new OrderLineWrapper(orderProduct);
                orderProducts.add(orderProductLineWrapper);
            }
            this.orderLineList = orderProducts;
        }
    }
    
    // OrderLineWrapper for Order Line Item object
    public class OrderLineWrapper{
                
        @AuraEnabled public String lineno;
        @AuraEnabled public String skuNumber;
        @AuraEnabled public Decimal quantity;
        @AuraEnabled public String unitOfMeasure;
        @AuraEnabled public String availableUnitOfMeasure;
        @AuraEnabled public String sourceOfSupply;
        @AuraEnabled public String requestedShipDate;
        @AuraEnabled public String priceRecord;
        @AuraEnabled public String estimatedShipDate;
        @AuraEnabled public String size;
        @AuraEnabled public String color;
        @AuraEnabled public String trim;
        @AuraEnabled public String shade;
        @AuraEnabled public Decimal quantityShippedInvoiced;
        @AuraEnabled public Decimal quantityCancelled;
        @AuraEnabled public Decimal extendedWeight;
        @AuraEnabled public Decimal cartonCount;
        @AuraEnabled public Decimal pieceCount;
        @AuraEnabled public Decimal unitPrice;
        @AuraEnabled public Double extendedPrice;
        @AuraEnabled public String status;
        @AuraEnabled public String trackingNumber;
        @AuraEnabled public String fulfillmentMethod;
        @AuraEnabled public String lineitemstatus;
        @AuraEnabled public String shippedDate;
        @AuraEnabled public String productdesc;
        @AuraEnabled public string carrierName;
        @AuraEnabled public string sellingUOM;
        @AuraEnabled public string sellingQTY;
        @AuraEnabled public string sscuom;
        @AuraEnabled public string sscqty;
        @AuraEnabled public string sscunitpriceuom;
        @AuraEnabled public String sscunitprice;
        //new id field
        @AuraEnabled public string orderLineId;
        @AuraEnabled public string Fulfillment_Contact_FirstName;
        @AuraEnabled public string Fulfillment_Contact_LastName;
        @AuraEnabled public string Fulfillment_Contact_Phone;
        @AuraEnabled public string Fulfilment_ScheduleTime;
        @AuraEnabled public string Fulfilment_TextMsgInd;
        @AuraEnabled public string InventoryItem_DocumentNumber;
        @AuraEnabled public Decimal InventoryItem_Length;
        @AuraEnabled public Decimal InventoryItem_Width;
        @AuraEnabled Public boolean isSlabOrder;
        public OrderLineWrapper(DT_SYS_OrderLine__x orderLineItem, String location,Map<String,String> pricerecordMap){
            
            this.orderLineId = orderLineItem.Id;
            this.lineno = orderLineItem.SalesOrderLineNo__c;
            this.SkuNumber = orderLineItem.Material__c;
            this.Quantity = orderLineItem.Quantity__c;
            this.UnitOfMeasure = orderLineItem.UOM__c;
            this.SourceOfSupply = location;
            this.requestedShipDate = orderLineItem.RequestedShipDate__c;
            this.priceRecord = pricerecordMap.get(orderLineItem.DiscountCode__c);
            this.estimatedShipDate = orderLineItem.PromisedShipDate__c;
            this.size = orderLineItem.MaterialDesc_Size__c;
            this.color = orderLineItem.MaterialDesc_Color__c;
            this.trim = orderLineItem.MaterialDesc_Trim__c;
            this.shade = orderLineItem.InventortAttr_AllocatedDetails__c;
            this.quantityShippedInvoiced = orderLineItem.Quantity_Invoiced__c;
            this.quantityCancelled = orderLineItem.Quantity_Cancelled__c;
            this.extendedWeight = orderLineItem.WeightExtended__c;
            this.cartonCount = orderLineItem.QuantityInCartons__c;
            this.pieceCount = orderLineItem.QuantityInPieces__c;
            this.unitPrice = orderLineItem.Price_PriceNet_Unit__c;
            this.ExtendedPrice = orderLineItem.Price_PriceNet_Extended__c;
            this.fulfillmentMethod = orderLineItem.Fulfilment_Method__c;
            this.shippedDate = orderLineItem.Last_ActualShipDate__c;
            this.productdesc = orderLineItem.MaterialDesc__c;
            this.trackingNumber = orderLineItem.Tracking_LastTrackingNo__c;
            this.carrierName = orderLineItem.Fulfilment_Carrier_Name__c;//Dal_Constants.CARRIER.get(orderLineItem.Fulfilment_Carrier_SCAC__c);
            this.sellingUOM = orderLineItem.Price_PricingUOM__c ;
            this.sellingQTY = orderLineItem.QuantityInLegacyBaseUOM__c;
            this.sscuom = orderLineItem.LegacyBaseUOM__c;
            this.sscqty = orderLineItem.QuantityInLegacyBaseUOM__c;
            this.sscunitpriceuom = orderLineItem.Price_PricingUOM__c;
            this.sscunitprice = orderLineItem.Price_PriceNet_UnitPricingUOM__c;
            this.lineitemstatus = orderLineItem.statusdesc2__c;
            this.Fulfilment_ScheduleTime = orderLineItem.Fulfilment_ScheduleTime__c;
            this.Fulfillment_Contact_FirstName = orderLineItem.Fulfilment_Contact_FirstName__c;
            this.Fulfillment_Contact_LastName = orderLineItem.Fulfilment_Contact_LastName__c;
            this.Fulfillment_Contact_Phone = orderLineItem.Fulfilment_Contact_Phone__c;
            this.Fulfilment_TextMsgInd = orderLineItem.Fulfilment_SendMsgTextInd__c;
            this.InventoryItem_DocumentNumber = orderLineItem.InventoryItem_DocumentNumber__c;
            this.InventoryItem_Length = orderLineItem.InventoryItem_Length__c;
            this.InventoryItem_Width = orderLineItem.InventoryItem_Width__c;
            this.isSlabOrder = orderLineItem.InventoryItem_SerialNumber__c !=null? true:false;
        }
        
        public OrderLineWrapper(DT_Order_Product__c orderLineItem){
            
            this.orderLineId = orderLineItem.Id;
            List<Product2> product = [
                SELECT Id, Description, UOM__c, Base_UoM__c, StockKeepingUnit, DW_ID__c, Color__c, Size__c, Tile_Type__c
                FROM Product2
                WHERE DW_ID__c LIKE :orderLineItem.SKU_Number__c
                LIMIT 1
            ];
            if(product != null && product.size() > 0){
                Product2 prod = product[0];
                this.SkuNumber = orderLineItem.SKU_Number__c;
                this.Quantity = orderLineItem.Quantity__c;
                this.UnitOfMeasure = orderLineItem.Unit_of_Measure__c;
                this.availableUnitOfMeasure = prod.UOM__c;
                this.productdesc = prod.Description;
            }
            //this.SourceOfSupply = location;
            this.requestedShipDate = String.valueOf(orderLineItem.Requested_Ship_Date__c);
            this.PriceRecord = orderLineItem.Price_Record__c;
        }
        
    }
    
    /*
* Method Name: startOrder
* Description: Purpose to retrieve an order matching the passed orderId parameter. If the parameter is null, we
* check the session cache and return that order. If no order is found in the session cache, we create a new order and put it in the cache.
* @param: Id orderId
* @return void
*/
    @AuraEnabled
    public static OrderWrapper startOrder(String orderId){
        System.debug(orderId);
        if(orderId != null && !orderId.equals('')){ //TODO create util method to check null or empty
            List<DT_Order__c> draftOrderQueryResults = getOrder(orderId);//call order manager directly
            if(draftOrderQueryResults.size() > 0){
                DT_Order__c myOrder = draftOrderQueryResults[0];
                //Dal_SessionController.setSessionOrder(myOrder.Id);
                OrderWrapper myOrderWrapper = new OrderWrapper(myOrder);
                System.debug(myOrderWrapper);
                return myOrderWrapper;
            }
        } else {
            /*//Check for an order in the session cache
List<DT_Order__c> sessionOrderCache = Dal_OrderManager.getCurrentOrder();
if(sessionOrderCache.size() > 0){
return new OrderWrapper(sessionOrderCache[0]);

} else {

//If no order in the session cache, create/insert a new one, put it in the session cache, and return it
return new OrderWrapper(Dal_OrderManager.createNewOrder());
}*/
            
            // create/insert a new one, and return it
            return new OrderWrapper(Dal_OrderManager.createNewOrder());
        }
        
        return null;
    }
    
    /*
* Method Name: getOrder
* Description: Purpose to get list of order by Id
* @param: Id orderId
* @return orderList
*/
    @AuraEnabled
    public static List<DT_Order__c> getOrder(Id orderId){
        List<DT_Order__c> order = Dal_OrderManager.getOrderById(orderId);
        return order;
    }
    
    /*
* Method Name: getSubmittedOrder
* Description: Purpose to grab a submitted order by id.
* @param: Id orderId
* @return wrapOrderAndOrderItem
*/
    @AuraEnabled
    public static OrderWrapper getSubmittedOrder(String orderNumber){
        Map<String, String> pricerecordMap = new Map<String, String>();
        Account selectedAccount = Dal_BaseController.getUserSelectedLocation();
        try{
            
            List<DT_SYS_PriceRecord__x> pricerecords = [select PriceRecordCode__c,PriceRecordDescription__c,Customer__c
                                                        from DT_SYS_PriceRecord__x 
                                                        where Customer__c =:selectedAccount.DW_ID__c];
            
            for(DT_SYS_PriceRecord__x pricerecord:pricerecords ){
                pricerecordMap.put(pricerecord.PriceRecordCode__c,pricerecord.PriceRecordDescription__c);
            }
            
        }
        catch(Exception ex){
            system.debug('Exception occured'+ex.getMessage());
        }
        system.debug('Dal_Constants.SSC_DIVISION'+Dal_Constants.SSC_DIVISION+''+'selectedAccount.Division__c '+selectedAccount.Division__c);
        String hostsystem = Dal_Constants.SSC_DIVISION.contains(selectedAccount.Division__c)? 'OASIS':'SAP';
        system.debug('orderNumber queried is '+orderNumber+'hostsystem========:>'+hostsystem);
        List<DT_SYS_OrderHeader__x> orderHeader = new List<DT_SYS_OrderHeader__x>();
        List<DT_SYS_OrderLine__x> orderListItem = new List<DT_SYS_OrderLine__x>();
        if(!Test.isRunningTest()){
            //Query Order header and line item on basis of salesorder.
            orderHeader = [
                SELECT Id, ExternalId, DisplayUrl, Account_Address_City__c, Account_Address_Country__c,
                Account_Address_Line1__c, Account_Address_Line2__c, Account_Address_Line3__c,
                Account_Address_Name__c, Account_Address_Name2__c, Account_Address_PostalCode__c, Account_Address_StateProvince__c,
                Account_Contact_Name__c,Account_Contact_LastName__c,Account_Contact_FirstName__c, Account_Contact_Phone__c, Account_Contact_eMail__c, Account_Id_Type__c,
                Account_Id_Value__c, Fulfilment_FreightTerms__c,CreatedByUser_Id_Type__c, CreatedByUser_Id_Value__c,
                CreatedTime__c, CustomerPONo__c, Fulfilment_CarrierPaidBy__c, Fulfilment_Carrier_CustomerAcctWithCarri__c,
                Fulfilment_Carrier_SCAC__c, Fulfilment_Method__c,ShipFromLoc__c,Total_Charge_ESC__c, Fulfilment_ShipComplete__c, Fulfilment_ShipMode__c,
                Fulfilment_ShipToAddress_Address_City__c, Fulfilment_ShipToAddress_Address_Country__c,
                Fulfilment_ShipToAddress_Address_Line1__c, Fulfilment_ShipToAddress_Address_Line2__c,
                Fulfilment_ShipToAddress_Address_Line3__c, Fulfilment_ShipToAddress_Address_Name__c, Fulfilment_ShipToAddress_Address_Name2__c,
                Fulfilment_ShipToAddress_Address_PostalC__c, Fulfilment_ShipToAddress_Address_StatePr__c,
                Fulfilment_ShipToAddress_SameAsAccount__c, HeaderCharge_CUS__c, HeaderCharge_FRT__c, HeaderCharge_HND__c,
                HeaderCharge_IFR__c, HeaderCharge_MIS__c, HeaderCharge_RES__c, HostSystem__c, JobName__c, Notes__c,
                OrderPlantName__c, OrderPlant__c, SalesOrder__c,Total_SubTotal__c,Total_Payment__c,Total_PaymentsReceived__c,WeightUOM__c,TaxStatus__c, Status__c,StatusDesc2__c, Total_Charges__c, Total_Collection__c,
                Total_Deposit__c, Total_Discount__c, Total_Due__c,Total_ShippingHandling__c, Total_HeaderCharges__c, Total_Materials__c, Total_TaxAmt_City__c,
                Total_TaxAmt_County__c, Total_TaxAmt_District__c, Total_TaxAmt_State__c, Total_TaxRate_City__c,
                Total_TaxRate_County__c, Total_TaxRate_District__c,CashPayment__c,CashOnDeliveryInd__c, Total_RefundToApply__c ,Total_Refund__c,Total_TaxRate_State__c, Total_TaxRate__c, Total_Tax__c,
                Total_Total__c, Total_Weight__c, id__c,SalesOrderType__c, SalesOrderTypeDesc__c FROM DT_SYS_OrderHeader__x
                WHERE SalesOrder__c =: orderNumber and HostSystem__c=:hostsystem ];
        }else{
            orderHeader.addAll(mockallOpenItemsList);
        }
        
        
        system.debug('orderHeader is '+orderHeader);
        Boolean isvalid = Dal_BaseController.isValidList(orderHeader);
        system.debug('isvalid is '+isvalid);
        if(isvalid)
        {
            if(!Test.isRunningTest()){
                orderListItem = [
                    Select DiscountCode__c, DiscountCodeApplied__c,QuantityInPieces__c, StatusDesc2__c, QuantityInCartons__c,Price_PriceNet_UnitPricing__c, DisplayUrl, ExternalId,
                    Fulfilment_Carrier_CustomerAcctWithCarri__c, Fulfilment_Carrier_SCAC__c,
                    Fulfilment_CarrierPaidBy__c, Fulfilment_Method__c, Fulfilment_ShipComplete__c,
                    Fulfilment_ShipMode__c, Fulfilment_Contact_FirstName__c,Fulfilment_Contact_LastName__c,
                    Fulfilment_ScheduleTime__c,Fulfilment_SendMsgTextInd__c,Fulfilment_Contact_Phone__c,
                    HostSystem__c, Id, id__c, InventortAttr_AllocatedDetails__c, InventortAttr_InventoryId__c,
                    InventortAttr_RequestedDetails__c, Last_ActualShipDate__c, LegacyBaseUOM__c,
                    LineCharge_ESC__c, LineCharge_FAB__c, Material__c, MaterialDesc__c, MaterialDesc_Color__c,
                    MaterialDesc_Size__c, MaterialDesc_Trim__c, Notes__c, OrderPlant__c,
                    Price_DiscountFactor__c, Price_PriceList_UnitPricingUOM__c, Price_PriceNet_Extended__c,
                    Price_PricingUOM__c,Price_PriceNet_UnitPricingUOM__c, PromisedShipDate__c, Quantity__c,Price_PriceNet_Unit__c,
                    Quantity_Cancelled__c, Quantity_Invoiced__c, Quantity_Open__c, Quantity_Shipped__c,
                    QuantityInLegacyBaseUOM__c, RequestedShipDate__c, SalesOrder__c, SalesOrderLineNo__c,
                    SpecialOrderInd__c, Status__c, Tracking_LastDelivery__c, Tracking_LastShipment__c,
                    Tracking_LastShipment_Carrier_SCAC__c,Fulfilment_Carrier_Name__c, Tracking_LastTrackingNo__c, UOM__c,
                    WeightExtended__c, WeightUOM__c,InventoryItem_DocumentNumber__c,InventoryItem_Width__c,InventoryItem_Length__c,InventoryItem_SerialNumber__c From DT_SYS_OrderLine__x
                    WHERE SalesOrder__c =: orderHeader[0].SalesOrder__c and HostSystem__c =: hostsystem];
            }
            else
            {
                orderListItem.addAll(mockallOrderLineList);
            }
        }
        else{
            return null;
        }
        //check if logged in user has access to this order
        //system.debug('orderHeader[0].Account_Id_Value__c '+orderHeader[0].Account_Id_Value__c+ 'selectedAccount.DW_ID__c '+selectedAccount.DW_ID__c);


        //Getting SSC Location for all queried line items
        Set<String> locationset = new Set<String>();
        for(DT_SYS_OrderLine__x orderList : orderListItem){
            locationset.add(orderList.OrderPlant__c);
        }
        //creating map to store locationid and name
        Map<string, string> locationmap = new Map<string, string>();
        for(SSC__c location : [Select DW_ID__c,Name from SSC__c where DW_ID__c in: locationset]){
            locationmap.put(location.DW_ID__c,location.Name);
        }
        /*Creating a list of wrapper class of Order line item to response back in order header wrapper class sending to
* lightning Controller
*/
        String location = null;
        List <OrderLineWrapper> lineWrapperList = new List<OrderLineWrapper>();
        for(DT_SYS_OrderLine__x orderList : orderListItem){
            //get location for each order plant from the map and set it in wrapper
            //Dal_ConversionCalculation.wrapConversionCal wrapConver = Dal_ConversionCalculation.getConversionCal(orderList.Material__c,orderList.Quantity__c,orderList.UOM__c);
            location = locationmap.get(orderList.OrderPlant__c);
            OrderLineWrapper lineWrapper = new OrderLineWrapper(orderList, location, pricerecordMap);
            lineWrapperList.add(lineWrapper);
            
        }
        system.debug('lineWrapperList is '+lineWrapperList);
        //Getting shipfrom address for the order header plant
        SSC__c shipfrom = Dal_BaseController.getSSCLocation(orderHeader[0].ShipFromLoc__c);
        // for BDC-------------------

        system.debug('orderPlantNumberFromHeader '+orderHeader[0].OrderPlant__c);
        SSC__c orderPlantNumber = [Select Name,DW_ID__c,Loc_Type__c from SSC__c where DW_ID__c =: orderHeader[0].OrderPlant__c limit 1];
        system.debug('orderPlantNumber '+orderPlantNumber.Loc_Type__c);
        // Creating Order Header Wrapper for sending data to lightning controller
        String LOC_TYPE;
        if(orderPlantNumber.Loc_Type__c == null || orderPlantNumber.Loc_Type__c == ''){
            LOC_TYPE = 'SSC';
        }else{
            LOC_TYPE = orderPlantNumber.Loc_Type__c;
        }
        OrderWrapper orderWrapper = new OrderWrapper(orderHeader[0],lineWrapperList, shipfrom,LOC_TYPE);
        system.debug('orderWrapper is '+orderWrapper);
        system.debug('orderHeader[0].Account_Id_Value__c '+orderHeader[0].Account_Id_Value__c+ 'selectedAccount.DW_ID__c '+selectedAccount.DW_ID__c);
        if(orderHeader[0].Account_Id_Value__c != selectedAccount.DW_ID__c)
        {
            system.debug('sending null wrapper');
            Dal_OrderProcessController.OrderWrapper ow = new Dal_OrderProcessController.OrderWrapper();
            return ow;
        }
        return orderWrapper;
        
        
    }
    
    /*
* Method Name: searchProductSKUs
* Description: Purpose to search for a list of Product2 records with their Product -
* StockKeepingUnit,Description,and UOM
* @return productList
*/
    @AuraEnabled
    public static List<Product2> searchProductSKUs(String sku){
        
        return Dal_SearchProductSkuUtil.searchProducts(sku);
    }
    
    
    /*
* Method Name: searchProducts
* Description: Purpose to search for a list of Product2 records by various fields (used in the product search modal) -
* StockKeepingUnit,Description,and UOM
* @return productList
*/
    @AuraEnabled
    public static List<DT_SYS_PriceRecord__x> getPriceRecords(String customerId){
        List<DT_SYS_PriceRecord__x> priceRecord = Dal_PriceRecordManager.getAllPriceRecord(customerId , 100);
        return priceRecord;
    }
    /*
* Method Name: getPriceRecordsByDate
* Description: Purpose to retrieve the possible default price records for the user's selected account for the requested date.
* @param: String customerId
* @param: Datetime requestedDate
* @return priceRecordList
*/
    @AuraEnabled
    public static List<DT_SYS_PriceRecord__x> getPriceRecordsByDate(String customerId, DateTime requestedDate){
        List<DT_SYS_PriceRecord__x> priceRecord = Dal_PriceRecordManager.getPriceRecordByDate(customerId, requestedDate, 100);
        return priceRecord;
    }
    
    @AuraEnabled
    public static List<Product2> searchProducts(String searchParameter){
        
        return Dal_SearchProductSkuUtil.searchProducts(searchParameter);
    }
    
    /*
* Method Name: getATPResults
* Description: Purpose to retrieve the Value from webservice on basis of filter values.
* @param: String SKU,String Quantity,String UOM,String SOS,String ReqShipDate,String PriceRecord
* @return wrapper object of Dal_ATP_Manager class
*/
    @AuraEnabled
    public static List<Dal_AvailabilityDate_Price_ATP_Manager.ATP_AvailableDate_Wrapper> getATPResults(String sku,String quantity,String uom,String reqShipDate,String priceRecord){
        system.debug('Input--'+sku+'--'+String.valueOf(quantity)+'--'+uom+'--'+reqShipDate+'---'+priceRecord);
        Dal_AvailabilityDate_Price_ATP_Manager AvailabilityManager = new Dal_AvailabilityDate_Price_ATP_Manager(sku,quantity,uom,reqShipDate,priceRecord);
        List<Dal_AvailabilityDate_Price_ATP_Manager.ATP_AvailableDate_Wrapper> response = AvailabilityManager.getATP_By_AvailibilityDate();
        system.debug('final response is '+response);
        return response;
    }
    
    /*
* Method Name: getATPResults
* Description: Purpose to retrieve the Value from webservice on basis of filter values.
* @param: String SKU,String Quantity,String UOM,String SOS,String ReqShipDate,String PriceRecord
* @return wrapper object of Dal_ATP_Manager class
*/
    @AuraEnabled
    public static List<Dal_TimePhase_ATP_Manager.ATP_TimePhase_Wrapper> getTimePhasedResults(String sku,String uom,String supplyplantId,String supplyplantType){
        system.debug('Input--'+sku+'--'+uom+'--'+supplyplantId+'---'+supplyplantType);
        Dal_TimePhase_ATP_Manager TimePhaseManager = new Dal_TimePhase_ATP_Manager(sku,'Legacy',uom,supplyplantId,supplyplantType);
        List<Dal_TimePhase_ATP_Manager.ATP_TimePhase_Wrapper> response = TimePhaseManager.getATP_By_TimePhase();
        system.debug('final response is '+response);
        return response;
    }
    
    /*
* Method Name: getShadeDetails
* Description: Purpose to retrieve the Value from webservice on basis of filter values.
* @param: String SKU,String Quantity,String UOM,String SOS,String ReqShipDate,String PriceRecord
* @return wrapper of object of Dal_Shade_Manager class
*/
    @AuraEnabled
    public static List<Dal_Shade_Manager.ShadeWrapper> getShadeDetails(String sku,String qty,String uom,String reqShipdate,String priceRecord,String supplyplantId,String supplyplantType){
        system.debug('Shade inputs are '+sku+'--'+qty+'--'+uom+'--'+reqShipdate+'--'+pricerecord+'--'+supplyplantId+'--'+supplyplantType);
        Dal_Shade_Manager shadeManager = new Dal_Shade_Manager(sku,qty,uom,reqShipdate,priceRecord,supplyplantId,supplyplantType);
        List<Dal_Shade_Manager.ShadeWrapper> response = shadeManager.getByShade();
        system.debug('Shade response is '+response);
        return response;
    }
    
    /*
* Method Name: getPricingbySKU
* Description: Purpose to delete OrderLineItem
* @param: DT_Order_Product__c orderProduct
* @return void
*/
    @AuraEnabled
    public static List<Dal_GetPriceManager.Dal_GetPriceWrapper> getPricingbySKU(String material,String pricedQuantity,String pricedQuantityUOM,String supplyPlant, String pricerecord){
        
        Dal_GetPriceManager price = new Dal_GetPriceManager(material,pricedQuantity,pricedQuantityUOM,supplyPlant,pricerecord);
        List<Dal_GetPriceManager.Dal_GetPriceWrapper> response = price.getPrice();
        system.debug('Response is '+response);
        return response;
    }
    /*
* Method Name: removeOrderLineItem
* Description: Purpose to delete OrderLineItem
* @param: DT_Order_Product__c orderProduct
* @return void
*/
    @AuraEnabled
    public static void removeOrderLineItem(DT_Order_Product__c orderProduct){
        Dal_OrderManager.deleteOrderLineItem(orderProduct);
    }
    
    @AuraEnabled
    public static DT_Order__c toDTOrder(OrderWrapper owrap){
        DT_Order__c order = new DT_Order__c();
        try{
            //map all fields required to save order
            order.Id = owrap.orderId;

            order.Address_Name__c = owrap.Account_Address_Name;
            order.Address_Name2__c = owrap.Account_Address_Name2;
            order.Address1__c = owrap.Account_Address_Line1;
            //order.Address2__c = owrap.Account_Address_Line2;
            //order.Address3__c = owrap.Account_Address_Line3;
            //order.Carrier__c = owrap.Carrier;
            order.City__c = owrap.Account_Address_City;
            order.State__c = owrap.Account_Address_StateProvince;
            order.Postal_Code__c = owrap.Account_Address_PostalCode;
            order.Country__c = owrap.Account_Address_Country;
            order.Contact_Phone__c = owrap.contactNumber;
            order.Delegate_First_Name__c = owrap.contactName;
            order.Delegate_Mobile_Phone__c = owrap.contactNumber;
            order.Freight_Terms__c = owrap.FreightTerms;
            order.JobName__c = owrap.jobName;
            order.Order_Origin_Salesforce__c = true;
            order.Purchase_Order__c = owrap.PONumber;
            order.Ship_Complete__c = owrap.isShipComplete != null ? owrap.isShipComplete.contains('Yes') : false;
            //order.Shipto_Name_1__c = owrap.Account_Address_Name;
            //order.Small_Package__c = owrap.smallPackage != null ? Boolean.valueOf(owrap.smallPackage) : false;
            order.Status__c = 'Draft';
            //order.Total_Extended_Weight__c = owrap.cumulativeShipmentWeight;
            //order.Total_Order_Amount__c = owrap.outstandingtotal != null ? Decimal.valueof(owrap.outstandingtotal) : 0;
            System.debug('Order');
        }
        catch(Exception Ex){
            system.debug('Exception occured '+Ex.getMessage());
        }
        return order;
    }
    @AuraEnabled
    public static List<DT_Order_Product__c> toDTOrderProduct(List<Dal_OrderJSON.OrderLineList> olinewwrap){
        List<DT_Order_Product__c> orderlinemapped = new List<DT_Order_Product__c>();
        try{
            for(Dal_OrderJSON.OrderLineList op : olinewwrap){
                system.debug('op.PriceRecord '+op.PriceRecord);
                DT_Order_Product__c orderproduct = new DT_Order_Product__c();
                List<Product2> product = [Select Id from Product2 where DW_ID__c =: op.skuNumber AND DW_ID__c != null];
                if(product != null && product.size() > 0){
                    orderproduct.Product_Sku__c = product[0].Id;
                }
                if(op.lineno != null) {
                    orderproduct.Name = String.valueOf(op.lineno);
                }
                if(op.extendedPrice != null) {
                    orderproduct.Extended_Price__c = Decimal.valueOf(op.extendedPrice);
                }
                orderproduct.Extended_Weight__c = Decimal.valueOf(op.extendedWeight);
                if(op.priceRecord != null) {
                    orderproduct.Price_Record__c = op.PriceRecord.priceRecordCode;
                }
                orderproduct.product_description__c = op.productdesc;
                if(op.Quantity != null) {
                    orderproduct.Quantity__c = Decimal.valueOf(op.Quantity);
                }
                orderproduct.Unit_of_Measure__c = op.unitOfMeasure;
                orderproduct.Product_SKU_Number__c = op.skuNumber;
                orderproduct.Source_of_Supply__c = op.sourceOfSupply;
                orderproduct.Source_of_Supply_Number__c = op.supplyplantid;
                if(op.requestedShipDate != null) {
                    orderproduct.Requested_Ship_Date__c = Date.valueOf(op.requestedShipDate);
                }
                
                if(op.priceRecord != null) {
                    orderproduct.Price_Record__c = op.priceRecord.priceRecordCode;
                }
                //set fields
                
                ////orderproduct.Carrier__c = Decimal.valueOf(op.carrierName); //Not comming any data from Front-End.
                //orderproduct.Color__c = op.color; // Coming Wrong Id for Color
                //orderproduct.Delivery_Preference__c = 'no mapping';
                //orderproduct.Brand__c = 'no mapping';
                //orderproduct.Division_code__c = 'no mapping';
                //orderproduct.DT_Shiptoaddress_Override__c = 'no mapping';
                //set the id whiel inserting
                //orderproduct.DT_Order_Id__c = op.
                //orderproduct.Freight_Terms__c = 'no mapping';
                //not avilable until submitted
                //orderproduct.Order_Number_ext__c = op.
                //duplicate fields
                //orderproduct.Orderline_status__c = op.
                ////orderproduct.Order_Line_Status__c = op.status;
                //orderproduct.Override_Name2__c = 'no mapping';
                //orderproduct.Override_Postal_Code__c = 'no mapping';
                //orderproduct.Override_shipcode_add__c = false;
                //orderproduct.Override_Shipto_Address1__c = 'no mapping';
                //orderproduct.Override_Shipto_Address2__c = 'no mapping';
                //orderproduct.Override_Shipto_City__c = 'no mapping';
                //orderproduct.Override_Shipto_State__c = 'no mapping';
                //orderproduct.Price_per_UOM__c = 'no mapping';
                //orderproduct.Product_name__c = 'no mapping';
                //orderproduct.QTY_of_UOM__c = 'no mapping';
                //orderproduct.RDC_number__c = 'no mapping';
                //orderproduct.Receiver_Company_name__c = 'no mapping';
                //orderproduct.Requested_Ship_Date__c = 'no mapping';
                //orderproduct.Shipment_line_status__c = 'no mapping';
                //orderproduct.Small_Packagecd__c = 'no mapping';
                //orderproduct.Small_Package_Carrier__c = 'no mapping';
                //will populate source of supply from SSC object
                //orderproduct.Source_of_Supply__c = op.
                //orderproduct.SSC_Name__c = 'no mapping';
                //orderproduct.Unit_Weight__c = 'no mapping';
                
                orderlinemapped.add(orderproduct);
                System.debug('OrderProduct');
                System.debug(orderproduct);
            }
            
        }
        catch(Exception Ex){
            system.debug('Exception occured '+Ex.getMessage());
        }
        return orderlinemapped;
        
    }
    
    /*
* Method Name: SaveOrder
* Description: Purpose to save the current order and any updates made to the order product line items. This will also
*  cleanup and remove any extra DT_Order_Product__c records that are related to the order but arent present in the orderProduct list
* @param: DT_Order__c order
* @param: List<DT_Order_Product__c> orderProduct
* @return void
*/
    @AuraEnabled
    public static String SaveOrder(String wrapper){
        system.debug('Inside SaveOrder '+wrapper);
        Dal_OrderJSON wrap = Dal_OrderJSON.parse(wrapper);
        system.debug('wrap'+wrap.orderLineList);
        
        DT_Order__c order = new DT_Order__c();
        order.Id = wrap.orderId;
       	if(String.isNotBlank(wrap.orderId)){
            DT_Order__c dt = [Select AccountName__c from DT_Order__c where id =:wrap.orderId];
            
            if(dt.AccountName__c != null){
                Account acc = [Select billingcity , BillingState , BillingPostalCode , BillingCountry from Account where id =:dt.AccountName__c ];
            
                if(acc.billingcity != wrap.Account_Address_City || acc.BillingState != wrap.Account_Address_StateProvince || 
                   acc.BillingPostalCode != wrap.Account_Address_PostalCode || acc.BillingCountry!=wrap.Account_Address_Country){
                       
                       order.IsOverrride__c = true;
                }else{
                    order.IsOverrride__c = false;
                }
            }
        }
        order.Address_Name__c = wrap.Account_Address_Name;
        order.Address_Name2__c = wrap.Account_Address_Name2;
        order.Address1__c = wrap.Account_Address_CareOf;
        order.Address2__c = wrap.Account_Address_Line1;
        order.City__c = wrap.Account_Address_City;
        order.State__c = wrap.Account_Address_StateProvince;
        order.Postal_Code__c = wrap.Account_Address_PostalCode;
        order.Country__c = wrap.Account_Address_Country;
        order.Contact_Phone__c = wrap.contactNumber;
        order.Contact_Name__c = wrap.contactName;
        order.Freight_Terms__c = wrap.FreightTerms;
        order.JobName__c = wrap.jobName;
        order.Order_Origin_Salesforce__c = true;
        order.Purchase_Order__c = wrap.PONumber;
        order.Ship_Complete__c = wrap.isShipComplete == 'true' ? true : false;
        order.Small_Package__c = wrap.smallPackage == 'true' ? true : false;
        order.Carrier__c = wrap.Carrier;
        order.Status__c = 'Draft';
        order.Default_Price_Code__c = wrap.defaultPriceCode;
        if(wrap.defaultRequestedShipDate != null) {
            order.Default_Requested_Ship_Date__c = Date.valueOf(wrap.defaultRequestedShipDate);
        }
        system.debug('wrap.orderLineList '+wrap.orderLineList);
        List<DT_Order_Product__c> orderProducts = toDTOrderProduct(wrap.orderLineList);
        System.debug('orderProducts'+orderProducts);
        return Dal_OrderManager.saveCurrentOrder(order, orderProducts);
        
    }
    
    /*
* Method Name: createOrder
* Description: create a new order by calling Dal_OrderCreateManager
* @param: Order Id from DT_Order__c
* @return type of String (Sales Order Number)
*/
    @AuraEnabled
    public static Peak_Response createOrder(Id orderId){
        
        DT_Order__c order = new DT_Order__c();
        
        Dal_OrderCreateManager orderCreateMgr = new Dal_OrderCreateManager(orderId);
        
        Peak_Response response = orderCreateMgr.getOrderCreate();
        
        if(response.success){
            order = [SELECT Id FROM DT_Order__c WHERE Id =: orderId] ;
            order.Status__c = 'Submitted';
            update order;
        }
        System.debug('Status-->'+ response.success);
        System.debug('OrderNumber-->'+ response.messages[0]);
        return response;
    }
    
    /*
* Method Name: cloneOrder
* Description: create a new order by r
* @param: Order Id from a submitted order
* @return returns the draft Id of the new cloned Order
*/
    @AuraEnabled
    public static String cloneOrder(String orderNumber){
        OrderWrapper wrapper = getSubmittedOrder(orderNumber);
        System.debug('wrapper---->'+wrapper);
        DT_Order__c order = new DT_Order__c();
        Account selectedAccount = Dal_BaseController.getUserSelectedLocation();
        If(selectedAccount != null){
            order.AccountName__c = selectedAccount.Id;
        }
        order.Order_Origin_Salesforce__c = true;
        
        order.Status__c = 'Draft';
        
        List<DT_Order_Product__c> orderProducts = new List<DT_Order_Product__c>();
        for(OrderLineWrapper lineWrapper : wrapper.orderLineList) {
            DT_Order_Product__c orderproduct = new DT_Order_Product__c();
            orderproduct.Name = String.valueOf(lineWrapper.lineno);
            
            List<Product2> product = [
                SELECT Id, Description, UOM__c, Base_UoM__c, StockKeepingUnit, DW_ID__c, Color__c, Size__c, Tile_Type__c
                FROM Product2
                WHERE DW_ID__c LIKE :lineWrapper.skuNumber
                LIMIT 1
            ];
            if(product != null && product.size() > 0){
                Product2 prod = product[0];
                orderproduct.Product_Sku__c = prod.Id;
                orderproduct.Product_SKU_Number__c = lineWrapper.skuNumber;
                orderproduct.Quantity__c = lineWrapper.quantity;
                orderproduct.Unit_of_Measure__c = lineWrapper.UnitOfMeasure;
                orderproduct.Available_UOM__c = prod.UOM__c;
                orderproduct.product_description__c = prod.Description;
                System.debug('orderproduct----->'+orderproduct);
            }
            orderProducts.add(orderproduct);
        }
        return Dal_OrderManager.saveCurrentOrder(order, orderProducts);
    }
    
    /*
* Method Name: getStatusCount
* Description: To get Count of Order status for Dasboard
* @param: none
* @return returns wrapper of count status
*/
    @AuraEnabled
    public static Dal_OrderManager.OrderCountstatusWrapper getStatusCount(){
        Dal_OrderManager.OrderCountstatusWrapper countWrapper = Dal_OrderManager.getOrderStatusCount();
        return countWrapper;
    }
    
}