/**
 * Created by Yadav on 12/6/2018.
 */

public with sharing class Dal_OrderFulfilmentCancelManager {

    public String orderNumber;
    public String orderNumberKey;
    public List<Dal_ScheduleOrderController.OrderLineWrapper> lineWrapper;
    public static String TypeOfCommunity = 'OASIS';

    //Constructor
    public Dal_OrderFulfilmentCancelManager(List<Dal_ScheduleOrderController.SchedulerWrapper> wrapperList,String totalLineItem){
        lineWrapper = new List<Dal_ScheduleOrderController.OrderLineWrapper>();
        System.debug('InConstructor--->'+wrapperList+'--------'+totalLineItem);
        System.debug('InConstructor--->'+wrapperList+'--------'+totalLineItem+'----'+wrapperList[0].OrderLineWrappers);
        orderNumber = wrapperList[0].OrderNumber;
        orderNumberKey = wrapperList[0].SalesOrderKey;
        if(totalLineItem.contains('ALL')){
            lineWrapper = wrapperList[0].OrderLineWrappers;
        }else{
            Integer index = Integer.valueOf(totalLineItem);
            System.debug('InConstructorELSE--->'+wrapperList[0].OrderLineWrappers[0]);
            lineWrapper.add(wrapperList[0].OrderLineWrappers[0]);

        }

    }

    /*
   * Method Name: getOrderFulfilment
   * Description: Purpose to get Order Fulfilment data from webservice .
   * @param: Not Any
   * @return List of Wrapper Class object.
   */
    public Peak_Response cancelFulfilment() {

        System.debug('cancelFulfilment--->');
        //Setting Endpoint
        Dal_OrderFulfilmentService.Endpoint1 orderFulfil = new Dal_OrderFulfilmentService.Endpoint1();

        List<Dal_OrderFulfilmentContext.Line> lines = new List<Dal_OrderFulfilmentContext.Line>();
        User user = [SELECT Id,ContactId,Email FROM User WHERE Id = :UserInfo.getUserId()];
        for(Dal_ScheduleOrderController.OrderLineWrapper lineItems: lineWrapper){
            System.debug('lineItems--->'+lineItems);
            Dal_OrderFulfilmentContext.Line line = new Dal_OrderFulfilmentContext.Line();
          //  line.Quantity = 1.0;
            line.SalesOrderLine = lineItems.LineNumber;
            line.SalesOrderLineKey = lineItems.linekey;
            lines.add(line);
        }
        System.debug('lines--->'+lines);

        Dal_OrderFulfilmentContext.ArrayOfLine arrayOfLine = new Dal_OrderFulfilmentContext.ArrayOfLine();
        arrayOfLine.Line = lines;

        Dal_OrderFulfilmentContext.Order order = new Dal_OrderFulfilmentContext.Order();
        order.HostSystem = TypeOfCommunity;
        order.SalesOrder = orderNumber;
        order.SalesOrderKey = orderNumberKey;
        order.ConfirmationEmail = user.Email;

        Dal_OrderFulfilmentContext.OrderFulfilmentSchedule_Remove request = new Dal_OrderFulfilmentContext.OrderFulfilmentSchedule_Remove();
        request.Lines = arrayOfLine;
        request.Order = order;

        System.debug('Cancel_request---->'+request);

        Dal_OrderFulfilmentDatacontract.Response response =  orderFulfil.OrderFulfilmentSchedule_RemoveLines(request);
        System.debug('Cancel_Response---->'+response);
        //creating peak response
        Peak_Response peakResponse = new Peak_Response();
        if(response.Result.Status == 'Ok' )
        {
            peakResponse.success = true;
            peakResponse.messages.add(response.Result.StatusDesc);
        }
        else
        {
            peakResponse.success = false;
        }

        System.debug('Status------->'+ peakResponse.success);
        System.debug('Status------->'+ peakResponse.messages);
        return peakResponse;
    }
}