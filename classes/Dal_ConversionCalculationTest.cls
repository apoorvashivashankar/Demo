@isTest
public class Dal_ConversionCalculationTest {
    static testMethod void getAllOrdersToSchedule(){     
        
        list<Product2> proList = new list<Product2>();
        Product2 pd = new Product2(Name = 'Demo Tile1',UOM__c = 'SF');
        proList.add(pd);
        Product2 pd1 = new Product2(Name = 'Demo Tile2',UOM__c = 'PC');
        proList.add(pd1);
        Product2 pd2 = new Product2(Name = 'Demo Tile3',UOM__c = 'CT');
        proList.add(pd2);
 		insert proList; 
        
        list<Conversion_Factor__c> convList = new list<Conversion_Factor__c>();
        Conversion_Factor__c con = new Conversion_Factor__c(Conversion_Factor_ID__c = 'TS1',Product__c = pd.Id,
                                                           Numerator__c = 25.0,Demoninator__c = 25.0,Name = 'test1');
        convList.add(con);
        Conversion_Factor__c con1 = new Conversion_Factor__c(Conversion_Factor_ID__c = 'TS2',Product__c = pd1.Id,
                                                           Numerator__c = 25.0,Demoninator__c = 25.0,Name = 'test2');
        convList.add(con1);
        Conversion_Factor__c con2 = new Conversion_Factor__c(Conversion_Factor_ID__c = 'TS3',Product__c = pd2.Id,
                                                           Numerator__c = 25.0,Demoninator__c = 0,Name = 'tes3');
        convList.add(con2);
		insert convList;
        
        String UnitOfMeasure = 'SF';
        Decimal Quantity = 25.0; 
        String skuNumber = pd.Id;
        Dal_ConversionCalculation.getConversionCal(UnitOfMeasure, Quantity, skuNumber);
        
    }
    static testMethod void getAllOrdersToSchedule1(){     
        
        list<Product2> proList = new list<Product2>();
        Product2 pd1 = new Product2(Name = 'Demo Tile1',UOM__c = 'PC');
        proList.add(pd1);
        insert proList;
        
        list<Conversion_Factor__c> conList = new list<Conversion_Factor__c>();
        Conversion_Factor__c con1 = new Conversion_Factor__c(Conversion_Factor_ID__c = 'TS1',Product__c = pd1.Id,
                                                           Numerator__c = 25.0,Demoninator__c = 25.0,Name = 'test');        
		conList.add(con1);
        insert conList;
        
        String UnitOfMeasure = 'PC';
        Decimal Quantity = 25.0; 
        String skuNumber = pd1.Id;
        Dal_ConversionCalculation.getConversionCal(UnitOfMeasure, Quantity, skuNumber);
    }   
    static testMethod void getAllOrdersToSchedule2(){     
        
        list<Product2> proList = new list<Product2>();
        Product2 pd1 = new Product2(Name = 'Demo Tile1',UOM__c = 'CT');
        proList.add(pd1);
        insert proList;
        
        list<Conversion_Factor__c> conList = new list<Conversion_Factor__c>();
        Conversion_Factor__c con1 = new Conversion_Factor__c(Conversion_Factor_ID__c = 'TS',Product__c = pd1.Id,
                                                           Numerator__c = 25.0,Demoninator__c = 25.0,Name = 'test');        
		conList.add(con1);
        insert conList;
        
        String UnitOfMeasure = 'CT';
        Decimal Quantity = 25.0; 
        String skuNumber = pd1.Id;
        Dal_ConversionCalculation.getConversionCal(UnitOfMeasure, Quantity, skuNumber);
    }    
    
    static testMethod void getAllOrdersToSchedule3(){     
        
        Dal_ConversionCalculation.getConversionCal('SF', null, null);
    }
    
    static testMethod void getAllOrdersToSchedule4(){     
        
        list<Product2> proList = new list<Product2>();
        Product2 pd1 = new Product2(Name = 'Demo Tile1',UOM__c = 'CT');
        proList.add(pd1);
        
        insert proList;
        
        list<Conversion_Factor__c> conList = new list<Conversion_Factor__c>();
        Conversion_Factor__c con1 = new Conversion_Factor__c(Conversion_Factor_ID__c = 'TS',Product__c = pd1.Id,
                                                           Numerator__c = 25.0,Demoninator__c = 25.0,Name = 'test');        
		conList.add(con1);
        insert conList;
        
        String UnitOfMeasure = 'SF';
        Decimal Quantity = 25.0; 
        String skuNumber = pd1.Id;
        
        try{
            Dal_ConversionCalculation.getConversionCal(UnitOfMeasure, Quantity, skuNumber);
        }catch(Exception e){}
    } 
    
    static testMethod void getAllOrdersToSchedule5(){     
        
        list<Product2> proList = new list<Product2>();
        Product2 pd1 = new Product2(Name = 'Demo Tile1',UOM__c = 'CT');
        proList.add(pd1);
        Product2 pd2 = new Product2(Name = 'Demo Tile2',UOM__c = 'PC');
        proList.add(pd2);
        insert proList;
        
        list<Conversion_Factor__c> conList = new list<Conversion_Factor__c>();
        Conversion_Factor__c con1 = new Conversion_Factor__c(Conversion_Factor_ID__c = 'TS1',Product__c = proList.get(0).Id,
                                                           Numerator__c = 25.0,Demoninator__c = 25.0,Name = 'test');        
		conList.add(con1);
		con1 = new Conversion_Factor__c(Conversion_Factor_ID__c = 'TS2',Product__c = proList.get(1).Id,
                                                           Numerator__c = 25.0,Demoninator__c = 25.0,Name = 'test1');        
		conList.add(con1);
        insert conList;
        
        String UnitOfMeasure = 'PC';
        Decimal Quantity = 25.0; 
        String skuNumber = pd1.Id;
        Dal_ConversionCalculation.getConversionCal(UnitOfMeasure, Quantity, skuNumber);
    }  
}