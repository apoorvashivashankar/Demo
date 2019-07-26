@istest
public class Dal_InventorySearchControllerTest {
    
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
            
            Contact con1 = new Contact(accountId = account.Id, lastName = 'test2',firstName='testFName',email='test@test.com',Contact_Type__c = 'Service');
            insert con1;
            
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
            
            User newUser1 = new User(profileId = p.id, username = 'newUser1@yahoo.com', email = 'pb1@ff.com',
                                    emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                    timezonesidkey = 'America/Los_Angeles', alias='nuser1', lastname='lastname1',
                                    Selected_Location__c = con1.accountId, contactId = con1.id
                                   );
            insert newUser1;


            DT_Cart__c cartObj = new DT_Cart__c();
            cartObj.Contact_Name__c = 'test';
            cartObj.Contact_Number__c = '1234567890';
            cartObj.Job_Name__c = 'Job';
            /*cartObj.National_Account__c = 'National';*/
            cartObj.Special_Instructions__c = 'test';
            cartObj.Status__c = 'Draft';
            cartObj.User__c = newUser.Id;
            cartObj.Cart_Account__c = account.Id;
            insert cartObj;
            
            DT_Cart__c cartObj1 = new DT_Cart__c();
            cartObj1.Contact_Name__c = 'test';
            cartObj1.Contact_Number__c = '124567890';
            cartObj1.Job_Name__c = 'Job';
            /*cartObj1.National_Account__c = 'National';*/
            cartObj1.Special_Instructions__c = 'test';
            cartObj1.Status__c = 'Draft';
            cartObj1.User__c = UserInfo.getUserId();
            cartObj1.Cart_Account__c = account.Id;
            insert cartObj1;

            List<DT_Cart_Product__c> cartProductList = new List<DT_Cart_Product__c>();
            DT_Cart_Product__c cartProduct = new DT_Cart_Product__c();
            cartProduct.DT_Cart__c = cartObj1.Id;
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
            
            DT_Cart_Product__c cartProduct3 = new DT_Cart_Product__c();
            cartProduct3.DT_Cart__c = cartObj.Id;
            cartProduct3.Fulfillment_Method__c = 'Delivery';
            cartProduct3.Shipping_Street__c = acc.ShippingStreet;
            cartProduct3.Shipping_City__c = acc.ShippingCity;
            cartProduct3.Shipping_State__c = acc.ShippingState;
            cartProduct3.Shipping_ZIP_Code__c = acc.ShippingPostalCode;
            cartProduct3.Lift_gate__c = true;
            //cartProduct3.Product__c = product.Id;
            cartProduct3.Quantity__c = 1;
            cartProduct3.SSC__c = ssc.Id;
            cartProduct3.Total_Amount__c = 1;
            //cartProduct3.Total_Carton__c = 12;
            cartProduct3.Unit__c = 12;
            cartProduct3.UOM__c = 'SF';
			cartProductList.add(cartProduct3);
            
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
    
    
    private static testMethod void Dal_CalTest(){
        User newUser = [SELECT Id,username FROM User WHERE Username = 'newUser@yahoo.com'];
        List<String> testData = new list<String>();
        testData.add('test');
        String Data = '[{"sku":"0100661P4","quantity":"1","uom":"SF","CodeSet":"Legacy","SupplyplantId":"4173","SupplyplantType":"SAP_Plant","reqShipdate":"2018-11-20"},{"sku":"J5051224F1L","quantity":"1","uom":"SF","CodeSet":"Legacy","SupplyplantId":"4101","SupplyplantType":"SAP_Plant","reqShipdate":"2018-11-20"}]';
        Test.startTest();
        System.runAs(newUser){
            WebServiceMockDalImplATPResults.testString = 'Y';
            Test.setMock(WebServiceMock.class, new WebServiceMockDalCalculatorResults());
            //Test.setMock(WebServiceMock.class, new WebServiceMockDalImplATPResults());
            //Test.setMock(WebServiceMock.class, new WebServiceMockDalImplShadeDetails());
            //Test.setMock(WebServiceMock.class, new WebServiceMockDalImplInventoryAtLocation());
            //Test.setMock(WebServiceMock.class, new WebServiceMockDalAvailibiltyDateResults());
            
            //Test.setMock(WebServiceMock.class, new WebServiceMockDalGetInvMilesResults());
           // Dal_InventorySearchController inveCtrl = new Dal_InventorySearchController();
            Dal_InventorySearchController.getDivision();
            Dal_InventorySearchController.getSize();
            Dal_InventorySearchController.getVendors();
            Dal_InventorySearchController.getProduct('blue','test');
            Dal_InventorySearchController.getInventorySeries('test');
            Dal_InventorySearchController.getMiles('test', 'test', '50');
            Dal_InventorySearchController.vendorProducts('test','test');
            Dal_InventorySearchController.getInventoryRecord(Data);
            Dal_InventorySearchController.getInventoryColorCodes('test','test');
            Dal_InventorySearchController.getProductList(testData, 'test','test');
            Dal_InventorySearchController.sizedProducts(testData, testData,'test','test');
            Dal_InventorySearchController.getConversionCalculation('test', 'test', 'test');
            Dal_InventorySearchController.addBussinessDays(system.today(), 12);
            Dal_InventorySearchController.getInventorySeriesCreate('test');
            Test.setMock(WebServiceMock.class, new WebServiceMockDalImplAddValidation());
            Dal_InventorySearchController.getAddress('ABC', '1553  Oakwood Avenue', 'New York', 'New York', 'US', '10001');
            //Dal_InventorySearchController.getConversionCalculation('test', 'test', '1');
        }
        Test.stopTest();
    }
    
    private static testMethod void Dal_ATPUnitTest(){
        User newUser = [SELECT Id,username FROM User WHERE Username = 'newUser@yahoo.com'];
        Account acc = [SELECT Id,Name FROM Account LIMIT 1];
        List<String> testData = new list<String>();
        testData.add('test');
        String Data = '[{"sku":"0100661P4","quantity":"1","uom":"SF","CodeSet":"Legacy","SupplyplantId":"4173","SupplyplantType":"SAP_Plant","reqShipdate":"2018-11-20"},{"sku":"J5051224F1L","quantity":"1","uom":"SF","CodeSet":"Legacy","SupplyplantId":"4101","SupplyplantType":"SAP_Plant","reqShipdate":"2018-11-20"}]';

        String cartTwoOrderData = '[{"accountCreditRiskCategory":"D70","availableQty":"11.50","dateAtSupplyPlant":"02-04","dateAtSupplyPlantFinal":"02-11","energySurCharge":0.0203,"milesWrapperList":[],"onTimeFlag":"Y","pricingUOM":"SF","pricingUOM_NetPrice":2.03,"sku":"BX01661P2","SOS":"1","supplyPlant":"SSC Arlington, TX","supplyPlantId":"4184","totalCartons":"0","Size":"6 X 6","Description":"Brixton Field Tile Wall 6x6 BONE Glazed","Color":"BONE","BaseUOM":"SF","ShowTill":5,"uomList":["PC","EA","SF","CT","PL","SM"],"PiecesPerCarton__c":50,"SquarefeetPerCarton__c":12.5,"updatedQuantity":"11","updatedBaseUOM":"SF","PiecesPerCarton":50,"SquarefeetPerCarton":12.5},{"accountCreditRiskCategory":"D70","availableQty":"0","dateAtSupplyPlant":"02-04","dateAtSupplyPlantFinal":"02-11","energySurCharge":0.0206,"milesWrapperList":[{"availableQty":"5950.00","miles":"10.34","sku":"K101661P1","supplyPlanCity":"CARROLLTON","supplyplantID":"4145","supplyPlantName":"SSC Carrollton, TX","totalCartons":"476"},{"availableQty":"85.00","miles":"14.17","sku":"K101661P1","supplyPlanCity":"HALTOM CITY","supplyplantID":"4145","supplyPlantName":"SSC Fort Worth, TX","totalCartons":"6"},{"availableQty":"10.25","miles":"16.18","sku":"K101661P1","supplyPlanCity":"ARLINGTON","supplyplantID":"4145","supplyPlantName":"SSC Arlington, TX","totalCartons":"0"},{"availableQty":"22.50","miles":"24.23","sku":"K101661P1","supplyPlanCity":"PLANO","supplyplantID":"4107","supplyPlantName":"SSC Plano, TX","totalCartons":"1"}],"onTimeFlag":"Y","pricingUOM":"SF","pricingUOM_NetPrice":2.06,"sku":"K101661P1","SOS":"1","supplyPlant":"SSC Southlake, TX","supplyPlantId":"4185","totalCartons":"0","Size":"6 X 6","Description":"Semi Gloss Field Tile 6x6 WHITE Group 2 Glazed","Color":"WHITE","BaseUOM":"SF","ShowTill":5,"uomList":["PC","EA","SF","CT","PL","SM"],"PiecesPerCarton__c":50,"SquarefeetPerCarton__c":12.5,"updatedQuantity":"12","updatedBaseUOM":"CT","PiecesPerCarton":50,"SquarefeetPerCarton":12.5}]';
        Test.startTest();
        System.runAs(newUser){
            WebServiceMockDalImplATPResults.testString = 'Y';
            //Test.setMock(WebServiceMock.class, new WebServiceMockDalCalculatorResults());
            Test.setMock(WebServiceMock.class, new WebServiceMockDalImplATPResults());
            //Test.setMock(WebServiceMock.class, new WebServiceMockDalImplShadeDetails());
            //Test.setMock(WebServiceMock.class, new WebServiceMockDalImplInventoryAtLocation());
            //Test.setMock(WebServiceMock.class, new WebServiceMockDalAvailibiltyDateResults());
            
            //Test.setMock(WebServiceMock.class, new WebServiceMockDalGetInvMilesResults());
           // Dal_InventorySearchController inveCtrl = new Dal_InventorySearchController();
          
            Dal_InventorySearchController.getInventoryRecord(Data);
            Dal_InventorySearchController.getAccountName(acc.Id);
            Dal_InventorySearchController.addToCart(cartTwoOrderData);
            
        }
        Test.stopTest();
    }
    
    private static testMethod void addToCartElse(){
        User newUser = [SELECT Id,username FROM User WHERE Username = 'newUser1@yahoo.com'];
        Account acc = [SELECT Id,Name FROM Account LIMIT 1];
       	
        Product2 prod = new Product2(Name = 'Laptop X200',DW_ID__c = 'D144S862MS1P');
        insert prod;
        
        Test.startTest();
            System.runAs(newUser){
                String cartValue = '[{"accountCreditRiskCategory":"D01","availableQty":"0","dateAtSupplyPlant":"02-04","dateAtSupplyPlantFinal":"02-11","energySurCharge":0.174,"milesWrapperList":[],"onTimeFlag":"Y","pricingUOM":"LF","pricingUOM_NetPrice":4.35,"sku":"D144S862MS1P","SOS":"1","supplyPlant":"SSC Anaheim, CA","supplyPlantId":"4127","totalCartons":"0","Size":"S862","Description":"S862 MS         D144 ARTISAN BROWN   STD","Color":"ARTISAN BROWN","BaseUOM":"LF","ShowTill":5,"uomList":["PC","SF","CT","PL","LF","SM"],"PiecesPerCarton__c":15,"SquarefeetPerCarton__c":25.5,"updatedQuantity":1,"updatedBaseUOM":"LF","PiecesPerCarton":15,"SquarefeetPerCarton":25.5}]';
                Dal_InventorySearchController.addToCart(cartValue);
            }
        Test.stopTest();
    }
    
    private static testMethod void Dal_LocationTest(){
        User newUser = [SELECT Id,username FROM User WHERE Username = 'newUser@yahoo.com'];
        DT_Cart__c dtCart = [SELECT Id,Name FROM DT_Cart__c WHERE Contact_Name__c = 'test' LIMIT 1];
        List<DT_Cart_Product__c> dtCartProduct =[SELECT Id,Name FROM DT_Cart_Product__c];
        List<String> testData = new list<String>();
        testData.add('test');
        String Data = '[{"sku":"0100661P4","quantity":"1","uom":"SF","CodeSet":"Legacy","SupplyplantId":"4173","SupplyplantType":"SAP_Plant","reqShipdate":"2018-11-20"},{"sku":"J5051224F1L","quantity":"1","uom":"SF","CodeSet":"Legacy","SupplyplantId":"4101","SupplyplantType":"SAP_Plant","reqShipdate":"2018-11-20"}]';

        String cartValue = '[{"accountCreditRiskCategory":"D01","availableQty":"0","dateAtSupplyPlant":"02-04","dateAtSupplyPlantFinal":"02-11","energySurCharge":0.174,"milesWrapperList":[],"onTimeFlag":"Y","pricingUOM":"LF","pricingUOM_NetPrice":4.35,"sku":"D144S862MS1P","SOS":"1","supplyPlant":"SSC Anaheim, CA","supplyPlantId":"4127","totalCartons":"0","Size":"S862","Description":"S862 MS         D144 ARTISAN BROWN   STD","Color":"ARTISAN BROWN","BaseUOM":"LF","ShowTill":5,"uomList":["PC","SF","CT","PL","LF","SM"],"PiecesPerCarton__c":15,"SquarefeetPerCarton__c":25.5,"updatedQuantity":1,"updatedBaseUOM":"LF","PiecesPerCarton":15,"SquarefeetPerCarton":25.5}]';

        String updateCartDetail = '[{"availableQuantity":"","availableUOM":"nullPC,SF,CT,PL,LF,SM","baseUOM":"LF","cartId":"a3v29000000PkTmAAK","cartLst":[{"Id":"a3v29000000PkTmAAK","Name":"DC-000024","User__c":"00529000002bGFAAA2","Special_Instructions__c":"test","Job_Name__c":"Job Name 123","National_Account__c":"0012900000Mb00aAAB","Contact_Name__c":"test contact","Contact_Number__c":"2346784745","Status__c":"Draft","Tax_Exempt":false,"Status":"Draft","Special_Instructions":"test","Job_Name":"Job Name 123","National_Account_Field":"0012900000Mb00aAAB","Contact_Name":"test contact","Contact_Number":"2346784745","User":"00529000002bGFAAA2"}],"energySurcharge":0.174,"fulfillmentType":"Delivery","isDelivery":true,"isPickUp":false,"liftGate":true,"productId":"'+dtCartProduct[0].Id+'","productName":"S862 MS         D144 ARTISAN BROWN   STD","productSKU":"D144S862MS1P","quantity":10,"shippingCity":"Brooklyn","shippingCountry":"","shippingName":"ray test ssc","shippingState":"NY","shippingStreet":"2453  Turkey Pen Road","shippingZIPCode":"11206","supplyPlantCity":"","supplyPlantCountry":"US","supplyPlantId":"4127","supplyPlantName":"SSC Anaheim, CA","supplyPlantState":"","supplyPlantStreet_Address":"","supplyPlantZip_Code":"","totalCarton":"","unit":4.35,"UOM":"LF","updatedQuantity":10,"updatedUOM":"LF","listOfUOM":["PC","SF","CT","PL","LF","SM"]},{"availableQuantity":"","availableUOM":"nullPC,SF,CT,PL,LF,SM","baseUOM":"LF","cartId":"a3v29000000PkTmAAK","cartLst":[{"Id":"a3v29000000PkTmAAK","Name":"DC-000024","User__c":"00529000002bGFAAA2","Special_Instructions__c":"test","Job_Name__c":"Job Name 123","National_Account__c":"0012900000Mb00aAAB","Contact_Name__c":"test contact","Contact_Number__c":"2346784745","Status__c":"Draft","Tax_Exempt":false,"Status":"Draft","Special_Instructions":"test","Job_Name":"Job Name 123","National_Account_Field":"0012900000Mb00aAAB","Contact_Name":"test contact","Contact_Number":"2346784745","User":"00529000002bGFAAA2"}],"energySurcharge":0.174,"fulfillmentType":"Delivery","isDelivery":true,"isPickUp":false,"liftGate":true,"productId":"a3w29000000JnnvAAC","productName":"S862 MS         D144 ARTISAN BROWN   STD","productSKU":"D144S862MS1P","quantity":1,"shippingCity":"Brooklyn","shippingCountry":"","shippingName":"ray test ssc","shippingState":"NY","shippingStreet":"2453  Turkey Pen Road","shippingZIPCode":"11206","supplyPlantCity":"","supplyPlantCountry":"US","supplyPlantId":"4127","supplyPlantName":"SSC Anaheim, CA","supplyPlantState":"","supplyPlantStreet_Address":"","supplyPlantZip_Code":"","totalCarton":"","unit":4.35,"UOM":"LF","updatedQuantity":1,"updatedUOM":"LF","listOfUOM":["PC","SF","CT","PL","LF","SM"]},{"availableQuantity":"","availableUOM":"nullPC,SF,CT,PL,LF,SM","baseUOM":"CT","cartId":"a3v29000000PkTmAAK","cartLst":[{"Id":"a3v29000000PkTmAAK","Name":"DC-000024","User__c":"00529000002bGFAAA2","Special_Instructions__c":"test","Job_Name__c":"Job Name 123","National_Account__c":"0012900000Mb00aAAB","Contact_Name__c":"test contact","Contact_Number__c":"2346784745","Status__c":"Draft","Tax_Exempt":false,"Status":"Draft","Special_Instructions":"test","Job_Name":"Job Name 123","National_Account_Field":"0012900000Mb00aAAB","Contact_Name":"test contact","Contact_Number":"2346784745","User":"00529000002bGFAAA2"}],"energySurcharge":0.174,"fulfillmentType":"Delivery","isDelivery":true,"isPickUp":false,"liftGate":true,"productId":"a3w29000000NVoMAAW","productName":"S862 MS         D144 ARTISAN BROWN   STD","productSKU":"D144S862MS1P","quantity":11,"shippingCity":"Brooklyn","shippingCountry":"","shippingName":"ray test ssc","shippingState":"NY","shippingStreet":"2453  Turkey Pen Road","shippingZIPCode":"11206","supplyPlantCity":"","supplyPlantCountry":"US","supplyPlantId":"4127","supplyPlantName":"SSC Anaheim, CA","supplyPlantState":"","supplyPlantStreet_Address":"","supplyPlantZip_Code":"","totalCarton":"","unit":4.35,"UOM":"CT","updatedQuantity":11,"updatedUOM":"CT","listOfUOM":["PC","SF","CT","PL","LF","SM"]},{"availableQuantity":"","availableUOM":"nullPC,SF,CT,PL,LF,SM","baseUOM":"LF","cartId":"a3v29000000PkTmAAK","cartLst":[{"Id":"a3v29000000PkTmAAK","Name":"DC-000024","User__c":"00529000002bGFAAA2","Special_Instructions__c":"test","Job_Name__c":"Job Name 123","National_Account__c":"0012900000Mb00aAAB","Contact_Name__c":"test contact","Contact_Number__c":"2346784745","Status__c":"Draft","Tax_Exempt":false,"Status":"Draft","Special_Instructions":"test","Job_Name":"Job Name 123","National_Account_Field":"0012900000Mb00aAAB","Contact_Name":"test contact","Contact_Number":"2346784745","User":"00529000002bGFAAA2"}],"energySurcharge":0.174,"fulfillmentType":"Delivery","isDelivery":true,"isPickUp":false,"liftGate":true,"productId":"a3w29000000JnnqAAC","productName":"S862 MS         D144 ARTISAN BROWN   STD","productSKU":"D144S862MS1P","quantity":11,"shippingCity":"Brooklyn","shippingCountry":"","shippingName":"ray test ssc","shippingState":"NY","shippingStreet":"2453  Turkey Pen Road","shippingZIPCode":"11206","supplyPlantCity":"","supplyPlantCountry":"US","supplyPlantId":"4127","supplyPlantName":"SSC Anaheim, CA","supplyPlantState":"","supplyPlantStreet_Address":"","supplyPlantZip_Code":"","totalCarton":"","unit":4.35,"UOM":"LF","updatedQuantity":11,"updatedUOM":"LF","listOfUOM":["PC","SF","CT","PL","LF","SM"]},{"availableQuantity":"","availableUOM":"nullPC,SF,CT,PL,LF,SM","baseUOM":"LF","cartId":"a3v29000000PkTmAAK","cartLst":[{"Id":"a3v29000000PkTmAAK","Name":"DC-000024","User__c":"00529000002bGFAAA2","Special_Instructions__c":"test","Job_Name__c":"Job Name 123","National_Account__c":"0012900000Mb00aAAB","Contact_Name__c":"test contact","Contact_Number__c":"2346784745","Status__c":"Draft","Tax_Exempt":false,"Status":"Draft","Special_Instructions":"test","Job_Name":"Job Name 123","National_Account_Field":"0012900000Mb00aAAB","Contact_Name":"test contact","Contact_Number":"2346784745","User":"00529000002bGFAAA2"}],"energySurcharge":0.174,"fulfillmentType":"Delivery","isDelivery":true,"isPickUp":false,"liftGate":true,"productId":"a3w29000000NVneAAG","productName":"S862 MS         D144 ARTISAN BROWN   STD","productSKU":"D144S862MS1P","quantity":13,"shippingCity":"Brooklyn","shippingCountry":"","shippingName":"ray test ssc","shippingState":"NY","shippingStreet":"2453  Turkey Pen Road","shippingZIPCode":"ray test ssc","supplyPlantCity":"","supplyPlantCountry":"US","supplyPlantId":"4124","supplyPlantName":"DANIA BEACH TILE & STONE G","supplyPlantState":"","supplyPlantStreet_Address":"","supplyPlantZip_Code":"","totalCarton":"","unit":4.35,"UOM":"LF","updatedQuantity":13,"updatedUOM":"LF","listOfUOM":["PC","SF","CT","PL","LF","SM"]},{"availableQuantity":"","availableUOM":"nullPC,SF,CT,PL,LF,SM","baseUOM":"LF","cartId":"a3v29000000PkTmAAK","cartLst":[{"Id":"a3v29000000PkTmAAK","Name":"DC-000024","User__c":"00529000002bGFAAA2","Special_Instructions__c":"test","Job_Name__c":"Job Name 123","National_Account__c":"0012900000Mb00aAAB","Contact_Name__c":"test contact","Contact_Number__c":"2346784745","Status__c":"Draft","Tax_Exempt":false,"Status":"Draft","Special_Instructions":"test","Job_Name":"Job Name 123","National_Account_Field":"0012900000Mb00aAAB","Contact_Name":"test contact","Contact_Number":"2346784745","User":"00529000002bGFAAA2"}],"energySurcharge":0.1788,"fulfillmentType":"Delivery","isDelivery":true,"isPickUp":false,"liftGate":true,"productId":"a3w29000000NVnfAAG","productName":"S886 MS         D144 ARTISAN BROWN   STD","productSKU":"D144S886MS1P","quantity":24,"shippingCity":"Brooklyn","shippingCountry":"","shippingName":"ray test ssc","shippingState":"NY","shippingStreet":"2453  Turkey Pen Road","shippingZIPCode":"ray test ssc","supplyPlantCity":"","supplyPlantCountry":"US","supplyPlantId":"4127","supplyPlantName":"DANIA BEACH TILE & STONE G","supplyPlantState":"","supplyPlantStreet_Address":"","supplyPlantZip_Code":"","totalCarton":"","unit":4.47,"UOM":"LF","updatedQuantity":24,"updatedUOM":"LF","listOfUOM":["PC","SF","CT","PL","LF","SM"]}]';

        String saveCheckoutDetail = '{"contactName":"test contact","contactNumber":"2346784745","Id":"'+dtCart.Id+'","jobName":"Job Name 123","nationalAccountId":"","nationalAccountIdNew":"","nationalAccountName":"","nationalAccountNameNew":"","po":"PO 1234","recordTypeId":"","specialInstruction":"test","status":"Draft","taxExempt":false}';
        Test.startTest();
        System.runAs(newUser){
            WebServiceMockDalImplATPResults.testString = 'Y';
            //Test.setMock(WebServiceMock.class, new WebServiceMockDalCalculatorResults());
            //Test.setMock(WebServiceMock.class, new WebServiceMockDalImplATPResults());
            Test.setMock(WebServiceMock.class, new WebServiceMockDalImplShadeDetails());
            Test.setMock(WebServiceMock.class, new WebServiceMockDalImplInventoryAtLocation());

            Test.setMock(WebServiceMock.class, new WebServiceMockDalTaxExemption());
            Test.setMock(WebServiceMock.class, new WebServiceMock_SSC_OrderCreate());
            
            //Test.setMock(WebServiceMock.class, new WebServiceMockDalGetInvMilesResults());
           // Dal_InventorySearchController inveCtrl = new Dal_InventorySearchController();
          
            Dal_InventorySearchController.getInventoryRecord(Data);
            Dal_InventorySearchController.getTaxExemption();
            Dal_InventorySearchController.getCartProducts();
            Dal_InventorySearchController.getMyCartProducts();
            Dal_InventorySearchController.addToCart(cartValue);
            Dal_InventorySearchController.getCheckoutCart(updateCartDetail);
            Dal_InventorySearchController.getCountries();
            
        }
        
        Dal_InventorySearchController.saveCheckoutDetail(saveCheckoutDetail);
        Dal_InventorySearchController.deleteProduct(dtCartProduct[0].Id);
        Test.stopTest();
    }
    
    private static testMethod void Dal_SSCOrderPlaceTest(){
        User newUser = [SELECT Id,username FROM User WHERE Username = 'newUser@yahoo.com'];
        DT_Cart__c dtCart = [SELECT Id,Name FROM DT_Cart__c WHERE Contact_Name__c = 'test' LIMIT 1];
        DT_Cart_Product__c dtCartProduct =[SELECT Id,Name FROM DT_Cart_Product__c LIMIT 1];
        
        Test.startTest();
        System.runAs(newUser){
            Test.setMock(WebServiceMock.class, new WebServiceMock_SSC_OrderCreate());
            
            Dal_InventorySearchController.placeOrder();
            
        }
        Test.stopTest();
    }
    
    private static testMethod void getMyCartPriceDataTest(){
        User newUser = [SELECT Id,username FROM User WHERE Username = 'newUser@yahoo.com'];
        
        Test.startTest();
        System.runAs(newUser){
            Test.setMock(WebServiceMock.class, new Dal_GetPriceMock());
            Dal_InventorySearchController.getMyCartPriceData('Test Meterial','Test pricedQuantity','Test pricedQuantityUOM','Test supplyPlant');
            
        }
        Test.stopTest();
    }
}