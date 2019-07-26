/**
* Created by Yadav on 8/16/2018.
*/

@IsTest
private class Dal_GetInventoryLocationTest {
    
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
            account.ShippingStreet = '123';
            account.ShippingCountry = 'US';
            account.ShippingCity = 'DALLAS';
            account.ShippingState = 'TX';
            account.ShippingPostalCode = '72332';
            update account;
            
            UserContactDefaults__c userCont = new UserContactDefaults__c();
            userCont.Default_Account_Id__c = con.AccountId;
            userCont.Default_Contact_Record_Type_Id__c = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Daltile Internal Contact').getRecordTypeId();
            insert userCont;
            
          	DT_Cart__c cartObj = new DT_Cart__c();
            cartObj.Contact_Name__c = 'test';
            cartObj.Contact_Number__c = '1234567890';
            cartObj.Job_Name__c = 'Job';
            /*cartObj.National_Account__c = 'National';*/
            cartObj.Special_Instructions__c = 'test';
            cartObj.Status__c = 'Draft';
            //cartObj.User__c = User.Id;
            insert cartObj;
			
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
            
            List<DT_Cart_Product__c> cartProductList = new List<DT_Cart_Product__c>();
            DT_Cart_Product__c cartProduct = new DT_Cart_Product__c();
            cartProduct.DT_Cart__c = cartObj.Id;
            cartProduct.Fulfillment_Method__c = 'Delivery';
            cartProduct.Shipping_Street__c = account.ShippingStreet;
            cartProduct.Shipping_City__c = account.ShippingCity;
            cartProduct.Shipping_State__c = account.ShippingState;
            cartProduct.Shipping_ZIP_Code__c = account.ShippingPostalCode;
            cartProduct.Lift_gate__c = true;
            //cartProduct.Product__c = product.Id;
            cartProduct.Quantity__c = 1;
            cartProduct.SSC__c = ssc.Id;
            cartProduct.Total_Amount__c = 1;
            //cartProduct.Total_Carton__c = 12;
            cartProduct.Unit__c = 12;
            cartProduct.UOM__c = 'SF';
            cartProductList.add(cartProduct);
            insert cartProductList;
            
        }
    }
    @isTest static void getInventoryLocationForDTcartProduct(){
        Profile p = [select Id,name from Profile where name='Customer Community Plus Login User'];
        Contact con = [SELECT Id FROM Contact];
        Account account = [SELECT Id FROM Account];
        String uniqueName = Dal_TestUtils.getUserString();
        User newUser = new User(profileId = p.id, username = uniqueName + '@test.org', email = uniqueName + '@test.org',
                                emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                timezonesidkey = 'America/Los_Angeles', alias='nuser', lastname='lastname',
                                Selected_Location__c = account.Id, contactId = con.id
                               );
        insert newUser;
        
        List<DT_Cart_Product__c> cartProductList = [SELECT Id,SSC__r.SAP_Plant__c,Product__r.DW_ID__c,UOM__c,Quantity__c FROM DT_Cart_Product__c];
        
        Test.startTest();
            System.runAs(newUser){
                Test.setMock(WebServiceMock.class, new WebServiceMockDalImplInventoryAtLocation());
                String SKU = 'ABC';
                String supplyplantId = '4101';
                String UOM = 'uom';
                
                Dal_GetInventoryLocation InventoryLocation = new Dal_GetInventoryLocation(cartProductList);
                InventoryLocation.getLocationWithMaterial();
            }
        Test.stopTest();
    }
    @isTest static void getInventoryAtlocationTest(){
        
        Profile p = [select Id,name from Profile where name='Customer Community Plus Login User'];
        Contact con = [SELECT Id FROM Contact];
        Account account = [SELECT Id FROM Account];
        String uniqueName = Dal_TestUtils.getUserString();
        User newUser = new User(profileId = p.id, username = uniqueName + '@test.org', email = uniqueName + '@test.org',
                                emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                timezonesidkey = 'America/Los_Angeles', alias='nuser', lastname='lastname',
                                Selected_Location__c = account.Id, contactId = con.id
                               );
        insert newUser;
        
        Product_Color__c color = new Product_Color__c();
            color.Name = 'TestRed';
            color.Code__c = 'E102';
            insert color;
            
            Product2 product = new Product2();
            product.Name = 'TestProduct';
            product.DW_ID__c ='0100441P4';
            product.Base_UoM__c ='pc';
            product.UOM__c ='pc;sf';
            product.Product_Color__c = color.Id;
            product.Weight__c = 2.11;
            product.Log_Code__c = 'I';
            product.Tile_Type__c  = 'SAM';
            insert product;
        
            SSC__c sc = new SSC__c();
            sc.SAP_Plant__c ='4238';
            sc.Street_Address__c ='test';
            sc.Zip_Code__c = '174013';
            insert sc;
            
            SampleStockingLocation__c sp = new SampleStockingLocation__c();
            // Location__c, 
            sp.Location__c = sc.Id;
            sp.Product__c = product.Id;
            insert sp;
        
        Test.startTest();
        System.runAs(newUser){
            
            Test.setMock(WebServiceMock.class, new WebServiceMockDalImplInventoryAtLocation());
            String SKU = 'ABC';
            String supplyplantId = '4101';
            String UOM = 'uom';
            
            Dal_OrderSampleManager.OrderLocationWrapper orderWrapper = new Dal_OrderSampleManager.OrderLocationWrapper();
            
            orderWrapper.SAP_Plant = supplyplantId;
            orderWrapper.sku = SKU;
            orderWrapper.BaseUOM = UOM ;
            
            list<Dal_OrderSampleManager.OrderLocationWrapper> orderLocationList = new List<Dal_OrderSampleManager.OrderLocationWrapper>();
            orderLocationList.add(orderWrapper);
            String json = '[{\"sku\":\"J5051224S1P\",\"quantity\":\"1\",\"uom\":\"SF\",\"CodeSet\":\"Legacy\",\"SupplyplantId\":\"4101\",\"SupplyplantType\":\"SAP_Plant\",\"reqShipdate\":\"2018-11-17\"},{\"sku\":\"J5051224F1L\",\"quantity\":\"1\",\"uom\":\"SF\",\"CodeSet\":\"Legacy\",\"SupplyplantId\":\"4101\",\"SupplyplantType\":\"SAP_Plant\",\"reqShipdate\":\"2018-11-17\"}]';
            
            Dal_OrderSampleManager.OrderLocationWrapper locationWrapper = new Dal_OrderSampleManager.OrderLocationWrapper(sp);
            
            List<Dal_OrderSampleManager.OrderLocationWrapper> locationWrapperList = new list<Dal_OrderSampleManager.OrderLocationWrapper>();
            locationWrapperList.add(locationWrapper);
            
            List<Dal_InventorySearchJSON> InvenotryJson = Dal_InventorySearchJSON.parse(json);
            
            Dal_GetInventoryLocation InventoryLocation = new Dal_GetInventoryLocation(locationWrapperList);
            
            Dal_GetInventoryLocation location_manager = new Dal_GetInventoryLocation(InvenotryJson);
            InventoryLocation.getLocationWithMaterial();
            location_manager.getLocationWithMaterial();
            
        }
        Test.stopTest();
    }
}