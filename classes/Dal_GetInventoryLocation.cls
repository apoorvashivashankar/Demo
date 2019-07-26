/**
 * Created by Yadav on 8/13/2018.
 */

public with sharing class Dal_GetInventoryLocation {


    //Global Variables
    public String SKU;
    public String UOM;
    public String SupplyPlantIdValue;
    public static String customerId;
    public static List<Dal_OrderSampleManager.OrderLocationWrapper> wrapper;
    public static List<Dal_InventorySearchJSON> inventoryData;
    public static List<DT_Cart_Product__c> inventoryCartData;
    public static Boolean inventory = false;
    public static Boolean cart = false;
    public static Boolean single = false;

    /*
   * Method Name: Dal_GetInventoryLocation (Constructor)
   * Description: Purpose to set values to global variables
   * @param: Stock keeping unit,Unit of messure,SupplyPlantIdValue.
   * @return Not Any
   */
    public Dal_GetInventoryLocation(List<Dal_OrderSampleManager.OrderLocationWrapper> wrapperLst) {
        wrapper = wrapperLst;
        single = true;
    }
    public Dal_GetInventoryLocation(List<Dal_InventorySearchJSON> data ) {
        inventoryData = data;
        inventory = true;
    }
    public Dal_GetInventoryLocation(List<DT_Cart_Product__c> data ) {
        inventoryCartData = data;
        cart = true;
    }

    /*
   * Method Name: getLocationWithMaterial
   * Description: Purpose to get data from webservice by Location.
   * @param: Not Any
   * @return Object of Wrapper Class.
   */
    public List<Inventory_Location_Wrapper> getLocationWithMaterial() {

        System.debug('inWrapper-->'+wrapper);
        //getting customer id from utility class 'Dal_BaseController'
        Account selectedAccount = Dal_BaseController.getUserSelectedLocation();
        customerId = selectedAccount.DW_ID__c;
        Account acc = [SELECT Id,SSC__r.SAP_Plant__c FROM Account WHERE Id =:selectedAccount.Id];
        System.debug('acc---'+acc);
        //Setting endpoint
        Dal_Inventory_DataManager.PubEndpoint availibiltyManager = new Dal_Inventory_DataManager.PubEndpoint();

        Dal_Inventory_DataController.DocumentOptions documentOptions = new Dal_Inventory_DataController.DocumentOptions();
        documentOptions.UOM_CodeSet = Dal_Constants.LEGACY;

        //putting all request item in list
        List<Dal_Inventory_DataController.RequestItem> Items = new List<Dal_Inventory_DataController.RequestItem>();
        Integer i = 0;

        if(inventory){
            System.debug('inventoryData-->'+inventoryData);
            for(Dal_InventorySearchJSON data : inventoryData)
            {

                Dal_Inventory_DataController.SupplyPlant supplyPlant = new Dal_Inventory_DataController.SupplyPlant();
                supplyPlant.SupplyPlantIdType = 'SAP_Plant';
                supplyPlant.SupplyPlantIdValue = acc.SSC__r.SAP_Plant__c; //'4223';//

                Dal_Inventory_DataController.RequestItem requestItem = new Dal_Inventory_DataController.RequestItem();
                if(data.sku != null)
                {
                    requestItem.Material = data.sku; //'0100661P4';//
                    requestItem.QtyUOM = data.uom ; //'SF'; //
                    requestItem.SupplyPlant = supplyPlant;

                    Items.add(requestItem);
                }
            }
        }else if(single){
            System.debug('Singlewrapper-->'+wrapper);
            for(Dal_OrderSampleManager.OrderLocationWrapper inputWrapper : wrapper)
            {

                Dal_Inventory_DataController.SupplyPlant supplyPlant = new Dal_Inventory_DataController.SupplyPlant();
                supplyPlant.SupplyPlantIdType = 'SAP_Plant';
                supplyPlant.SupplyPlantIdValue = inputWrapper.SAP_Plant;

                Dal_Inventory_DataController.RequestItem requestItem = new Dal_Inventory_DataController.RequestItem();
                if(inputWrapper.sku != null)
                {
                    requestItem.Material = inputWrapper.sku;
                    requestItem.QtyUOM = inputWrapper.BaseUOM ;
                    requestItem.SupplyPlant = supplyPlant;

                    Items.add(requestItem);
                }
            }
        } 

        else if(cart){
            System.debug('CartinventoryCartData-->'+inventoryCartData);
            for(DT_Cart_Product__c dataCart : inventoryCartData)
            {
                Dal_Inventory_DataController.SupplyPlant supplyPlant = new Dal_Inventory_DataController.SupplyPlant();
                supplyPlant.SupplyPlantIdType = 'SAP_Plant';
                supplyPlant.SupplyPlantIdValue = dataCart.SSC__r.SAP_Plant__c; //'4223';//

                Dal_Inventory_DataController.RequestItem requestItem = new Dal_Inventory_DataController.RequestItem();
                if(dataCart.Product__r.DW_ID__c != null)
                {
                    requestItem.Material = dataCart.Product__r.DW_ID__c; //'0100661P4';//
                    requestItem.QtyUOM = dataCart.UOM__c ; //'SF'; //
                    requestItem.RequestedQty = String.valueOf(dataCart.Quantity__c ); //'10'; //
                    requestItem.SupplyPlant = supplyPlant;

                    Items.add(requestItem);
                }
            }
        }
 
        System.debug('Request_Items-->'+Items);

        // creating Array of requested item by putting list of requested item list
        Dal_Inventory_DataController.ArrayOfRequestItem arrayOfrequestedItem = new Dal_Inventory_DataController.ArrayOfRequestItem();
        arrayOfrequestedItem.RequestItem = Items;

        //Setting Request iterms all together
        Dal_Inventory_DataController.InventoryRequest request = new Dal_Inventory_DataController.InventoryRequest();
        request.DocumentOptions = documentOptions;
        request.RequestItems = arrayOfrequestedItem;
        system.debug('Request is--->' + request);

        list<Inventory_Location_Wrapper> WrapperList = new List<Inventory_Location_Wrapper>();
        try {
            Dal_Inventory_DataController.InventoryResponse response = new Dal_Inventory_DataController.InventoryResponse();
            response = availibiltyManager.GetInventoryAtLocation(request);
            System.debug('Response------>' + response);

            Dal_Inventory_DataController.ArrayOfResponseItem reslist = response.ResponseItems;

            system.debug('Response list size ' + reslist.ResponseItem.size());
            if (reslist.ResponseItem.size() > 0) {
                for (Dal_Inventory_DataController.ResponseItem res : reslist.ResponseItem) {
                    Inventory_Location_Wrapper locationWrapper = new Inventory_Location_Wrapper();

                    locationWrapper.SKU = res.Material;
                    locationWrapper.availableQty = res.AvailableQty;
                    locationWrapper.OnHandQty = res.OnHandQty;
                    locationWrapper.supplyplantType = res.SupplyPlant.SupplyPlantIdType;
                    locationWrapper.supplyplantID = res.SupplyPlant.SupplyPlantIdValue;
                    locationWrapper.totalCartons = res.AvailableQty_CartonsPlusPieces_Cartons;
                    WrapperList.add(locationWrapper);
                    system.debug('Cartons---' + res.AvailableQty_CartonsPlusPieces_Cartons);
                    system.debug('wrapper---' + locationWrapper);
                }

            }
        }catch (Exception e){
            System.debug('Error in Inventory-->'+e.getMessage());
        }
        return WrapperList;
    }

    //use the wrapper defenition in this class, remove from other process controller class
    public class Inventory_Location_Wrapper {

        @AuraEnabled public String SKU { get; set; }
        @AuraEnabled public String availableQty { get; set; }
        @AuraEnabled public String OnHandQty { get; set; }
        @AuraEnabled public String supplyplantType { get; set; }
        @AuraEnabled public String supplyplantID { get; set; }
        @AuraEnabled public String totalCartons { get; set; }

    }
}