/**
* This class contains unit tests for validating the behavior of Apex classes
* and triggers.
*/
@isTest
global class Dal_OrderFulfilmentMock implements WebServiceMock{
    
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
           
            Dal_OrderFulfilmentDatacontract.Response response_x = new Dal_OrderFulfilmentDatacontract.Response();
            response_x.Result = results;
            //response_x.Response = response;
            response.put('response_x',response_x);
            
        }
}