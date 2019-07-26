@isTest
global class WebServiceMockDalImplInventoryAtLocation implements WebServiceMock {

    global void doInvoke(
            Object stub,
            Object requests,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType){

        //Dal_Inventory_DataController.SupplyPlant sup = new Dal_Inventory_DataController.SupplyPlant();
        // sup.SupplyPlantDesc= 'test';
        // sup.SupplyPlantIdType= 'test';
        //sup.SupplyPlantIdValue= 'test';

        //Dal_Inventory_DataController.DocumentOptions doc = new Dal_Inventory_DataController.DocumentOptions();
        //doc.UOM_CodeSet = 'test';

        /*Dal_Inventory_DataController.Destination dst = new Dal_Inventory_DataController.Destination();
        dst.DestinationIdType = 'test';
        dst.DestinationIdValue = 'test';

        List<Dal_Inventory_DataController.ResponseItem> respList = new List<Dal_Inventory_DataController.ResponseItem>();
        Dal_Inventory_DataController.ResponseItem resp = new Dal_Inventory_DataController.ResponseItem();

        List<Dal_Inventory_DataController.ResponseItem> respList = new List<Dal_Inventory_DataController.ResponseItem>();
        Dal_Inventory_DataController.ResponseItem resp = new Dal_Inventory_DataController.ResponseItem();
        resp.PricedQuantity = 'test';
        resp.AllocatedQty = 'test';
        resp.AvailableQty = 'test';
        resp.Material = 'test';
        resp.SupplyPlant = sup;
        resp.SOS_Preference = '1';
        resp.RequestedAdjustedQtyAvailabilityInd = 'Y';
        resp.ATP_DateAtSupplyPlant = String.valueof(System.today() - 5);
        respList.add(resp);


        Dal_Inventory_DataController.ArrayOfResponseItem res = new Dal_Inventory_DataController.ArrayOfResponseItem();
        res.ResponseItem = respList;

        Dal_Inventory_DataController.InventoryRequest req = new Dal_Inventory_DataController.InventoryRequest();
        req.DocumentOptions = doc;
        req.Destination = dst;
        req.ResponseItems = res;

        Dal_Inventory_DataController.GetInventoryAtLocation_TimePhasedRequestBody request =
            new Dal_Inventory_DataController.GetInventoryAtLocation_TimePhasedRequestBody();
        request.request = req;

        Dal_Inventory_DataController.InventoryResponse resp = new Dal_Inventory_DataController.InventoryResponse();
        resp.DocumentOptions = doc;
        resp.Destination = dst;
        resp.ResponseItems = res;

        Dal_Inventory_DataController.ArrayOfResponseItem arr = new Dal_Inventory_DataController.ArrayOfResponseItem();
        arr.ResponseItem = respList;  */



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
        resp.AvailableQty = '5.5';
        resp.Material = '0100441P4';
        resp.SupplyPlant = sup;
        resp.SOS_Preference = '1';
        resp.RequestedAdjustedQtyAvailabilityInd = 'N';
        resp.ATP_DateAtSupplyPlant = String.valueof(System.today());
        respList.add(resp);

        Dal_Inventory_DataController.ArrayOfResponseItem res = new Dal_Inventory_DataController.ArrayOfResponseItem();
        res.ResponseItem = respList;

        Dal_Inventory_DataController.InventoryResponse respons = new Dal_Inventory_DataController.InventoryResponse();
        respons.DocumentOptions = doc;
        respons.Destination = dst;
        respons.ResponseItems = res;

        Dal_Inventory_DataController.GetInventoryAtLocationResponseBody response_x = new Dal_Inventory_DataController.GetInventoryAtLocationResponseBody();
        //request_x.request = response;
        response_x.Response = respons;
        response.put('response_x',response_x);

    }
}