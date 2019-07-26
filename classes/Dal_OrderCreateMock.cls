/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 */
@isTest
global class Dal_OrderCreateMock implements WebServiceMock{

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

         Dal_OrderCreateDataContract.Charge charge = new Dal_OrderCreateDataContract.Charge();
         Dal_OrderCreateDataContract.RequestItem requestItem = new Dal_OrderCreateDataContract.RequestItem ();
         Dal_OrderCreateDataContract.ArrayOfCharge arrayOfCharge = new Dal_OrderCreateDataContract.ArrayOfCharge();   
         Dal_OrderCreateDataContract.Note note = new Dal_OrderCreateDataContract.Note();   
        
         Dal_OrderCreateDataContract.ArrayOfNote arrayOfNote = new Dal_OrderCreateDataContract.ArrayOfNote();       
            
         Dal_OrderCreateDataContract.ErrorDetail error = new Dal_OrderCreateDataContract.ErrorDetail();
            
         Dal_OrderCreateDataContract.Tracking track = new  Dal_OrderCreateDataContract.Tracking();
            
         Dal_OrderCreateDataContract.ArrayOfErrorDetail errorDetails = new Dal_OrderCreateDataContract.ArrayOfErrorDetail();
           
         Dal_OrderCreateDataContract.ArrayOfResponseItem responseItems = new Dal_OrderCreateDataContract.ArrayOfResponseItem();  
            
         Dal_OrderCreateDataContract.Result result = new Dal_OrderCreateDataContract.Result(); 
         //result.Status = 'Ok';
             
         Dal_OrderCreateDataContract.Response resp = new  Dal_OrderCreateDataContract.Response();  
         resp.ErrorDetails = errorDetails;
         resp.ResponseItems = responseItems;
         resp.Result = result;
            
		Dal_OrderCreateContext.CreateSalesOrderResponse_element response_x = new Dal_OrderCreateContext.CreateSalesOrderResponse_element();
		response_x.CreateSalesOrderResult = resp;

		/* Dal_OrderFulfilmentContext.CreateOrderFulfilmentScheduleResult res = new Dal_OrderFulfilmentContext.CreateOrderFulfilmentScheduleResult();
		res.Result = results;

		Dal_OrderFulfilmentContext.CreateOrderFulfilmentScheduleResponseBody response_x = new Dal_OrderFulfilmentContext.CreateOrderFulfilmentScheduleResponseBody();
		response_x.CreateOrderFulfilmentScheduleResult = res;  */
        //response_x.Response = response;
		response.put('response_x',response_x);

    }
}