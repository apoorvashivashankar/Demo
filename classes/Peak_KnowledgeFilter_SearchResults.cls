/**
 * Created by 7Summits on 8/3/17.
 */

public with sharing class Peak_KnowledgeFilter_SearchResults {

    @auraEnabled Public List<Peak_KnowledgeFilter_SearchResult> results {get;set;}

    /**
        Search Results constructor for SOQL query results
     */
    public Peak_KnowledgeFilter_SearchResults(List<KnowledgeArticleVersion> resultsList){
        List<Peak_KnowledgeFilter_SearchResult> searchResults = new List<Peak_KnowledgeFilter_SearchResult>();

        // create a set of result Ids that will be used
        // to get the topicAssignments associated with the result
        Set<Id> resultIds = new Set<Id>();
        for (KnowledgeArticleVersion result : resultsList) {
            resultIds.add(result.Id);
        }

        // get the topics associated with the results
        Map<Id, List<Peak_KnowledgeFilter_SearchResultTopic>> topicAssignments = getAllTopicAssignments(resultIds);

        // iterate all the search results and create search result object to return
        for (KnowledgeArticleVersion result : resultsList) {
            String knowledgeArticleId = result.KnowledgeArticleId;
            String title = result.Title;
            Integer articleTotalViewCount = result.ArticleTotalViewCount;
            DateTime lastModifiedDate = result.LastModifiedDate;

            // get the topics associated with this result
            List<Peak_KnowledgeFilter_SearchResultTopic> topicsList = new List<Peak_KnowledgeFilter_SearchResultTopic>();
            if(topicAssignments.containsKey(result.Id)){
                topicsList = topicAssignments.get(result.Id);
            }

            Peak_KnowledgeFilter_SearchResult resultWrapper = new Peak_KnowledgeFilter_SearchResult(knowledgeArticleId, title, articleTotalViewCount, lastModifiedDate, topicsList);

            searchResults.add(resultWrapper);
        }

        this.results = searchResults;
    }

    /**
        Search Results constructor for SOSL search results
     */
    public Peak_KnowledgeFilter_SearchResults(List<Search.SearchResult> resultsList){
        List<Peak_KnowledgeFilter_SearchResult> searchResults = new List<Peak_KnowledgeFilter_SearchResult>();

        // create a set of result Ids that will be used
        // to get the topicAssignments associated with the result
        Set<Id> resultIds = new Set<Id>();
        for (Search.SearchResult result : resultsList) {
            KnowledgeArticleVersion kav = (KnowledgeArticleVersion) result.getSObject();
            resultIds.add(kav.Id);
        }

        // get the topics associated with the results
        Map<Id, List<Peak_KnowledgeFilter_SearchResultTopic>> topicAssignments = getAllTopicAssignments(resultIds);

        // iterate all the search results and create search result object to return
        for (Search.SearchResult searchResult : resultsList) {
            KnowledgeArticleVersion result = (KnowledgeArticleVersion) searchResult.getSObject();

            String knowledgeArticleId = result.KnowledgeArticleId;
            String title = result.Title;
            Integer articleTotalViewCount = result.ArticleTotalViewCount;
            DateTime lastModifiedDate = result.LastModifiedDate;

            // get the topics associated with this result
            List<Peak_KnowledgeFilter_SearchResultTopic> topicsList = new List<Peak_KnowledgeFilter_SearchResultTopic>();
            if(topicAssignments.containsKey(result.Id)){
                topicsList = topicAssignments.get(result.Id);
            }

            Peak_KnowledgeFilter_SearchResult resultWrapper = new Peak_KnowledgeFilter_SearchResult(knowledgeArticleId, title, articleTotalViewCount, lastModifiedDate, topicsList);

            searchResults.add(resultWrapper);
        }

        this.results = searchResults;
    }

    private Map<Id, List<Peak_KnowledgeFilter_SearchResultTopic>> getAllTopicAssignments(Set<Id> resultIds) {
        Map<Id, List<Peak_KnowledgeFilter_SearchResultTopic>> results = new Map<Id, List<Peak_KnowledgeFilter_SearchResultTopic>>();
        String netwrkId = System.Network.getNetworkId();

        // get a map of all the topics in the org
        Map<Id, Topic> topicsMap = getAllTopics();

        // query for all the topicAssignments in the org that match have a matching entityId as one of our search results
        List<TopicAssignment> topicAssignments = [SELECT Id, EntityId, TopicId FROM TopicAssignment WHERE EntityId IN : resultIds And Topic.NetworkId =: netwrkId];

        // Iterate all the topic assignments and return a map that has a key of the
        // the a results entity ID and the value of all the topics associated to it.
        for (TopicAssignment topicAssignment : topicAssignments) {

            // check if already have the item in our map, if not
            // add the key and then add the item to the list. If
            // it is already there just add it to the list
            if(results.containsKey(topicAssignment.EntityId)) {
                List<Peak_KnowledgeFilter_SearchResultTopic> searchResultTopicList = results.get(topicAssignment.EntityId);
                Peak_KnowledgeFilter_SearchResultTopic newTopic = createSearchResultTopic(topicAssignment, topicsMap);
                searchResultTopicList.add(newTopic);
                results.put(topicAssignment.EntityId, searchResultTopicList);
            }

            else {
                Peak_KnowledgeFilter_SearchResultTopic newTopic = createSearchResultTopic(topicAssignment, topicsMap);
                results.put(topicAssignment.EntityId, new List<Peak_KnowledgeFilter_SearchResultTopic>{newTopic});
            }

        }

        return results;
    }

    /**
        Get all the topics in the org
     */
    private Map<Id, Topic> getAllTopics() {
        String netwrkId = System.Network.getNetworkId();

        List<Topic> topics = [SELECT Id, Name FROM Topic WHERE NetworkId =: netwrkId];

        Map<Id, Topic> topicObjIds = new Map<Id, Topic>();

        for(Topic topic : topics) {
            topicObjIds.put(topic.Id, topic);
        }

        return topicObjIds;
    }

    /**
        Given a map of a topics and a topicAssignment check to see if the topicAssignment is in the map of topics. If so return a searchResultTopic object.
     */
    private Peak_KnowledgeFilter_SearchResultTopic createSearchResultTopic(TopicAssignment topicAssignment, Map<Id, Topic> topicsMap){
        Peak_KnowledgeFilter_SearchResultTopic result = new Peak_KnowledgeFilter_SearchResultTopic();
        if(topicsMap.containsKey(topicAssignment.TopicId)){
            Topic topic = topicsMap.get(topicAssignment.TopicId);
            result.id = topic.Id;
            result.name = topic.Name;
        }

        return result;
    }

}