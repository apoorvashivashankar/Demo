/**
 * Created by 7Summits on 4/4/18. 
 */
public  with sharing class Dal_TimePhase_ATP_Manager {
    
    //Global Variables
    Public String SKU;
    public String UOM;
    public String CodeSet;
    public String SupplyplantId;
    public String SupplyplantType;
    
    /*
	* Method Name: Dal_TimePhase_ATP_Manager (Constructor)
	* Description: Purpose to set values to global variables
	* @param: Stock keeping unit,Quantity,Unit of messure,SOS,ReqShipDate,PriceRecord.
	* @return Not Any 
	*/
    public Dal_TimePhase_ATP_Manager(String SKU,String CodeSet,String UOM,String SupplyplantId,String SupplyplantType){
        this.SKU = SKU;
        this.CodeSet = CodeSet;
        this.UOM = UOM; 
        this.SupplyplantId = SupplyplantId;
        this.SupplyplantType = SupplyplantType;
    }

    /*
	* Method Name: getATP_By_TimePhase
	* Description: Purpose to get values to global variables
	* @param: Stock keeping unit,Quantity,Unit of messure,SOS,ReqShipDate,PriceRecord.
	* @return Not Any 
	*/    
    public List<ATP_TimePhase_Wrapper> getATP_By_TimePhase(){
        
        //Setting endpoint 
        Dal_Inventory_DataManager.PubEndpoint ATP = new  Dal_Inventory_DataManager.PubEndpoint();
        
        Dal_Inventory_DataController.DocumentOptions documentOptions = new Dal_Inventory_DataController.DocumentOptions();
        documentOptions.UOM_CodeSet = CodeSet;
        
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
        requestedItem.SupplyPlant = supplyPlant ;

        system.debug('requestedItem '+requestedItem);

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
		System.debug('Request------>'+request);
       	Dal_Inventory_DataController.InventoryResponse response = new Dal_Inventory_DataController.InventoryResponse();
        System.debug('Response------>'+response);
        response = ATP.GetInventoryAtLocation_TimePhased(request);
        
        //parse the response and initialise a wrapper obj to return to lightning controller
        Dal_Inventory_DataController.ArrayOfResponseItem reslist = response.ResponseItems;
      	
        List<ATP_TimePhase_Wrapper> atpWrapperList = new List<ATP_TimePhase_Wrapper>();
          
       
            for(Dal_Inventory_DataController.ResponseItem res : reslist.ResponseItem){
                ATP_TimePhase_Wrapper atpWrapper = new ATP_TimePhase_Wrapper();
              	system.debug('2---'+res.AvailableQty);
                system.debug('3---'+res.ATP_DateAtSupplyPlant);
                system.debug('4---'+res.AvailableIncrementalQty);
                system.debug('4---'+res.SupplyType);
                atpWrapper.dateValue = res.ATP_DateAtSupplyPlant;
                atpWrapper.cumulativeQTY = res.AvailableQty;
                atpWrapper.atpQTY = res.AvailableIncrementalQty;
                atpWrapper.instock = 'No';
                try {
                    if(Decimal.valueOf(res.AvailableQty) > 0 && Decimal.valueOf(res.AvailableIncrementalQty) > 0 && res.SupplyType == 'I') {
                        atpWrapper.instock = 'Yes';
                    }
                } catch(Exception e) {
                    System.debug('Exception caught and ignored: '+e);
                }

                atpWrapperList.add(atpWrapper);
            }
        return atpWrapperList;            
    }
   
    //Wrapper class to for making resopnse available to lightning controller
    public class ATP_TimePhase_Wrapper{
        @AuraEnabled public String dateValue{get;set;}
        @AuraEnabled public String cumulativeQTY{get;set;}
        @AuraEnabled public String atpQTY{get;set;}
        @AuraEnabled public String instock{get;set;}
    }
}