/**
 * Created by Yadav on 11/16/2018.
 */

public with sharing class Dal_GetInventory_Miles_Manager {

    //Global Variables

    public static String customerId;
    public static List<Dal_InventorySearchJSON> inventoryData;
    public static Boolean inventory = false;

    public static String material;
    public static String qtyUOM;
    public static String mileRadiusTo;

    public Dal_GetInventory_Miles_Manager(List<Dal_InventorySearchJSON> data) {
        inventoryData = data;
        inventory = true;
    }

    public Dal_GetInventory_Miles_Manager(String mtrl, String UOM, String milesRadius) {
        material = mtrl;
        qtyUOM = UOM;
        mileRadiusTo = milesRadius;
    }

    public List<Inventory_Miles_Wrapper> getMilesRadius() {

        System.debug('Data-->' + inventoryData);
        //getting customer id from utility class 'Dal_BaseController'
        Account selectedAccount = Dal_BaseController.getUserSelectedLocation();
        customerId = selectedAccount.DW_ID__c;

        Account acc = [SELECT Id,SSC__r.SAP_Plant__c FROM Account WHERE Id = :selectedAccount.Id];
        System.debug('acc---' + acc);
        //Setting endpoint
        Dal_Inventory_DataManager.PubEndpoint milesManager = new Dal_Inventory_DataManager.PubEndpoint();

        Dal_Inventory_DataController.DocumentOptions documentOptions = new Dal_Inventory_DataController.DocumentOptions();
        documentOptions.UOM_CodeSet = Dal_Constants.LEGACY;

        //putting all request item in list
        List<Dal_Inventory_DataController.RequestItem> Items = new List<Dal_Inventory_DataController.RequestItem>();
        Integer i = 0;

        if (inventory) {
            for (Dal_InventorySearchJSON data : inventoryData) {
                Dal_Inventory_DataController.SupplyPlant supplyPlant = new Dal_Inventory_DataController.SupplyPlant();
                supplyPlant.SupplyPlantIdType = 'SAP_Plant';
                supplyPlant.SupplyPlantIdValue = acc.SSC__r.SAP_Plant__c; //'4173';//

                Dal_Inventory_DataController.RequestItem requestItem = new Dal_Inventory_DataController.RequestItem();
                if (data.sku != null) {
                    requestItem.Material = data.sku; //'0100661P4';//
                    requestItem.QtyUOM = data.uom; //'SF';// ;
                    requestItem.SupplyPlant = supplyPlant;
                    requestItem.MileRadiusFrom = '0';
                    requestItem.MileRadiusTo = '50';
                    Items.add(requestItem);
                }
            }
        } else {
            Dal_Inventory_DataController.SupplyPlant supplyPlant = new Dal_Inventory_DataController.SupplyPlant();
            supplyPlant.SupplyPlantIdType = 'SAP_Plant';
            supplyPlant.SupplyPlantIdValue = acc.SSC__r.SAP_Plant__c; //'4173';//

            Dal_Inventory_DataController.RequestItem requestItem = new Dal_Inventory_DataController.RequestItem();

            requestItem.Material = material;
            requestItem.QtyUOM = qtyUOM ;
            requestItem.SupplyPlant = supplyPlant;
            requestItem.MileRadiusFrom = '0';
            requestItem.MileRadiusTo = mileRadiusTo;
            Items.add(requestItem);

        }

        System.debug('Miles Request_Items-->' + Items);

        // creating Array of requested item by putting list of requested item list
        Dal_Inventory_DataController.ArrayOfRequestItem arrayOfrequestedItem = new Dal_Inventory_DataController.ArrayOfRequestItem();
        arrayOfrequestedItem.RequestItem = Items;

        //Setting Request iterms all together
        Dal_Inventory_DataController.InventoryRequest request = new Dal_Inventory_DataController.InventoryRequest();
        request.DocumentOptions = documentOptions;
        request.RequestItems = arrayOfrequestedItem;
        system.debug('Request is--->' + request);

        list<Inventory_Miles_Wrapper> WrapperList = new List<Inventory_Miles_Wrapper>();
        try {

            Dal_Inventory_DataController.InventoryResponse response = new Dal_Inventory_DataController.InventoryResponse();
            response = milesManager.GetInventoryAtNearbySSCS_ByMileRadius(request);
            System.debug('Response------>' + response);

            Dal_Inventory_DataController.ArrayOfResponseItem reslist = response.ResponseItems;
            system.debug('Response list size ' + reslist.ResponseItem.size());

            if (reslist.ResponseItem.size() > 0) {
                for (Dal_Inventory_DataController.ResponseItem res : reslist.ResponseItem) {
                    Inventory_Miles_Wrapper milesWrapper = new Inventory_Miles_Wrapper();

                    system.debug('Cartons---' + res.AvailableQty_CartonsPlusPieces_Cartons);
                    system.debug('Distance---' + res.DistanceMiles);
                    system.debug('SupplyPlantId---' + res.SupplyPlant.SupplyPlantIdValue);
                    system.debug('SupplyPlant---' + res.SupplyPlant);

                    milesWrapper.sku = res.Material;
                    milesWrapper.availableQty = res.AvailableQty;
                    milesWrapper.supplyplantID = res.SupplyPlant.SupplyPlantIdValue;
                    milesWrapper.totalCartons = res.AvailableQty_CartonsPlusPieces_Cartons;
                    milesWrapper.miles = res.DistanceMiles;
                    WrapperList.add(milesWrapper);

                }

            }
        } catch (Exception e) {
            System.debug('Error in Miles' + e.getMessage());
        }
        system.debug('Mileswrapper---' + WrapperList);

        Set<String> supplyplants = new Set<String>();

        List<Inventory_Miles_Wrapper> inventoryMilesWrapperList = new List<Inventory_Miles_Wrapper>();
        Map<String,List<Inventory_Miles_Wrapper>> mapOfWrapper = new Map<String,List<Inventory_Miles_Wrapper>>();
        if(WrapperList.size() > 0){
            for(Inventory_Miles_Wrapper wrap : WrapperList){
                supplyplants.add(wrap.supplyplantID);
                if(!mapOfWrapper.containsKey(wrap.supplyplantID)){
                    mapOfWrapper.put(wrap.supplyplantID,new List<Inventory_Miles_Wrapper>());
                }
                mapOfWrapper.get(wrap.supplyplantID).add(wrap);
            }
        }
        system.debug('mapOfWrapper---' + mapOfWrapper);
        system.debug('supplyplants---' + supplyplants);
        Inventory_Miles_Wrapper inventoryMilesWrapper;
        for(SSC__c  ssc : [Select Id,Name,City__c, State__c, Country__c,SAP_Plant__c From SSC__c  WHERE SAP_Plant__c IN:supplyplants]){
            if(!mapOfWrapper.isEmpty()) {
                if (mapOfWrapper.containsKey(ssc.SAP_Plant__c)) {
                    for(Integer j=0;j<mapOfWrapper.get(ssc.SAP_Plant__c).size();j++){
                        inventoryMilesWrapper = new Inventory_Miles_Wrapper();
                        Inventory_Miles_Wrapper milesWrapper = mapOfWrapper.get(ssc.SAP_Plant__c)[j];
                        inventoryMilesWrapper.sku = milesWrapper.sku;
                        inventoryMilesWrapper.availableQty = milesWrapper.availableQty;
                        inventoryMilesWrapper.supplyplantID = milesWrapper.supplyplantID;
                        inventoryMilesWrapper.totalCartons = milesWrapper.totalCartons;
                        inventoryMilesWrapper.miles = milesWrapper.miles;
                        inventoryMilesWrapper.supplyPlantName = ssc.Name;
                        inventoryMilesWrapper.supplyPlanCity = ssc.City__c;
                       // inventoryMilesWrapper.supplyPlanState = ssc.State__c;
                       // inventoryMilesWrapper.supplyPlanCountry = ssc.Country__c;
                       System.debug('mapOfWrapper.get(ssc.SAP_Plant__c)[j]'+mapOfWrapper.get(ssc.SAP_Plant__c)[j]); 
                        inventoryMilesWrapperList.add(inventoryMilesWrapper);
                    }
                }
            }
            
        }
        system.debug('inventoryMilesWrapperList---' + inventoryMilesWrapperList);
        system.debug('After Sorting --->' + sortMilesLst(inventoryMilesWrapperList));
        return sortMilesLst(inventoryMilesWrapperList);

    }


    //use the wrapper defenition in this class, remove from other process controller class
    public class Inventory_Miles_Wrapper {

        @AuraEnabled public String sku { get; set; }
        @AuraEnabled public String availableQty { get; set; }
        @AuraEnabled public String supplyplantID { get; set; }
        @AuraEnabled public String totalCartons { get; set; }
        @AuraEnabled public String miles { get; set; }
        @AuraEnabled public String supplyPlantName { get; set; }
        @AuraEnabled public String supplyPlanCity { get; set; }
        @AuraEnabled public String supplyPlanState{ get; set; }
        @AuraEnabled public String supplyPlanCountry { get; set; }

    }


    public static List<Inventory_Miles_Wrapper> sortMilesLst(List<Inventory_Miles_Wrapper> milesList){

       System.debug('Inventory_Miles_WrapperList-->'+milesList);
        Map<Decimal, Inventory_Miles_Wrapper> orderMap = new Map<Decimal, Inventory_Miles_Wrapper>(); // Reversed for sorting
        List<Decimal> sortThis = new List<Decimal>();
        Decimal count = 500; 
        for(Inventory_Miles_Wrapper orderMiles : milesList)
        {
            count++;
            if(orderMap.containsKey(Decimal.valueOf(orderMiles.miles)))
            {
                orderMap.put(Decimal.valueOf(orderMiles.miles)+count, orderMiles); // For simplicity in this example, we assume the name is unique
                sortThis.add(Decimal.valueOf(orderMiles.miles)+count);
            }else{
                orderMap.put(Decimal.valueOf(orderMiles.miles), orderMiles); // For simplicity in this example, we assume the name is unique
                sortThis.add(Decimal.valueOf(orderMiles.miles));
            }

        }

        sortThis.sort(); // Sort by Color in this case
        System.debug('sortThis-->'+sortThis);
        List<Inventory_Miles_Wrapper> milesSorted = new List<Inventory_Miles_Wrapper>();

        for(Decimal integerVal : sortThis)
        {
            milesSorted.add(orderMap.get(integerVal));
        }

        System.debug('Sorted Miles-->'+milesSorted);

        return milesSorted;
    }
}