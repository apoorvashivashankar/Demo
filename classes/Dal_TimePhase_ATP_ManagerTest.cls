@isTest
public class Dal_TimePhase_ATP_ManagerTest {
    
    
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
            account.Division__c = 'OASIS';
            update account;
            
            UserContactDefaults__c userCont = new UserContactDefaults__c();
            userCont.Default_Account_Id__c = con.AccountId;
            userCont.Default_Contact_Record_Type_Id__c = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Daltile Internal Contact').getRecordTypeId();
            insert userCont;
            Profile p = [select Id,name from Profile where name='Customer Community Plus Login User'];
            String uniqueName = Dal_TestUtils.getUserString();
            User newUser = new User(profileId = p.id, username = uniqueName + '@test.org', email = 'pb@ff.com',
                                    emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                    timezonesidkey = 'America/Los_Angeles', alias='nuser', lastname='lastname',
                                    Selected_Location__c = account.Id, contactId = con.id
                                   );
            insert newUser;
        }
    }
    @isTest static void getATP_By_TimePhaseTest(){
        User newUser = [SELECT Id,username FROM User WHERE email = 'pb@ff.com' limit 1];
        
        Test.startTest();
        System.runAs(newUser){
            Test.setMock(WebServiceMock.class, new WebServiceMockDalImplTimePhased());
            String SKU = 'ABC';
            String supplyplantType = 'supplyplantType';
            String supplyplantId = 'supplyplantId';
            String UOM = 'uom';
            Dal_OrderProcessController.getTimePhasedResults(sku, uom, supplyplantId, supplyplantType);
            Dal_TimePhase_ATP_Manager atp_manager = new Dal_TimePhase_ATP_Manager('1','2','3','4','5');
            //List<Dal_TimePhase_ATP_Manager.ATP_TimePhase_Wrapper> atp_wrp = atp_manager.getATP_By_TimePhase();
        }
        Test.stopTest();
    }
}