/**
 * Created by 7Summits on 4/4/18. 
 */
public  without sharing  class Dal_AvailabilityDate_Price_ATP_Manager { 

    //Global Variables 
    Public String SKU;
    public String UOM;
    public String Quantity;
    public String SOS;
    public String ReqShipDate;
    public String PriceRecord;
    public static String customerId;

    /*
	* Method Name: Dal_AvailabilityDate_Price_ATP_Manager (Constructor) 
	* Description: Purpose to set values to global variables
	* @param: Stock keeping unit,Quantity,Unit of messure,ReqShipDate,PriceRecord.
	* @return Not Any 
	*/
    public Dal_AvailabilityDate_Price_ATP_Manager(String SKU,String Quantity,String UOM,String ReqShipDate,String PriceRecord){
        this.SKU = SKU;
        this.UOM = UOM;
        this.Quantity = Quantity;
        this.ReqShipDate = ReqShipDate;
        this.PriceRecord = PriceRecord;
    }

    /*
	* Method Name: getATP_By_AvailibilityDate
	* Description: Purpose to get data from webservice by AvailibilityDate.
	* @param: Not Any
	* @return Object of Wrapper Class. 
	*/
    public List<ATP_AvailableDate_Wrapper> getATP_By_AvailibilityDate(){
    	
    	//getting customer id from utility class 'Dal_BaseController'
        Account selectedAccount = Dal_BaseController.getUserSelectedLocation();
        customerId = selectedAccount.DW_ID__c;
        

        //Setting endpoint 
        Dal_Inventory_DataManager.PubEndpoint availibiltyManager = new  Dal_Inventory_DataManager.PubEndpoint();
        
        Dal_Inventory_DataController.DocumentOptions documentOptions = new Dal_Inventory_DataController.DocumentOptions();
        documentOptions.UOM_CodeSet = Dal_Constants.LEGACY; 

        Dal_Inventory_DataController.Destination destination = new  Dal_Inventory_DataController.Destination();
        destination.DestinationIdType = Dal_Constants.LEGACY_CUSTOMER_SHIP_TO ;
        destination.DestinationIdValue = customerId;

        //Setting request item for calling webservice
        Dal_Inventory_DataController.RequestItem requestedItem = new Dal_Inventory_DataController.RequestItem();
        requestedItem.Material = SKU;
        requestedItem.QtyUOM = UOM;
      	requestedItem.RequestedQty = Quantity;
        requestedItem.PriceRecord = PriceRecord;
        requestedItem.FromDateAtSupplyPlant = ReqShipDate;

		system.debug('requestedItem--'+requestedItem);

		//putting all request item in list
        List<Dal_Inventory_DataController.RequestItem> Items = new List<Dal_Inventory_DataController.RequestItem>();
        Items.add(requestedItem);

        // creating Array of requested item by putting list of requested item list 
        Dal_Inventory_DataController.ArrayOfRequestItem arrayOfrequestedItem = new Dal_Inventory_DataController.ArrayOfRequestItem();
        arrayOfrequestedItem.RequestItem = Items;
        
        //Setting Request iterms all together
        Dal_Inventory_DataController.InventoryRequest request = new  Dal_Inventory_DataController.InventoryRequest();
     	request.DocumentOptions = documentOptions;
        request.Destination = destination;
        request.RequestItems = arrayOfrequestedItem;
        system.debug('request'+request);
        
        Dal_Inventory_DataController.InventoryResponse response = new Dal_Inventory_DataController.InventoryResponse();
       	response = availibiltyManager.GetInventoryAtSourcesOfSupply_AvailabilityDate_Price(request);
        System.debug('Response------>'+response); 
        
        //parse the response and initialise a wrapper obj to return to lightning controller

        Dal_Inventory_DataController.ArrayOfResponseItem reslist = response.ResponseItems;
      	list<ATP_AvailableDate_Wrapper> atpWrapperList = new List<ATP_AvailableDate_Wrapper>();
        system.debug('Response list size '+reslist.ResponseItem.size());
        if(reslist.ResponseItem.size() > 0)
        {
            for(Dal_Inventory_DataController.ResponseItem res : reslist.ResponseItem)
            {   
                ATP_AvailableDate_Wrapper atpWrapper = new ATP_AvailableDate_Wrapper();
                //6 scenarios
                //follow this rule always, 
                //if primary sp have the quantity on requested date - green
                //if primary sp dont have the quantity on the requested but at latter date - then its yellow scenario
                //if primary sp dont have the quantity at all - Will advise scenario
                //Doc Scenario - #1,5 - green, use sos = 1 and RequestedAdjustedQtyAvailabilityInd = Y and ATP_DateAtSupplyPlant =< Requestedshipdate
                //Doc Scenario - #2,6 - Will Advise, use if SOS = 1 and RequestedAdjustedQtyAvailabilityInd = N
                //Doc Scenario - #3,4 - Yellow, use sos =1 and RequestedAdjustedQtyAvailabilityInd = Y and ATP_DateAtSupplyplant  > RequestedDate
               
                system.debug('SOS_Preference---'+res.SOS_Preference);
            	system.debug('OnHandQty---'+res.OnHandQty);
             	system.debug('AvailableQty_ATP_Date---'+res.AvailableQty_ATP_Date);
                system.debug('ATP_DateAtSupplyPlant---'+res.ATP_DateAtSupplyPlant);
                system.debug('SupplyPlantDesc---'+res.SupplyPlant.SupplyPlantDesc);
                system.debug('PricingUOM_NetPrice---'+res.PricingUOM_NetPrice);
                system.debug('PriceForPricedQty---'+res.PriceForPricedQty); 
                system.debug('RequestedAdjustedQtyAvailabilityInd---'+res.RequestedAdjustedQtyAvailabilityInd);
                system.debug('PricedQuantity--'+res.PricedQuantity);
                system.debug('PricingUOM--'+res.PricingUOM);
                system.debug('ReqShipDate--'+ReqShipDate);

                atpWrapper.onTimeFlag = 'N';

                try {
                    if(Date.valueOf(res.ATP_DateAtSupplyPlant) <= Date.valueOf(ReqShipDate) && res.RequestedAdjustedQtyAvailabilityInd == 'Y' ) {
                        atpWrapper.onTimeFlag = 'Y';
                    }
                } catch(Exception e) {
                    System.debug('Unable to parse dates: '+e);
                }
                atpWrapper.dateAtSupplyPlant = res.ATP_DateAtSupplyPlant;
                atpWrapper.supplyPlant = res.SupplyPlant.SupplyPlantDesc ;
                atpWrapper.SOS = res.SOS_Preference;
                atpWrapper.availableQty = res.AvailableQty_ATP_Date;
                atpWrapper.netPrice = res.PricingUOM_NetPrice;
                atpWrapper.qtyprice = res.PriceForPricedQty;
                atpWrapper.supplyplantType = res.SupplyPlant.SupplyPlantIdType;
                atpWrapper.supplyplantID = res.SupplyPlant.SupplyPlantIdValue;
                atpWrapper.isqtyAvailabe = res.RequestedAdjustedQtyAvailabilityInd;
                atpWrapper.pricedQuantity = res.PricedQuantity;
                atpwrapper.priceduom = res.PricingUOM;
                atpWrapper.extendedWeight = res.WeightForPricedQty; 

                //create wrapper and add to list
                atpWrapperList.add(atpWrapper);
                system.debug('wrapper---'+atpWrapperList);     
            }
        }

        return atpWrapperList;
    }

    //use the wrapper defenition in this class, remove from other process controller class 
    public class ATP_AvailableDate_Wrapper{

        @AuraEnabled public String dateAtSupplyPlant{get;set;}
        @AuraEnabled public String supplyPlant{get;set;}
        @AuraEnabled public String SOS{get;set;}
        @AuraEnabled public String availableQty{get;set;} 
        @AuraEnabled public String onTimeFlag{get;set;}
     	@AuraEnabled public String netPrice{get;set;}
        @AuraEnabled public String qtyprice{get;set;}
        @AuraEnabled public String supplyplantType{get;set;}
        @AuraEnabled public String supplyplantID{get;set;}
		@AuraEnabled public String isqtyAvailabe{get;set;}
        @AuraEnabled public String pricedQuantity{get;set;}
        @AuraEnabled public String extendedWeight{get;set;}  
        @AuraEnabled public String priceduom{get;set;}
    }
    
}