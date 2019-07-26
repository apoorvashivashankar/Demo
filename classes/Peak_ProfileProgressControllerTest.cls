@IsTest
private class Peak_ProfileProgressControllerTest {

    @testSetup
    static void methodName() {
         UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType ='None' limit 1];
        update new User(Id=userInfo.getUserId(), UserRoleId = ur.Id);

        system.runAs(new User(Id=userInfo.getUserId())) {
        Contact testContact = Peak_TestUtils.createTestContact();
        
         insert new UserContactDefaults__c(Default_Account_Id__c = Peak_TestUtils.createTestAccount().Id, 
                                          Default_Contact_Record_Type_Id__c = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Daltile Internal Contact').getRecordTypeId());
    }
}

    // Test the dynamic query builder
    @isTest
    public static void testDynamicQueryBuilder(){
        // Set up and run as a standard user
        String[] fields = new List<String>();
        fields.add('FirstName');

        List<Contact> testContacts = [SELECT Id from Contact where Email = :Peak_TestConstants.STANDARD_EMAIL];

        List<Profile> standardProfileList = [SELECT Id FROM Profile WHERE Name like '%Community%'];
		User testUser;
		
		if (!Peak_Utils.isNullOrEmpty(standardProfileList)) {
			Profile standardProfile = standardProfileList[0];
            
			testUser = new User(Alias = Peak_TestConstants.STANDARD_ALIAS, Email=Peak_TestConstants.STANDARD_EMAIL, EmailEncodingKey=Peak_TestConstants.ENCODING, FirstName=Peak_TestConstants.FIRSTNAME, LastName=Peak_TestConstants.LASTNAME, LanguageLocaleKey=Peak_TestConstants.LOCALE,LocaleSidKey=Peak_TestConstants.LOCALE, ProfileId = standardProfile.Id,TimeZoneSidKey=Peak_TestConstants.TIMEZONE, UserName=Peak_TestConstants.STANDARD_USERNAME);
		}
        
        testUser.ContactId = testContacts[0].Id;
        insert testUser;

        // The following code runs as user 'testUser'
        String builtQuery = Peak_ProfileProgressController.dynamicQueryBuilder('User', testUser.Id, fields);
        system.assertEquals('SELECT Id, FirstName FROM User WHERE Id = \'' + testUser.Id + '\'',builtQuery);
    }
    // Test getting the user
    @isTest
    public static void testGetUser(){
        // Set up and run as a standard user
        List<Contact> testContacts = [SELECT Id from Contact where Email = :Peak_TestConstants.STANDARD_EMAIL];

        User testUser = Peak_TestUtils.createStandardUserNoContact();
        testUser.ContactId = testContacts[0].Id;
        insert testUser;

        System.runAs(testUser) {
            // The following code runs as user 'testUser'
            User queryUser = Peak_ProfileProgressController.getUser();
            system.assertEquals(Peak_TestConstants.FIRSTNAME + ' ' + Peak_TestConstants.LASTNAME,queryUser.Name);
        }
    }
    @isTest
    public static void testGetUserById(){
        // Set up and run as a standard user
        List<Contact> testContacts = [SELECT Id from Contact where Email = :Peak_TestConstants.STANDARD_EMAIL];

        User testUser = Peak_TestUtils.createStandardUserNoContact();
        testUser.ContactId = testContacts[0].Id;
        insert testUser;

        String[] fields = new List<String>();
        fields.add('FirstName');
        fields.add('LastName');
        fields.add('Email');


        User queryUser = Peak_ProfileProgressController.getUserById(testUser.Id, fields);
        system.assertEquals(Peak_TestConstants.FIRSTNAME, queryUser.FirstName);
        system.assertEquals(Peak_TestConstants.LASTNAME, queryUser.LastName);
        system.assertEquals(Peak_TestConstants.STANDARD_EMAIL, queryUser.Email);
    }
    // Test getting the site prefix
    @isTest
    public static void testSitePrefix(){
        String prefix = Peak_ProfileProgressController.getSitePrefix();
    }
}