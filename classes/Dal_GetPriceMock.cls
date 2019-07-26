/**
* This class contains unit tests for validating the behavior of Apex classes
* and triggers.
*/
@isTest
global class Dal_GetPriceMock implements WebServiceMock{
    
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
            
            Dal_GetPriceDataController.MyServiceFault myservice= new Dal_GetPriceDataController.MyServiceFault();
            myservice.Message = 'message';
            List<Dal_GetPriceCallout.Item> items = new List<Dal_GetPriceCallout.Item>();
            Dal_GetPriceCallout.Item itm = new Dal_GetPriceCallout.Item();
            itm.PricedQuantity  = 25;
            itm.PricedQuantityUOM  = '25';
            itm.DiscountCode  = '25';
            itm.PricedQuantityUOM  = '25';
            items.add(itm);
            
            List<Dal_GetPriceCallout.ArrayOfItem> arrys = new List<Dal_GetPriceCallout.ArrayOfItem>();
            Dal_GetPriceCallout.ArrayOfItem arry = new Dal_GetPriceCallout.ArrayOfItem(); 
            arry.Item = items;
            arrys.add(arry);
            
            List<Dal_GetPriceCallout.ResponseItem> resplist = new List<Dal_GetPriceCallout.ResponseItem>();
            Dal_GetPriceCallout.ResponseItem resp = new Dal_GetPriceCallout.ResponseItem ();
            resp.PriceCode = '25';
            resp.ExtendedNetPrice = 25;
            resp.PricedQuantityUOM = '25';
            resp.PricedUOM_NetPrice = 25;
            resp.WeightForPricedQty = '12';
            resp.EnergySurchargeFactor = 12;
            resplist.add(resp);
            
            Dal_GetPriceCallout.ArrayOfResponseItem repItm = new Dal_GetPriceCallout.ArrayOfResponseItem();
            repItm.Item = resplist;
            Dal_GetPriceCallout.BaseResponseContract rep4 = new Dal_GetPriceCallout.BaseResponseContract();
            Dal_GetPriceCallout.PerformanceData rep3 = new Dal_GetPriceCallout.PerformanceData();
            Dal_GetPriceCallout.ArrayOfPerformanceCounter rep2 = new Dal_GetPriceCallout.ArrayOfPerformanceCounter();
            Dal_GetPriceCallout.PerformanceCounter rep1 = new Dal_GetPriceCallout.PerformanceCounter();
            
            Dal_GetPriceCallout.ForParty party = new Dal_GetPriceCallout.ForParty();  
            Dal_GetPriceCallout.ServiceContext service = new Dal_GetPriceCallout.ServiceContext(); 
            Dal_GetPriceCallout.DaltilePriceResponse price = new Dal_GetPriceCallout.DaltilePriceResponse();
            price.Items = repItm;
            price.ForParty = party;
            price.Plant = 'plant';
            price.ServiceContext = service;
            Dal_GetPriceCallout.GetPriceResponse_element response_x = new Dal_GetPriceCallout.GetPriceResponse_element();
            response_x.GetPriceResult = price;
            response.put('response_x',response_x);
            
        }
    
}