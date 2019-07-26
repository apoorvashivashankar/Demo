/* Copyright ©2016-2017 7Summits Inc. All rights reserved. */

@isTest
private class SVNSUMMITS_IdeaListWrapperTest {
    public static Network currNetwork;
    public static List<Community> currCommunity;
    public static List<Idea> currIdeaList;

    static void testSetupQuery() {
        currCommunity = [Select Id, Name FROM Community];
        currIdeaList = [SELECT Id FROM Idea WHERE title = 'test' ORDER BY CreatedDate DESC];
    }

    @testSetup
    static void testSetupData() {
        SVNSUMMITS_IdeaListWrapperTest.testSetupQuery();

        System.assertNotEquals(null, SVNSUMMITS_IdeaListWrapperTest.currCommunity);
        System.assert(SVNSUMMITS_IdeaListWrapperTest.currCommunity.size() > 0);

        Idea currIdea = new Idea(CommunityId = currCommunity[0].Id, title = 'test', Related_Topic_Name__c = 'test');
        Idea currIdea2 = new Idea(CommunityId = currCommunity[0].Id, title = 'test', Related_Topic_Name__c = 'test');

        List<Idea> tmpIdeaList = new List<Idea>();
        tmpIdeaList.add(currIdea);
        tmpIdeaList.add(currIdea2);
        insert tmpIdeaList;

        System.assertNotEquals(null, tmpIdeaList[0].Id);
        System.assertNotEquals(null, tmpIdeaList[1].Id);
    }

    @isTest
    static void test_SVNSUMMITS_ideaListWrapper() {

        Topic t = new Topic(Name = 'test');
        insert t;

        SVNSUMMITS_IdeaListWrapperTest.testSetupQuery();

        Id ideaId1 = SVNSUMMITS_IdeaListWrapperTest.currIdeaList[0].Id;
        Id ideaId2 = SVNSUMMITS_IdeaListWrapperTest.currIdeaList[1].Id;

        String QUERY = 'SELECT Id, Title, Status, CreatedBy.Name, CreatedBy.Id, Related_Topic_Name__c,';
        QUERY += ' Body, CreatedDate, Categories, numComments, VoteTotal, attachmentName FROM Idea WHERE Id =\'' + ideaId1 + '\' OR Id =\'' + ideaId2 + '\' ORDER BY CreatedDate DESC';

        SVNSUMMITS_ideaListWrapper ilw = new SVNSUMMITS_ideaListWrapper(QUERY, 1);

        System.assertNotEquals(null, ilw);
        System.assertNotEquals(null, ilw.ideaList);
        System.assert(ilw.ideaList.size() == 1);
        System.assert(ilw.pageNumber == 1);
        System.assert(ilw.ideaList[0].Id == ideaId1);

        // custom settings
        System.assertEquals(null, ilw.debugMode);
        System.assertEquals(null, ilw.allowDownVoting);

        ilw.nextPage();
        System.assert(ilw.pageNumber == 2);
        System.assert(ilw.ideaList[0].Id == ideaId2);

        ilw.previousPage();
        System.assert(ilw.pageNumber == 1);
        System.assert(ilw.ideaList[0].Id == ideaId1);
    }
}