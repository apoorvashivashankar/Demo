@isTest(seeAllData=false)
public class Dal_SearchProductSkuUtilTest {
    
    @testSetup
    static void testsetup(){ 
        UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType ='None' limit 1];
        update new User(Id=userInfo.getUserId(), UserRoleId = ur.Id);
        
        system.runAs(new User(Id=userInfo.getUserId())) {
            Contact con = Dal_TestUtils.createTestContact();  
            
            List<SSC__c> sscList = new List<SSC__c>();
            SSC__c ssc = new SSC__c();
            ssc.Name = 'SSC Account';
            sscList.add(ssc);
            insert sscList;
            
            Account account = new Account();
            account.Id = con.AccountId;
            account.SSC__c = ssc.Id;  
            account.DW_ID__c = '00880021';
            
            update account;
            
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
            product.Brand__c = 'DB';
            insert product;
            
            ProductSeries__c series = new ProductSeries__c();
            series.Series__c  = 'Series';
            series.Name = 'test';
            insert series;
            
            ProductSeriesColor__c seriescolor = new ProductSeriesColor__c();
            seriescolor.Product_Series__c = series.Id;
            seriescolor.Product_Color__c = color.Id;
            insert seriescolor;
            
            UserContactDefaults__c userCont = new UserContactDefaults__c();
            userCont.Default_Account_Id__c = con.AccountId;
            userCont.Default_Contact_Record_Type_Id__c = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Daltile Internal Contact').getRecordTypeId();
            insert userCont;
        }
    }
    static testmethod void statementSummarybyCustomerTest(){
        System.runAs(new user(ID = UserInfo.getUserID())) {
            Profile p = [select Id,name from Profile where name='Customer Community Plus Login User'];
            String uniqueName = Dal_TestUtils.getUserString();
            Contact contact = [SELECT Id FROM Contact];
            Account account = [SELECT Id, Division__c FROM Account];
            account.Division__c = '40';
            update account;
            User newUser = new User(profileId = p.id,  username = uniqueName + '@test.org', email = 'pb@ff.com',
                                    emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                    timezonesidkey = 'America/Los_Angeles', alias='nuser', lastname='lastname', 
                                    Selected_Location__c = account.Id, contactId = contact.id
                                   );
            insert newUser;
            
            Test.startTest();
            System.runAs(newUser){
                String searchParameter = 'Product';
                Dal_SearchProductSkuUtil.searchProducts(searchParameter);
            }        
            Test.stopTest();
        }       
    }
    static testmethod void searchProduct_1_Test(){
        System.runAs(new user(ID = UserInfo.getUserID())) {
            Profile p = [select Id,name from Profile where name='Customer Community Plus Login User'];
            String uniqueName = Dal_TestUtils.getUserString();
            Contact contact = [SELECT Id FROM Contact];
            Account account = [SELECT Id, Division__c FROM Account];
            account.Division__c = '41';
            update account;
            User newUser = new User(profileId = p.id,  username = uniqueName + '@test.org', email = 'pb@ff.com',
                                    emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                    timezonesidkey = 'America/Los_Angeles', alias='nuser', lastname='lastname', 
                                    Selected_Location__c = account.Id, contactId = contact.id
                                   );
            insert newUser;
            
            Test.startTest();
            System.runAs(newUser){
                String searchParameter = 'Product';
                Dal_SearchProductSkuUtil.searchProducts(searchParameter);
            }        
            Test.stopTest();
        }       
    }
    static testmethod void searchProduct_2_Test(){
        System.runAs(new user(ID = UserInfo.getUserID())) {
            Profile p = [select Id,name from Profile where name='Customer Community Plus Login User'];
            String uniqueName = Dal_TestUtils.getUserString();
            Contact contact = [SELECT Id FROM Contact];
            Account account = [SELECT Id, Division__c FROM Account];
            account.Division__c = '42';
            update account;
            User newUser = new User(profileId = p.id,  username = uniqueName + '@test.org', email = 'pb@ff.com',
                                    emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                    timezonesidkey = 'America/Los_Angeles', alias='nuser', lastname='lastname', 
                                    Selected_Location__c = account.Id, contactId = contact.id
                                   );
            insert newUser;
            
            Test.startTest();
            System.runAs(newUser){
                String searchParameter = 'Product';
                Dal_SearchProductSkuUtil.searchProducts(searchParameter);
            }        
            Test.stopTest();
        }       
    } 
    static testmethod void searchProduct_3_Test(){
        System.runAs(new user(ID = UserInfo.getUserID())) {
            Profile p = [select Id,name from Profile where name='Customer Community Plus Login User'];
            String uniqueName = Dal_TestUtils.getUserString();
            Contact contact = [SELECT Id FROM Contact];
            Account account = [SELECT Id, Division__c FROM Account];
            account.Division__c = '43';
            update account;
            User newUser = new User(profileId = p.id,  username = uniqueName + '@test.org', email = 'pb@ff.com',
                                    emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                    timezonesidkey = 'America/Los_Angeles', alias='nuser', lastname='lastname', 
                                    Selected_Location__c = account.Id, contactId = contact.id
                                   );
            insert newUser;
            
            Test.startTest();
            System.runAs(newUser){
                String searchParameter = 'Product';
                Dal_SearchProductSkuUtil.searchProducts(searchParameter);
            }        
            Test.stopTest();
        }       
    }     
    static testmethod void searchProduct_4_Test(){
        System.runAs(new user(ID = UserInfo.getUserID())) {
            Profile p = [select Id,name from Profile where name='Customer Community Plus Login User'];
            String uniqueName = Dal_TestUtils.getUserString();
            Contact contact = [SELECT Id FROM Contact];
            Account account = [SELECT Id, Division__c FROM Account];
            account.Division__c = '44';
            update account;
            
            ProductSeriesColor__c series = [SELECT Id,Product_Series__c, Product_Series__r.Name FROM ProductSeriesColor__c LIMIT 1];
            
            User newUser = new User(profileId = p.id, username = uniqueName + '@test.org', email = 'pb@ff.com',
                                    emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                    timezonesidkey = 'America/Los_Angeles', alias='nuser', lastname='lastname', 
                                    Selected_Location__c = account.Id, contactId = contact.id
                                   );
            insert newUser;
            
            Test.startTest();
            System.runAs(newUser){
                List<String>searchParameterList = new List<String>();
                List<String>colorCode = new List<String>{'test'};
                    String searchParameter = 'Product';
                String vendor = 'test';
                String brand = 'DB';
                searchParameterList.add(searchParameter);
                Dal_SearchProductSkuUtil.searchProducts(searchParameter);
                Dal_SearchProductSkuUtil.searchSize();
                Dal_SearchProductSkuUtil.getSeries(brand);
                Dal_SearchProductSkuUtil.quickSearchProductsWithBrand(searchParameter);
                Dal_SearchProductSkuUtil.searchVendorNames();
                Dal_SearchProductSkuUtil.searchSampleProducts(searchParameterList);
                Dal_SearchProductSkuUtil.searchVendorProducts(searchParameter, vendor);
                Dal_SearchProductSkuUtil.searchProductsWithBrand(searchParameterList, brand, searchParameter);
                Dal_SearchProductSkuUtil.searchSizedProducts(colorCode, searchParameterList, searchParameter, brand);
                Dal_SearchProductSkuUtil.getSeriesCreate(brand);
                Dal_SearchProductSkuUtil.getColors(series.Product_Series__c, brand);
            }        
            Test.stopTest();
        }       
    }     
}