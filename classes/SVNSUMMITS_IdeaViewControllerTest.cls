/* Copyright ©2016-2017 7Summits Inc. All rights reserved. */

@isTest
private class SVNSUMMITS_IdeaViewControllerTest {
	public static Network currNetwork;
	public static List<Community> currCommunity;
	public static List<Idea> currIdeaList;

	static void testSetupQuery() {
		currCommunity = [Select Id, Name FROM Community];
		currIdeaList = [SELECT Id FROM Idea WHERE title = 'test' ORDER BY CreatedDate DESC];
	}

	@testSetup
	static void testSetupData() {
		SVNSUMMITS_IdeaViewControllerTest.testSetupQuery();
		System.assertNotEquals(null, SVNSUMMITS_IdeaViewControllerTest.currCommunity);
		System.assert(SVNSUMMITS_IdeaViewControllerTest.currCommunity.size() > 0);

		Idea currIdea1 = new Idea(CommunityId = currCommunity[0].Id, title = 'test', Related_Topic_Name__c = 'test');
		Idea currIdea2 = new Idea(CommunityId = currCommunity[0].Id, title = 'test', Related_Topic_Name__c = 'test');

		List<Idea> tmpIdeaList = new List<Idea>();
		tmpIdeaList.add(currIdea1);
		tmpIdeaList.add(currIdea2);

		insert tmpIdeaList;
		System.assertNotEquals(null, tmpIdeaList[0].Id);
		System.assertNotEquals(null, tmpIdeaList[1].Id);
	}

	@isTest
	static void test_isAuthenticated() {
		System.assert(true, SVNSUMMITS_IdeaViewController.isAuthenticated());
	}

	@isTest
	static void test_isNicknameDisplayEnabled() {
		System.assertEquals(true, SVNSUMMITS_IdeaViewController.isNicknameDisplayEnabled());
	}

	@isTest
	static void test_getSitePrefix() {
		System.assertEquals('', SVNSUMMITS_IdeaViewController.getSitePrefix());
	}

	@isTest
	static void test_getZoneId() {
		SVNSUMMITS_IdeaViewControllerTest.testSetupQuery();
		System.assertNotEquals('', SVNSUMMITS_IdeaViewController.getZoneId(SVNSUMMITS_IdeaViewControllerTest.currCommunity[0].Name));
		System.assertEquals('', SVNSUMMITS_IdeaViewController.getZoneId('______'));
		System.assertEquals('', SVNSUMMITS_IdeaViewController.getZoneId(''));
	}

	@isTest
	static void test_getIdea() {
		SVNSUMMITS_IdeaViewControllerTest.testSetupQuery();
		Idea tmpIdea = SVNSUMMITS_IdeaViewController.getIdea(SVNSUMMITS_IdeaViewControllerTest.currIdeaList[0].Id, SVNSUMMITS_IdeaViewControllerTest.currCommunity[0].Id);
		System.assertEquals(tmpIdea.Id, SVNSUMMITS_IdeaViewControllerTest.currIdeaList[0].Id);
		tmpIdea = SVNSUMMITS_IdeaViewController.getIdea('dsfsdfdsfsds', SVNSUMMITS_IdeaViewControllerTest.currCommunity[0].Id);
		System.assertEquals(null, tmpIdea.Id);

		Boolean canDelete = SVNSUMMITS_IdeaViewController.isRecordDeletable(tmpIdea.Id + '');
		Boolean canEdit = SVNSUMMITS_IdeaViewController.isRecordEditable(tmpIdea.Id + '');
	}

	@isTest
	static void test_getMergedIdeas() {
		SVNSUMMITS_IdeaViewControllerTest.testSetupQuery();
		List<Idea> mergedIdeas = SVNSUMMITS_IdeaViewController.getMergedIdeas(SVNSUMMITS_IdeaViewControllerTest.currIdeaList[0].Id, SVNSUMMITS_IdeaViewControllerTest.currCommunity[0].Id);
		System.assertNotEquals(null, mergedIdeas);
	}

	@isTest
	static void test_getIdeaTitle() {
		SVNSUMMITS_IdeaViewControllerTest.testSetupQuery();
		Idea tmpIdea = SVNSUMMITS_IdeaViewController.getIdea(SVNSUMMITS_IdeaViewControllerTest.currIdeaList[0].Id, SVNSUMMITS_IdeaViewControllerTest.currCommunity[0].Id);
		System.assertEquals(tmpIdea.Id, SVNSUMMITS_IdeaViewControllerTest.currIdeaList[0].Id);
		String StrIdeaTitle = SVNSUMMITS_IdeaViewController.getIdeaTitle(SVNSUMMITS_IdeaViewControllerTest.currIdeaList[0].Id, SVNSUMMITS_IdeaViewControllerTest.currCommunity[0].Id);
		System.assertEquals(tmpIdea.Id, SVNSUMMITS_IdeaViewControllerTest.currIdeaList[0].Id);
	}

	@isTest
	static void test_deleteIdea() {
		SVNSUMMITS_IdeaViewControllerTest.testSetupQuery();
		Idea tmpIdea = SVNSUMMITS_IdeaViewController.getIdea(SVNSUMMITS_IdeaViewControllerTest.currIdeaList[0].Id, SVNSUMMITS_IdeaViewControllerTest.currCommunity[0].Id);
		Id currIdeaId = tmpIdea.Id;
		Boolean deleteable = SVNSUMMITS_IdeaViewController.isRecordDeletable(currIdeaId + '');
		System.assertEquals(true, SVNSUMMITS_IdeaViewController.deleteIdea(currIdeaId + ''));
		System.assertEquals(false, SVNSUMMITS_IdeaViewController.deleteIdea(currIdeaId + ''));
	}

	@isTest
	static void test_vote() {
		SVNSUMMITS_IdeaViewControllerTest.testSetupQuery();
		Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
		User u = new User(Alias = 'standt', Email = 'standarduser@testorg.com',
				EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
				LocaleSidKey = 'en_US', ProfileId = p.Id,
				TimeZoneSidKey = 'America/Los_Angeles', UserName = 'standarduser@CCIDEASLC.com');
		System.runAs(u) {
			Vote v = SVNSUMMITS_IdeaViewController.vote(SVNSUMMITS_IdeaViewControllerTest.currIdeaList[0].Id, true);
			System.assertNotEquals(null, v.Id);
		}

		Vote v = SVNSUMMITS_IdeaViewController.vote(SVNSUMMITS_IdeaViewControllerTest.currIdeaList[0].Id, true);
		System.assertEquals(null, v);

		v = SVNSUMMITS_IdeaViewController.vote(null, true);
		System.assertEquals(null, v);
	}

	@isTest
	static void test_getVote() {
		SVNSUMMITS_IdeaViewControllerTest.testSetupQuery();
		Vote v = SVNSUMMITS_IdeaViewController.getVote(SVNSUMMITS_IdeaViewControllerTest.currIdeaList[0].Id);
		System.assertEquals(SVNSUMMITS_IdeaViewControllerTest.currIdeaList[0].Id, v.ParentId);
		System.assertEquals(UserInfo.getUserId(), v.CreatedById);
		System.assertEquals('Up', v.Type);

		Id tmpId = SVNSUMMITS_IdeaViewControllerTest.currIdeaList[0].Id;
		delete SVNSUMMITS_IdeaViewControllerTest.currIdeaList[0];
		v = SVNSUMMITS_IdeaViewController.getVote(tmpId);
		System.assertEquals(null, v.CreatedById);
	}

	@isTest
	static void test_getPicklistValues() {
		System.assertNotEquals(null, SVNSUMMITS_IdeaViewController.getPicklistValues('Idea', 'Status'));
	}

	@isTest
	static void test_getCommonSettings() {
		SVNSUMMITS_Ideas_Common common = SVNSUMMITS_IdeaViewController.getCommonSettings();

		// custom settings
		System.assertNotEquals(null, common);
		System.assertEquals(null, common.allowDownVoting);
		System.assertEquals(null, common.debugMode);
	}

	@isTest
	static void test_getTopicList() {
		Topic t = new Topic(Name = 'test');
		insert t;

		List<Topic> topicList = SVNSUMMITS_IdeaViewController.getTopicNamesList();
		Boolean containsValue = false;

		for (Topic s : topicList) {
			if (s.Name == 'test') {
				containsValue = true;
			}
		}
		System.assertEquals(true, containsValue);
	}

	@IsTest
	static void test_getTopicMap() {
		currCommunity = [Select Id, Name FROM Community];

		Topic t = new Topic(Name = 'test');
		insert t;

		Idea currIdea = new Idea(CommunityId = currCommunity[0].Id, title = 'test', Related_Topic_Name__c = 'test');
		insert currIdea;

		Map<String, String> topicMap = SVNSUMMITS_IdeaViewController.getTopicMap('test');
		System.assertEquals(true, topicMap.containsKey('test'));
	}
}