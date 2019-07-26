/* Copyright ©2016-2017 7Summits Inc. All rights reserved. */

@isTest
private class SVNSUMMITS_IdeaCommentsControllerTest
{
	public static Network currNetwork;
	public static List<Community> currCommunity;
	public static Idea currIdea;
	public static IdeaComment currIdeaComment;


	static void testSetupQuery() {
		currCommunity = [Select Id, Name FROM Community];
		currIdea = [SELECT Id FROM Idea WHERE title = 'test' ORDER BY CreatedDate DESC LIMIT 1];
		currIdeaComment = [SELECT Id FROM IdeaComment WHERE IdeaId = :currIdea.Id];

	}

	@testSetup
	static void testSetupData() {
		currCommunity = [Select Id, Name FROM Community];
		System.assertNotEquals(null,currCommunity);
		System.assert(currCommunity.size() > 0);
		Idea tmpIdea = new Idea(CommunityId = currCommunity[0].Id, title='test');
		insert tmpIdea;
		System.assertNotEquals(null,tmpIdea.Id);
		IdeaComment tmpIdeaComment = new IdeaComment(CommentBody = 'test', IdeaId = tmpIdea.Id);
		insert tmpIdeaComment;
		System.assertNotEquals(null,tmpIdeaComment.Id);

	}

	@isTest
	static void test_isAuthenticated()
	{
		System.assert(true, SVNSUMMITS_IdeaCommentsController.isAuthenticated());
	}

	@isTest
	static void test_isNicknameDisplayEnabled()
	{
		System.assertEquals(true, SVNSUMMITS_IdeaCommentsController.isNicknameDisplayEnabled());
	}

	@isTest
	static void test_getSitePrefix()
	{
		System.assertEquals('', SVNSUMMITS_IdeaCommentsController.getSitePrefix());
	}

	@isTest
	static void test_getZoneId()
	{
		SVNSUMMITS_IdeaCommentsControllerTest.testSetupQuery();
		System.assertNotEquals('', SVNSUMMITS_IdeaCommentsController.getZoneId(SVNSUMMITS_IdeaCommentsControllerTest.currCommunity[0].Name));
		System.assertEquals('', SVNSUMMITS_IdeaCommentsController.getZoneId('______'));
		System.assertEquals('', SVNSUMMITS_IdeaCommentsController.getZoneId(''));
	}

	@isTest
	static void test_isValidIdeaId()
	{
		SVNSUMMITS_IdeaCommentsControllerTest.testSetupQuery();
		String ideaIdString = SVNSUMMITS_IdeaCommentsControllerTest.currIdea.Id+'';
		System.assertEquals(true, SVNSUMMITS_IdeaCommentsController.isValidIdeaId(ideaIdString, SVNSUMMITS_IdeaCommentsControllerTest.currCommunity[0].Id+''));
		delete SVNSUMMITS_IdeaCommentsControllerTest.currIdea;
		System.assertEquals(false, SVNSUMMITS_IdeaCommentsController.isValidIdeaId(ideaIdString, SVNSUMMITS_IdeaCommentsControllerTest.currCommunity[0].Id+''));
		System.assertEquals(false, SVNSUMMITS_IdeaCommentsController.isValidIdeaId('sdjhfjsdfk', SVNSUMMITS_IdeaCommentsControllerTest.currCommunity[0].Id+''));
	}

	@isTest
	static void test_getTotalCommentCount()
	{
		SVNSUMMITS_IdeaCommentsControllerTest.testSetupQuery();
		String ideaIdString = SVNSUMMITS_IdeaCommentsControllerTest.currIdea.Id+'';
		System.assertEquals(1, SVNSUMMITS_IdeaCommentsController.getTotalCommentCount(ideaIdString,SVNSUMMITS_IdeaCommentsControllerTest.currCommunity[0].Id+''));
		delete currIdeaComment;
		System.assertEquals(0, SVNSUMMITS_IdeaCommentsController.getTotalCommentCount(ideaIdString,SVNSUMMITS_IdeaCommentsControllerTest.currCommunity[0].Id+''));
	}

	@isTest
	static void test_getIdeaComments()
	{
		SVNSUMMITS_IdeaCommentsControllerTest.testSetupQuery();
		String ideaIdString = SVNSUMMITS_IdeaCommentsControllerTest.currIdea.Id+'';
		List<ideaComment> currIdeaCommentList = SVNSUMMITS_IdeaCommentsController.getIdeaComments(ideaIdString, 1, SVNSUMMITS_IdeaCommentsControllerTest.currCommunity[0].Id+'');
		System.assertEquals(1, currIdeaCommentList.size());
		System.assertEquals(SVNSUMMITS_IdeaCommentsControllerTest.currIdeaComment.Id, currIdeaCommentList[0].Id);
	}

	@isTest
	static void test_IdeaCommentVoting()
	{
		SVNSUMMITS_IdeaCommentsControllerTest.testSetupQuery();
		String ideaIdString = SVNSUMMITS_IdeaCommentsControllerTest.currIdea.Id+'';
		List<ideaComment> currIdeaCommentList = SVNSUMMITS_IdeaCommentsController.getIdeaComments(ideaIdString, 1, SVNSUMMITS_IdeaCommentsControllerTest.currCommunity[0].Id+'');
		Map<String,Vote> currIdeaCommentVotesMap = SVNSUMMITS_IdeaCommentsController.getIdeaCommentVotes(ideaIdString, 1, SVNSUMMITS_IdeaCommentsControllerTest.currCommunity[0].Id+'');
		System.assertEquals(0, currIdeaCommentVotesMap.values().size());

		Vote v = SVNSUMMITS_IdeaCommentsController.likeIdeaComment(currIdeaCommentList[0].Id);
		System.assertNotEquals(null, v.Id);

		currIdeaCommentVotesMap = SVNSUMMITS_IdeaCommentsController.getIdeaCommentVotes(ideaIdString, 1, SVNSUMMITS_IdeaCommentsControllerTest.currCommunity[0].Id+'');
		System.assertEquals(1, currIdeaCommentVotesMap.values().size());

		System.assertEquals(true,SVNSUMMITS_IdeaCommentsController.unlikeIdeaComment(v.Id));

		currIdeaCommentVotesMap = SVNSUMMITS_IdeaCommentsController.getIdeaCommentVotes(ideaIdString, 1, SVNSUMMITS_IdeaCommentsControllerTest.currCommunity[0].Id+'');
		System.assertEquals(0, currIdeaCommentVotesMap.values().size());


	}

	@isTest
	static void test_addComment()
	{
		SVNSUMMITS_IdeaCommentsControllerTest.testSetupQuery();
		String ideaIdString = SVNSUMMITS_IdeaCommentsControllerTest.currIdea.Id+'';
		ideaComment tmpIdeaComment = SVNSUMMITS_IdeaCommentsController.addComment(ideaIdString, 'test');
		System.assertNotEquals(null, ideaComment.Id);
	}
}