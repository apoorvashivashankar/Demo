/* Copyright ©2016-2017 7Summits Inc. All rights reserved. */

/**
 * Created by francoiskorb on 10/26/16.
 */

global with sharing class SVNSUMMITS_IdeasTopicController {

    @AuraEnabled
    public static List<String> getTopicNamesList()
    {
        Id networkId = System.Network.getNetworkId();
        List<String> topicNamesList = new List<String>();
        List<Topic> topicList = new List<Topic>();

        if (networkId != null)
        {
            topicList = [SELECT CreatedById,CreatedDate,Description,Id,Name,NetworkId,TalkingAbout
            FROM Topic WHERE NetworkId = :networkId];
        }
        else
        {
            topicList = [SELECT CreatedById,CreatedDate,Description,Id,Name,NetworkId,TalkingAbout
            FROM Topic LIMIT 2000];
        }

        for(Topic t : topicList)
        {
            topicNamesList.add(t.Name);
        }

        return topicNamesList;
    }

    @AuraEnabled
    public static Map <String, String> getTopicMap(List<String> uniqueTopicNames)
    {
        Id networkId = System.Network.getNetworkId();
        Map <String, String> topicNameToId = new Map <String, String>();
        List<Topic> topicList = new List<Topic>();

        if (networkId != null) {
            topicList = [
                    SELECT CreatedById, CreatedDate, Description, Id, Name, NetworkId, TalkingAbout
                    FROM Topic
                    WHERE Name IN :uniqueTopicNames AND NetworkId = :networkId
            ];
        } else {
            topicList = [
                    SELECT CreatedById, CreatedDate, Description, Id, Name, NetworkId, TalkingAbout
                    FROM Topic
                    WHERE Name IN :uniqueTopicNames
            ];
        }

        for (Topic t : topicList) {
            topicNameToId.put(t.Name, t.Id);
        }

        system.debug('----topicNameToId' + topicNameToId);

        return topicNameToId;
    }
}