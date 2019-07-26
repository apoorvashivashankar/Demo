/**
 * Created by Preshit on 23-02-2019.
 */

@isTest
global class Dal_OrderFulfilmentCancel_Mock implements WebServiceMock{
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

        Dal_OrderFulfilmentContext.OrderFulfilmentSchedule_RemoveLinesResponse_element response_x = new Dal_OrderFulfilmentContext.OrderFulfilmentSchedule_RemoveLinesResponse_element();
        response_x.OrderFulfilmentSchedule_RemoveLinesResult = Orderresponse;

        //response_x.Response = response;
        response.put('response_x',response_x);


    }
}