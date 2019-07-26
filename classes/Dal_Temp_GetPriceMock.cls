/**
* This class contains unit tests for validating the behavior of Apex classes
* and triggers.
*/
@isTest
global class Dal_Temp_GetPriceMock implements WebServiceMock{
    
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
            
            Dal_GetPriceDataContext.PerformanceCounter per = new Dal_GetPriceDataContext.PerformanceCounter();
            Dal_GetPriceDataContext.ServiceContext ser = new Dal_GetPriceDataContext.ServiceContext();
            Dal_GetPriceDataContext.BaseResponseContract brc = new Dal_GetPriceDataContext.BaseResponseContract();
            Dal_GetPriceDataContext.PerformanceData perd = new Dal_GetPriceDataContext.PerformanceData();
            Dal_GetPriceDataContext.ArrayOfPerformanceCounter arry = new Dal_GetPriceDataContext.ArrayOfPerformanceCounter();
            Dal_GetPriceDataContext.PerformanceCounter perCout = new Dal_GetPriceDataContext.PerformanceCounter();
            
            List<Dal_GetPriceDataContext.Item> items = new List<Dal_GetPriceDataContext.Item>();
            Dal_GetPriceDataContext.Item itm = new Dal_GetPriceDataContext.Item();
            items.add(itm);
            
            Dal_GetPriceDataContext.ForParty ForParty = new Dal_GetPriceDataContext.ForParty();
            ForParty.PartyId = '1234';
            ForParty.PartyId_Type = 'TYPE';
            
            Dal_GetPriceDataContext.ArrayOfItem arri = new Dal_GetPriceDataContext.ArrayOfItem();
            arri.Item = items;
                       
            Dal_GetPriceDataContext.DaltilePriceResponse priceResult = new Dal_GetPriceDataContext.DaltilePriceResponse();
            priceResult.Plant = 'ABC';
            priceResult.Items = arri;
            priceResult.ForParty = ForParty;
                       
            Dal_GetPriceDataContext.GetPriceResponse_element response_x = new Dal_GetPriceDataContext.GetPriceResponse_element();
            response_x.GetPriceResult = priceResult;
            response.put('response_x',response_x);
            
        }
    
}