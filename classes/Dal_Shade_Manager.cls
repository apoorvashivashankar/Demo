/**
 * Created by 7Summits on 4/4/18. 
 */
public with sharing class Dal_Shade_Manager {

    Public String SKU;
    public String UOM;
    public String Quantity;
    public String SOS;
    public String ReqShipDate;
    public String PriceRecord;
    public String SupplyplantId;
    public String SupplyplantType;
    
    /*
	* Method Name: Dal_Shade_Manager (Constructor)
	* Description: Purpose to set values to global variables
	* @param: Stock keeping unit,Quantity,Unit of messure,ReqShipDate,PriceRecord.
	* @return Not Any 
	*/
    public Dal_Shade_Manager(String SKU,String Quantity,String UOM,String ReqShipDate,String PriceRecord,String SupplyplantId,String SupplyplantType){
        this.SKU = SKU;
        this.UOM = UOM;
        this.Quantity = Quantity;
        this.ReqShipDate = ReqShipDate;
        this.PriceRecord = PriceRecord;
         this.SupplyplantId = SupplyplantId;
        this.SupplyplantType = SupplyplantType;
    }
     public List<ShadeWrapper> getByShade(){

         //Setting endpoint data
        Dal_Inventory_DataManager.PubEndpoint Shade = new  Dal_Inventory_DataManager.PubEndpoint();

        Dal_Inventory_DataController.DocumentOptions documentOptions = new Dal_Inventory_DataController.DocumentOptions();
        documentOptions.UOM_CodeSet = Dal_Constants.LEGACY;

        Dal_Inventory_DataController.Destination destination = new  Dal_Inventory_DataController.Destination();
        destination.DestinationIdType = '';
        destination.DestinationIdValue = '';

        Dal_Inventory_DataController.SupplyPlant supplyPlant = new Dal_Inventory_DataController.SupplyPlant();
        supplyPlant.SupplyPlantIdType = SupplyplantType;
        supplyPlant.SupplyPlantIdValue = SupplyplantId;

        //Setting request item for calling webservice
        Dal_Inventory_DataController.RequestItem requestedItem = new Dal_Inventory_DataController.RequestItem();
        requestedItem.Material = SKU;
        requestedItem.QtyUOM = UOM;
      	requestedItem.RequestedQty = Quantity;
        requestedItem.PriceRecord = '';
        requestedItem.PricePlant = '';
        requestedItem.FromDateAtSupplyPlant = '';
        requestedItem.SupplyPlant = supplyPlant ;

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

         Dal_Inventory_DataController.InventoryResponse response = new Dal_Inventory_DataController.InventoryResponse();
         response = Shade.GetInventoryAtLocation_ByShade(request);
         System.debug('Shade Response------>'+response);

         //parse the response and initialise a wrapper obj to return to lightning controller
         Dal_Inventory_DataController.ArrayOfResponseItem reslist = response.ResponseItems;

         List<ShadeWrapper> shadeWrapperList = new List<ShadeWrapper>();
        	

            for(Dal_Inventory_DataController.ResponseItem res : reslist.ResponseItem){
                ShadeWrapper shadeWrapper = new ShadeWrapper();
                shadeWrapper.onHandQty = res.OnHandQty;
                shadeWrapper.availableQty = res.AvailableQty;
                shadeWrapper.material = res.Material;
                shadeWrapper.shade = res.Shade;
                shadeWrapper.supplyPlant = res.SupplyPlant.SupplyPlantIdValue;
                shadeWrapper.UOM = res.QtyUOM;
            	system.debug('1--'+res.Shade);
             	system.debug('2---'+res.AvailableQty);
                system.debug('3---'+res.ATP_DateAtSupplyPlant);

                shadeWrapperList.add(shadeWrapper);
            }
            system.debug('shadeWrapperList------->'+shadeWrapperList);
         return shadeWrapperList;
     }
    
    //Wrapper class to for making resopnse available to lightning controller
     public class ShadeWrapper{
         @AuraEnabled
        public String onHandQty{get;set;}
         @AuraEnabled
        public String availableQty{get;set;}
         @AuraEnabled
        public String material{get;set;}
         @AuraEnabled
        public String shade{get;set;}
         @AuraEnabled
        public String supplyPlant{get;set;}
         @AuraEnabled
        public String UOM{get;set;}
      
    }
}