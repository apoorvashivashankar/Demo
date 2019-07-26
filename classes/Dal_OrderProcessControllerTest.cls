/**
* Created by 7Summits on 3/28/18.
*
**/
@isTest
private class Dal_OrderProcessControllerTest {
    
    @testSetup
    static void testSetup(){
        UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType ='None' limit 1];
        update new User(Id=userInfo.getUserId(), UserRoleId = ur.Id);
        
        system.runAs(new User(Id=userInfo.getUserId())) {
            Contact con = Dal_TestUtils.createTestContact();
            
            DT_Order__c  order = new DT_Order__c ();
            order.Name = 'FirstOrder';
            insert order;
            
            Account account = new Account();
            account.Id = con.AccountId;
            account.DW_ID__c = '00880021';
            account.Division__c = 'OASIS';
            update account;
            
            Region__c r04 = new Region__c(Select__c = true
                                          , SBU__c = 'SC'
                                          , DW_ID__c = '04'
                                          , Name = 'DT Mid-West');
            insert r04;
            
            SSC__c ssc = new SSC__c(Closed__c = false
                                    , DW_ID__c = '000111'    
                                    , Loc_Type__c = 'SSC'
                                    , Manager__c = UserInfo.getUserId()
                                    , Region__c = r04.Id
                                    , ROM__c = UserInfo.getUserId()
                                    , RSM__c = UserInfo.getUserId()
                                    , RVP__c = UserInfo.getUserId()     
                                    , Sales_Region__c = '04'
                                    , SBU__c = 'SC'
                                    , Select__c = true
                                    , SSC_Fax_Number__c = '123-345-5567'
                                    , SSC_Phone_Number__c = '123-345-5567'
                                    , State__c = 'TX'
                                    , Street_Address__c = '12345 1st street'
                                    , Zip_Code__c = '12345');
            insert ssc;
            
            SSC__c ssc1 = new SSC__c(Closed__c = false
                                    , DW_ID__c = '02111'    
                                    , Manager__c = UserInfo.getUserId()
                                    , Region__c = r04.Id
                                    , ROM__c = UserInfo.getUserId()
                                    , RSM__c = UserInfo.getUserId()
                                    , RVP__c = UserInfo.getUserId()     
                                    , Sales_Region__c = '04'
                                    , SBU__c = 'SC'
                                    , Select__c = true
                                    , SSC_Fax_Number__c = '123-345-5567'
                                    , SSC_Phone_Number__c = '123-345-5567'
                                    , State__c = 'TX'
                                    , Street_Address__c = '12345 1st street'
                                    , Zip_Code__c = '12345');
            insert ssc1;
            
            UserContactDefaults__c userCont = new UserContactDefaults__c();
            userCont.Default_Account_Id__c = con.AccountId;
            userCont.Default_Contact_Record_Type_Id__c = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Daltile Internal Contact').getRecordTypeId();
            insert userCont;
            Profile p = [select Id,name from Profile where name='Customer Community Plus Login User'];
            
            String uniqueName = Dal_TestUtils.getUserString(); 
            User newUser = new User(profileId = p.id, username = uniqueName + '@test.org' , email = 'pb@ff.com',
                                    emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                    timezonesidkey = 'America/Los_Angeles', alias='nuser', lastname='lastname',
                                    Selected_Location__c = account.Id, contactId = con.id
                                   );
            insert newUser;
        }
    }
    static testMethod void orderProcessTest() {
        Dal_OrderProcessController.OrderWrapper dal = new Dal_OrderProcessController.OrderWrapper();
        Dal_OrderProcessController.toDTOrder(dal);
        User newUser = [SELECT Id,username,email FROM User WHERE email = 'pb@ff.com'];
        DT_Order__c dtorder = [SELECT Id,Address_Name__c,Address1__c,Address2__c,Address3__c,City__c,State__c,Postal_Code__c,
                               Country__c,Freight_Terms__c,AccountName__r.Freight_Term__c,Carrier__c,Ship_Complete__c,Small_Package__c,Purchase_Order__c,
                               JobName__c,Contact_Name__c,Contact_Phone__c,Default_Requested_Ship_Date__c,Default_Price_Code__c,(select id from DT_Order_Products__r)
                               from DT_Order__c where Name = 'FirstOrder'];
        //Dal_OrderProcessController.OrderWrapper dal1 = new Dal_OrderProcessController.OrderWrapper(dtorder);
        Dal_OrderProcessController.startOrder(dtorder.Id);
        //Dal_OrderProcessController.createOrder(dtorder.Id);
        String orderNumber = '12456';
        String SKU = 'ABC';
        String Quantity = '12';
        String PriceRecord = '200';
        String SOS = 'sos';
        String supplyplantType = 'supplyplantType';
        String supplyplantId = 'supplyplantId';
        String UOM = 'uom';
        Date requestedDate = System.today();
        String ReqShipDate = String.valueof(System.today());
        
        DT_Order__c  order = new DT_Order__c (Name = 'FirstOrder', AccountName__c = [SELECT Id FROM Account LIMIT 1].Id);
        insert order;
        
        Product2 prod = new Product2(Name = 'Free Frorm',IsActive = TRUE, DW_ID__c = 'ABC');
        insert prod;
        
        SSC__c storeaddress = new SSC__c();
        storeaddress.Name = 'Test';
        storeaddress.Street_Address__c = 'Test';
        storeaddress.City__c = 'Test';   
        storeaddress.State__c = 'US';
        storeaddress.Zip_Code__c = 'Test';
        storeaddress.SSC_Phone_Number__c = '123456789';
        storeaddress.SSC_Fax_Number__c = 'Test';
        storeaddress.DW_ID__c = '123';
        insert storeaddress;
        
        List<DT_Order_Product__c> orderProductList = new List<DT_Order_Product__c>();
        DT_Order_Product__c orderProduct = new DT_Order_Product__c(Name= '11',DT_Order_Id__c = order.Id, Product_Sku__c = prod.Id);
        orderProductList.add(orderProduct);
        DT_Order_Product__c orderProduct1 = new DT_Order_Product__c(Name= '22',DT_Order_Id__c = order.Id, Product_Sku__c = prod.Id);
        orderProductList.add(orderProduct1);
        insert orderProductList;
        Dal_OrderProcessController.OrderLineWrapper dalorderline = new Dal_OrderProcessController.OrderLineWrapper(orderProduct);
        //Dal_OrderProcessController.removeOrderLineItem(orderProduct1);
        DT_SYS_OrderHeader__x dtsys = new DT_SYS_OrderHeader__x(
            Account_Address_Line2__c ='Z2',Account_Address_Name__c='NY',SalesOrder__c='12456',HostSystem__c = 'SAP',OrderPlant__c ='000111'
        );
        
        DT_SYS_OrderLine__x orderLine = new DT_SYS_OrderLine__x(Quantity__c=10.00,UOM__c='10',RequestedShipDate__c=String.valueOf(System.today()),
                                                                MaterialDesc_Size__c='test',MaterialDesc_Color__c='test',
                                                                MaterialDesc_Trim__c='test',Quantity_Invoiced__c=10.00,
                                                                Quantity_Cancelled__c=10.00,WeightExtended__c=10.00,
                                                                Price_PriceNet_Extended__c=10);
        
        Dal_OrderProcessController.mockallOpenItemsList.add(dtsys); 
        //        Boolean isvalid = Dal_BaseController.isValidList(dtsys); 
        Dal_OrderProcessController.mockallOrderLineList.add(orderLine);
        System.runAs(newUser){ 
            Test.setMock(WebServiceMock.class, new WebServiceMockDalImplATPResults());
            
            Dal_OrderProcessController.startOrder(order.Id);
            List<DT_Order__c> orderList = Dal_OrderProcessController.getOrder(order.Id);
            
            List<Product2> searchProductList = Dal_OrderProcessController.searchProductSKUs(SKU);
            
            List<DT_SYS_PriceRecord__x> priceRecords = Dal_OrderProcessController.getPriceRecords(order.Id);
            
            Dal_OrderProcessController.OrderWrapper wrp = new Dal_OrderProcessController.OrderWrapper();
            
            Dal_OrderProcessController.toDTOrder(wrp);
            try{
                Dal_OrderProcessController.cloneOrder(order.Id);
            }catch(Exception e){}
            
            try{
                Dal_OrderProcessController.removeOrderLineItem(orderProduct);
            }catch(Exception e){}
            
            try{
                Dal_OrderProcessController.getSubmittedOrder(orderNumber);
            }catch(Exception e){}    
            
            List<DT_SYS_PriceRecord__x> priceRecordsByDate = Dal_OrderProcessController.getPriceRecordsByDate(order.Id, requestedDate);
            Dal_OrderProcessController.searchProducts('Test');
            
            try{
                Dal_OrderProcessController.getATPResults('00880021', '1', '1', Date.today().format(), null);
            }catch(Exception e){}
            
            try{
                Dal_OrderProcessController.getTimePhasedResults('00880021', '1', '1', '1');
            }catch(Exception e){}
            
            try{
                Dal_OrderProcessController.getShadeDetails('00880021', '1', '1', Date.today().format(), null, 'Test', 'Test');
            }catch(Exception e){}
            
            try{
                Dal_OrderProcessController.getPricingbySKU('00880021', '1', '1', '1', null);
            }catch(Exception e){}
            
            List<Dal_OrderJSON.OrderLineList> tempList = new List<Dal_OrderJSON.OrderLineList>();
            Dal_OrderJSON.OrderLineList temp = new Dal_OrderJSON.OrderLineList();
            temp.lineno = 1;
            temp.skuNumber = 'Test';
            temp.quantity = '11';
            temp.unitOfMeasure = 'cm';
            temp.sourceOfSupply = 'Test';
            temp.supplyplantid = 'Test';
            temp.requestedShipDate = Date.today().format();
            temp.estimatedShipDate = Date.today().format();
            temp.size = '1';
            temp.color = 'Test';
            temp.extendedWeight = '44';
            temp.unitPrice = '546';
            temp.extendedPrice = '565';
            temp.productdesc = 'Test';
            tempList.add(temp);
            
            Dal_OrderProcessController.toDTOrderProduct(tempList);
            
            Dal_OrderJSON tempJSON = new Dal_OrderJSON();
            tempJSON.orderLineList = tempList;
            tempJSON.orderId = order.Id;
            
            try{
                Dal_OrderProcessController.SaveOrder(JSON.serialize(tempJSON));
            }catch(Exception e){}
            
            try{
                Dal_OrderProcessController.createOrder(order.Id);
            }catch(Exception e){}
            
            try{
                Dal_OrderProcessController.getStatusCount();
            }catch(Exception e){}
        }
    }
    static testMethod void removeOrderTest() {
        User newUser = [SELECT Id,username,email FROM User WHERE email = 'pb@ff.com'];
        
        Test.startTest();
        System.runAs(newUser){
            Test.setMock(WebServiceMock.class, new WebServiceMockDalImplATPResults());
            String statusValue = 'Approve';
            String orderNumber = '12456';
            String SKU = 'ABC';
            String Quantity = '12';
            String PriceRecord = '200';
            String SOS = 'sos';
            String supplyplantType = 'supplyplantType';
            String supplyplantId = 'supplyplantId';
            String UOM = 'uom';
            String ReqShipDate = String.valueof(System.today());
            //List<Dal_AvailabilityDate_Price_ATP_Manager.ATP_AvailableDate_Wrapper> atpResults = Dal_OrderProcessController.getATPResults(sku, quantity, uom, reqShipDate, priceRecord);
            //System.assert(true, atpResults);
            // DT_Order__c orders = Dal_OrderProcessController.startOrder(null);
        }
        Test.stopTest();
    }
    @isTest
    static void webserviceOrderTest() {
        User newUser = [SELECT Id,username,email FROM User WHERE email = 'pb@ff.com'];
        
        Test.startTest();
        System.runAs(newUser){
            Test.setMock(WebServiceMock.class, new WebServiceMockDalImplATPResults());
            String statusValue = 'Approve';
            String orderNumber = '12456';
            String SKU = 'ABC';
            String Quantity = '12';
            String PriceRecord = '200';
            String SOS = 'sos';
            String supplyplantType = 'supplyplantType';
            String supplyplantId = 'supplyplantId';
            String UOM = 'uom';
            String qty = '1';
            String ReqShipDate = String.valueof(System.today()-15);
            //List<Dal_AvailabilityDate_Price_ATP_Manager.ATP_AvailableDate_Wrapper> atpResults = Dal_OrderProcessController.getATPResults(sku, quantity, uom, reqShipDate, priceRecord);
            //System.assert(true, atpResults);
        }
        Test.stopTest();
    }
    @isTest
    static void webserviceOrderTwoTest() {
        User newUser = [SELECT Id,username,email FROM User WHERE email = 'pb@ff.com'];
        
        Test.startTest();
        System.runAs(newUser){
            Test.setMock(WebServiceMock.class, new WebServiceMockDalImplShadeDetails());
            String statusValue = 'Approve';
            String orderNumber = '12456';
            String SKU = 'ABC';
            String Quantity = '12';
            String PriceRecord = '200';
            String SOS = 'sos';
            String supplyplantType = 'supplyplantType';
            String supplyplantId = 'supplyplantId';
            String UOM = 'uom';
            String qty = '1';
            String ReqShipDate = null;
            String searchParameter = '008082001';
            String material = '123';
            String pricedQuantity = '123';
            String pricedQuantityUOM = 'uom';
            String supplyPlant = 'uom';
            //List<Dal_Shade_Manager.ShadeWrapper> shadeDetails = Dal_OrderProcessController.getShadeDetails(sku, qty, uom, reqShipdate, priceRecord, supplyplantId, supplyplantType);
            //Dal_OrderProcessController.searchProducts(searchParameter);
            //Dal_OrderProcessController.getPricingbySKU(material, pricedQuantity, pricedQuantityUOM, supplyPlant);
            //System.assert(true, shadeDetails);
        }
        Test.stopTest();
    }
    @isTest
    static void webserviceOrderT3rdTest() {
        User newUser = [SELECT Id,username,email FROM User WHERE email = 'pb@ff.com'];
        
        Test.startTest();
        System.runAs(newUser){
            Test.setMock(WebServiceMock.class, new WebServiceMockDalImplTimePhased());
            String SKU = 'ABC';
            String supplyplantType = 'supplyplantType';
            String supplyplantId = 'supplyplantId';
            String UOM = 'uom';
            //List<Dal_TimePhase_ATP_Manager.ATP_TimePhase_Wrapper> timePhasedResults = Dal_OrderProcessController.getTimePhasedResults(sku, uom, supplyplantId, supplyplantType);
            //System.assert(true, timePhasedResults);
        }
        Test.stopTest();
    }
    @isTest
    static void testmeth() {
        DT_SYS_OrderHeader__x dtorderheader = new DT_SYS_OrderHeader__x();
        dtorderheader.JobName__c = 'testname';
        dtorderheader.Account_Contact_LastName__c = 'testlastname';
        dtorderheader.Account_Contact_FirstName__c = 'testfirstname';        
        Database.insertAsync(dtorderheader);
        SSC__c ssc = new SSC__c();
        ssc.City__c = 'testcity';
        insert ssc;
        String LocType = 'BDC';
        list<Dal_OrderProcessController.OrderLineWrapper> listorderline = new list<Dal_OrderProcessController.OrderLineWrapper>();
        Dal_OrderProcessController.OrderWrapper dal2 = new Dal_OrderProcessController.OrderWrapper(dtorderheader,listorderline,ssc,LocType);
        DT_SYS_OrderLine__x dtorderlinex = new DT_SYS_OrderLine__x();
        dtorderlinex.Fulfilment_Contact_FirstName__c = 'testname';
        Database.insertAsync(dtorderheader);
        String Location = 'new york';
        map<String,String> mapofString = new map<String,String>();
        Dal_OrderProcessController.OrderLineWrapper dalorderlinevar = new Dal_OrderProcessController.OrderLineWrapper(dtorderlinex,Location,mapofString);
        //Dal_OrderProcessController.searchProducts('searchterm');
    }
    
}