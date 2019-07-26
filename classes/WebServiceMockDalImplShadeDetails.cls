@isTest
global class WebServiceMockDalImplShadeDetails implements WebServiceMock {

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
            resp.RequestedAdjustedQtyAvailabilityInd = 'N';
            resp.ATP_DateAtSupplyPlant = String.valueof(System.today());
            respList.add(resp);

            /*Dal_Inventory_DataController.PerformanceCounter per = new Dal_Inventory_DataController.PerformanceCounter();
            per.ServiceName = 'Serv';
            per.DurationInMs = long.valueOf('123456789');
            per.Name = 'Serv';
            per.LogTime = datetime.newInstance(2014, 9, 15, 12, 30, 0);*/

            Dal_Inventory_DataController.ArrayOfResponseItem res = new Dal_Inventory_DataController.ArrayOfResponseItem();
            res.ResponseItem = respList;

            Dal_Inventory_DataController.InventoryResponse requests = new Dal_Inventory_DataController.InventoryResponse();
            requests.DocumentOptions = doc;
            requests.Destination = dst;
            requests.ResponseItems = res;

            Dal_Inventory_DataController.GetInventoryAtLocation_ByShadeResponseBody response_x = new Dal_Inventory_DataController.GetInventoryAtLocation_ByShadeResponseBody();
            response_x.Response = requests;
            response.put('response_x',response_x);

        }
}