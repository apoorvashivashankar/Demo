/* Copyright ©2016-2017 7Summits Inc. All rights reserved. */

@isTest
private class SVNSUMMITS_IdeaVotersControllerTest
{
	public static Network currNetwork;
	public static List<Community> currCommunity;
	public static List<Idea> currIdeaList;

	static void testSetupQuery() {
		currCommunity = [Select Id, Name FROM Community];
		currIdeaList = [SELECT Id FROM Idea WHERE title = 'test' ORDER BY CreatedDate DESC];
	}

	@testSetup
	static void testSetupData() {
		SVNSUMMITS_IdeaVotersControllerTest.testSetupQuery();
		System.assertNotEquals(null,SVNSUMMITS_IdeaVotersControllerTest.currCommunity);
		System.assert(SVNSUMMITS_IdeaVotersControllerTest.currCommunity.size() > 0);
		Idea currIdea = new Idea(CommunityId = currCommunity[0].Id, title='test',Related_Topic_Name__c='test');
		Idea currIdea2 = new Idea(CommunityId = currCommunity[0].Id, title='test',Related_Topic_Name__c='test');
		List<Idea> tmpIdeaList = new List<Idea>();
		tmpIdeaList.add(currIdea);
		tmpIdeaList.add(currIdea2);
		insert tmpIdeaList;
		System.assertNotEquals(null,tmpIdeaList[0].Id);
		System.assertNotEquals(null,tmpIdeaList[1].Id);
	}

	@isTest
	static void test_isAuthenticated()
	{
		System.assert(true, SVNSUMMITS_IdeaVotersController.isAuthenticated());
	}

	@isTest
	static void test_isNicknameDisplayEnabled()
	{
		System.assertEquals(true, SVNSUMMITS_IdeaVotersController.isNicknameDisplayEnabled());
	}

	@isTest
	static void test_getSitePrefix()
	{
		System.assertEquals('', SVNSUMMITS_IdeaVotersController.getSitePrefix());
	}

	@isTest
	static void test_getZoneId()
	{
		SVNSUMMITS_IdeaVotersControllerTest.testSetupQuery();
		System.assertNotEquals('', SVNSUMMITS_IdeaVotersController.getZoneId(SVNSUMMITS_IdeaVotersControllerTest.currCommunity[0].Name));
		System.assertEquals('', SVNSUMMITS_IdeaVotersController.getZoneId('______'));
		System.assertEquals('', SVNSUMMITS_IdeaVotersController.getZoneId(''));
	}

	@isTest
	static void test_isValidIdeaId()
	{
		SVNSUMMITS_IdeaVotersControllerTest.testSetupQuery();
		Boolean isValid = SVNSUMMITS_IdeaVotersController.isValidIdeaId(SVNSUMMITS_IdeaVotersControllerTest.currIdeaList[0].Id, SVNSUMMITS_IdeaVotersControllerTest.currCommunity[0].Id);
		System.assertEquals(true, isValid);

		Id tmpId = SVNSUMMITS_IdeaVotersControllerTest.currIdeaList[0].Id;
		delete SVNSUMMITS_IdeaVotersControllerTest.currIdeaList[0];
		isValid = SVNSUMMITS_IdeaVotersController.isValidIdeaId(tmpId, SVNSUMMITS_IdeaVotersControllerTest.currCommunity[0].Id);
		System.assertEquals(false, isValid);

		isValid = SVNSUMMITS_IdeaVotersController.isValidIdeaId('sdfsdfsd', SVNSUMMITS_IdeaVotersControllerTest.currCommunity[0].Id);
		System.assertEquals(false, isValid);
	}

	@isTest
	static void test_getTotalVoterCount()
	{
		SVNSUMMITS_IdeaVotersControllerTest.testSetupQuery();
		System.assertEquals(1, SVNSUMMITS_IdeaVotersController.getTotalVoterCount(SVNSUMMITS_IdeaVotersControllerTest.currIdeaList[0].Id));
	}

	@isTest
	static void test_getIdeaVoters()
	{
		SVNSUMMITS_IdeaVotersControllerTest.testSetupQuery();
		System.assertEquals(1, SVNSUMMITS_IdeaVotersController.getIdeaVoters(SVNSUMMITS_IdeaVotersControllerTest.currIdeaList[0].Id,10).size());
	}
}