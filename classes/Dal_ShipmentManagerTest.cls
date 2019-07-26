/**
* This class contains unit tests for validating the behavior of Apex classes
**/
@isTest(seeAllData=false)
public class Dal_ShipmentManagerTest {        
    @testSetup
    static void testSetup(){
        
        UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType ='None' limit 1];
        update new User(Id=userInfo.getUserId(), UserRoleId = ur.Id);
        
        System.runAs(new user(ID = UserInfo.getUserID())) {
            Contact con = Dal_TestUtils.createTestContact();  
            
            DT_Order__c  order = new DT_Order__c ();
            order.Name = 'FirstOrder';
            insert order;
            
            Account account = new Account();
            account.Id = con.AccountId;
            account.DW_ID__c = '00880021';
            update account;
            
            UserContactDefaults__c userCont = new UserContactDefaults__c();
            userCont.Default_Account_Id__c = con.AccountId;
            userCont.Default_Contact_Record_Type_Id__c = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Daltile Internal Contact').getRecordTypeId();
            insert userCont;
            
            Profile p = [select Id,name from Profile where name='Customer Community Plus Login User'];
    
			String uniqueName = Dal_TestUtils.getUserString();            
            User newUser = new User(profileId = p.id,  username = uniqueName + '@test.org', email = 'pb@ff.com',
                                    emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                    timezonesidkey = 'America/Los_Angeles', alias='nuser', lastname='lastname', 
                                    Selected_Location__c = con.accountId, contactId = con.id
                                   );
            insert newUser;
        }
        
    }
    static testMethod void statusbyDist_HistTest() {
        User newUser = [SELECT Id,username FROM User WHERE email = 'pb@ff.com' limit 1];
        String FakeIdOne = Dal_TestUtils.getFakeId(DT_SYS_ShipmentList__x.SObjectType); 
        DT_SYS_ShipmentList__x testShipmentRecord  = new  DT_SYS_ShipmentList__x(id = FakeIdOne  , Shipment__c= 'TestShipment',ShipmentCreationDate__c =  String.valueOf(System.today()),
                                                                                   Carrier_Name__c= 'TestCarrier',ShipFromLocDesc__c= 'TestShipFromLocDesc',
                                                                                   StatusDesc__c=  'TestStatusDesc',Status__c=  'TestStatus',TrackingNbr__c =  'TestTrackingNbr');
		Dal_ShipmentManager.mockallShipmentList.add(testshipmentrecord);
        
		//Account acc = [Select Id from Account];        
		String FakeId = Dal_TestUtils.getFakeId(DT_SYS_ShipmentLine__x.SObjectType); 		
        DT_SYS_ShipmentLine__x testShipmentLineRecord = new DT_SYS_ShipmentLine__x(id = FakeId , CartonCount__c='TestCartonCount',CustomerPONo__c='TestCustomerPONo',MaterialDesc__c ='TestMaterialDesc',
                                                                                  Material__c ='TesMaterial',OrderQuantity__c =20,PieceCount__c ='testPieceCount',
                                                                                  SalesOrder__c ='testSalesOrder',Shade__c ='TestShade',Shipment__c='testShipment',ShippedQuantity__c=10,
                                                                                  TrackingNo__c='TestTrackingNo',UOM__c ='testUOM',Weight__c=30);

        Dal_ShipmentManager.mockallShipmentLineList.add(testShipmentLineRecord);
        
         system.debug('Dal_ShipmentManager.mockallShipmentLineList'+Dal_ShipmentManager.mockallShipmentLineList);
        //Datetime dateFrom = date.newInstance(1983, 7, 15);
        //Datetime dateTo = date.newInstance(1983, 7, 15);
        String dateFrom = '2019-04-15';
        String dateTo = '2019-05-15';
        Integer pageNo = 123;
        String shipmentNumber = '12345';
        String shipFromLoc = '12345';
        Test.startTest();
        System.runAs(newUser){
            
            Dal_ShipmentManager.getCustomerId();
            Dal_ShipmentManager.getShipmentCount();
            Dal_ShipmentManager.getShipmentDetail('4003910244');
            Dal_ShipmentManager.getShipmentList(dateFrom,dateTo,pageNo);
            Dal_ShipmentManager.searchShipments(shipmentNumber,dateFrom,null,shipFromLoc,pageNo);
            Dal_ShipmentManager.searchShipments(shipmentNumber,null,dateTo,shipFromLoc,pageNo);
			Dal_ShipmentManager.searchShipments(shipmentNumber,dateFrom,dateTo,shipFromLoc,pageNo);            
        } 
        Test.stopTest();       
    }
 
  
    
}