@IsTest
private class Peak_ContentObjectTest {

    @testSetup
    static void testSetup() {
         UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType ='None' limit 1];
        update new User(Id=userInfo.getUserId(), UserRoleId = ur.Id);

        system.runAs(new User(Id=userInfo.getUserId())) {
        Contact testContact = Peak_TestUtils.createTestContact();
        
        insert new UserContactDefaults__c(Default_Account_Id__c = Peak_TestUtils.createTestAccount().Id, 
                                          Default_Contact_Record_Type_Id__c = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Daltile Internal Contact').getRecordTypeId());
    }
}

    @isTest
    public static void testPeak_ContentObject() {

        List<Contact> testContacts = [SELECT Id from Contact where Email = :Peak_TestConstants.STANDARD_EMAIL];

        List<Profile> standardProfileList = [SELECT Id FROM Profile WHERE Name like '%Community%'];
		User testUser;
		
		if (!Peak_Utils.isNullOrEmpty(standardProfileList)) {
			Profile standardProfile = standardProfileList[0];
            
			testUser = new User(Alias = Peak_TestConstants.STANDARD_ALIAS, Email=Peak_TestConstants.STANDARD_EMAIL, EmailEncodingKey=Peak_TestConstants.ENCODING, FirstName=Peak_TestConstants.FIRSTNAME, LastName=Peak_TestConstants.LASTNAME, LanguageLocaleKey=Peak_TestConstants.LOCALE,LocaleSidKey=Peak_TestConstants.LOCALE, ProfileId = standardProfile.Id,TimeZoneSidKey=Peak_TestConstants.TIMEZONE, UserName=Peak_TestConstants.STANDARD_USERNAME);
		}
		
        testUser.ContactId = testContacts[0].Id;
        insert testUser;

        Test.startTest();

        Peak_ContentObject peakContentObject = new Peak_ContentObject();
        peakContentObject.contentID = testUser.Id;
        peakContentObject.title = Peak_TestConstants.FIRSTNAME;
        peakContentObject.description = Peak_TestConstants.TEST_DESCRIPTION;
        peakContentObject.fullDescription = Peak_TestConstants.TEST_DESCRIPTION;
        peakContentObject.attachments = new List<Attachment>();
        peakContentObject.url = Peak_TestConstants.TEST_URL;
        peakContentObject.featured = false;
        peakContentObject.bannerImage = '';
        peakContentObject.avatar = '';
        peakContentObject.commentCount = 1;
        peakContentObject.commentUrl = '';
        peakContentObject.dateTimeField = DateTime.newInstance(2011, 11, 18, 3, 3, 3);
        peakContentObject.dateField = Peak_TestConstants.TODAY;

        system.assertEquals(peakContentObject.title,Peak_TestConstants.FIRSTNAME);
        Test.stopTest();
    }

}