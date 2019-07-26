/**
 * Created by Yadav on 8/27/2018.
 */
@isTest(seeAllData=false)
public with sharing class Dal_OrderSampleCreateManagerTest {


    @testSetup
    static void testSetup() {
        UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType ='None' limit 1];
        update new User(Id=userInfo.getUserId(), UserRoleId = ur.Id);
        
        System.runAs(new user(ID = UserInfo.getUserID())) {
            Contact con = Dal_TestUtils.createTestContact();

            DT_Order__c dtorder = new DT_Order__c();
            dtorder.Name = 'test-dtorder-name';
            dtorder.Delegate_First_Name__c = '123';
            dtorder.Requested_Ship_date__c = system.today();
            dtorder.Default_Requested_Ship_Date__c = system.today();
            dtorder.Carrier__c = '8ret';
            insert dtorder;

            DT_Order_Product__c dtorderproduct = new DT_Order_Product__c();
            dtorderproduct.Name = '0000';
            dtorderproduct.DT_Order_Id__c = dtorder.Id;
            insert dtorderproduct;

            Account account = new Account();
            account.Id = con.AccountId;
            account.DW_ID__c = '00880021';
            account.Division__c = 'OASIS';
            update account;

            UserContactDefaults__c userCont = new UserContactDefaults__c();
            userCont.Default_Account_Id__c = con.AccountId;
            userCont.Default_Contact_Record_Type_Id__c = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Daltile Internal Contact').getRecordTypeId();
            insert userCont;

            User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
            System.runAs ( thisUser ) {
                Profile p = [select Id,name from Profile where name = 'Customer Community Plus Login User'];
                String uniqueName = Dal_TestUtils.getUserString();
                User newUser = new User(profileId = p.id, username = uniqueName + '@test.org', email = 'pb@ff.com',
                        emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                        timezonesidkey = 'America/Los_Angeles', alias = 'nuser', lastname = 'lastname',
                        Selected_Location__c = account.Id, contactId = con.id
                );
                insert newUser;
            }
        }

    }
    @isTest static void testMethod1() {
        /*Profile p = [select Id,name from Profile where name='Customer Community Plus Login User'];
        Contact con = [SELECT Id FROM Contact LIMIT 1];
        Account account = [SELECT Id FROM Account LIMIT 1];
        User newUser = new User(profileId = p.id, username = 'newUser@yahoo.com', email = 'pb@ff.com',
        emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
        timezonesidkey = 'America/Los_Angeles', alias='nuser', lastname='lastname',
        Selected_Location__c = account.Id, contactId = con.id
        );
        insert newUser; */
        User newUser = [SELECT Id,username FROM User where email = 'pb@ff.com'  LIMIT 1];
        String json = '{\"productOrderLines\":[{\"Address\":\"199 PLANTERS ROAD\",\"availableQty\":\"10.000\",\"BaseUOM\":\"EA\",\"Color\":\"BV95\",\"Country\":\"US\",\"ExtendedWeight\":2.78,\"isAdded\":true,\"OnHandQty\":\"10.000\",\"productId\":\"01t0G000004TaDKQA0\",\"ProductLine\":\"LOOSE TILE (0615)\",\"productName\":\"10X14 SAMPLE    BV95 DOVE            STD\",\"quantityLst\":[1,2,3,4,5],\"SAP_Plant\":\"4101\",\"selectedQuantity\":1,\"sku\":\"BV951014SAM1P2\",\"totalQuantity\":0,\"Zip\":\"75182-9601\",\"estimatedAvailabilityDate\":\"08/24/18\"},{\"Address\":\"199 PLANTERS ROAD\",\"availableQty\":\"7.000\",\"BaseUOM\":\"EA\",\"Color\":\"BV95\",\"Country\":\"US\",\"ExtendedWeight\":4.17,\"isAdded\":true,\"OnHandQty\":\"8.000\",\"productId\":\"01t0G000004TlqrQAC\",\"ProductLine\":\"LOOSE TILE (0615)\",\"productName\":\"12X24 SAM       BV95 DOVE            STD\",\"quantityLst\":[1,2,3,4,5],\"SAP_Plant\":\"4101\",\"selectedQuantity\":1,\"sku\":\"BV951224PSAM1P6\",\"totalQuantity\":0,\"Zip\":\"75182-9601\",\"estimatedAvailabilityDate\":\"08/24/18\"}],\"orderDetails\":{\"selectedAddress\":{\"name\":\"Ray Test Dist 8082001\",\"isActive\":true,\"isPrimary\":true},\"freightTerms\":\"Prepaid\",\"isShipComplete\":\"no\",\"carrier\":\"UPS Ground\",\"isSmallPackage\":\"yes\",\"poNumber\":\"po\",\"jobName\":\"job\"},\"cumulativeOrderWeight\":\"6.95\"}';
        Test.startTest();
        System.runAs(newUser) {
            Test.setMock(WebServiceMock.class, new Dal_OrderCreateMock());
            Dal_OrderSampleManager.createSampleOrder(json);
        }
        test.stopTest();
    }


}