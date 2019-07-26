/**
 * Created by 7Summits on 5/2/18.
**/
public with sharing class Dal_ConversionCalculation {
    
    /*
	* Method Name: getConversionCal
	* Description: Purpose to covert the unit of measure into Piece Count & Carton Count
	* @param: String UnitOfMeasure, Decimal Quantity, String skuNumber
	* @return Wrapper class Object holding carton count & piece count.
	*/
    public static WrapConversionCal getConversionCal( String UnitOfMeasure, Decimal Quantity, String skuNumber){
        String CONVERSION_ID_PC = 'PC';
        String CONVERSION_ID_CT = 'CT'; 
        String CONVERSION_ID_SF = 'SF';  
        Decimal fromValue;
        Decimal toValue ;
        
        Conversion_Factor__c convFrom = new Conversion_Factor__c();
        Conversion_Factor__c convTo = new Conversion_Factor__c(); 
        
        WrapConversionCal wrapCC = new WrapConversionCal();
 		System.debug('UnitOfMeasure'+UnitOfMeasure);
        if(UnitOfMeasure == CONVERSION_ID_SF)
        {
            try {   
            convFrom = [SELECT Demoninator__c, Numerator__c
                        FROM Conversion_Factor__c
                        WHERE Product__c =: skuNumber AND Product__r.UOM__c =: UnitOfMeasure LIMIT 1];
           
            fromValue = (convFrom.Numerator__c / convFrom.Demoninator__c); 
            
            }catch (System.QueryException e) {
  				System.debug('No Rows Exception');
			}
            
            try {
            convTo = [SELECT Demoninator__c, Numerator__c
                      FROM Conversion_Factor__c
                      WHERE Product__c =: skuNumber AND Product__r.UOM__c =: 'CT'];
            
            toValue   = (convTo.Numerator__c / convTo.Demoninator__c);
            wrapCC.cartonCount = (fromValue/toValue) * Quantity ;
            }catch (System.QueryException e) {
  				System.debug('No Rows Exception');
			}
            
            try {
            convTo = [SELECT Demoninator__c, Numerator__c
                      FROM Conversion_Factor__c
                      WHERE Product__c =: skuNumber AND Product__r.UOM__c =: 'PC'];
                //if(!Test.isRunningTest()){
                    toValue   = (convTo.Numerator__c / convTo.Demoninator__c);
                    wrapCC.pieceCount = (fromValue/toValue) * Quantity ;
             	//}   
            }catch (System.QueryException e) {
  				System.debug('No Rows Exception');
			}                
           
        }
        if(UnitOfMeasure == CONVERSION_ID_PC){
            try {
            convFrom = [SELECT Demoninator__c, Numerator__c
                        FROM Conversion_Factor__c
                        WHERE Product__c =: skuNumber AND Product__r.UOM__c =: UnitOfMeasure];
            
            fromValue = (convFrom.Numerator__c / convFrom.Demoninator__c);
             
            convTo = [SELECT Demoninator__c, Numerator__c
                      FROM Conversion_Factor__c
                      WHERE Product__c =: skuNumber AND Product__r.UOM__c =: 'CT'];
            
            toValue   = (convTo.Numerator__c / convTo.Demoninator__c);
            
            wrapCC.cartonCount = (fromValue/toValue) * Quantity ;
            wrapCC.pieceCount = Quantity ;
             }catch (System.QueryException e) {
  				System.debug('No Rows Exception');
			} 
        }
        else if(UnitOfMeasure == CONVERSION_ID_CT){
            try {
            convFrom  = [SELECT Demoninator__c, Numerator__c
                         FROM Conversion_Factor__c
                         WHERE Product__c =: skuNumber AND Product__r.UOM__c =: UnitOfMeasure];
            
            fromValue = (convFrom.Numerator__c / convFrom.Demoninator__c);
            
            convTo = [SELECT Demoninator__c, Numerator__c
                      FROM Conversion_Factor__c
                      WHERE Product__c =: skuNumber AND Product__r.UOM__c =: 'PC'];
            
            toValue   = (convTo.Numerator__c / convTo.Demoninator__c);
            
            wrapCC.cartonCount = Quantity ;
            wrapCC.pieceCount = (fromValue/toValue) * Quantity ;
             }catch (System.QueryException e) {
  				System.debug('No Rows Exception');
			} 
        }
          
         return wrapCC;
    }
    
    // Wrapper Class
    public class WrapConversionCal {
        public Decimal cartonCount;
        public Decimal pieceCount;
    }
    
}