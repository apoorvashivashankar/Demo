/**
 * Created by Yadav on 1/22/2019.
 */

public with sharing class DAl_SSC_OrderCreateManager {

    public static final String HOST_SYSTEM = 'OASIS';
    public static final String CREATEDVIA = 'DT Pro-Exchange';
    public static final String QUALIFIER_VAL = 'CustomerPONo';
    public static final String SCHEDULE_TYPE = 'Delivery';
    public static final String PICKUP = 'PickUp';
    public static final String ORDER_TYPE = 'SALES';
    public static final String CHARGE_ID_VALUE = 'ESC';
    public static final String SPECIAL_INSTRUCTION = 'Special Instructions';

    public List<DT_Cart__c> orderCartList ;
    public List<DT_Cart_Product__c> orderProductList ;
    List<Dal_SSC_OrderCreateWrapper> orderCreateWrapperList;

    public class Dal_SSC_OrderCreateWrapper {
        public String materialId ;
        public Decimal pricedQuantity ;
        public String pricedQuantityUOM ;
        public String supplyPlant ;

        public Dal_SSC_OrderCreateWrapper(DT_Cart_Product__c cartProduct) {
            materialId = cartProduct.Product__r.DW_ID__c;
            pricedQuantity = cartProduct.Quantity__c;
            pricedQuantityUOM = cartProduct.UOM__c;
            supplyPlant = cartProduct.SSC__r.SAP_Plant__c;
        }
    }


    // Constructor
    public DAl_SSC_OrderCreateManager(Id orderId) {
        orderCartList = new List<DT_Cart__c>();
        orderProductList = new List<DT_Cart_Product__c>();
        try {
            orderCartList = [
                    SELECT Id, Name, CreatedDate, LastModifiedDate,User__c, Special_Instructions__c,DT_Cart__c.National_Account__r.NA_ID__c	,
                            Job_Name__c, Contact_Name__c, Contact_Number__c, Status__c, National_Account__c, Tax_Exempt__c, PO__c,
                            Cart_Account__r.BillingCity,Cart_Account__r.BillingCountry,Cart_Account__r.BillingState,
                            Cart_Account__r.BillingStreet,Cart_Account__r.BillingPostalCode,Cart_Account__r.Name,Job_Name_Certificate_Id__c,
                            Job_Name_Expiration__c
                    FROM DT_Cart__c
                    Where Id = :orderId
            ];

            System.debug('Order header-->' + orderCartList[0]);

        } catch (Exception exp) {
            System.debug('orderheaderList: An unexpected error has occurred: ' + exp.getMessage());
        }

        try {
            orderProductList = [
                    SELECT Id, CreatedDate, LastModifiedDate,SSC__r.SAP_Plant__c,SSC__r.Name,SSC__r.State__c,SSC__r.City__c,SSC__r.DW_ID__c,SSC__r.Country__c,SSC__r.Zip_Code__c,SSC__r.Street_Address__c, Name,
                            DT_Cart__c,Shipping_Name__c, Shipping_Street__c, Shipping_City__c, Shipping_State__c,Shipping_Country__c,
                            Shipping_ZIP_Code__c,Product__c,Product__r.Name,Product__r.Base_UoM__c,Product__r.DW_ID__c,SSC__c, Fulfillment_Method__c, Lift_gate__c, UOM__c,
                            Unit__c, Quantity__c,Energy_Surcharge__c,Available_UOM__c, Quantity_Measure__c, Total_Amount__c
                    FROM DT_Cart_Product__c
                    WHERE DT_Cart__c = :orderId
            ] ;


            if (orderProductList.size() > 0 && orderProductList != null) {
                orderCreateWrapperList = new List<Dal_SSC_OrderCreateWrapper>();
                for (DT_Cart_Product__c cartProduct : orderProductList) {
                    Dal_SSC_OrderCreateWrapper wrapper = new Dal_SSC_OrderCreateWrapper(cartProduct);
                    orderCreateWrapperList.add(wrapper);
                }
                System.debug('SSCorderCreateWrapperList---->' + orderCreateWrapperList);
            }

            System.debug('Order Products-->' + orderProductList.size());

        } catch (Exception exp) {
            System.debug('orderProducts: An unexpected error has occurred: ' + exp.getMessage());
        }
    }

    /*
* Method Name: getOrderFulfilment
* Description: Purpose to get Order create data from webservice .
* @param: Not Any
* @return List of Wrapper Class object.
*/
    public List<Peak_Response> getOrderCreate() {

        System.debug('orderCreateWrapperList-->' + orderCreateWrapperList);

        Dal_GetPriceManager priceManager = new Dal_GetPriceManager(orderCreateWrapperList);
        List<Dal_GetPriceManager.Dal_GetPriceWrapper> getPriceList = new List<Dal_GetPriceManager.Dal_GetPriceWrapper>();
        getPriceList = priceManager.getPrice();
        System.debug('getPriceList--->' + getPriceList);

        Map<String, Dal_GetPriceManager.Dal_GetPriceWrapper> priceMap = new Map<String, Dal_GetPriceManager.Dal_GetPriceWrapper>();
        if (getPriceList.size() > 0) {
            for (Dal_GetPriceManager.Dal_GetPriceWrapper priceWrapper : getPriceList) {
                priceMap.put(priceWrapper.sku, priceWrapper);
            }
        }
        System.debug('priceMap_At_SSC_OrderCreate--->' + priceMap);

        User user = [SELECT Id,ContactId,Email FROM User WHERE Id = :UserInfo.getUserId()];
        Contact con = [SELECT Id,Name,Email FROM Contact WHERE Id = :user.ContactId];

        String customerId;
        Account selectedAccount = Dal_BaseController.getUserSelectedLocation();

        customerId = selectedAccount.DW_ID__c;

        Account acc = [SELECT Id,SSC__r.DW_ID__c FROM Account WHERE Id = :selectedAccount.Id];

        DT_Cart__c orderCart = new DT_Cart__c();
        List<DT_Cart_Product__c>orderProduct = new List<DT_Cart_Product__c>();

        if (orderCartList.size() != null && !String.isBlank(orderCartList[0].Id)) {
            orderCart = orderCartList[0];
        }

        if (orderProductList.size() > 0 && orderProductList.size() != null) {
            orderProduct = orderProductList;
        }

        Dal_OrderCreateService.Endpoint1 orderCreate = new Dal_OrderCreateService.Endpoint1();

        Map<String, List<DT_Cart_Product__c>> productMap = new Map<String, List<DT_Cart_Product__c>>();
        Map<String, String> fulfillmentTypeMap = new Map<String, String>();

        for (DT_Cart_Product__c product : orderProduct) {
            if (product.SSC__r.SAP_Plant__c != null) {
                if (!productMap.containsKey(product.SSC__r.SAP_Plant__c)) {
                    productMap.put(product.SSC__r.SAP_Plant__c, new List<DT_Cart_Product__c>());
                    fulfillmentTypeMap.put(product.SSC__r.SAP_Plant__c, product.Fulfillment_Method__c);
                }
                productMap.get(product.SSC__r.SAP_Plant__c).add(product);
            }

        }

        Dal_OrderCreateDataContract.Address accAddress = new Dal_OrderCreateDataContract.Address();
        accAddress.City = orderCart.Cart_Account__r.BillingCity;
        accAddress.Name = orderCart.Cart_Account__r.Name;
        accAddress.Line1 = orderCart.Cart_Account__r.BillingStreet;
        accAddress.Line2 = '';
        accAddress.Line3 = '';
        accAddress.Name2 = '';
        accAddress.PostalCode = orderCart.Cart_Account__r.BillingPostalCode;
        accAddress.StateProvince = orderCart.Cart_Account__r.BillingState;
        accAddress.Country = orderCart.Cart_Account__r.BillingCountry;

        // For ShipToAddress
        Dal_OrderCreateDataContract.Address address = new Dal_OrderCreateDataContract.Address();
        String scheduleType ;

        Peak_Response peakResponse;
        List<Peak_Response> peakResponselist = new List<Peak_Response>();
        System.debug('fulfillmentTypeMap----'+fulfillmentTypeMap);
        for (String type : fulfillmentTypeMap.keySet()) {
            System.debug('type----'+type);
            peakResponse = new Peak_Response();

            if (fulfillmentTypeMap.get(type).equalsIgnoreCase(SCHEDULE_TYPE)) {
                System.debug('type----'+SCHEDULE_TYPE);
                scheduleType = SCHEDULE_TYPE;
                address.City = productMap.get(type)[0].Shipping_City__c;
                address.Name = productMap.get(type)[0].Shipping_Name__c;
                address.Line1 = productMap.get(type)[0].Shipping_Street__c;
                address.Line2 = '';
                address.Line3 = '';
                address.Name2 = ''; // get the saved address name from DT order
                address.PostalCode = productMap.get(type)[0].Shipping_ZIP_Code__c;
                address.StateProvince = productMap.get(type)[0].Shipping_State__c;
                address.Country = productMap.get(type)[0].Shipping_Country__c;
            } else {
                System.debug('----Pickup'+type);
                scheduleType = PICKUP;
                address.City = productMap.get(type)[0].SSC__r.City__c;
                address.Name = productMap.get(type)[0].SSC__r.Name;
                address.Line1 = productMap.get(type)[0].SSC__r.Street_Address__c;
                address.Line2 = '';
                address.Line3 = '';
                address.Name2 = ''; // get the saved address name from DT order
                address.PostalCode = productMap.get(type)[0].SSC__r.Zip_Code__c;
                address.StateProvince = productMap.get(type)[0].SSC__r.State__c ;
                address.Country = productMap.get(type)[0].SSC__r.Country__c;
            }

            // For ShipToAddress & Account
            Dal_OrderCreateDataContract.Contact contact = new Dal_OrderCreateDataContract.Contact();
            contact.EMail = user.Email;
            contact.FirstName = orderCart.Contact_Name__c;
            contact.LastName = '';
            contact.Phone = orderCart.Contact_Number__c;
            contact.Fax = '';

            // For Request
            Dal_OrderCreateDataContract.DocumentOptions documentOptions = new Dal_OrderCreateDataContract.DocumentOptions();
            documentOptions.PlantIdentifierType = '';
            documentOptions.UOM_CodeSet = Dal_Constants.LEGACY;

            // For Account Detail
            Dal_OrderCreateDataContract.Account account = new Dal_OrderCreateDataContract.Account();
            account.Address = accAddress;
            account.Contact = contact;
            account.Division = '';
            account.LegacyCustomer = customerId;
            //account.SAP_Customer = '';
            account.SalesOrganization = productMap.get(type)[0].SSC__r.DW_ID__c;
            System.debug('CustomerId----> ' + customerId);
            System.debug('SalesOrganization----> ' + account.SalesOrganization);

            // For Fulfilment
            Dal_OrderCreateDataContract.Carrier carrier = new Dal_OrderCreateDataContract.Carrier();
            carrier.CustomerAccountWithCarrier = '';
            //store the mapping in Dal constatnd and then send the code instead of pick list value
            carrier.SCAC = '';


            // For Fulfilment
            Dal_OrderCreateDataContract.ShipToAddress shipToAddress = new Dal_OrderCreateDataContract.ShipToAddress();
            shipToAddress.Address = address;
            shipToAddress.Contact = contact;

            if (scheduleType.equalsIgnoreCase(SCHEDULE_TYPE)) {
                shipToAddress.SameAsAccount = 'Y';
            } else {
                shipToAddress.SameAsAccount = 'N';
            }

            // For SalesOrderHeader
            Dal_OrderCreateDataContract.Fulfilment fulfilment = new Dal_OrderCreateDataContract.Fulfilment();
            //fulfilment.Carrier = carrier;
            fulfilment.FreightTerms = '';
            fulfilment.ShipMode = 'TL';
            fulfilment.ShipComplete = 'N';
            fulfilment.ShipToAddress = shipToAddress;
            if (scheduleType.equalsIgnoreCase(SCHEDULE_TYPE)) {
                fulfilment.Method = 'SHP' ;
            } else {
                fulfilment.Method = 'PICK';
            }

            // For List of reference
            Dal_OrderCreateDataContract.Reference reference = new Dal_OrderCreateDataContract.Reference();
            reference.Qualifier = QUALIFIER_VAL;
            reference.Value = orderCart.PO__c;

            // For ArrayOfReference
            List<Dal_OrderCreateDataContract.Reference> referenceList = new List<Dal_OrderCreateDataContract.Reference>();
            referenceList.add(reference);

            // For SalesOrderHeader
            Dal_OrderCreateDataContract.ArrayOfReference references = new Dal_OrderCreateDataContract.ArrayOfReference();
            references.Reference = referenceList;

            Dal_OrderCreateDataContract.Note note = new Dal_OrderCreateDataContract.Note();
            note.Text = orderCart.Special_Instructions__c;
            note.Qualifier = SPECIAL_INSTRUCTION;

            List<Dal_OrderCreateDataContract.Note> noteList = new List<Dal_OrderCreateDataContract.Note>();
            noteList.add(note);

            Dal_OrderCreateDataContract.ArrayOfNote notes = new Dal_OrderCreateDataContract.ArrayOfNote();
            notes.Note = noteList;

            // For DalTileSalesOrder
            Dal_OrderCreateDataContract.SalesOrderHeader salesOrderHeader = new Dal_OrderCreateDataContract.SalesOrderHeader();
            salesOrderHeader.Account = account;
            //salesOrderHeader.CreatedByUser = '';
            //salesOrderHeader.CreatedByUser_Id_Type = '';
            salesOrderHeader.CreatedTime = System.now();
            salesOrderHeader.CreatedVia = CREATEDVIA;
            salesOrderHeader.DocumentOptions = documentOptions;
            salesOrderHeader.Fulfilment = fulfilment;
            salesOrderHeader.HostSystem = HOST_SYSTEM;
            salesOrderHeader.JobName = orderCart.Job_Name__c;
            salesOrderHeader.References = references;
            salesOrderHeader.Notes = notes;
            salesOrderHeader.RequestedShipDate = System.now() ;
            SalesOrderHeader.SalesOrderType = ORDER_TYPE;
            salesOrderHeader.UpdatedTime = System.now();//orderCart.LastModifiedDate;
            salesOrderHeader.TaxExemptionExpDate = String.valueOf(orderCart.Job_Name_Expiration__c);//'2019-01-26T00:00:00';
            salesOrderHeader.TaxExemptionCertID = orderCart.Job_Name_Certificate_Id__c;
            salesOrderHeader.TaxExemptionInd = orderCart.Tax_Exempt__c == true ? 'Y' : 'N' ;
            salesOrderHeader.NationalAccountCode = orderCart.National_Account__r.NA_ID__c	;

            //salesOrderHeader.OrderPlant = '' ;


            Decimal totalWeight = 0;

            // For ArrayOfSalesOrderLine
            List<Dal_OrderCreateDataContract.SalesOrderLine> salesOrderLineList = new List<Dal_OrderCreateDataContract.SalesOrderLine>();

            if (productMap.get(type).size() > 0 && productMap.get(type).size() != null) {


                Integer SalesOrderLineNumber = 0;

                for (DT_Cart_Product__c product : productMap.get(type)) {

                    SalesOrderLineNumber++;
                    System.debug('OrderNumber------>' + SalesOrderLineNumber);

                    Dal_GetPriceManager.Dal_GetPriceWrapper priceWrapper = priceMap.get(product.Product__r.DW_ID__c);
                    if (priceWrapper != null) {

                        Dal_ConversionCalculatorManager calculatorManager = new Dal_ConversionCalculatorManager(product.Product__r.DW_ID__c,product.UOM__c,String.valueOf(product.Quantity__c));
                        List<Dal_ConversionCalculatorManager.CalculatorWrapper> calculatorWrappers = calculatorManager.getConversionResult();

                        Dal_OrderCreateDataContract.Charge Charge = new Dal_OrderCreateDataContract.Charge();
                        Charge.ChargeId = CHARGE_ID_VALUE;
                        Charge.ChargeRate = priceWrapper.EnergySurchargeFactor;
                        Charge.ChargeValue = priceWrapper.ExtendedEnergySurCharge;

                        // For ArrayOfReference
                        List<Dal_OrderCreateDataContract.Charge> chargeList = new List<Dal_OrderCreateDataContract.Charge>();
                        chargeList.add(Charge);

                        Dal_OrderCreateDataContract.ArrayOfCharge Charges = new Dal_OrderCreateDataContract.ArrayOfCharge();
                        Charges.Charge = chargeList;

                        // For SalesOrderLine
                        Dal_OrderCreateDataContract.Price price = new Dal_OrderCreateDataContract.Price();
                        price.DiscountCode = priceWrapper.discountCode;
                        price.DiscountCodeApplied = priceWrapper.discountCodeApplied;
                        price.DiscountFactor = priceWrapper.discountFactor;
                        price.PriceList_UnitPricingUOM = priceWrapper.pricingUOM_ListPrice;
                        price.PriceNet_UnitPricingUOM = priceWrapper.pricingUOM_NetPrice;
                        price.PriceNet_Extended = priceWrapper.extendedNetPrice;
                        price.PricingUOM = priceWrapper.pricingUOM; // From Cart

                        // For List of SalesOrderLine
                        Dal_OrderCreateDataContract.SalesOrderLine salesOrderLine = new Dal_OrderCreateDataContract.SalesOrderLine();
                        salesOrderLine.CostExtended = priceWrapper.extendedListPrice;
                        salesOrderLine.LastActualShipDate = System.now();
                        salesOrderLine.Material = priceWrapper.materialId; //product.Product__r.DW_ID__c;
                        salesOrderLine.Price = price;
                        salesOrderLine.PromisedShipDate = System.now();
                        salesOrderLine.Quantity = priceWrapper.quantity; //product.Quantity__c;
                        salesOrderLine.QuantityInLegacyBaseUOM = 1;
                        salesOrderLine.RequestedShipDate = System.now();
                        salesOrderLine.SalesOrderLineNo = SalesOrderLineNumber;
                        salesOrderLine.SupplyPlant = product.SSC__r.SAP_Plant__c;
                        System.debug('Supply plant-->' + product.SSC__r.SAP_Plant__c);
                        salesOrderLine.UOM = priceWrapper.uom; //priceWrapper.pricingUOM;
                        salesOrderLine.WeightExtended = Decimal.valueOf(priceWrapper.weightForPricedQty);
                        salesOrderLine.PriceRecord = '';
                        salesOrderLine.Charges = Charges;
                        salesOrderLineList.add(salesOrderLine);
                        System.debug('salesOrderLine------>' + salesOrderLine);

                    }else {
                        Dal_OrderCreateDataContract.Charge Charge = new Dal_OrderCreateDataContract.Charge();
                        Charge.ChargeId = CHARGE_ID_VALUE;//String.valueOf(priceWrapper.ExtendedEnergySurCharge);
                        Charge.ChargeRate = 0; //priceWrapper.EnergySurchargeFactor;
                        Charge.ChargeValue = 0;//priceWrapper.ExtendedEnergySurCharge;

                        // For ArrayOfReference
                        List<Dal_OrderCreateDataContract.Charge> chargeList = new List<Dal_OrderCreateDataContract.Charge>();
                        chargeList.add(Charge);

                        Dal_OrderCreateDataContract.ArrayOfCharge Charges = new Dal_OrderCreateDataContract.ArrayOfCharge();
                        Charges.Charge = chargeList;

                        // For SalesOrderLine
                        Dal_OrderCreateDataContract.Price price = new Dal_OrderCreateDataContract.Price();
                        price.DiscountCode = '';
                        price.DiscountCodeApplied = '';
                        price.DiscountFactor = 0; //priceWrapper.discountFactor;
                        price.PriceList_UnitPricingUOM = 0;//priceWrapper.pricingUOM_ListPrice;
                        //price.PriceNet_UnitPricingUOM = 0;//priceWrapper.pricingUOM_NetPrice;
                        price.PriceNet_Extended = 0; //priceWrapper.extendedNetPrice;
                        price.PricingUOM = ''; //priceWrapper.pricingUOM; // From Cart

                        // For List of SalesOrderLine
                        Dal_OrderCreateDataContract.SalesOrderLine salesOrderLine = new Dal_OrderCreateDataContract.SalesOrderLine();
                        salesOrderLine.CostExtended = 0;//priceWrapper.extendedListPrice;
                        salesOrderLine.LastActualShipDate = System.now();
                        salesOrderLine.Material = product.Product__r.DW_ID__c;
                        salesOrderLine.Price = price;
                        salesOrderLine.PromisedShipDate = System.now();
                        salesOrderLine.Quantity = product.Quantity__c;
                        salesOrderLine.RequestedShipDate = System.now();
                        salesOrderLine.SalesOrderLineNo = SalesOrderLineNumber;
                        salesOrderLine.SupplyPlant = product.SSC__r.SAP_Plant__c;
                        System.debug('Supply plant-->' + product.SSC__r.SAP_Plant__c);
                        salesOrderLine.UOM = product.UOM__c;//priceWrapper.pricingUOM;
                        salesOrderLine.WeightExtended = 0;//Decimal.valueOf(priceWrapper.weightForPricedQty);
                        salesOrderLine.PriceRecord = '';
                        salesOrderLine.Charges = Charges;
                        salesOrderLineList.add(salesOrderLine);
                        System.debug('salesOrderLine------>' + salesOrderLine);
                    }
                }

            }

            // For Request
            Dal_OrderCreateDataContract.ArrayOfSalesOrderLine salesOrderLines = new Dal_OrderCreateDataContract.ArrayOfSalesOrderLine();
            salesOrderLines.SalesOrderLine = salesOrderLineList;


            // For RequestItem
            Dal_OrderCreateDataContract.DalTileSalesOrder dalTileSalesOrder = new Dal_OrderCreateDataContract.DalTileSalesOrder();
            dalTileSalesOrder.SalesOrderHeader = salesOrderHeader;
            dalTileSalesOrder.SalesOrderLines = salesOrderLines;
            // dalTileSalesOrder.Totals = totals;

            // For List of RequestItem
            Dal_OrderCreateDataContract.RequestItem requestItem = new Dal_OrderCreateDataContract.RequestItem();
            requestItem.DalTileSalesOrder = dalTileSalesOrder;

            // For ArrayOfRequestItem
            List<Dal_OrderCreateDataContract.RequestItem> requestItemList = new List<Dal_OrderCreateDataContract.RequestItem>();
            requestItemList.add(requestItem);

            // For Request
            Dal_OrderCreateDataContract.ArrayOfRequestItem requestItems = new Dal_OrderCreateDataContract.ArrayOfRequestItem();
            requestItems.RequestItem = requestItemList;


            // Main Request
            Dal_OrderCreateDataContract.Request request = new Dal_OrderCreateDataContract.Request();
            request.DocumentOptions = documentOptions ;

            request.RequestItems = requestItems;

            system.debug('Request is ' + request);

            try {
                Dal_OrderCreateDataContract.Response response = orderCreate.CreateSalesOrder(request);
                System.debug('RESPONSE ---->' + response);
                System.debug('SalesOrder ---->' + response.ResponseItems.ResponseItem[0].DalTileSalesOrder.SalesOrderHeader.SalesOrder);
                System.debug('RESPONSE STATUS---->' + response.Result.Status);
                System.debug('RESPONSE StatusDesc---->' + response.Result.StatusDesc);
                //System.debug('RESPONSE sales Order Number--->'+response.ResponseItems.ResponseItem[0].DalTileSalesOrder.SalesOrderHeader.SalesOrder);


                if (response.Result.Status == 'OK') {
                    peakResponse.success = true;
                    peakResponse.messages.add(response.ResponseItems.ResponseItem[0].DalTileSalesOrder.SalesOrderHeader.SalesOrder);
                } else {
                    peakResponse.success = false;
                }

                System.debug('Status------->' + peakResponse.success);
                System.debug('Message------->' + peakResponse.messages);
            } catch (Exception e) {
                System.debug('Exception Occurs--->' + e.getMessage());
            }
            peakResponselist.add(peakResponse);
        }
        return peakResponselist;
    }

}