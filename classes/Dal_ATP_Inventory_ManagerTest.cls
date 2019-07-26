@isTest
private with sharing class Dal_ATP_Inventory_ManagerTest {
    
    private class WebServiceMockImpl implements WebServiceMock
    {        
        public void doInvoke(
            Object stub, Object request, Map<String, Object> response,
            String endpoint, String soapAction, String requestName,
            String responseNS, String responseName, String responseType)
        {
            if(request instanceof Dal_ATP_Inventory_Controller.GetInventoryAtSourcesOfSupplyRequestBody)
                response.put('response_x', new  Dal_ATP_Inventory_Controller.GetInventoryAtSourcesOfSupplyResponseBody());
            return;
        }
        
       /*  public void doInvoke1(
            Object stub, Object request, Map<String, Object> response,
            String endpoint, String soapAction, String requestName,
            String responseNS, String responseName, String responseType)
        {
            if(request instanceof Dal_ATP_Inventory_Controller.GetInventoryAtSourcesOfSupply_TimePhasedRequestBody)
                response.put('response_x', new  Dal_ATP_Inventory_Controller.GetInventoryAtSourcesOfSupply_TimePhasedResponseBody());
            return;
        }
*/
        
  }
 }