/* Copyright ©2016-2017 7Summits Inc. All rights reserved. */

/**
 * Created by francois korb on 11/29/16.
 */

@IsTest
private class SVNSUMMITS_IdeaTitleControllerTest {
	public static Network currNetwork;
	public static List<Community> currCommunity;
	public static List<Idea> currIdeaList;

	static void testSetupQuery() {
		currCommunity = [Select Id, Name FROM Community];
		currIdeaList = [SELECT Id FROM Idea WHERE title = 'test' ORDER BY CreatedDate DESC];
	}

	@testSetup
	static void testSetupData() {
		SVNSUMMITS_IdeaTitleControllerTest.testSetupQuery();
		System.assertNotEquals(null,SVNSUMMITS_IdeaTitleControllerTest.currCommunity);
		System.assert(SVNSUMMITS_IdeaTitleControllerTest.currCommunity.size() > 0);
		Idea currIdea1 = new Idea(CommunityId = currCommunity[0].Id, title='test',Related_Topic_Name__c='test');
		Idea currIdea2 = new Idea(CommunityId = currCommunity[0].Id, title='test',Related_Topic_Name__c='test');

		List<Idea> tmpIdeaList = new List<Idea>();
		tmpIdeaList.add(currIdea1);
		tmpIdeaList.add(currIdea2);

		insert tmpIdeaList;
		System.assertNotEquals(null,tmpIdeaList[0].Id);
		System.assertNotEquals(null,tmpIdeaList[1].Id);
	}

	@isTest
	static void test_getSitePrefix()
	{
		System.assertEquals('', SVNSUMMITS_IdeaTitleController.getSitePrefix());
	}

	@isTest
	static void test_isAuthenticated()
	{
		System.assert(true, SVNSUMMITS_IdeaTitleController.isAuthenticated());
	}

	@isTest
	static void test_getZoneId()
	{
		SVNSUMMITS_IdeaTitleControllerTest.testSetupQuery();
		System.assertNotEquals('', SVNSUMMITS_IdeaTitleController.getZoneId(SVNSUMMITS_IdeaTitleControllerTest.currCommunity[0].Name));
		System.assertEquals('', SVNSUMMITS_IdeaTitleController.getZoneId('______'));
		System.assertEquals('', SVNSUMMITS_IdeaTitleController.getZoneId(''));
	}

	@isTest
	static void test_getIdea()
	{
		SVNSUMMITS_IdeaTitleControllerTest.testSetupQuery();
		Idea tmpIdea = SVNSUMMITS_IdeaTitleController.getIdea(SVNSUMMITS_IdeaTitleControllerTest.currIdeaList[0].Id,
							SVNSUMMITS_IdeaTitleControllerTest.currCommunity[0].Id);
		System.assertEquals(tmpIdea.Id,SVNSUMMITS_IdeaTitleControllerTest.currIdeaList[0].Id);
		tmpIdea = SVNSUMMITS_IdeaTitleController.getIdea('dsfsdfdsfsds', SVNSUMMITS_IdeaTitleControllerTest.currCommunity[0].Id);
		System.assertEquals(null,tmpIdea.Id);
	}

}