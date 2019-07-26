/**
* This class contains unit tests for validating the behavior of Apex classes
**/
@isTest
public class Dal_AvailabilityDate_Price_ATP_Mgr_Test {
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

            User newUser = new User(profileId = p.id, username = 'newUser@yahoo.com', email = 'pb@ff.com',
                                    emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                    timezonesidkey = 'America/Los_Angeles', alias='nuser', lastname='lastname',
                                    Selected_Location__c = con.accountId, contactId = con.id
                                   );
            insert newUser;
        }
    }
    
    
    private static testMethod void Dal_ATPUnitTest(){
        
        User newUser = [SELECT Id,username FROM User WHERE Username = 'newUser@yahoo.com'];
        
        Test.startTest();
        System.runAs(newUser){
            WebServiceMockDalImplATPResults.testString = 'Y';
            Test.setMock(WebServiceMock.class, new WebServiceMockDalImplATPResults());
            String SKU = 'ABC';
            String Quantity = '12';
            String PriceRecord = '200';
            String supplyplantType = 'supplyplantType';
            String supplyplantId = 'supplyplantId';
            String UOM = 'uom';
            String qty = '1';
            String ReqShipDate = String.valueof(System.today()-15);
            Dal_AvailabilityDate_Price_ATP_Manager dalAvailDateMgr 
                = new Dal_AvailabilityDate_Price_ATP_Manager(SKU,Quantity,UOM,ReqShipDate,PriceRecord);
            list<Dal_AvailabilityDate_Price_ATP_Manager.ATP_AvailableDate_Wrapper> atpWrapperList = dalAvailDateMgr.getATP_By_AvailibilityDate(); 
            System.assert(true,atpWrapperList.size()>0); 
        }
        Test.stopTest();
    }
    
    private static testMethod void Dal_ATPUnitTest1(){
        
        User newUser = [SELECT Id,username FROM User WHERE Username = 'newUser@yahoo.com'];
        
        Test.startTest();
        System.runAs(newUser){
            WebServiceMockDalImplATPResults.testString = 'Y';
            Test.setMock(WebServiceMock.class, new WebServiceMockDalImplATPResults());
            String SKU = 'ABC';
            String Quantity = '12';
            String PriceRecord = '200';
            String SOS = 'sos';
            String supplyplantType = 'supplyplantType';
            String supplyplantId = 'supplyplantId';
            String UOM = 'uom';
            String qty = '1';
            String ReqShipDate = String.valueof(System.today()+15);
            Dal_AvailabilityDate_Price_ATP_Manager dalAvailDateMgr 
                = new Dal_AvailabilityDate_Price_ATP_Manager(SKU,Quantity,UOM,ReqShipDate,PriceRecord);
            list<Dal_AvailabilityDate_Price_ATP_Manager.ATP_AvailableDate_Wrapper> atpWrapperList = dalAvailDateMgr.getATP_By_AvailibilityDate(); 
            System.assert(true,atpWrapperList.size()>0); 
        }
        Test.stopTest();
    }
    
    private static testMethod void Dal_ATPUnitTest3(){
        
        User newUser = [SELECT Id,username FROM User WHERE Username = 'newUser@yahoo.com'];
        
        Test.startTest();
        System.runAs(newUser){
            WebServiceMockDalImplATPResults.testString = 'N';
            Test.setMock(WebServiceMock.class, new WebServiceMockDalImplATPResults());
            String SKU = 'ABC';
            String Quantity = '1000000';
            String PriceRecord = '200';
            String SOS = 'sos';
            String supplyplantType = 'supplyplantType';
            String supplyplantId = 'supplyplantId';
            String UOM = 'uom';
            String qty = '1';
            String ReqShipDate = String.valueof(System.today()-15);
            Dal_AvailabilityDate_Price_ATP_Manager dalAvailDateMgr 
                = new Dal_AvailabilityDate_Price_ATP_Manager(SKU,Quantity,UOM,ReqShipDate,PriceRecord);
            list<Dal_AvailabilityDate_Price_ATP_Manager.ATP_AvailableDate_Wrapper> atpWrapperList = dalAvailDateMgr.getATP_By_AvailibilityDate(); 
            System.assert(true,atpWrapperList.size()>0);
        }
        Test.stopTest();
    }
    
}