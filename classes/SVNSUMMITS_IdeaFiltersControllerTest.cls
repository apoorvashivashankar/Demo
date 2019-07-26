/* Copyright ©2016-2017 7Summits Inc. All rights reserved. */

/**
 * Created by francoiskorb on 10/19/16.
 */

@IsTest
private class SVNSUMMITS_IdeaFiltersControllerTest {
    public static Network currNetwork;
    public static List<Community> currCommunity;
    public static Idea currIdea;

    @testSetup
    static void testSetupData() {
        currCommunity = [Select Id, Name FROM Community];
        System.assertNotEquals(null,currCommunity);
    }

    static void testSetupQuery() {
        currCommunity = [Select Id, Name FROM Community];
        currIdea = [SELECT Id FROM Idea WHERE title = 'test' ORDER BY CreatedDate DESC LIMIT 1];
        System.assertNotEquals(null, currIdea);
    }

    @isTest
    static void test_getSitePrefix()
    {
        System.assertEquals('', SVNSUMMITS_IdeaFiltersController.getSitePrefix());
    }

    @isTest
    static void test_getPicklistValues()
    {
        System.assertNotEquals(null, SVNSUMMITS_IdeaFiltersController.getPicklistValues('Idea','Categories'));
    }

    @isTest
    static void test_getTopicNamesList()
    {
        Topic t = new Topic(Name='UnitTestTopic');
        insert t;

        List<String> topicList = SVNSUMMITS_IdeaFiltersController.getTopicNamesList();
        Boolean containsValue = false;

        for (String s : topicList)
        {
            if (s == 'UnitTestTopic')
            {
                containsValue = true;
            }
        }
        System.assertEquals(true,containsValue);
    }

    @isTest
    static void test_getObjectValues()
    {
        String objName = 'IdeaTheme';
        String fieldName = 'Title';

        List<String> objList = SVNSUMMITS_IdeaFiltersController.getobjValues(objName, fieldName);
        System.assertNotEquals(null, objList);

        System.assertEquals(null, SVNSUMMITS_IdeaFiltersController.getobjValues('', ''));
    }

    @isTest
    static void test_isAuthenticated()
    {
        System.assertNotEquals(null, SVNSUMMITS_IdeaFiltersController.isAuthenticated());
    }

}