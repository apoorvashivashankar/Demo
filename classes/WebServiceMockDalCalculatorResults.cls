@isTest
global class WebServiceMockDalCalculatorResults implements WebServiceMock {
    
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
            
            list<Dal_ConversionCalculatorService.ConverionResult_element>ConverionResultlist = new list<Dal_ConversionCalculatorService.ConverionResult_element>();
            Dal_ConversionCalculatorService.ConverionResult_element ConverionResult = new Dal_ConversionCalculatorService.ConverionResult_element();
            ConverionResult.ToUOM = 'test';
            ConverionResult.ConverionFactor = 1;
            ConverionResult.ConvertedQty = 1;
            ConverionResultlist.add(ConverionResult);
            
            Dal_ConversionCalculatorService.ConverionFactor_element ConverionFactor = new Dal_ConversionCalculatorService.ConverionFactor_element();
            ConverionFactor.Denominator = 'test';
            ConverionFactor.Numerator = 'test';
            
            Dal_ConversionCalculatorService.MaterialConverionFactors_element MaterialConverionFactors = new Dal_ConversionCalculatorService.MaterialConverionFactors_element();
            MaterialConverionFactors.Material = 'test';
            MaterialConverionFactors.UOM_CodeSet = 'test';
            
            
            
            Dal_ConversionCalculatorService.UOM_ConversionsResponse_element UOMConversion = new  Dal_ConversionCalculatorService.UOM_ConversionsResponse_element();
            UOMConversion.MaterialConverionFactors = MaterialConverionFactors;
            
            
            Dal_ConversionCalculatorService.MaterialConverionsCalculator_element MaterialConverionsCalculator = new Dal_ConversionCalculatorService.MaterialConverionsCalculator_element();
            MaterialConverionsCalculator.Material = 'test';
            MaterialConverionsCalculator.FromUOM = 'test';
            MaterialConverionsCalculator.UOM_CodeSet ='test';
            MaterialConverionsCalculator.Quantity = 1;
            MaterialConverionsCalculator.ConverionResult = ConverionResultlist;
            
            
            Dal_ConversionCalculatorService.ToAll_UOMsResponse_element ToAll_UOMsresponse = new Dal_ConversionCalculatorService.ToAll_UOMsResponse_element();
            ToAll_UOMsresponse.MaterialConverionsCalculator = MaterialConverionsCalculator;
            
            Dal_ConversionCalculatorService.Request2 request2 = new Dal_ConversionCalculatorService.Request2();
            request2.Material = 'test';
            request2.Option_UOM_CodeSet = 'test';
            
             Dal_ConversionCalculatorService.Request1 request1 = new Dal_ConversionCalculatorService.Request1();
            request1.Material = 'test';
            request1.Option_UOM_CodeSet = 'test';
            request1.UOM = 'test';
            request1.Quantity = '1';
            
            
            Dal_ConversionCalculatorService.ToUOM_FromUOMResponse_element ToUOM_Response_element = new Dal_ConversionCalculatorService.ToUOM_FromUOMResponse_element();
            ToUOM_Response_element.MaterialConverionsCalculator = MaterialConverionsCalculator;
            
            
           Dal_ConversionCalculatorService.ToAll_UOMs_element ToAll_UOM_element = new Dal_ConversionCalculatorService.ToAll_UOMs_element();
            ToAll_UOM_element.request = request1;
            
            
            Dal_ConversionCalculatorService.Request reque = new Dal_ConversionCalculatorService.Request();
            reque.Material = 'test';
            reque.Option_UOM_CodeSet = 'test';
            reque.ToUOM = 'test';
            reque.FromUOM = 'test';
            reque.Quantity = '1';
            
            Dal_ConversionCalculatorService.ToUOM_FromUOM_element  ToUOM_FromUOM_element = new Dal_ConversionCalculatorService.ToUOM_FromUOM_element();
            ToUOM_FromUOM_element.request = reque;
            
            Dal_ConversionCalculatorService.UOM_Conversions_element UOM_Conversion_element = new Dal_ConversionCalculatorService.UOM_Conversions_element();
            UOM_Conversion_element.request = request2;
            
            system.debug('----ToAll_UOMsresponse----'+ToAll_UOMsresponse);
            response.put('response_x',ToAll_UOMsresponse);
        }
    
}