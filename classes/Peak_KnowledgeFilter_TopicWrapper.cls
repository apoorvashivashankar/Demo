/**
 * Created by 7Summits on 8/1/17.
 */

public with sharing class Peak_KnowledgeFilter_TopicWrapper {
    @auraEnabled
    @TestVisible Public String topicName {get;set;}

    @auraEnabled
    @TestVisible Public String topicId {get;set;}

    @auraEnabled
    @TestVisible Public List<Peak_KnowledgeFilter_TopicWrapper> childTopicList {get;set;}

    public Peak_KnowledgeFilter_TopicWrapper(String Name, String Id){
        topicName = Name;
        topicId = Id;
        childTopicList = new List<Peak_KnowledgeFilter_TopicWrapper>();
    }

}