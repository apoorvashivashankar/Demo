/**
 * Created by Yadav on 11/16/2018.
 */

public without sharing class Dal_GetInventory_AvailabilityDate {

    //Global Variables
    public String SKU;
    public String UOM;
    public String SupplyPlantIdValue;
    public static String customerId;
    public static List<Dal_InventorySearchJSON> inventoryData;
    public static Boolean inventory = false;

    public Dal_GetInventory_AvailabilityDate(List<Dal_InventorySearchJSON> data ) {
        inventoryData = data;
        inventory = true;
    }

    public List<AvailableDate_Wrapper> getAvailibilityDate() {

        System.debug('getAvailibilityDate---->');
        //getting customer id from utility class 'Dal_BaseController'
        Account selectedAccount = Dal_BaseController.getUserSelectedLocation();
        customerId = selectedAccount.DW_ID__c;

        Account acc = [SELECT Id,SSC__r.SAP_Plant__c FROM Account WHERE Id =:selectedAccount.Id];
        System.debug('acc--availibility-'+acc.SSC__r.SAP_Plant__c);

        //Setting endpoint
        Dal_Inventory_DataManager.PubEndpoint availibiltyManager = new Dal_Inventory_DataManager.PubEndpoint();

        Dal_Inventory_DataController.DocumentOptions documentOptions = new Dal_Inventory_DataController.DocumentOptions();
        documentOptions.UOM_CodeSet = Dal_Constants.LEGACY;

        Dal_Inventory_DataController.Destination destination = new Dal_Inventory_DataController.Destination();
        destination.DestinationIdType = Dal_Constants.SAP_Plant ;
        destination.DestinationIdValue = acc.SSC__r.SAP_Plant__c;
        //destination.DestinationIdValue = '4223';

        //putting all request item in list
        List<Dal_Inventory_DataController.RequestItem> Items = new List<Dal_Inventory_DataController.RequestItem>();


        for(Dal_InventorySearchJSON data : inventoryData)
        {
            //Setting request item for calling webservice
            Dal_Inventory_DataController.RequestItem requestedItem = new Dal_Inventory_DataController.RequestItem();
            requestedItem.Material = data.sku; //'0100661P4';
            requestedItem.QtyUOM = data.uom; // 'PC';
            requestedItem.RequestedQty = data.quantity; //'1';
            Items.add(requestedItem);
        }


        system.debug('requestedItem--' + Items);

        // creating Array of requested item by putting list of requested item list
        Dal_Inventory_DataController.ArrayOfRequestItem arrayOfrequestedItem = new Dal_Inventory_DataController.ArrayOfRequestItem();
        arrayOfrequestedItem.RequestItem = Items;

        //Setting Request iterms all together
        Dal_Inventory_DataController.InventoryRequest request = new Dal_Inventory_DataController.InventoryRequest();
        request.DocumentOptions = documentOptions;
        request.Destination = destination;
        request.RequestItems = arrayOfrequestedItem;
        System.debug('request_Availibility--->' + request);

        List<AvailableDate_Wrapper> atpWrapperList = new List<AvailableDate_Wrapper>();
        try {
            Dal_Inventory_DataController.InventoryResponse response = new Dal_Inventory_DataController.InventoryResponse();
            response = availibiltyManager.GetInventoryAtSourcesOfSupply_AvailabilityDate(request);
            System.debug('Response_Availibilty------>' + response);

            //parse the response and initialise a wrapper obj to return to lightning controller

            Dal_Inventory_DataController.ArrayOfResponseItem reslist = response.ResponseItems;

            System.debug('Response list size--in_availability ' + reslist.ResponseItem.size());

            
            if (reslist.ResponseItem.size() > 0) {
                for (Dal_Inventory_DataController.ResponseItem res : reslist.ResponseItem) {
                    system.debug('responseData---' + res);
                    AvailableDate_Wrapper atpWrapper = new AvailableDate_Wrapper();

                    atpWrapper.onTimeFlag = 'N';

                    try {
                        if (Date.valueOf(res.ATP_DateAtSupplyPlant) <= Date.valueOf(Datetime.now()) && res.RequestedAdjustedQtyAvailabilityInd == 'Y') {
                            atpWrapper.onTimeFlag = 'Y';
                        }
                    } catch (Exception e) {
                        System.debug('Unable to parse dates: ' + e);
                    }
                    atpWrapper.dateAtSupplyPlant = res.ATP_DateAtSupplyPlant;
                    atpWrapper.supplyPlant = res.SupplyPlant.SupplyPlantDesc ;
                    atpWrapper.SOS = res.SOS_Preference;
                    atpWrapper.availableQty = res.AvailableQty_ATP_Date;
                    atpWrapper.supplyplantType = res.SupplyPlant.SupplyPlantIdType;
                    atpWrapper.supplyplantID = res.SupplyPlant.SupplyPlantIdValue;
                    atpWrapper.isqtyAvailabe = res.RequestedAdjustedQtyAvailabilityInd;
                    atpWrapper.sku = res.Material;

                    //create wrapper and add to list
                    atpWrapperList.add(atpWrapper);
                    system.debug('wrapper---' + atpWrapperList);
                }

            }
        }catch (Exception e){
            System.debug('Error--->'+e.getMessage());

        }
        return atpWrapperList;
    }

    //use the wrapper defenition in this class, remove from other process controller class
    public class AvailableDate_Wrapper{

        @AuraEnabled public String sku{get;set;}
        @AuraEnabled public String dateAtSupplyPlant{get;set;}
        @AuraEnabled public String onTimeFlag{get;set;}
        @AuraEnabled public String supplyPlant{get;set;}
        @AuraEnabled public String SOS{get;set;}
        @AuraEnabled public String availableQty{get;set;}
        @AuraEnabled public String supplyplantType{get;set;}
        @AuraEnabled public String supplyplantID{get;set;}
        @AuraEnabled public String isqtyAvailabe{get;set;}


    }
}