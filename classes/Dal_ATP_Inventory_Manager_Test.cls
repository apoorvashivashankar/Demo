@isTest
public with sharing class Dal_ATP_Inventory_Manager_Test
{
    public class WebServiceMockImpl implements WebServiceMock
    {
        public void doInvoke(
            Object stub, Object request, Map<String, Object> response,
            String endpoint, String soapAction, String requestName,
            String responseNS, String responseName, String responseType)
        {
            if(request instanceof Dal_ATP_Inventory_Controller.GetInventoryAtSourcesOfSupplyRequestBody)
                response.put('response_x', new Dal_ATP_Inventory_Controller.GetInventoryAtSourcesOfSupplyResponseBody());
            
            else if(request instanceof Dal_ATP_Inventory_Controller.GetInventoryAtSourcesOfSupply_ctxRequestBody)
                response.put('response_x', new Dal_ATP_Inventory_Controller.GetInventoryAtSourcesOfSupply_ctxResponseBody());
            
            else if(request instanceof Dal_ATP_Inventory_Controller.GetInventoryAtSourcesOfSupply_TimePhasedRequestBody)
                response.put('response_x', new Dal_ATP_Inventory_Controller.GetInventoryAtSourcesOfSupply_TimePhasedResponseBody());
            
            else if(request instanceof Dal_ATP_Inventory_Controller.GetInventoryAtSourcesOfSupply_TimePhased_ctxRequestBody)
                response.put('response_x', new Dal_ATP_Inventory_Controller.GetInventoryAtSourcesOfSupply_TimePhased_ctxResponseBody());
            
            else if(request instanceof Dal_ATP_Inventory_Controller.GetInventoryAtLocation_ctxRequestBody)
                response.put('response_x', new Dal_ATP_Inventory_Controller.GetInventoryAtLocation_ctxResponseBody());
            
            else if(request instanceof Dal_ATP_Inventory_Controller.GetInventoryAtLocationRequestBody)
                response.put('response_x', new Dal_ATP_Inventory_Controller.GetInventoryAtLocationResponseBody());
            
            else if(request instanceof Dal_ATP_Inventory_Controller.GetInventoryAtLocation_ByShadeRequestBody)
                response.put('response_x', new Dal_ATP_Inventory_Controller.GetInventoryAtLocation_ByShadeResponseBody());
            
            else if(request instanceof Dal_ATP_Inventory_Controller.GetInventoryAtNearbySSCSRequestBody)
                response.put('response_x', new Dal_ATP_Inventory_Controller.GetInventoryAtNearbySSCSResponseBody());
            
            else if(request instanceof Dal_ATP_Inventory_Controller.GetInventoryAtNearbySSCS_ctxRequestBody)
                response.put('response_x', new Dal_ATP_Inventory_Controller.GetInventoryAtNearbySSCS_ctxResponseBody());
            
            else if(request instanceof Dal_ATP_Inventory_Controller.GetInventoryAtLocation_TimePhasedRequestBody)
                response.put('response_x', new Dal_ATP_Inventory_Controller.GetInventoryAtLocation_TimePhasedResponseBody());
            
            else if(request instanceof Dal_ATP_Inventory_Controller.GetInventoryAtLocation_AvailabilityDate_ctxRequestBody)
                response.put('response_x', new Dal_ATP_Inventory_Controller.GetInventoryAtLocation_AvailabilityDate_ctxResponseBody());
            
            else if(request instanceof Dal_ATP_Inventory_Controller.GetInventoryAtSourcesOfSupply_AvailabilityDate_PriceRequestBody)
                response.put('response_x', new Dal_ATP_Inventory_Controller.GetInventoryAtSourcesOfSupply_AvailabilityDate_PriceResponseBody());                        
            
            else if(request instanceof Dal_ATP_Inventory_Controller.GetInventoryAtLocation_TimePhased_ctxRequestBody)
                response.put('response_x', new Dal_ATP_Inventory_Controller.GetInventoryAtLocation_TimePhased_ctxResponseBody());
            
            else if(request instanceof Dal_ATP_Inventory_Controller.GetInventoryAtSourcesOfSupply_AvailabilityDate_ctxRequestBody)
                response.put('response_x', new Dal_ATP_Inventory_Controller.GetInventoryAtSourcesOfSupply_AvailabilityDate_ctxResponseBody());            
           
            else if(request instanceof Dal_ATP_Inventory_Controller.GetInventoryAtLocation_ByShade_ctxRequestBody)
                response.put('response_x', new Dal_ATP_Inventory_Controller.GetInventoryAtLocation_ByShade_ctxResponseBody());
            
            else if(request instanceof Dal_ATP_Inventory_Controller.GetInventoryAtLocation_AvailabilityDateRequestBody)
                response.put('response_x', new Dal_ATP_Inventory_Controller.GetInventoryAtLocation_AvailabilityDateResponseBody());                       
            
            else if(request instanceof Dal_ATP_Inventory_Controller.GetInventoryAtSourcesOfSupply_AvailabilityDate_Price_ctxRequestBody)
                response.put('response_x', new Dal_ATP_Inventory_Controller.GetInventoryAtSourcesOfSupply_AvailabilityDate_Price_ctxResponseBody());
            
            else if(request instanceof Dal_ATP_Inventory_Controller.GetInventoryAtSourcesOfSupply_AvailabilityDateRequestBody)
                response.put('response_x', new Dal_ATP_Inventory_Controller.GetInventoryAtSourcesOfSupply_AvailabilityDateResponseBody());
            
            return;
        }
    }
}