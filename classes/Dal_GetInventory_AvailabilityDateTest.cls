@isTest
public class Dal_GetInventory_AvailabilityDateTest {
    
    @testSetup
    static void testSetup(){
        UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType ='None' limit 1];
        update new User(Id=userInfo.getUserId(), UserRoleId = ur.Id);
        
        
        System.runAs(new user(ID = UserInfo.getUserID())) {
            Contact con = Dal_TestUtils.createTestContact();
            
            /* DT_Order__c  order = new DT_Order__c ();
order.Name = 'FirstOrder';
insert order;*/
            
            Account account = new Account();
            account.Id = con.AccountId;
            account.DW_ID__c = '00880021';
            update account;
            
            UserContactDefaults__c userCont = new UserContactDefaults__c();
            userCont.Default_Account_Id__c = con.AccountId;
            userCont.Default_Contact_Record_Type_Id__c = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Daltile Internal Contact').getRecordTypeId();
            insert userCont;
            Profile p = [select Id,name from Profile where name='Customer Community Plus Login User'];
            
            User newUser = new User(profileId = p.id, username = 'newUser@yahoo.com', email = 'pb@ff.com',
                                    emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                    timezonesidkey = 'America/Los_Angeles', alias='nuser', lastname='lastname',
                                    Selected_Location__c = con.accountId, contactId = con.id
                                   );
            insert newUser;
            
            List<SSC__c> sscList = new List<SSC__c>();
            SSC__c ssc = new SSC__c();
            ssc.Name = 'SSC Account';
            ssc.SAP_Plant__c = '4101'; 
            sscList.add(ssc);
            insert sscList;
        }
    }
    
    private static testMethod void Dal_GetInventoryTest(){
        User newUser = [SELECT Id,username FROM User WHERE Username = 'newUser@yahoo.com'];
        
        Test.startTest();
        System.runAs(newUser){
            
            Test.setMock(WebServiceMock.class, new WebServiceMockDalAvailibiltyDateResults());
            
            String data = '[{\"sku\":\"J5051224S1P\",\"quantity\":\"1\",\"uom\":\"SF\",\"CodeSet\":\"Legacy\",\"SupplyplantId\":\"4101\",\"SupplyplantType\":\"SAP_Plant\",\"reqShipdate\":\"2018-11-17\"},{\"sku\":\"J5051224F1L\",\"quantity\":\"1\",\"uom\":\"SF\",\"CodeSet\":\"Legacy\",\"SupplyplantId\":\"4101\",\"SupplyplantType\":\"SAP_Plant\",\"reqShipdate\":\"2018-11-17\"}]';
            List<Dal_InventorySearchJSON> inventoryJson = Dal_InventorySearchJSON.parse(data);
            Dal_GetInventory_AvailabilityDate getAvilability = new Dal_GetInventory_AvailabilityDate(inventoryJson);
            getAvilability.getAvailibilityDate();            
        }
        Test.stopTest();
    }
}