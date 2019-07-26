public class Dal_ConversionCalculatorManager {
    
    //Global Variables 
    public String Material;
    public String ToUOM;
    public String Quantity;
    
    /*
	* Method Name: Dal_ConversionCalculatorManager (Constructor) 
	* Description: Purpose to set values to global variables
	* @param: Stock keeping Material,ToUOM,Quantity.
	* @return Not Any 
	*/
    public Dal_ConversionCalculatorManager( String Material, String ToUOM, String Quantity){
        this.Material = Material;
        this.ToUOM = ToUOM;
        this.Quantity = Quantity;
    }
    /*
	* Method Name: getConversionResult
	* Description: Purpose to get data from webservice by conversionCalculator.
	* @param: Not Any
	* @return list of Wrapper Class. 
	*/
    public List<CalculatorWrapper> getConversionResult(){
        //Setting endpoint
        Dal_ConversionCalculatorData.Endpoint1 calculatorManager = new Dal_ConversionCalculatorData.Endpoint1();
        //Setting request item for calling webservice
        Dal_ConversionCalculatorService.Request1 request = new Dal_ConversionCalculatorService.Request1();
        request.Option_UOM_CodeSet = Dal_Constants.LEGACY;
        request.Material = Material;
        request.Quantity = Quantity;
        request.UOM = ToUOM;
        
        Dal_ConversionCalculatorService.MaterialConverionsCalculator_element response = new Dal_ConversionCalculatorService.MaterialConverionsCalculator_element();
        response = calculatorManager.ToAll_UOMs(request);
        System.debug('response-------'+response.ConverionResult);
        list<CalculatorWrapper> calculatorManagerList = new list<CalculatorWrapper>();
        for(Dal_ConversionCalculatorService.ConverionResult_element value : response.ConverionResult){
            System.debug('TOUOM--->'+value.ToUOM);
            system.debug('ConverionFactor-----'+value.ConverionFactor);
            system.debug('ConvertedQty-----'+value.ConvertedQty);
            CalculatorWrapper cw = new CalculatorWrapper(value);
            calculatorManagerList.add(cw);
        }
        
        system.debug('calculatorManagerList----'+calculatorManagerList);
        return calculatorManagerList;
    }
    
    //use the wrapper defenition in this class, remove from other process controller class
    public class CalculatorWrapper{
        
        @AuraEnabled public String ToUOM;
        @AuraEnabled public double ConverionFactor;
        @AuraEnabled public double ConvertedQty;
        
        public CalculatorWrapper(Dal_ConversionCalculatorService.ConverionResult_element value){
            
            this.ToUOM = value.ToUOM;
            this.ConverionFactor = value.ConverionFactor;
            this.ConvertedQty = value.ConvertedQty;
        }
        
    }
    
}