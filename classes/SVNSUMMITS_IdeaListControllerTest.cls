/* Copyright ©2016-2017 7Summits Inc. All rights reserved. */

@isTest
private class SVNSUMMITS_IdeaListControllerTest
{
	public static Network currNetwork;
	public static List<Community> currCommunity;
	public static Idea currIdea;

	static void testSetupQuery() {
		currCommunity = [Select Id, Name FROM Community];
		currIdea = [SELECT Id FROM Idea WHERE title = 'test' ORDER BY CreatedDate DESC LIMIT 1];
	}

	@testSetup
	static void testSetupData() {
		currCommunity = [Select Id, Name FROM Community];
		System.assertNotEquals(null,currCommunity);
		System.assert(currCommunity.size() > 0);
		List<Idea> tmpIdeaList = new List<Idea>();
		Idea tmpIdea = new Idea(CommunityId = currCommunity[0].Id, title='test');
		tmpIdeaList.add(tmpIdea);
		Idea tmpIdea2 = new Idea(CommunityId = currCommunity[0].Id, title='test');
		tmpIdeaList.add(tmpIdea2);
		insert tmpIdeaList;
		System.assertNotEquals(null,tmpIdeaList[0].Id);
		System.assertNotEquals(null,tmpIdeaList[1].Id);
		IdeaComment tmpIdeaComment = new IdeaComment(CommentBody = 'test', IdeaId = tmpIdeaList[1].Id);
		insert tmpIdeaComment;
		System.assertNotEquals(null,tmpIdeaComment.Id);
	}

	@isTest
	static void test_isAuthenticated()
	{
		System.assert(true, SVNSUMMITS_IdeaListController.isAuthenticated());
	}

	@isTest
	static void test_isNicknameDisplayEnabled()
	{
		System.assertEquals(true, SVNSUMMITS_IdeaListController.isNicknameDisplayEnabled());
	}

	@isTest
	static void test_getUserId()
	{
		System.assertEquals(UserInfo.getUserId(), SVNSUMMITS_IdeaListController.getUserId());
	}

	@isTest
	static void test_getSitePrefix()
	{
		System.assertEquals('', SVNSUMMITS_IdeaListController.getSitePrefix());
	}

	@isTest
	static void test_getIdeasAttributeCount()
	{
		SVNSUMMITS_IdeaListControllerTest.testSetupQuery();
		Integer countAttr = SVNSUMMITS_IdeaListController.getIdeasAttributeCount(SVNSUMMITS_IdeaListControllerTest.currCommunity[0].Id+'', 'Voted On Ideas', UserInfo.getUserId()+'');
		System.assertEquals(0, countAttr);
		countAttr = SVNSUMMITS_IdeaListController.getIdeasAttributeCount(SVNSUMMITS_IdeaListControllerTest.currCommunity[0].Id+'', 'My Ideas', UserInfo.getUserId()+'');
		System.assert(countAttr == 2);
	}

	@isTest
	static void test_getZoneId()
	{
		SVNSUMMITS_IdeaListControllerTest.testSetupQuery();
		System.assertNotEquals('', SVNSUMMITS_IdeaListController.getZoneId(SVNSUMMITS_IdeaListControllerTest.currCommunity[0].Name));
		System.assertEquals('', SVNSUMMITS_IdeaListController.getZoneId('______'));
		System.assertEquals('', SVNSUMMITS_IdeaListController.getZoneId(''));
	}

	@isTest
	static void test_getFeaturedIdeas()
	{
		SVNSUMMITS_IdeaListControllerTest.testSetupQuery();
		SVNSUMMITS_ideaListWrapper ilw = SVNSUMMITS_IdeaListController.getIdeas();

		SVNSUMMITS_ideaListWrapper feature = SVNSUMMITS_IdeaListController.getFeaturedIdeas(
				ilw.ideaList[0].Id, ilw.ideaList[1].Id, '');
		System.assert(feature.ideaList.size() == 2);
	}

	@isTest
	static void test_getIdeas()
	{
		SVNSUMMITS_IdeaListControllerTest.testSetupQuery();
		SVNSUMMITS_ideaListWrapper ilw = SVNSUMMITS_IdeaListController.getIdeas();
		System.assertNotEquals(null, ilw);
		System.assertNotEquals(null, ilw.ideaList);
		System.assert(ilw.ideaList.size() == 2);

		ilw = SVNSUMMITS_IdeaListController.getIdeas(1, null, SVNSUMMITS_IdeaListControllerTest.currCommunity[0].Id+'', 'Popular Ideas', false, false, null, false, null, false, false, '', '', '', '', '');
		System.assertNotEquals(null, ilw);
		System.assertNotEquals(null, ilw.ideaList);
		System.assert(ilw.ideaList.size() == 1);

		ilw = SVNSUMMITS_IdeaListController.getIdeas(1, null, SVNSUMMITS_IdeaListControllerTest.currCommunity[0].Id+'', 'Recent Ideas', false, false, null, false, null, false, true, '', '', '', '', '');
		System.assertNotEquals(null, ilw);
		System.assertNotEquals(null, ilw.ideaList);
		System.assert(ilw.ideaList.size() == 0);

		ilw = SVNSUMMITS_IdeaListController.getIdeas(1, null, SVNSUMMITS_IdeaListControllerTest.currCommunity[0].Id+'', 'Top All-Time', false, false, null, false, null, true, false, '', '', '', '', '');
		System.assertNotEquals(null, ilw);
		System.assertNotEquals(null, ilw.ideaList);
		System.assert(ilw.ideaList.size() == 1);

		ilw = SVNSUMMITS_IdeaListController.getIdeas(1, null, SVNSUMMITS_IdeaListControllerTest.currCommunity[0].Id+'', 'Popular Ideas', false, false, null, true, '________________', false, false, '', '', '', '', '');
		System.assertNotEquals(null, ilw);
		System.assertNotEquals(null, ilw.ideaList);
		System.assert(ilw.ideaList.size() == 0);

		ilw = SVNSUMMITS_IdeaListController.getIdeas(1, null, SVNSUMMITS_IdeaListControllerTest.currCommunity[0].Id+'', 'Recent Comments', false, false, null, true, '', false, false, '', '', '', '', '');
		System.assertNotEquals(null, ilw);
		System.assertNotEquals(null, ilw.ideaList);
		System.assert(ilw.ideaList.size() == 0);

		ilw = SVNSUMMITS_IdeaListController.getIdeas(1, null, SVNSUMMITS_IdeaListControllerTest.currCommunity[0].Id+'', 'Recent Comments', true, false, null, false, null, false, false, '', '', '', '', '');
		System.assertNotEquals(null, ilw);
		System.assertNotEquals(null, ilw.ideaList);
		System.assert(ilw.ideaList.size() == 1);

		ilw = SVNSUMMITS_IdeaListController.getIdeas(1, null, SVNSUMMITS_IdeaListControllerTest.currCommunity[0].Id+'', 'Popular Ideas', false, true, '______', false, null, false, false, '', '', '', '', '');
		System.assertNotEquals(null, ilw);
		System.assertNotEquals(null, ilw.ideaList);
		System.assert(ilw.ideaList.size() == 0);

		ilw = SVNSUMMITS_IdeaListController.getIdeas(1, '_____,------', SVNSUMMITS_IdeaListControllerTest.currCommunity[0].Id+'', 'Popular Ideas', false, false, null, false, null, false, false, '', '', '', '', '');
		System.assertNotEquals(null, ilw);
		System.assertNotEquals(null, ilw.ideaList);
		System.assert(ilw.ideaList.size() == 0);

	}

	@isTest
	static void test_nextPage()
	{
		SVNSUMMITS_IdeaListControllerTest.testSetupQuery();
		SVNSUMMITS_ideaListWrapper ilw = SVNSUMMITS_IdeaListController.nextPage(1,1, null,
				SVNSUMMITS_IdeaListControllerTest.currCommunity[0].Id+'', 'Popular Ideas',
				false, false, null, false, null, false, false, '', '', '', '', '');
		System.assertEquals(2, ilw.pageNumber);
	}

	@isTest
	static void test_previousPage()
	{
		SVNSUMMITS_IdeaListControllerTest.testSetupQuery();
		SVNSUMMITS_ideaListWrapper ilw = SVNSUMMITS_IdeaListController.nextPage(1,1, null,
				SVNSUMMITS_IdeaListControllerTest.currCommunity[0].Id+'', 'Popular Ideas',
				false, false, null, false, null, false, false, '', '', '', '', '');
		System.assertEquals(2, ilw.pageNumber);
		ilw = SVNSUMMITS_IdeaListController.previousPage(1,2, null,
				SVNSUMMITS_IdeaListControllerTest.currCommunity[0].Id+'', 'Popular Ideas',
				false, false, null, false, null, false, false, '', '', '', '', '');
		System.assertEquals(1, ilw.pageNumber);
	}

	@isTest
	static void test_getPage()
	{
		SVNSUMMITS_IdeaListControllerTest.testSetupQuery();
		SVNSUMMITS_ideaListWrapper ilw = SVNSUMMITS_IdeaListController.getPage(1,1, null,
				SVNSUMMITS_IdeaListControllerTest.currCommunity[0].Id+'', 'Popular Ideas',
				false, false, null, false, null, false, false, '', '', '', '', '');
		System.assertEquals(1, ilw.pageNumber);

	}

	@isTest
	static void test_submitVote()
	{
		SVNSUMMITS_IdeaListControllerTest.testSetupQuery();
		Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@CCIDEASLC.com');
		System.runAs(u)
		{
			Idea afterVoteIdea = SVNSUMMITS_IdeaListController.submitVote(SVNSUMMITS_IdeaListControllerTest.currIdea.Id+'', 'Down');
			System.assertEquals(0, afterVoteIdea.VoteTotal);
		}

		Idea afterVoteIdea = SVNSUMMITS_IdeaListController.submitVote(SVNSUMMITS_IdeaListControllerTest.currIdea.Id+'', 'Up');
		System.assertEquals(null, afterVoteIdea);

	}

	@isTest
	static void test_getPicklistValues()
	{
		System.assertNotEquals(null, SVNSUMMITS_IdeaListController.getPicklistValues('Idea','Categories'));
	}

	@isTest
	static void test_getCommonSettings() {
		SVNSUMMITS_Ideas_Common common = SVNSUMMITS_IdeaListController.getCommonSettings();

		// custom settings
		System.assertNotEquals(null, common);
		// System.assertNotEquals(null, common.allowDownVoting);
		// System.assertNotEquals(null, common.debugMode);
	}

	@isTest
	static void test_getObjectValues()
	{
		String objName = 'IdeaTheme';
		String fieldName = 'Title';

		List<String> objList = SVNSUMMITS_IdeaListController.getobjValues(objName, fieldName);
		System.assertNotEquals(null, objList);

		System.assertEquals(null, SVNSUMMITS_IdealistController.getobjValues('', ''));
	}

	@isTest
	static void test_filterWrapper()
	{
		SVNSUMMITS_IdeaListController.filterWrapper fw = new SVNSUMMITS_IdeaListController.filterWrapper('field1', 'value1');
		System.assertEquals('field1', fw.field);
		System.assertEquals('value1', fw.value);
	}

	@IsTest
	static void test_getNameSpacePrefix() {
		SVNSUMMITS_IdeaBaseController controller = new SVNSUMMITS_IdeaBaseController();
		System.assertNotEquals(null, controller);

		SVNSUMMITS_IdeaBaseController.BaseModel model = SVNSUMMITS_IdeaBaseController.getModel();
		System.assertNotEquals(null, model);
	}
}