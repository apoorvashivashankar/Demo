public class Dal_Temp_GetPrice {
	
   	// global variables
    public String PartyId;
    public String Material;
    public String PricedQuantity;
    public String PricedQuantityUOM;
    public String SupplyPlant;
    
    // Constructor
    public Dal_Temp_GetPrice(String PartyId,String Material,String PricedQuantity,String PricedQuantityUOM,String SupplyPlant)
    {
        this.PartyId = PartyId;
        this.Material = Material;
        this.PricedQuantity = PricedQuantity;
        this.PricedQuantityUOM = PricedQuantityUOM;
        this.SupplyPlant = SupplyPlant;
    }
    
    /*
	* Method Name: getPrice
	* Description: Purpose to get Price data from webservice .
	* @param: Not Any
	* @return List of Wrapper Class object. 
	*/
    public List<Dal_GetPriceWrapper> getPrice()
    {
        Dal_GetPriceDataService.Endpoint1 priceService = new Dal_GetPriceDataService.Endpoint1();
      
        // setting codes set for request
        Dal_GetPriceDataContext.ServiceOptions serviceOptions = new Dal_GetPriceDataContext.ServiceOptions();
        serviceOptions.UOM_CodeSet = 'Legacy';
        
        // setting party Id & Type for request
        Dal_GetPriceDataContext.ForParty forParty = new Dal_GetPriceDataContext.ForParty();
        forParty.PartyId_Type = 'LegacyCustomer';
        forParty.PartyId = '008082001';
        
        // creating list of items which needs to request a Price webservice.
        Dal_GetPriceDataContext.Item requestedItem = new Dal_GetPriceDataContext.Item();
        requestedItem.Material = 'A88912242P6';
        requestedItem.PricedQuantity = 105.00;
        requestedItem.PricedQuantityUOM = 'PC';
     //   requestedItem.SupplyPlant = '4101';
        system.debug('requestedItem--'+requestedItem);   
        
        // list of all items
        List<Dal_GetPriceDataContext.Item> items = new List<Dal_GetPriceDataContext.Item>();
        items.add(requestedItem);
        
        //Array of all List of Items
        Dal_GetPriceDataContext.ArrayOfItem arrayOfItems = new Dal_GetPriceDataContext.ArrayOfItem();
        arrayOfItems.Item = items ;
        
        // Combining all data needs to be request  
        Dal_GetPriceDataContext.DaltilePriceRequest request = new Dal_GetPriceDataContext.DaltilePriceRequest();
        request.ServiceOptions = serviceOptions;
     //   request.Plant = '';
        request.ForParty = forParty;
        request.Items = arrayOfItems;
        system.debug('Final Request--'+request);
        
        // calling method for WebService Callout
        Dal_GetPriceDataContext.DaltilePriceResponse response = priceService.GetPrice(request);
        system.debug('Response of Data---->'+response);   
        
        // Creating List for wrapper Class to sending data back to front end controller.
        List<Dal_GetPriceWrapper> getPriceWrapperList = new List<Dal_GetPriceWrapper>();
        Dal_GetPriceWrapper priceWrapper = new Dal_GetPriceWrapper();
        
        priceWrapper.PricedUOM_ListPrice = '';
		priceWrapper.PricedUOM_NetPrice = '';
        priceWrapper.PricedUOM_EnergySurcharge = '';
        priceWrapper.PriceMethod = '';
		priceWrapper.DiscountFactor = '';
        priceWrapper.PricingUOM_ISO = '';
        priceWrapper.PricingUOM = '';
        priceWrapper.PricingUOM_ListPrice = '';
        priceWrapper.PricingUOM_NetPrice = '';
        priceWrapper.PricingUOM_EnergySurcharge = '';
        priceWrapper.ExtendedListPrice = '';
        priceWrapper.ExtendedNetPrice = '';
        priceWrapper.ExtendedEnergySurCharge = '';
        priceWrapper.EnergySurchargeFactor = '';
        priceWrapper.DiscountCodeApplied = '';
        priceWrapper.PriceCode = '';
        
        getPriceWrapperList.add(priceWrapper);
        
      //  System
        return getPriceWrapperList;
    }
    
    // Wrapper class for packing response data to send it on front end.
    public Class Dal_GetPriceWrapper
    {
        public string PricedUOM_ListPrice;
		public string PricedUOM_NetPrice;
        public string PricedUOM_EnergySurcharge;
        public string PriceMethod;
		public String DiscountFactor;
        public String PricingUOM_ISO;
        public String PricingUOM;
        public String PricingUOM_ListPrice;
        public String PricingUOM_NetPrice;
        public String PricingUOM_EnergySurcharge;
        public String ExtendedListPrice;
        public String ExtendedNetPrice;
        public String ExtendedEnergySurCharge;
        public String EnergySurchargeFactor;
        public String DiscountCodeApplied;
        public String PriceCode;
       
    }

}