@isTest
global class WebServiceMockDalImplATPResults implements WebServiceMock {

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
            sup.SupplyPlantIdType= 'test';
            sup.SupplyPlantIdValue= 'test';
            
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
            resp.RequestedAdjustedQtyAvailabilityInd = testString;
            resp.ATP_DateAtSupplyPlant = String.valueof(System.today() - 5);
            respList.add(resp);
            
                
            Dal_Inventory_DataController.ArrayOfResponseItem res = new Dal_Inventory_DataController.ArrayOfResponseItem(); 
			res.ResponseItem = respList;             
            
            Dal_Inventory_DataController.InventoryResponse requests = new Dal_Inventory_DataController.InventoryResponse();
            requests.DocumentOptions = doc;
            requests.Destination = dst;
            requests.ResponseItems = res;
                
			Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_AvailabilityDate_PriceResponseBody response_x = new Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_AvailabilityDate_PriceResponseBody();
            //request_x.request = request;
            response_x.Response = requests;
            response.put('response_x',response_x);
            
        }
}