/* Copyright ©2016-2017 7Summits Inc. All rights reserved. */

@isTest
private class SVNSUMMITS_IdeaNewControllerTest {
	public static List<Community> currCommunity;
	public static Idea awesomeIdea;
	public static Network currNetwork;
	public static List<Idea> currIdeaList;

	static void testSetupQuery(Boolean queryData) {
		currCommunity = [Select Id, Name FROM Community];
		currIdeaList = [SELECT Id FROM Idea WHERE title = 'test' ORDER BY CreatedDate DESC];

		if (queryData) {
			awesomeIdea = [SELECT Id FROM Idea WHERE Title = 'test is awesome'];
		}
	}
	@testSetup
	static void testSetupData() {
		SVNSUMMITS_IdeaNewControllerTest.testSetupQuery(false);
		System.assertNotEquals(null, SVNSUMMITS_IdeaNewControllerTest.currCommunity);
		System.assert(SVNSUMMITS_IdeaNewControllerTest.currCommunity.size() > 0);
		List<Idea> ideasToInsert = new List<Idea>();

		for (Integer i = 0; i < 1; i++) {
			Idea currIdea = new Idea(Title = 'test is awesome', CommunityId = SVNSUMMITS_IdeaNewControllerTest.currCommunity[0].Id);
			ideasToInsert.add(currIdea);
		}

		for (Integer i = 0; i < 5; i++) {
			Idea currIdea = new Idea(Title = 'test', CommunityId = SVNSUMMITS_IdeaNewControllerTest.currCommunity[0].Id);
			ideasToInsert.add(currIdea);
		}

		insert ideasToInsert;
		System.assert(ideasToInsert.size() == 6);
		System.assertNotEquals(null, ideasToInsert[0].Id);
	}

	@isTest
	static void test_isAuthenticated() {
		System.assert(true, SVNSUMMITS_IdeaNewController.isAuthenticated());
	}

	@isTest
	static void test_getSitePrefix() {
		System.assertEquals('', SVNSUMMITS_IdeaNewController.getSitePrefix());
	}

	@isTest
	static void test_getSessionId() {
		System.assertNotEquals(null, SVNSUMMITS_IdeaNewController.getSessionId());
	}

	@isTest
	static void test_getInstanceUrl() {
		String instanceUrl = SVNSUMMITS_IdeaNewController.getInstanceUrl();
		System.debug('getSalesforceBaseUrl = ' + instanceUrl);
		System.assertNotEquals(null, instanceUrl);
	}

	@isTest
	static void test_getZoneId() {
		SVNSUMMITS_IdeaNewControllerTest.testSetupQuery(false);
		System.assertNotEquals('', SVNSUMMITS_IdeaNewController.getZoneId(SVNSUMMITS_IdeaNewControllerTest.currCommunity[0].Name));
		System.assertEquals('', SVNSUMMITS_IdeaNewController.getZoneId('______'));
		System.assertEquals('', SVNSUMMITS_IdeaNewController.getZoneId(''));
	}

	@isTest
	static void test_createIdeaNew() {

		SVNSUMMITS_IdeaNewControllerTest.testSetupQuery(false);
		List<Idea> ideaList = new List<Idea>();
		Idea currIdea = new Idea(Title = 'test', CommunityId = SVNSUMMITS_IdeaNewControllerTest.currCommunity[0].Id);
		ideaList.add(currIdea);
		System.assertNotEquals(null, SVNSUMMITS_IdeaNewController.createIdeaNew(ideaList));
		System.assertEquals(null, SVNSUMMITS_IdeaNewController.createIdeaNew(null));
	}

	@isTest
	static void test_updateIdea() {
		SVNSUMMITS_IdeaNewControllerTest.testSetupQuery(false);
		List<Idea> ideaList = new List<Idea>();
		Idea currIdea = new Idea(Title = 'test', CommunityId = SVNSUMMITS_IdeaNewControllerTest.currCommunity[0].Id);
		ideaList.add(currIdea);
		System.assertNotEquals(null, SVNSUMMITS_IdeaNewController.createIdeaNew(ideaList));

		currIdea.Title = 'Updated Title';
		List<Idea> updateList = new List<Idea>();
		updateList.add(currIdea);
		SVNSUMMITS_IdeaNewController.updateIdea(updateList);
		Idea savedIdea = SVNSUMMITS_IdeaViewController.getIdea(currIdea.Id, SVNSUMMITS_IdeaNewControllerTest.currCommunity[0].Id);
		System.assertEquals('Updated Title', savedIdea.Title);

		System.assertEquals(null, SVNSUMMITS_IdeaNewController.updateIdea(null));
	}

	@isTest
	static void test_deleteIdea() {
		SVNSUMMITS_IdeaNewControllerTest.testSetupQuery(false);
		List<Idea> ideaList = new List<Idea>();
		Idea currIdea = new Idea(Title = 'test', CommunityId = SVNSUMMITS_IdeaNewControllerTest.currCommunity[0].Id);
		ideaList.add(currIdea);
		Id currIdeaId = SVNSUMMITS_IdeaNewController.createIdeaNew(ideaList);
		System.assertNotEquals(null, currIdeaId);

		System.assertEquals(true, SVNSUMMITS_IdeaNewController.deleteIdea(currIdeaId + ''));
		System.assertEquals(false, SVNSUMMITS_IdeaNewController.deleteIdea(currIdeaId + ''));
	}

	@isTest
	static void test_checkDuplicateIdeas() {
		SVNSUMMITS_IdeaNewControllerTest.testSetupQuery(true);
		Id[] fixedSearchResults = new Id[]{
				SVNSUMMITS_IdeaNewControllerTest.awesomeIdea.Id
		};
		System.Test.setFixedSearchResults(fixedSearchResults);
		List<Idea> ideaList = SVNSUMMITS_IdeaNewController.checkDuplicateIdeas('test',
				SVNSUMMITS_IdeaNewControllerTest.currCommunity[0].Id + '', 5);
		System.assertEquals(5, ideaList.size());
	}

	@isTest
	static void test_getTopicNamesList() {
		Topic t = new Topic(Name = 'test');
		insert t;
		List<Topic> topicList = SVNSUMMITS_IdeaNewController.getTopicNamesList();
		Boolean containsValue = false;
		for (Topic s : topicList) {
			if (s.Name == 'test') {
				containsValue = true;
			}
		}
		System.assertEquals(true, containsValue);
	}

	@isTest
	static void test_getPicklistValues() {
		List<String> pickList = SVNSUMMITS_IdeaNewController.getPicklistValues('Idea', 'Categories');
		system.debug(LoggingLevel.DEBUG, pickList);
		System.assertNotEquals(null, pickList);
	}

	@isTest
	static void test_getObjectValues() {
		String objName = 'IdeaTheme';
		String fieldName = 'Title';

		List<String> objList = SVNSUMMITS_IdeaNewController.getobjValues(objName, fieldName);
		System.assertNotEquals(null, objList);

		System.assertEquals(null, SVNSUMMITS_IdeaNewController.getobjValues('', fieldName));
	}

	@isTest
	static void test_getThemeList() {
		List<IdeaTheme> themes = SVNSUMMITS_IdeaNewController.getThemeList('');
		System.assertEquals(null, themes);
		//themes = SVNSUMMITS_IdeaNewController.getThemeList('ideaslc');
		//system.assertNotEquals(null, themes);
	}

	@isTest
	static void test_getIdea() {
		SVNSUMMITS_IdeaNewControllerTest.testSetupQuery(false);
		Idea tmpIdea = SVNSUMMITS_IdeaNewController.getIdea(SVNSUMMITS_IdeaNewControllerTest.currIdeaList[0].Id,
				SVNSUMMITS_IdeaNewControllerTest.currCommunity[0].Id);
		System.assertEquals(tmpIdea.Id, SVNSUMMITS_IdeaNewControllerTest.currIdeaList[0].Id);
	}

	@isTest
	static void test_defaultStatus() {
		String status = SVNSUMMITS_IdeaNewController.getDefaultStatus();
		System.assertNotEquals(null, status);
		system.debug('default Idea status: ' + status);
	}

	@isTest
	static void test_getCommonSettings() {
		SVNSUMMITS_Ideas_Common settings = SVNSUMMITS_IdeaNewController.getCommonSettings();
		system.assertNotEquals(null, settings);
	}
}