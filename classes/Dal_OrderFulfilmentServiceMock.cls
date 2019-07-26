@isTest
global class Dal_OrderFulfilmentServiceMock implements WebServiceMock{
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
            
            Dal_OrderFulfilmentDatacontract.Result results = new Dal_OrderFulfilmentDatacontract.Result();
            results.Status = 'Ok';
            results.StatusDesc = 'SaleForce';
            
            Dal_OrderFulfilmentDatacontract.Response responseData = new Dal_OrderFulfilmentDatacontract.Response();
            responseData.Result = results;
            
            Dal_OrderFulfilmentDatacontract.Response Orderresponse = new Dal_OrderFulfilmentDatacontract.Response();
            Orderresponse.Result = results;
            
            Dal_OrderFulfilmentContext.CreateOrderFulfilmentScheduleResponse_element response_x = new Dal_OrderFulfilmentContext.CreateOrderFulfilmentScheduleResponse_element();
            response_x.CreateOrderFulfilmentScheduleResult = Orderresponse;
            
            Dal_OrderFulfilmentContext.OrderFulfilmentSchedule_RemoveLinesResponse_element OrderFulfilmentSchedule_RemoveLines = new Dal_OrderFulfilmentContext.OrderFulfilmentSchedule_RemoveLinesResponse_element();
            OrderFulfilmentSchedule_RemoveLines.OrderFulfilmentSchedule_RemoveLinesResult = responseData;
            
            List<Dal_OrderFulfilmentContext.Line> lineList = new List<Dal_OrderFulfilmentContext.Line>();
            Dal_OrderFulfilmentContext.Line line = new Dal_OrderFulfilmentContext.Line();
            line.Quantity = 12.2;
            line.SalesOrderLine = 'test';
            line.SalesOrderLineKey = 'test';
            lineList.add(line);
            
            Dal_OrderFulfilmentContext.ArrayOfLine lines = new Dal_OrderFulfilmentContext.ArrayOfLine();
            lines.Line = lineList;
            
            Dal_OrderFulfilmentContext.Order order = new Dal_OrderFulfilmentContext.Order();
            order.HostSystem = 'test';
            order.SalesOrder = 'test';
            order.SalesOrderKey = 'test';
            
            Dal_OrderFulfilmentContext.OrderFulfilmentSchedule_Remove  orderScheduleRemove = new Dal_OrderFulfilmentContext.OrderFulfilmentSchedule_Remove();
            orderScheduleRemove.Lines = lines;
            orderScheduleRemove.Order = order;
            
            if(request instanceof Dal_OrderFulfilmentContext.OrderFulfilmentSchedule_RemoveLines_element){
                Dal_OrderFulfilmentContext.OrderFulfilmentSchedule_RemoveLinesResponse_element respElement = new Dal_OrderFulfilmentContext.OrderFulfilmentSchedule_RemoveLinesResponse_element();
                //Dal_OrderFulfilmentDatacontract.Response respElement = new Dal_OrderFulfilmentDatacontract.Response();
                response.put('response_x', respElement); 
            }
            
            if(request instanceof Dal_OrderFulfilmentContext.CreateOrderFulfilmentSchedule_element){
                Dal_OrderFulfilmentContext.CreateOrderFulfilmentScheduleResponse_element respElement = new Dal_OrderFulfilmentContext.CreateOrderFulfilmentScheduleResponse_element();
                //Dal_OrderFulfilmentDatacontract.Response respElement = new Dal_OrderFulfilmentDatacontract.Response();
                response.put('response_x', respElement); 
            }
            
        }
}