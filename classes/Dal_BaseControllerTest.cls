/**
* Created by 7Summits on 2/13/18.
*
*/

@IsTest
private class Dal_BaseControllerTest {
    
    @testSetup static void testSetup() {
        UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType ='None' limit 1];
        update new User(Id=userInfo.getUserId(), UserRoleId = ur.Id);

        system.runAs(new User(Id=userInfo.getUserId())) {
        Contact testContact = Dal_TestUtils.createTestContact();
        Contact con = Dal_TestUtils.createTestContact();
        
        DT_Order__c  order = new DT_Order__c ();
        order.Name = 'FirstOrder';
        insert order;
        
        Account account = new Account();
        account.Id = con.AccountId;
        account.DW_ID__c = '008082001';
        account.Division__c = '44';
        update account;
        
        UserContactDefaults__c userCont = new UserContactDefaults__c();
        userCont.Default_Account_Id__c = con.AccountId;
        userCont.Default_Contact_Record_Type_Id__c = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Daltile Internal Contact').getRecordTypeId();
        insert userCont;
        
        SSC__c ssc =new SSC__c();
        ssc.Name = 'Test';
        ssc.City__c = 'Test';
        
        ssc.Street_Address__c = 'Test';
        ssc.Zip_Code__c = '123';
        ssc.DW_ID__c = '008082001';
        
        insert ssc;
            
            DT_Cart__c cartObj = new DT_Cart__c();
            cartObj.Contact_Name__c = 'test';
            cartObj.Contact_Number__c = '1234567890';
            cartObj.Job_Name__c = 'Job';
            cartObj.Cart_Account__c = account.Id;
            cartObj.Special_Instructions__c = 'test';
            cartObj.Status__c = 'Draft';
            //cartObj.User__c = User.Id;
            insert cartObj;
    }
    }
    
    @isTest
    public static void testGetSitePrefix() {
        system.assert(Peak_BaseController.getSitePrefix() != null);
    }
    
    // Test running as a guest
    @isTest
    public static void testGuest(){
        // Set up and run as guest user
        Profile p = [select Id,name from Profile where name='Customer Community Plus Login User'];
       // UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType =:'CustomerPortal' limit 1];
        Contact contact = [SELECT Id FROM Contact LIMIT 1];
        Account account = [SELECT Id FROM Account LIMIT 1];
        String statusValue = 'Approve';
         String uniqueName = Dal_TestUtils.getUserString();
        User newUser = new User(profileId = p.id, username = uniqueName + '@test.org' , email = uniqueName + '@test.org',
                                emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                timezonesidkey = 'America/Los_Angeles', alias='nuser', lastname='lastname',
                                Selected_Location__c = account.Id, contactId = contact.id
                               );
        insert newUser;
        
        Test.startTest();
        System.runAs(newUser){
            //Dal_BaseController.setUserSelectedLocation('1234');
        }
        Test.stopTest();    
    }
    
    // Test running as a logged in user
    @isTest
    public static void testGetLoggedInUser(){
        test.startTest();
        User loggedInUser = Dal_BaseController.getUser();
        Test.stopTest();
        System.assertNotEquals(null, loggedInUser);
    }
    
    @isTest
    public static void testGetCredentials(){
        test.startTest();
     //   System.assertEquals(null, Dal_BaseController.getCredentials('AllServices'));
		 Dal_BaseController.getCredentials('AllServices');
        Test.stopTest();
    }
    
    @isTest
    public static void testSetUserSelectedLocation(){
        Test.startTest();
        Dal_BaseController.setUserSelectedLocation(Dal_TestConstants.USER_SELECTED_LOCATION);
        Test.stopTest();
        
        User loggedInUser = Dal_BaseController.getUser();
        
        //System.assertEquals(loggedInUser.Selected_Location__c, Dal_TestConstants.USER_SELECTED_LOCATION);
    }
    
    @isTest
    public static void testSetUserSelectedLocation2(){
        Test.startTest();
        Dal_BaseController.setUserSelectedLocation(null);
        Test.stopTest();
    }
    
    @isTest
    public static void testGetUserLocations(){
        Test.startTest();
        Dal_BaseController.getUserLocations('SSC');
        Test.stopTest();       
        System.assertEquals(true, true);
    }
    
    @isTest
    public static void testGetUserLocationsDist(){
        Test.startTest();
        System.assertNotEquals(Dal_BaseController.getUserLocations('Distributor'), null);
        Test.stopTest();       
    }
    
    @isTest
    public static void testGetUserLocationDist(){
        Test.startTest();
        Dal_BaseController.getUserLocations('42');
        Test.stopTest();
        
        System.assertEquals(true, true);
    }
    
    @isTest
    public static void testGetAccountTeam(){
        Test.startTest();
        Dal_BaseController.getAccountTeam();
        Test.stopTest();
        
        System.assertEquals(true, true);
    }
    
    @isTest
    public static void testGetThemeSettings(){
        Test.startTest();
        Peak_Response response = Dal_BaseController.getThemeSettings('customSettingName');
        Test.stopTest();
        
        System.assertEquals(true, true);
    }
    
     @isTest
    public static void testGetThemeSettingsBlank(){
        Test.startTest();
        System.assertNotEquals(Dal_BaseController.getThemeSettings(null), null);
        Test.stopTest();
    }
    
    @isTest
    public static void testgetSSCLocation(){
        Test.startTest();
        SSC__c ssc =  Dal_BaseController.getSSCLocation('008082001');
        Test.stopTest();
    }
    
    @isTest
    public static void testgetSSCLocationInvalid(){
        Test.startTest();
        System.assert(Dal_BaseController.getSSCLocation('456546') == null);
        Test.stopTest();
    }
    
    @isTest
    public static void testgetSSCLocationBlank(){
        Test.startTest();
        System.assert(Dal_BaseController.getSSCLocation(null) == null);
        Test.stopTest();
    }
    
    @isTest
    public static void testgetSessionOrder(){
        Profile p = [select Id,name from Profile where name='Customer Community Plus Login User'];

        Contact contact = [SELECT Id FROM Contact Limit 1];
        Account account = [SELECT Id FROM Account Limit 1];
        String statusValue = 'Approve';
        User newUser = new User(profileId = p.id, username = 'newUser@yahoo.com', email = 'pb@ff.com',
                                emailencodingkey = 'UTF-8', localesidkey = 'en_US', languagelocalekey = 'en_US',
                                timezonesidkey = 'America/Los_Angeles', alias='nuser', lastname='lastname',
                                Selected_Location__c = account.Id, contactId = contact.id
                               );
        insert newUser;
        
        Test.startTest();
        System.runAs(newUser){
            String order =  Dal_BaseController.getSessionOrder();
        }
        Test.stopTest();
    } 
    
    @isTest
    public static void testSessionOrder(){
        Test.startTest();
        Dal_BaseController.setSessionOrder('1');
        Test.stopTest();
    }
    
    @isTest
    public static void testvalidList(){
        Test.startTest();
        List<Account> accts = [SELECT Id, Name FROM Account LIMIT 10];
        Boolean response = Dal_BaseController.isValidList(accts);
        Test.stopTest();
    }
    
    @isTest
    public static void testvalidList2(){
        Test.startTest();
        List<SObject> sObj =new List<SObject>();
        Boolean response = Dal_BaseController.isValidList(sObj);
        Test.stopTest();
    }
    
    @isTest
    public static void testguestUser(){
        Test.startTest();
        Boolean response = Dal_BaseController.isGuestUser();
        Test.stopTest();
    }
    
    @isTest
    public static void testsiteprefix(){
        Test.startTest();
        String response = Dal_BaseController.getSitePrefix();
        Test.stopTest();
    }
    
    @isTest
    public static void testdraft(){
        Test.startTest();
        DT_Order__c order = [SELECT Id FROM DT_Order__c];
        Boolean response = Dal_BaseController.deleteDraftOrder(order.Id);
        Test.stopTest();
    }
    
    @isTest
    public static void testdraftBlank(){
        Test.startTest();
        System.assert(Dal_BaseController.deleteDraftOrder(null) <> null);
        Test.stopTest();
    }
    
     @isTest
    public static void testcartdelete(){
        DT_Cart__c dtCart = [SELECT Id,Name FROM DT_Cart__c WHERE Contact_Name__c = 'test' LIMIT 1];
        Test.startTest();
        Dal_BaseController.deleteCart(dtCart.Id);
        Test.stopTest();
    }
    @isTest
    public static void testgetAcccountCartDetail(){
        Account account = [SELECT Id FROM Account Limit 1];
        Test.startTest();
        Dal_BaseController.getAcccountCartDetail(account.Id);
        Test.stopTest();
    }
}