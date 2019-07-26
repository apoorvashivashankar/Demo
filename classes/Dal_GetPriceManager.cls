/**
 * Created by 7Summits on 4/18/18. 
 */
public class Dal_GetPriceManager {

   	// global variables
    public String PartyId;
    public String Material;
    public String PricedQuantity;
    public String PricedQuantityUOM;
    public String SupplyPlant;
    public String pricerecord;
    public List<Dal_InventorySearchJSON> inventoryData;
    public List<DAl_SSC_OrderCreateManager.Dal_SSC_OrderCreateWrapper> sscData;
    public Boolean isList = false;
    public Boolean isSSCOrder = false;
    public Boolean forSingle = false;
    public List<DT_Cart_Product__c> cartProducts;
    public Boolean isCartproduct = false;

    // Constructor
    public Dal_GetPriceManager(String material,String pricedQuantity,String pricedQuantityUOM,String supplyPlant, String pricerecord)
    {
        this.Material = material;
        this.PricedQuantity = pricedQuantity;
        this.PricedQuantityUOM = pricedQuantityUOM;
        this.SupplyPlant = supplyPlant;
        this.pricerecord = pricerecord;
        this.forSingle = true;
    }
    public Dal_GetPriceManager(List<Dal_InventorySearchJSON> data)
    {
        inventoryData = data;
        isList = true;
    }
    public Dal_GetPriceManager(List<DAl_SSC_OrderCreateManager.Dal_SSC_OrderCreateWrapper> data)
    {
        sscData = data;
        isSSCOrder = true;
    }
    public Dal_GetPriceManager(List<DT_Cart_Product__c> cartProductData)
    {
        cartProducts = cartProductData;
        isCartproduct = true;
    }

    /*
	* Method Name: getPrice
	* Description: Purpose to get Price data from webservice .
	* @param: Not Any
	* @return List of Wrapper Class object. 
	*/
    public List<Dal_GetPriceWrapper> getPrice()
    {
        System.debug('sscData_isSSCOrder'+sscData+'--------------'+isSSCOrder);
        String customerId; 
        Account selectedAccount = Dal_BaseController.getUserSelectedLocation();
        customerId = selectedAccount.DW_ID__c;
        //customerId = '008082001';
        //Setting Endpoint
        Dal_GetPriceServices.Endpoint1 getPriceService = new Dal_GetPriceServices.Endpoint1();
      
        // setting codes set for request
        Dal_GetPriceCallout.ServiceOptions serviceOptions = new Dal_GetPriceCallout.ServiceOptions();
        serviceOptions.UOM_CodeSet = Dal_Constants.LEGACY ;
        
        // setting party Id & Type for request
        Dal_GetPriceCallout.ForParty forParty = new Dal_GetPriceCallout.ForParty();
        forParty.PartyId_Type = Dal_Constants.LEGACY_CUSTOMER;
        forParty.PartyId = customerId;

        // list of all items
        List<Dal_GetPriceCallout.Item> Items = new List<Dal_GetPriceCallout.Item>();

        if(isList){
            for(Dal_InventorySearchJSON data : inventoryData){
                System.debug('INfor--'+data);
                // creating list of items which needs to request a Price webservice.
                Dal_GetPriceCallout.Item requestedItem = new Dal_GetPriceCallout.Item();
                requestedItem.Material = data.sku; //'0100661P4';//
                requestedItem.PricedQuantity = 1;
                requestedItem.PricedQuantityUOM = data.uom; //'SF';//
                requestedItem.DiscountCode = '';
                requestedItem.SupplyPlant = '';

                Items.add(requestedItem);
            }
            System.debug('requestedItem--'+Items);
        }
        if(forSingle){
            // creating list of items which needs to request a Price webservice.
            Dal_GetPriceCallout.Item requestedItem = new Dal_GetPriceCallout.Item();
            requestedItem.Material = Material;
            requestedItem.PricedQuantity = Decimal.valueof(PricedQuantity);
            requestedItem.PricedQuantityUOM = PricedQuantityUOM;
            requestedItem.DiscountCode = pricerecord;
            requestedItem.SupplyPlant = SupplyPlant;

            Items.add(requestedItem);
            System.debug('requestedItem--'+requestedItem);
        }
        if(isSSCOrder){
            System.debug('sscData--'+sscData);
            if(sscData.size() > 0){
                for(DAl_SSC_OrderCreateManager.Dal_SSC_OrderCreateWrapper sscWrapper: sscData){
                        Dal_GetPriceCallout.Item requestedItem = new Dal_GetPriceCallout.Item();
                        requestedItem.Material = sscWrapper.materialId; //'0100661P4';//
                        requestedItem.PricedQuantity = sscWrapper.pricedQuantity;
                        requestedItem.PricedQuantityUOM = sscWrapper.pricedQuantityUOM; //'SF';//
                        requestedItem.DiscountCode = '';
                        requestedItem.SupplyPlant = sscWrapper.supplyPlant;
                        Items.add(requestedItem);
                }
                System.debug('ItemsForSSC_Order--'+Items); 
            }
        }

        if(isCartproduct){ 
            System.debug('cartProducts--'+cartProducts);
            if(cartProducts.size() > 0){
                for(DT_Cart_Product__c product: cartProducts){
                    Dal_GetPriceCallout.Item requestedItem = new Dal_GetPriceCallout.Item();
                    requestedItem.Material = product.Product__r.DW_ID__c; //'0100661P4';//
                    requestedItem.PricedQuantity = product.Quantity__c;
                    requestedItem.PricedQuantityUOM = product.UOM__c; //'SF';//
                    requestedItem.DiscountCode = '';
                    requestedItem.SupplyPlant = product.SSC__r.SAP_Plant__c;
                    Items.add(requestedItem);
                }
                System.debug('ItemsForCartProduct--'+Items);
            }
        }
        


        
        //Array of all List of Items
        Dal_GetPriceCallout.ArrayOfItem arrayOfItems = new Dal_GetPriceCallout.ArrayOfItem();
        arrayOfItems.Item = Items ;
        
        // Combining all data needs to be request  
        Dal_GetPriceCallout.DaltilePriceRequest request = new Dal_GetPriceCallout.DaltilePriceRequest();
        request.ServiceOptions = serviceOptions;
        request.ForParty = forParty;
        request.Items = arrayOfItems;

        // Creating List for wrapper Class to sending data back to front end controller.
        List<Dal_GetPriceWrapper> getPriceWrapperList = new List<Dal_GetPriceWrapper>();

        try {

            // calling method for WebService Callout
            Dal_GetPriceCallout.DaltilePriceResponse response = getPriceService.GetPrice(request);
            system.debug('Response of Data---->' + response);


            for (Dal_GetPriceCallout.ResponseItem responseItem : response.Items.Item) {
                Dal_GetPriceWrapper priceWrapper = new Dal_GetPriceWrapper();
                priceWrapper.TotalPrice = responseItem.ExtendedNetPrice;
                priceWrapper.priceperUnit = responseItem.PricedUOM_NetPrice;
                priceWrapper.uom = responseItem.PricedQuantityUOM;
                priceWrapper.pricingUOM_NetPrice = responseItem.PricingUOM_NetPrice;
                priceWrapper.pricingUOM = responseItem.PricingUOM;
                priceWrapper.sku = responseItem.Material;
                priceWrapper.ExtendedEnergySurCharge = responseItem.ExtendedEnergySurCharge;
                priceWrapper.EnergySurchargeFactor = responseItem.EnergySurchargeFactor;
                priceWrapper.weightForPricedQty = responseItem.WeightForPricedQty;
                priceWrapper.extendedListPrice = responseItem.ExtendedListPrice;
                priceWrapper.extendedNetPrice = responseItem.ExtendedNetPrice;
                priceWrapper.pricingUOM_ListPrice = responseItem.PricingUOM_ListPrice;
                priceWrapper.discountFactor = responseItem.DiscountFactor;

                priceWrapper.materialId = responseItem.Material;
                priceWrapper.quantity = responseItem.PricedQuantity;
                priceWrapper.discountCode = responseItem.PriceMethod;
                priceWrapper.discountCodeApplied = responseItem.DiscountCodeApplied;
                getPriceWrapperList.add(priceWrapper);

            }
            System.debug('Wrapper List ---- >' + getPriceWrapperList);
        }catch (Exception e){
            System.debug('Error in Price--->'+e.getMessage());
        }

        return getPriceWrapperList;
    }
    
    // Wrapper class for packing response data to send it on front end.
    public class Dal_GetPriceWrapper
    {
        @AuraEnabled public String sku;
        @AuraEnabled public Decimal totalPrice;
		@AuraEnabled public Decimal priceperUnit;
        @AuraEnabled public String uom;
        @AuraEnabled public List<String> sos;
		@AuraEnabled public String pricingUOM;
        @AuraEnabled public Decimal pricingUOM_NetPrice;
        @AuraEnabled public Decimal ExtendedEnergySurCharge;
        @AuraEnabled public Decimal EnergySurchargeFactor;
        @AuraEnabled public String weightForPricedQty;
        @AuraEnabled public Decimal extendedListPrice;
        @AuraEnabled public Decimal extendedNetPrice;
        @AuraEnabled public Decimal pricingUOM_ListPrice;
        @AuraEnabled public Decimal discountFactor;

        @AuraEnabled public String materialId;
        @AuraEnabled public Decimal quantity;
        @AuraEnabled public String discountCode;
        @AuraEnabled public String discountCodeApplied;

    }
}