// ===================
// Test Peak Utils
// ===================
@isTest
public with sharing class Peak_UtilsTest {

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

	// Test building a formatted string from a set of strings
	@isTest
	public static void testBuildStringFromSet(){
		Peak_Utils utils = new Peak_Utils();
		Set<String> sourceSet = new Set<String>();
		sourceSet.add('Hello');
		sourceSet.add('There');
		system.assertEquals('Hello, There', utils.buildStringFromSet(sourceSet)); // test that this is building a string from a set properly
	}

	@isTest
	public static void testGetUser(){
		// Set up and run as a standard user
		List<Contact> testContacts = [SELECT Id from Contact where Email = :Peak_TestConstants.STANDARD_EMAIL];

		List<Profile> standardProfileList = [SELECT Id FROM Profile WHERE Name like '%Community%'];
		User testUser;
		
		if (!Peak_Utils.isNullOrEmpty(standardProfileList)) {
			Profile standardProfile = standardProfileList[0];
           
			testUser = new User(Alias = Peak_TestConstants.STANDARD_ALIAS, Email=Peak_TestConstants.STANDARD_EMAIL, EmailEncodingKey=Peak_TestConstants.ENCODING, FirstName=Peak_TestConstants.FIRSTNAME, LastName=Peak_TestConstants.LASTNAME, LanguageLocaleKey=Peak_TestConstants.LOCALE,LocaleSidKey=Peak_TestConstants.LOCALE, ProfileId = standardProfile.Id,TimeZoneSidKey=Peak_TestConstants.TIMEZONE, UserName=Peak_TestConstants.STANDARD_USERNAME);
		}
        
		testUser.ContactId = testContacts[0].Id;
		insert testUser;

		system.runAs(testUser){
			system.assertEquals(testUser.Id,Peak_Utils.getUser().Id);
		}
	}

	@isTest
	public static void testIsNullOrEmpty() {
		// Assert return true for empty list
		List<String> stringList = new List<String>();
		system.assertEquals(Peak_Utils.isNullOrEmpty(stringList),true);

		// Assert return false for not empty list
		stringList.add(Peak_TestConstants.ACCOUNT_NAME);
		system.assertEquals(Peak_Utils.isNullOrEmpty(stringList),false);
	}

	@isTest
	public static void testGetSitePrefix() {
		system.assert(Peak_Utils.getSitePrefix() != null);
	}

	@isTest
	public static void testCreateAttachment() {
		// Set up and run as a standard user
		List<Contact> testContacts = [SELECT Id from Contact where Email = :Peak_TestConstants.STANDARD_EMAIL];

		User testUser = Peak_TestUtils.createStandardUserNoContact();
		testUser.ContactId = testContacts[0].Id;
		insert testUser;

		Attachment testAttachment = Peak_TestUtils.createAttachment(testUser.Id);
		system.assert(testAttachment != null);
	}

	@isTest
	public static void testGetPicklistValues(){
		Peak_Utils peakUtils = new Peak_Utils();
		List<String> options = peakUtils.getPicklistValues('User','LanguageLocaleKey');
		System.assert(options.size()>0);
	}


}