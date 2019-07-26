/**
 * Created by Preshit on 05-02-2019.
 */
@isTest
public with sharing class Dal_SSC_MyCartControllerTest {

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

            Region__c r = new Region__c(Select__c = true
                    , SBU__c = 'SC'
                    , DW_ID__c = '113321'
                    , Name = 'MIDWEST REGION11');
            insert r;

            SSC__c ssc = new SSC__c(Closed__c = false
                    , DW_ID__c = '000111'
                    ,SAP_Plant__c = '4127'
                    , Loc_Type__c = 'SSC'
                    , Manager__c = UserInfo.getUserId()
                    , Region__c = r.Id
                    , Sales_Region__c = '04'
                    , SBU__c = 'DI'
                    , Select__c = true
                    , SSC_Fax_Number__c = '123-345-5567'
                    , SSC_Phone_Number__c = '123-345-5567'
                    , State__c = 'TX'
                    , Street_Address__c = '12345 1st street'
                    , Zip_Code__c = '12345');
            insert ssc;

            SSC__c ssc1 = new SSC__c(Closed__c = false
                    , DW_ID__c = '000134'
                    ,SAP_Plant__c = '4145'
                    , Loc_Type__c = 'SSC'
                    , Manager__c = UserInfo.getUserId()
                    , Region__c = r.Id
                    , Sales_Region__c = '04'
                    , SBU__c = 'DI'
                    , Select__c = true
                    , SSC_Fax_Number__c = '123-345-5223'
                    , SSC_Phone_Number__c = '123-345-5223'
                    , State__c = 'TX'
                    , Street_Address__c = '1235 12st street'
                    , Zip_Code__c = '12325');
            insert ssc1;

            SSC__c ssc2 = new SSC__c(Closed__c = false
                    , DW_ID__c = '000112'
                    ,SAP_Plant__c = '4185'
                    , Loc_Type__c = 'SSC'
                    , Manager__c = UserInfo.getUserId()
                    , Region__c = r.Id
                    , Sales_Region__c = '04'
                    , SBU__c = 'DI'
                    , Select__c = true
                    , SSC_Fax_Number__c = '123-345-7722'
                    , SSC_Phone_Number__c = '123-345-7722'
                    , State__c = 'TX'
                    , Street_Address__c = '12367 12st street'
                    , Zip_Code__c = '54321');
            insert ssc2;

            Account acc = new Account(
                    name = 'TestAcct1'
                    , OwnerId = UserInfo.getUserid()
                    , Region__c = r.id
                    , BillingStreet = '123'
                    , BillingCountry = '123'
                    , BillingCity = 'DAL'
                    , BillingState = 'TX'
                    , BillingPostalCode = '72332'
                    , ShippingStreet = '123'
                    , ShippingCountry = 'US'
                    , ShippingCity = 'DALLAS'
                    , ShippingState = 'TX'
                    , ShippingPostalCode = '72332'
                    ,  phone = '9722787827'
            );
            insert acc;

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

            DT_Cart__c cartObj = new DT_Cart__c();
            cartObj.Contact_Name__c = 'test';
            cartObj.Contact_Number__c = '1234567890';
            cartObj.Job_Name__c = 'Job';
            /*cartObj.National_Account__c = 'National';*/
            cartObj.Special_Instructions__c = 'test';
            cartObj.Status__c = 'Draft';
            cartObj.User__c = newUser.Id;
            insert cartObj;

            List<DT_Cart_Product__c> cartProductList = new List<DT_Cart_Product__c>();
            DT_Cart_Product__c cartProduct = new DT_Cart_Product__c();
            cartProduct.DT_Cart__c = cartObj.Id;
            cartProduct.Fulfillment_Method__c = 'Delivery';
            cartProduct.Shipping_Street__c = acc.ShippingStreet;
            cartProduct.Shipping_City__c = acc.ShippingCity;
            cartProduct.Shipping_State__c = acc.ShippingState;
            cartProduct.Shipping_ZIP_Code__c = acc.ShippingPostalCode;
            cartProduct.Lift_gate__c = true;
            //cartProduct.Product__c = product.Id;
            cartProduct.Quantity__c = 1;
            cartProduct.SSC__c = ssc.Id;
            cartProduct.Total_Amount__c = 1;
            //cartProduct.Total_Carton__c = 12;
            cartProduct.Unit__c = 12;
            cartProduct.UOM__c = 'SF';
            cartProductList.add(cartProduct);

            DT_Cart_Product__c cartProduct1 = new DT_Cart_Product__c();
            cartProduct1.DT_Cart__c = cartObj.Id;
            cartProduct1.Fulfillment_Method__c = 'Delivery';
            cartProduct1.Shipping_Street__c = acc.ShippingStreet;
            cartProduct1.Shipping_City__c = acc.ShippingCity;
            cartProduct1.Shipping_State__c = acc.ShippingState;
            cartProduct1.Shipping_ZIP_Code__c = acc.ShippingPostalCode;
            cartProduct1.Lift_gate__c = true;
            //cartProduct.Product__c = product.Id;
            cartProduct1.Quantity__c = 1;
            cartProduct1.SSC__c = ssc1.Id;
            cartProduct1.Total_Amount__c = 1;
            //cartProduct.Total_Carton__c = 12;
            cartProduct1.Unit__c = 12;
            cartProduct1.UOM__c = 'SF';
            cartProductList.add(cartProduct1);

            DT_Cart_Product__c cartProduct2 = new DT_Cart_Product__c();
            cartProduct2.DT_Cart__c = cartObj.Id;
            cartProduct2.Fulfillment_Method__c = 'Delivery';
            cartProduct2.Shipping_Street__c = acc.ShippingStreet;
            cartProduct2.Shipping_City__c = acc.ShippingCity;
            cartProduct2.Shipping_State__c = acc.ShippingState;
            cartProduct2.Shipping_ZIP_Code__c = acc.ShippingPostalCode;
            cartProduct2.Lift_gate__c = true;
            //cartProduct.Product__c = product.Id;
            cartProduct2.Quantity__c = 1;
            cartProduct2.SSC__c = ssc2.Id;
            cartProduct2.Total_Amount__c = 1;
            //cartProduct.Total_Carton__c = 12;
            cartProduct2.Unit__c = 12;
            cartProduct2.UOM__c = 'SF';
            cartProductList.add(cartProduct2);
            insert cartProductList;
        }

    }

    public static testMethod void getMyCartProductsCount(){
        User us = [SELECT Id,Profile.Name FROM user WHERE Id =: UserInfo.getUserId()];
        
        Test.startTest();
        System.runAs(new user(ID = UserInfo.getUserID())) {
            Dal_SSC_MyCartController.getMyCartProductsCount();   
        }
        Test.stopTest();

    }

}