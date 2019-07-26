@isTest
public class Dal_Dist_OrderProcessControllerTest {
    
    @isTest static void testupdate(){
        
        Account acc = new Account();
        acc.AccountNumber = '0000123655';
        
        DT_Order__c orderDT = new DT_Order__c();
        orderDT.Name = 'Testorder';
        orderDT.Address1__c = 'opposite to WTP';
        insert orderDT;
        DT_Order__c orderDT1 = new DT_Order__c();

		Dal_Dist_OrderProcessController.saveOrderDetails(orderDT);
        Dal_Dist_OrderProcessController.saveOrderDetails(orderDT1);
        
    }
    
    @isTest static void testupdate1(){
        
        
        
    }
    
}