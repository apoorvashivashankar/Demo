/**
* This class contains unit tests for validating the behavior of Apex classes
* and triggers.
*/
@isTest
global class Dal_OrderFulfilment_Mock implements WebServiceMock{
    
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
            
            
            Dal_OrderFulfilmentDatacontract.Result results = new Dal_OrderFulfilmentDatacontract.Result();
            results.Status = 'Ok';
            results.StatusDesc = 'SaleForce';
            
            Dal_OrderFulfilmentDatacontract.Response Orderresponse = new Dal_OrderFulfilmentDatacontract.Response();
            Orderresponse.Result = results;
            
            Dal_OrderFulfilmentContext.CreateOrderFulfilmentScheduleResponse_element response_x = new Dal_OrderFulfilmentContext.CreateOrderFulfilmentScheduleResponse_element();
            response_x.CreateOrderFulfilmentScheduleResult = Orderresponse;
            
            //response_x.Response = response;
            response.put('response_x',response_x);
            
            
        }
}