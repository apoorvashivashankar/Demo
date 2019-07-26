@istest
public class Dal_OrderFulfilmentServiceTest {
    
    public static testMethod void testPubEndpoint(){
        
        test.startTest();
        Test.setMock(WebServiceMock.class, new Dal_OrderFulfilmentServiceMock());
        Dal_OrderFulfilmentService.Endpoint1 orderService = new Dal_OrderFulfilmentService.Endpoint1();
        
        Dal_OrderFulfilmentContext.OrderFulfilmentSchedule_Remove OrderFulfilmentSchedule_RemoveLines = new Dal_OrderFulfilmentContext.OrderFulfilmentSchedule_Remove();
        
        Dal_OrderFulfilmentContext.OrderFulfilmentSchedule OrderFulfilmentSchedule = new Dal_OrderFulfilmentContext.OrderFulfilmentSchedule();
        
        orderService.CreateOrderFulfilmentSchedule(OrderFulfilmentSchedule);
        orderService.OrderFulfilmentSchedule_RemoveLines(OrderFulfilmentSchedule_RemoveLines);
    	test.stopTest();
    }
}