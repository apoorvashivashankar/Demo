/* Copyright ©2016-2017 7Summits Inc. All rights reserved. */

/**
 * Created by francois korb on 10/26/16.
 */
@isTest
private class SVNSUMMITS_IdeasTopicControllerTest {

    @isTest
    static void test_getTopicNamesList()
    {
        Topic t = new Topic(Name='test');
        insert t;

        List<String> topicList = SVNSUMMITS_IdeasTopicController.getTopicNamesList();

        Boolean containsValue = false;

        for (String s : topicList)
        {
            if (s == 'test')
            {
                containsValue = true;
            }
        }
        System.assertEquals(true,containsValue);
    }

    @isTest
    static void test_getTopicMap()
    {
        List<Community> currCommunity = [Select Id, Name FROM Community];

        Topic t = new Topic(Name='test');
        insert t;

        Idea currIdea = new Idea(CommunityId = currCommunity[0].Id, title = 'test', Related_Topic_Name__c = 'test');
        insert currIdea;

        Set<String> uniqueTopicNames = new Set<String>();
        uniqueTopicNames.add('test');
        List<String> topicNames = new List<String>();

        for (String name : uniqueTopicNames)
        {
            topicNames.add(name);
        }

        Map<String, String> topicMap = SVNSUMMITS_IdeasTopicController.getTopicMap(topicNames);

        Boolean containsValue = topicMap.containsKey('test');

        System.assertEquals(true,containsValue);
    }
}