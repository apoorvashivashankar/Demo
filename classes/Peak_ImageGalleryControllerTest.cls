@IsTest
private class Peak_ImageGalleryControllerTest {
    @testSetup
    static void testSetup() {
         UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType ='None' limit 1];
        update new User(Id=userInfo.getUserId(), UserRoleId = ur.Id);

        system.runAs(new User(Id=userInfo.getUserId())) {
        
        User testUser = Peak_TestUtils.createStandardUser();
        insert testUser;

        Peak_Image_Gallery__c testGallery = new Peak_Image_Gallery__c(Name = Peak_TestConstants.TEST_GALLERYNAME, Default_Image__c = Peak_TestConstants.TEST_URL, Description__c = Peak_TestConstants.TEST_DESCRIPTION);
        insert testGallery;

        List<Peak_Image_Gallery_Entry__c> testEntries = new List<Peak_Image_Gallery_Entry__c>();
        testEntries.add(new Peak_Image_Gallery_Entry__c(Name = Peak_TestConstants.TEST_GALLERYENTRYNAME, Peak_Image_Gallery__c = testGallery.Id, Image_URL__c = Peak_TestConstants.TEST_URL, Sort_Order__c = Peak_TestConstants.TEST_GALLERYENTRYSORT1));
        testEntries.add(new Peak_Image_Gallery_Entry__c(Name = Peak_TestConstants.TEST_GALLERYENTRYNAME, Peak_Image_Gallery__c = testGallery.Id, Image_URL__c = Peak_TestConstants.TEST_URL, Sort_Order__c = Peak_TestConstants.TEST_GALLERYENTRYSORT2));
        insert  testEntries;
        }

    }
    @isTest
    public static void testGetImageGallery() {
        //creating test user to run with to make sure the user has access to the object
        List<User> testUsers = [SELECT Id FROM User WHERE Email = :Peak_TestConstants.STANDARD_EMAIL];
        List<Peak_Image_Gallery__c> testGalleries = [SELECT Id FROM Peak_Image_Gallery__c WHERE Name = :Peak_TestConstants.TEST_GALLERYNAME];

        Test.startTest();
        System.runAs(testUsers[0]) {
            Peak_Response testResults = Peak_ImageGalleryController.GetImageGallery(testGalleries[0].Id);
            Peak_Image_Gallery__c foundGallery = (Peak_Image_Gallery__c)testResults.results[0];
            //Can't test the gallery entries because for some reason the subquery doesn't show in the Peak_Response object while in apex but goes through to the component
            String testString = foundGallery.Default_Image__c + foundGallery.Description__c;
            String assertString = Peak_TestConstants.TEST_URL + Peak_TestConstants.TEST_DESCRIPTION;
            System.assertEquals(assertString, testString);
        }
        Test.stopTest();
    }

}