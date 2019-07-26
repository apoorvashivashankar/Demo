/**
 * Created by Yadav on 8/17/2018.
 */

@isTest
public with sharing class Dal_OrderSampleManagerTest {

    @testSetup
    static void testSetup(){
        UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType ='None' limit 1];
        update new User(Id=userInfo.getUserId(), UserRoleId = ur.Id);

        system.runAs(new User(Id=userInfo.getUserId())) {
        Contact con = Dal_TestUtils.createTestContact();
        Freight_Term__c tempTerm = new Freight_Term__c(Code__c = '435545', Name = 'Test');
        insert tempTerm;

        ProductSeries__c series = new ProductSeries__c();
        series.Series__c  = 'Series';
        series.Name = 'test';
        insert series;

        Division__c division = new Division__c();
        division.Code__c  = '40';
        insert division;

        ProductSeriesDivision__c pd = new ProductSeriesDivision__c();
        pd.Series__c = series.Id;
        pd.Division__c = division.Id;
        insert pd;

        Product_Color__c color = new Product_Color__c();
        color.Name = 'TestRed';
        color.Code__c = 'E102';
        insert color;

        ProductSeriesColor__c seriescolor = new ProductSeriesColor__c();
        seriescolor.Product_Series__c = series.Id;
        seriescolor.Product_Color__c = color.Id;
        
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
            
        Available_UOM__c availableUOM = new Available_UOM__c();
        availableUOM.Denominator__c = 832;
        availableUOM.Nominator__c = 90461;
        availableUOM.Name = 'pc';
        availableUOM.Product__c = product.Id;
        insert availableUOM;
            
        Account account = new Account();
        account.Id = con.AccountId;
        account.DW_ID__c = '008082001';
        account.Division__c = '40';
        account.Freight_Term__c = tempTerm.Id;
        update account;
        
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
        UserContactDefaults__c userCont = new UserContactDefaults__c();
        userCont.Default_Account_Id__c = con.AccountId;
        userCont.Default_Contact_Record_Type_Id__c = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Daltile Internal Contact').getRecordTypeId();
        insert userCont;
        
       
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

    static testMethod void orderManagerTest() {
        
        User newUser = [SELECT Id,username FROM User WHERE email = 'pb@ff.com' limit 1];
        ProductSeries__c series = [SELECT  Id from ProductSeries__c];
        List<Product_Color__c> colorlst = [Select Id,Name,Code__c from Product_Color__c];
        List<SampleStockingLocation__c> ssl =[Select Id from SampleStockingLocation__c limit 1];
        System.debug('colorlst-----test-->'+colorlst);
        Test.startTest();
        System.runAs(newUser){
            Test.setMock(WebServiceMock.class, new WebServiceMockDalImplInventoryAtLocation());
     		List<String> lstOfValue = new List<String>();
            List<ProductSeriesDivision__c> prod = Dal_OrderSampleManager.getOrderSampleSeries();
            List<Dal_OrderSampleManager.ColorCode> seriescolor = Dal_OrderSampleManager.getOrderSampleSeriesProduct(series.Id);
            for(Product_Color__c colorVal : colorlst){
                lstOfValue.add(colorVal.Code__c);
                System.debug('COlor--->'+lstOfValue);
            }
          //  List<Dal_OrderSampleManager.OrderLocationWrapper> getProductWrapper = Dal_OrderSampleManager.getProduct(lstOfValue);
              Dal_OrderSampleManager.getProduct(lstOfValue);
           
        }
        Test.stopTest();
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
        User newUser = [SELECT Id,username FROM User WHERE email = 'pb@ff.com' LIMIT 1];
        String json = '{\"productOrderLines\":[{\"Address\":\"199 PLANTERS ROAD\",\"availableQty\":\"10.000\",\"BaseUOM\":\"EA\",\"Color\":\"BV95\",\"Country\":\"US\",\"ExtendedWeight\":2.78,\"isAdded\":true,\"OnHandQty\":\"10.000\",\"productId\":\"01t0G000004TaDKQA0\",\"ProductLine\":\"LOOSE TILE (0615)\",\"productName\":\"10X14 SAMPLE    BV95 DOVE            STD\",\"quantityLst\":[1,2,3,4,5],\"SAP_Plant\":\"4101\",\"selectedQuantity\":1,\"sku\":\"BV951014SAM1P2\",\"totalQuantity\":0,\"Zip\":\"75182-9601\",\"estimatedAvailabilityDate\":\"08/24/18\"},{\"Address\":\"199 PLANTERS ROAD\",\"availableQty\":\"7.000\",\"BaseUOM\":\"EA\",\"Color\":\"BV95\",\"Country\":\"US\",\"ExtendedWeight\":4.17,\"isAdded\":true,\"OnHandQty\":\"8.000\",\"productId\":\"01t0G000004TlqrQAC\",\"ProductLine\":\"LOOSE TILE (0615)\",\"productName\":\"12X24 SAM       BV95 DOVE            STD\",\"quantityLst\":[1,2,3,4,5],\"SAP_Plant\":\"4101\",\"selectedQuantity\":1,\"sku\":\"BV951224PSAM1P6\",\"totalQuantity\":0,\"Zip\":\"75182-9601\",\"estimatedAvailabilityDate\":\"08/24/18\"}],\"orderDetails\":{\"selectedAddress\":{\"name\":\"Ray Test Dist 8082001\",\"isActive\":true,\"isPrimary\":true},\"freightTerms\":\"Prepaid\",\"isShipComplete\":\"no\",\"carrier\":\"UPS Ground\",\"isSmallPackage\":\"yes\",\"poNumber\":\"po\",\"jobName\":\"job\"},\"cumulativeOrderWeight\":\"6.95\"}';
        Test.startTest();
        System.runAs(newUser) {
            Test.setMock(WebServiceMock.class, new Dal_OrderCreateMock());
            Dal_OrderSampleManager.createSampleOrder(json);
        }
        test.stopTest();
    }

    

}