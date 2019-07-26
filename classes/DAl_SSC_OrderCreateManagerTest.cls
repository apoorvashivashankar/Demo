/**
 * Created by Preshit on 31-01-2019.
 */
@istest
public with sharing class DAl_SSC_OrderCreateManagerTest {

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
                    , Loc_Type__c = 'SSC'
                    ,SAP_Plant__c = '4185'
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
            
            DT_Cart__c cartObj1 = new DT_Cart__c();
            cartObj1.Contact_Name__c = 'test contact';
            cartObj1.Contact_Number__c = '1234567840';
            cartObj1.Job_Name__c = 'Test Job';
            /*cartObj1.National_Account__c = 'National';*/
            cartObj1.Special_Instructions__c = 'test';
            cartObj1.Status__c = 'Draft';
            cartObj1.User__c = newUser.Id;
            insert cartObj1;

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
            cartProduct1.DT_Cart__c = cartObj1.Id;
            cartProduct1.Fulfillment_Method__c = 'Pickup';
            cartProduct1.Shipping_Street__c = acc.ShippingStreet;
            cartProduct1.Shipping_City__c = acc.ShippingCity;
            cartProduct1.Shipping_State__c = acc.ShippingState;
            cartProduct1.Shipping_ZIP_Code__c = acc.ShippingPostalCode;
            cartProduct1.Lift_gate__c = true;
            //cartProduct1.Product__c = product.Id;
            cartProduct1.Quantity__c = 1;
            cartProduct1.SSC__c = ssc.Id;
            cartProduct1.Total_Amount__c = 1;
            //cartProduct.Total_Carton__c = 12;
            cartProduct1.Unit__c = 12;
            cartProduct1.UOM__c = 'SF';
            cartProductList.add(cartProduct1);
            
            insert cartProductList;
        }

    }


    private static testMethod void Dal_OrderCreate(){

        User newUser = [SELECT Id,username FROM User WHERE Username = 'newUser@yahoo.com'];
        Account acc = [SELECT Id,Name FROM Account LIMIT 1];

        DT_Cart__c dtCart = [SELECT Id,Name FROM DT_Cart__c WHERE Contact_Name__c = 'test' LIMIT 1];
        
        DT_Cart__c dtCart1 = [SELECT Id,Name FROM DT_Cart__c WHERE Contact_Name__c = 'test contact' LIMIT 1];

        /*List<String> testData = new list<String>();
        testData.add('test');*/
        //String Data = '[{"sku":"0100661P4","quantity":"1","uom":"SF","CodeSet":"Legacy","SupplyplantId":"4173","SupplyplantType":"SAP_Plant","reqShipdate":"2018-11-20"},{"sku":"J5051224F1L","quantity":"1","uom":"SF","CodeSet":"Legacy","SupplyplantId":"4101","SupplyplantType":"SAP_Plant","reqShipdate":"2018-11-20"}]';

        //String cartTwoOrderData = '[{"accountCreditRiskCategory":"D70","availableQty":"11.50","dateAtSupplyPlant":"02-04","dateAtSupplyPlantFinal":"02-11","energySurCharge":0.0203,"milesWrapperList":[],"onTimeFlag":"Y","pricingUOM":"SF","pricingUOM_NetPrice":2.03,"sku":"BX01661P2","SOS":"1","supplyPlant":"SSC Arlington, TX","supplyPlantId":"4185","totalCartons":"0","Size":"6 X 6","Description":"Brixton Field Tile Wall 6x6 BONE Glazed","Color":"BONE","BaseUOM":"SF","ShowTill":5,"uomList":["PC","EA","SF","CT","PL","SM"],"PiecesPerCarton__c":50,"SquarefeetPerCarton__c":12.5,"updatedQuantity":"11","updatedBaseUOM":"SF","PiecesPerCarton":50,"SquarefeetPerCarton":12.5},{"accountCreditRiskCategory":"D70","availableQty":"0","dateAtSupplyPlant":"02-04","dateAtSupplyPlantFinal":"02-11","energySurCharge":0.0206,"milesWrapperList":[{"availableQty":"5950.00","miles":"10.34","sku":"K101661P1","supplyPlanCity":"CARROLLTON","supplyplantID":"4185","supplyPlantName":"SSC Carrollton, TX","totalCartons":"476"},{"availableQty":"85.00","miles":"14.17","sku":"K101661P1","supplyPlanCity":"HALTOM CITY","supplyplantID":"4145","supplyPlantName":"SSC Fort Worth, TX","totalCartons":"6"},{"availableQty":"10.25","miles":"16.18","sku":"K101661P1","supplyPlanCity":"ARLINGTON","supplyplantID":"4145","supplyPlantName":"SSC Arlington, TX","totalCartons":"0"},{"availableQty":"22.50","miles":"24.23","sku":"K101661P1","supplyPlanCity":"PLANO","supplyplantID":"4107","supplyPlantName":"SSC Plano, TX","totalCartons":"1"}],"onTimeFlag":"Y","pricingUOM":"SF","pricingUOM_NetPrice":2.06,"sku":"K101661P1","SOS":"1","supplyPlant":"SSC Southlake, TX","supplyPlantId":"4185","totalCartons":"0","Size":"6 X 6","Description":"Semi Gloss Field Tile 6x6 WHITE Group 2 Glazed","Color":"WHITE","BaseUOM":"SF","ShowTill":5,"uomList":["PC","EA","SF","CT","PL","SM"],"PiecesPerCarton__c":50,"SquarefeetPerCarton__c":12.5,"updatedQuantity":"12","updatedBaseUOM":"CT","PiecesPerCarton":50,"SquarefeetPerCarton":12.5}]';
        Test.startTest();
        	Test.setMock(WebServiceMock.class, new Dal_GetPriceMock());
        	//Test.setMock(WebServiceMock.class, new MockDispatcher());
        	
        System.runAs(newUser){
			//Test.setMock(WebServiceMock.class, new WebServiceMockDalCalculatorResults());
        	//Test.setMock(WebServiceMock.class, new WebServiceMock_SSC_OrderCreate());
            //Test.setMock(WebServiceMock.class, new WebServiceMockDalCalculatorResults());
            //Test.setMock(WebServiceMock.class, new WebServiceMockDalTaxExemption());
            
            //Test.setMock(WebServiceMock.class, new WebServiceMockDalCalculatorResults());
            
            try{
                DAl_SSC_OrderCreateManager orderCreateManager = new DAl_SSC_OrderCreateManager(dtCart.Id);
            	orderCreateManager.getOrderCreate();
                //Test.setMock(WebServiceMock.class, new WebServiceMockDalCalculatorResults());
                DAl_SSC_OrderCreateManager orderCreateManager1 = new DAl_SSC_OrderCreateManager(dtCart1.Id);
            	orderCreateManager1.getOrderCreate();
            }catch(Exception e){
                
            }
            
        }
        Test.stopTest();

    }
    
    private static testMethod void Dal_OrderCreate1(){

        User newUser = [SELECT Id,username FROM User WHERE Username = 'newUser@yahoo.com'];
        Account acc = [SELECT Id,Name FROM Account LIMIT 1];
        DT_Cart__c dtCart = [SELECT Id,Name FROM DT_Cart__c WHERE Contact_Name__c = 'test' LIMIT 1];
        DT_Cart__c dtCart1 = [SELECT Id,Name FROM DT_Cart__c WHERE Contact_Name__c = 'test contact' LIMIT 1];

        Test.startTest();
        System.runAs(newUser){

            Test.setMock(WebServiceMock.class, new WebServiceMockDalCalculatorResults());
            //Test.setMock(WebServiceMock.class, new WebServiceMockDalTaxExemption());
            Test.setMock(WebServiceMock.class, new Dal_GetPriceMock());
            //Test.setMock(WebServiceMock.class, new WebServiceMockDalCalculatorResults());
            Test.setMock(WebServiceMock.class, new WebServiceMock_SSC_OrderCreate());
            
            DAl_SSC_OrderCreateManager orderCreateManager = new DAl_SSC_OrderCreateManager(dtCart.Id);
            orderCreateManager.getOrderCreate();
            
            DAl_SSC_OrderCreateManager orderCreateManager1 = new DAl_SSC_OrderCreateManager(dtCart1.Id);
            orderCreateManager1.getOrderCreate();

        }
        Test.stopTest();
    }
}