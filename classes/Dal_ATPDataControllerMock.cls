@isTest
global class Dal_ATPDataControllerMock implements WebServiceMock{
    
    global void doInvoke(
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName,
        String responseType) {
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
            //resp.RequestedAdjustedQtyAvailabilityInd = testString;
            resp.ATP_DateAtSupplyPlant = String.valueof(System.today() - 5);
            respList.add(resp);
            
            List<Dal_Inventory_DataController.RequestItem> reqList = new List<Dal_Inventory_DataController.RequestItem>();
            Dal_Inventory_DataController.RequestItem req = new Dal_Inventory_DataController.RequestItem();            
            
                
            Dal_Inventory_DataController.ArrayOfResponseItem res = new Dal_Inventory_DataController.ArrayOfResponseItem(); 
			res.ResponseItem = respList;             
            
            Dal_Inventory_DataController.InventoryResponse requests = new Dal_Inventory_DataController.InventoryResponse();
            requests.DocumentOptions = doc;
            requests.Destination = dst;
            requests.ResponseItems = res;
            
            if(request instanceof Dal_Inventory_DataController.GetInventoryAtSourcesOfSupplyRequestBody){
                Dal_Inventory_DataController.GetInventoryAtSourcesOfSupplyResponseBody respElement = new Dal_Inventory_DataController.GetInventoryAtSourcesOfSupplyResponseBody();
                
                response.put('response_x', respElement); 
            }
            if(request instanceof Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_ctxRequestBody){
                
                Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_ctxResponseBody respContext = new Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_ctxResponseBody(); 
                response.put('response_x', respContext);  
            }
            if(request instanceof Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_TimePhasedRequestBody){
                
                Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_TimePhasedResponseBody respSupply = new Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_TimePhasedResponseBody(); 
                response.put('response_x', respSupply);  
            }
            if(request instanceof Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_TimePhased_ctxRequestBody){
                
                Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_TimePhased_ctxResponseBody respSupply1 = new Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_TimePhased_ctxResponseBody(); 
                response.put('response_x', respSupply1);  
            }
            if(request instanceof Dal_Inventory_DataController.GetInventoryAtLocation_ctxRequestBody){
                
                Dal_Inventory_DataController.GetInventoryAtLocation_ctxResponseBody respctx = new Dal_Inventory_DataController.GetInventoryAtLocation_ctxResponseBody(); 
                response.put('response_x', respctx);  
            }
            if(request instanceof Dal_Inventory_DataController.GetInventoryAtLocationRequestBody){
                
                Dal_Inventory_DataController.GetInventoryAtLocationResponseBody respLocation = new Dal_Inventory_DataController.GetInventoryAtLocationResponseBody(); 
                response.put('response_x', respLocation);  
            }
            if(request instanceof Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_AvailabilityDate_PriceRequestBody){
                
                Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_AvailabilityDate_PriceResponseBody respPrice = new Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_AvailabilityDate_PriceResponseBody(); 
                response.put('response_x', respPrice);  
            }
            if(request instanceof Dal_Inventory_DataController.GetInventoryAtLocation_AvailabilityDate_ctxRequestBody){
                
                Dal_Inventory_DataController.GetInventoryAtLocation_AvailabilityDate_ctxResponseBody respDate = new Dal_Inventory_DataController.GetInventoryAtLocation_AvailabilityDate_ctxResponseBody(); 
                response.put('response_x', respDate);  
            }
            if(request instanceof Dal_Inventory_DataController.GetInventoryAtLocation_TimePhased_ctxRequestBody){
                
                Dal_Inventory_DataController.GetInventoryAtLocation_TimePhased_ctxResponseBody respTime = new Dal_Inventory_DataController.GetInventoryAtLocation_TimePhased_ctxResponseBody(); 
                response.put('response_x', respTime);  
            }
            if(request instanceof Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_AvailabilityDate_ctxRequestBody){
                
                Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_AvailabilityDate_ctxResponseBody respSupply = new Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_AvailabilityDate_ctxResponseBody(); 
                response.put('response_x', respSupply);  
            }
            if(request instanceof Dal_Inventory_DataController.GetInventoryAtLocation_ByShade_ctxRequestBody){
                
                Dal_Inventory_DataController.GetInventoryAtLocation_ByShade_ctxResponseBody respShade = new Dal_Inventory_DataController.GetInventoryAtLocation_ByShade_ctxResponseBody(); 
                response.put('response_x', respShade);  
            }
            if(request instanceof Dal_Inventory_DataController.GetInventoryAtLocation_AvailabilityDateRequestBody){
                
                Dal_Inventory_DataController.GetInventoryAtLocation_AvailabilityDateResponseBody respAvailDate = new Dal_Inventory_DataController.GetInventoryAtLocation_AvailabilityDateResponseBody(); 
                response.put('response_x', respAvailDate);  
            }
            if(request instanceof Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_AvailabilityDate_Price_ctxRequestBody){
                
                Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_AvailabilityDate_Price_ctxResponseBody respAvailDatePrice = new Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_AvailabilityDate_Price_ctxResponseBody(); 
                response.put('response_x', respAvailDatePrice);  
            }
            if(request instanceof Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_AvailabilityDateRequestBody){
                
                Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_AvailabilityDateResponseBody respSourceSupply = new Dal_Inventory_DataController.GetInventoryAtSourcesOfSupply_AvailabilityDateResponseBody(); 
                response.put('response_x', respSourceSupply);  
            }
            if(request instanceof Dal_Inventory_DataController.GetInventoryAtLocation_ByShadeRequestBody){
                
                Dal_Inventory_DataController.GetInventoryAtLocation_ByShadeResponseBody respByShade = new Dal_Inventory_DataController.GetInventoryAtLocation_ByShadeResponseBody(); 
                response.put('response_x', respByShade);  
            }
            if(request instanceof Dal_Inventory_DataController.GetInventoryAtLocation_TimePhasedRequestBody){
                
                Dal_Inventory_DataController.GetInventoryAtLocation_TimePhasedResponseBody respAtLocationTime = new Dal_Inventory_DataController.GetInventoryAtLocation_TimePhasedResponseBody(); 
                response.put('response_x', respAtLocationTime);  
            }
            if(request instanceof Dal_Inventory_DataController.GetInventoryAtNearbySSCS_ctxRequestBody){
                
                Dal_Inventory_DataController.GetInventoryAtNearbySSCS_ctxResponseBody respNearBy = new Dal_Inventory_DataController.GetInventoryAtNearbySSCS_ctxResponseBody(); 
                response.put('response_x', respNearBy);  
            }
            if(request instanceof Dal_Inventory_DataController.GetInventoryAtNearbySSCSRequestBody){
                
                Dal_Inventory_DataController.GetInventoryAtNearbySSCSResponseBody respNearBySSC = new Dal_Inventory_DataController.GetInventoryAtNearbySSCSResponseBody(); 
                response.put('response_x', respNearBySSC);  
            }
            
            if(request instanceof Dal_Inventory_DataController.GetInventoryAtNearbySSCS_ByMileRadiusRequestBody){
                
                Dal_Inventory_DataController.GetInventoryAtNearbySSCS_ByMileRadiusResponseBody respMiles = new Dal_Inventory_DataController.GetInventoryAtNearbySSCS_ByMileRadiusResponseBody(); 
                response.put('response_x', respMiles);  
            } 
            if(request instanceof Dal_Inventory_DataController.GetSourcesOfSupplyRequestBody){
                
                Dal_Inventory_DataController.GetSourcesOfSupplyResponseBody respSupply = new Dal_Inventory_DataController.GetSourcesOfSupplyResponseBody(); 
                response.put('response_x', respSupply);  
            } 
        }
    
}