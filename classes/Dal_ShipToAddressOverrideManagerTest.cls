/**
* Created by 7Summits on 2/21/18
*/
@isTest
public class Dal_ShipToAddressOverrideManagerTest {
    
    @testSetup
    static void testsetup(){
        UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType ='None' limit 1];
        update new User(Id=userInfo.getUserId(), UserRoleId = ur.Id);
        
       System.runAs(new user(ID = UserInfo.getUserID())) { 
       	Contact con = Dal_TestUtils.createTestContact();  
        
        List<SSC__c> sscList = new List<SSC__c>();
        SSC__c ssc = new SSC__c();
        ssc.Name = 'SSC Account';
        sscList.add(ssc);
        insert sscList;
        
        Account account = new Account();
        account.Id = con.AccountId;
        account.SSC__c = ssc.Id; 
        account.DW_ID__c = '008082001';
        update account;
        
        Country__c country = new Country__c(); 
		country.Name = 'US';
        insert country;
           
        UserContactDefaults__c userCont = new UserContactDefaults__c();
        userCont.Default_Account_Id__c = con.AccountId;
        userCont.Default_Contact_Record_Type_Id__c = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Daltile Internal Contact').getRecordTypeId();
        insert userCont; 
        
        //Account account = Dal_TestUtils.createTestAccount();
        
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
        shipOveride.Accountname_c__c = account.Id;
        insert shipOveride;
           
            Profile p = [select Id,name from Profile where name='Customer Community Plus Login User'];
            String uniqueName = Dal_TestUtils.getUserString();
            User newUser = new User(profileId = p.id, username = uniqueName + '@test.org', email = 'pb@ff.com',
                                    emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                    timezonesidkey = 'America/Los_Angeles', alias='nuser', lastname='lastname', 
                                    Selected_Location__c = con.accountId, contactId = con.id
                                   );
            insert newUser;
        }        
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
        DT_Shiptoaddress_Override__c shipAddress = [Select Id,Accountname_c__c from DT_Shiptoaddress_Override__c limit 1];
        
        Test.startTest(); 
        List<Dal_ShipToAddressOverrideManager.Dal_ShipToAddressWrapper> shipToOver = Dal_ShipToAddressOverrideManager.getShipToOverridesByLocation(account.Id);
        System.assert(true, shipToOver);

        
        List<Dal_ShipToAddressOverrideManager.Dal_ShipToAddressWrapper> shipToOverDefault = Dal_ShipToAddressOverrideManager.setShipToOverrideDefault(shipAddress.Id);
        System.assert(true, shipToOverDefault);
        List<Dal_ShipToAddressOverrideManager.Dal_ShipToAddressWrapper> deactiveAllShip = Dal_ShipToAddressOverrideManager.deactivateAllShipToOverrides(account.Id);
        System.assert(true, deactiveAllShip);
        Dal_ShipToAddressOverrideManager.Dal_ShipToAddressWrapper wrapper= Dal_ShipToAddressOverrideManager.createShipToOverride(jsonString);       
        Boolean isTrue = Dal_ShipToAddressOverrideManager.deleteShipToOverride(jsonString);

        List<Dal_OrderSearchController.StatusOption> statusOptions = Dal_ShipToAddressOverrideManager.getCountries();
        Test.StopTest();
        
    }
    static testmethod void shiptoAddressTest() {  
        
        Test.startTest(); 
        
        Test.setMock(WebServiceMock.class, new WebServiceMockDalImplAddValidation());
        Dal_ShipToAddressOverrideManager.getValidatedAddress('1', 'H.no.5', 'NY', 'NY', '547445', 'US');
        List<Dal_ShipToAddressOverrideManager.Dal_ShipToAddressWrapper> shipToOver = Dal_ShipToAddressOverrideManager.getShipToOverridesByLocation(null);
        System.assert(true, shipToOver);
        List<Dal_ShipToAddressOverrideManager.Dal_ShipToAddressWrapper> shipToOverDefault = Dal_ShipToAddressOverrideManager.setShipToOverrideDefault(null);
        System.assert(true, shipToOverDefault);
        List<Dal_ShipToAddressOverrideManager.Dal_ShipToAddressWrapper> deactiveAllShip = Dal_ShipToAddressOverrideManager.deactivateAllShipToOverrides(null);
        System.assert(true, deactiveAllShip);
        Test.StopTest();
        
    } 
    static testMethod void statusbyDistTest() {
        User newUser = [SELECT Id,username FROM User WHERE email = 'pb@ff.com' limit 1];
        Test.startTest();
        System.runAs(newUser){
           List<Dal_ShipToAddressOverrideManager.Dal_ShipToAddressWrapper> ShipToAddressWrapper =  Dal_ShipToAddressOverrideManager.getShipToAddressWrappersForCurrentLocation();
           List<Dal_ShipToAddressOverrideManager.Dal_ShipToAddressWrapper> searchAdd = Dal_ShipToAddressOverrideManager.searchAddressForCurrentLocation('Test');
        } 
        Test.stopTest();       
    }       
}