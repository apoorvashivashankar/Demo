// ===================
// Test Peak Test Utils
// DEPRECATED - With Peak_TestUtils being annotated with @isTest, we no longer need coverage on it
// ===================
@isTest
public with sharing class Peak_TestUtilsTest {

	// Create a standard user
	@isTest
	public static void testCreateStandardUser(){
		User testUser = Peak_TestUtils.createStandardUser();
		System.assertEquals(Peak_TestConstants.LASTNAME,testUser.LastName);
	}

	// Create a guest user
	@isTest
	public static void testCreateGuestUser(){
		User testUser = Peak_TestUtils.createGuestUser();
		System.assertEquals(Peak_TestConstants.LASTNAME,testUser.LastName);
	}

	@isTest
	public static void testGetFakeId() {
		system.assert(Peak_TestUtils.getFakeId(User.SObjectType) != null);
	}

}