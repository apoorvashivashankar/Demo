/**
* Created by 7Summits on 2/21/18
*/
@isTest(SeeAllData=false)
public class Dal_ShipToListControllerTest {
  
    @testSetup
    static void testsetup(){
        
        Account account = Dal_TestUtils.createTestAccount();
        
        DT_Shiptoaddress_Override__c shipOveride = new DT_Shiptoaddress_Override__c(); 	 
        shipOveride.name = 'ShipTest';
        shipOveride.Address_Line_1__c = 'address1';
        shipOveride.Address_Line_2__c = 'address2';
        shipOveride.Address_Line_3__c = 'address3';
        shipOveride.Address_Line_4__c = 'address4';
        shipOveride.City__c = 'NY';
        shipOveride.State__c = 'NY';
        shipOveride.Default__c = true ;
        shipOveride.Postal_code__c = '99999';
        shipOveride.Country__c = 'US';
        shipOveride.Accountname_c__c = account.DW_ID__c;
        insert shipOveride;
        
    }
    static testmethod void shiptoAddress() {  
        
        List<DT_Shiptoaddress_Override__c> shipToAddress = [SELECT Id,name,Address_Line_1__c,Address_Line_2__c,Address_Line_3__c,Address_Line_4__c,
                                                            City__c,State__c,Default__c,Postal_code__c,Country__c,Accountname_c__c FROM DT_Shiptoaddress_Override__c]; 
        JSONGenerator gen = JSON.createGenerator(true); 	
        gen.writeStartObject();
        //this corresponds to an instance of the GoogleCalendarEvent class
        gen.writeStringField('Address_Line_1__c', shipToAddress[0].Address_Line_1__c);
        gen.writeStringField('Address_Line_2__c', shipToAddress[0].Address_Line_2__c);
        gen.writeStringField('Address_Line_3__c', shipToAddress[0].Address_Line_3__c);
        gen.writeStringField('Address_Line_4__c', shipToAddress[0].Address_Line_4__c);
        gen.writeStringField('City__c', shipToAddress[0].City__c);
        gen.writeStringField('State__c', shipToAddress[0].State__c);
        gen.writeBooleanField('Default__c', shipToAddress[0].Default__c);
        gen.writeStringField('Postal_code__c', shipToAddress[0].Postal_code__c);
        gen.writeStringField('Country__c',shipToAddress[0].Country__c);       
        gen.writeEndObject();			
        String jsonString = gen.getAsString();
        
        Account account = [Select Id,name ,DW_ID__c from Account limit 1];
        System.debug('account'+account);
 
        test.startTest();
        
        Dal_ShipToListController.getShipToOverridesByLocation(account.Id);
        Dal_ShipToListController.setShipToOverrideDefault(shipToAddress[0].Id);
        Dal_ShipToListController.deactivateAllShipToOverrides(account.Id);
        Dal_ShipToListController.createShipToOverride(jsonString);       
        Dal_ShipToListController.deleteShipToOverride(jsonString);
              
        test.StopTest();
        
    }
    
}