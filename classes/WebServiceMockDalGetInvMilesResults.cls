@isTest
global class WebServiceMockDalGetInvMilesResults implements WebServiceMock {
    public static String testString{get;set;}
    global void doInvoke(
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName,
        String responseType){
            
            Dal_Inventory_DataController.SupplyPlant sup = new Dal_Inventory_DataController.SupplyPlant();
            sup.SupplyPlantDesc= 'test';
            sup.SupplyPlantIdType= '4101';
            sup.SupplyPlantIdValue= '4101';
            
            Dal_Inventory_DataController.DocumentOptions doc = new Dal_Inventory_DataController.DocumentOptions();
            doc.UOM_CodeSet = 'test';
            
            Dal_Inventory_DataController.Destination dst = new Dal_Inventory_DataController.Destination();
            dst.DestinationIdType = 'test';
            dst.DestinationIdValue = 'test';
            
            List<Dal_Inventory_DataController.ResponseItem> respList = new List<Dal_Inventory_DataController.ResponseItem>();
            Dal_Inventory_DataController.ResponseItem resp = new Dal_Inventory_DataController.ResponseItem();
            resp.PricedQuantity = 'test';
            resp.AllocatedQty = 'test'; 
            resp.AvailableQty = 'test';
            resp.Material = 'test';
            resp.SupplyPlant = sup;
            resp.SOS_Preference = '1';
            resp.DistanceMiles = '50';
            resp.RequestedAdjustedQtyAvailabilityInd = testString;
            resp.ATP_DateAtSupplyPlant = String.valueof(System.today() - 5);
            respList.add(resp);
            
            
            Dal_Inventory_DataController.ArrayOfResponseItem res = new Dal_Inventory_DataController.ArrayOfResponseItem(); 
            res.ResponseItem = respList;             
            
            Dal_Inventory_DataController.DocumentOptions document = new Dal_Inventory_DataController.DocumentOptions();
            document.UOM_CodeSet = 'tesst';
            
            Dal_Inventory_DataController.Destination destination = new Dal_Inventory_DataController.Destination();
            destination.DestinationIdType = 'test';
            destination.DestinationIdValue = 'test';
            
            list<Dal_Inventory_DataController.RequestItem> requestItemList = new list<Dal_Inventory_DataController.RequestItem>();
            Dal_Inventory_DataController.RequestItem requestItem = new Dal_Inventory_DataController.RequestItem();
            requestItem.Material = 'test';
            requestItem.QtyUOM = 'test';
            requestItem.RequestedQty = 'test';
            requestItem.PriceRecord = 'test';
            requestItem.PricePlant = 'test';
            requestItem.FromDateAtSupplyPlant = 'test';
            requestItem.NoOfPlantsToCheck = 'test';
            requestItem.NoOfPlantsToCheckFrom = 'test';
            requestItem.MileRadiusFrom = 'test';
            requestItem.MileRadiusTo = 'test';
            requestItemList.add(requestItem);
            
            Dal_Inventory_DataController.ArrayOfRequestItem aaryaRequestItem = new Dal_Inventory_DataController.ArrayOfRequestItem();
            aaryaRequestItem.RequestItem = requestItemList;
            
            Dal_Inventory_DataController.InventoryRequest Invrequest = new Dal_Inventory_DataController.InventoryRequest();
            Invrequest.Destination = destination;
            Invrequest.DocumentOptions = document;
            Invrequest.RequestItems = aaryaRequestItem;
            
            
            Dal_Inventory_DataController.InventoryResponse requests = new Dal_Inventory_DataController.InventoryResponse();
            requests.DocumentOptions = doc;
            requests.Destination = dst;
            requests.ResponseItems = res;
            
            Dal_Inventory_DataController.GetInventoryAtNearbySSCS_ByMileRadiusResponseBody milesResponse = new Dal_Inventory_DataController.GetInventoryAtNearbySSCS_ByMileRadiusResponseBody();
            milesResponse.Response = requests;
            
            response.put('response_x',milesResponse);
            
        }
}