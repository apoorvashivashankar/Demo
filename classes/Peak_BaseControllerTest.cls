@isTest
public with sharing class Peak_BaseControllerTest {

    @testSetup static void testSetup() {
         UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType ='None' limit 1];
        update new User(Id=userInfo.getUserId(), UserRoleId = ur.Id);

        system.runAs(new User(Id=userInfo.getUserId())) {
        Contact testContact = Peak_TestUtils.createTestContact();
        
        insert new UserContactDefaults__c(Default_Account_Id__c = Peak_TestUtils.createTestAccount().Id, 
                                          Default_Contact_Record_Type_Id__c = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Daltile Internal Contact').getRecordTypeId());
    }
    }

    @isTest
    public static void testGetSitePrefix() {
    	system.assert(Peak_BaseController.getSitePrefix() != null);
    }

    // Test finding a user
    @isTest
    public static void testUser(){
        List<Contact> testContacts = [SELECT Id from Contact where Email = :Peak_TestConstants.STANDARD_EMAIL];

        List<Profile> standardProfileList = [SELECT Id FROM Profile WHERE Name like '%Community%'];
		User testUser;
		
		if (!Peak_Utils.isNullOrEmpty(standardProfileList)) {
			Profile standardProfile = standardProfileList[0];
            UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType =:'CustomerPortal' limit 1];
			testUser = new User(Alias = Peak_TestConstants.STANDARD_ALIAS, Email=Peak_TestConstants.STANDARD_EMAIL, EmailEncodingKey=Peak_TestConstants.ENCODING, FirstName=Peak_TestConstants.FIRSTNAME, LastName=Peak_TestConstants.LASTNAME, LanguageLocaleKey=Peak_TestConstants.LOCALE,LocaleSidKey=Peak_TestConstants.LOCALE, ProfileId = standardProfile.Id,TimeZoneSidKey=Peak_TestConstants.TIMEZONE, UserName=Peak_TestConstants.STANDARD_USERNAME);
		}
		
        testUser.ContactId = testContacts[0].Id;
        insert testUser;

        test.startTest();

        System.runAs(testUser) {
            System.assertEquals(false,Peak_BaseController.isGuestUser());
        }

        Test.stopTest();

    }

    // Test running as a guest
    @isTest
    public static void testGuest(){
        // Set up and run as guest user 
        User guestUser = Peak_TestUtils.createGuestUser();

        System.runAs(guestUser) {
            System.assertEquals(true,Peak_BaseController.isGuestUser());
        }
    }

}