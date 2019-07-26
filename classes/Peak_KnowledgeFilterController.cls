/**
 * Created by 7Summits on 7/19/17.
 */

public with sharing class Peak_KnowledgeFilterController {

    @AuraEnabled
    public static List<Peak_KnowledgeFilter_TopicWrapper> getNavigationalTopics(List<String> topicIds) {
        List<Peak_KnowledgeFilter_TopicWrapper> filters = Peak_KnowledgeFilter_TopicFilters.getFiltersListByIds(topicIds);
        return filters;
    }

    /**
        Since you can't pass complex objects into APEX from a
        controller so couldn't pass a List<List<String>> so doing
        it this way with topicFilterOne, topicFilterTwo, topicFilterThree, topicFilterFour
     */
    @AuraEnabled
    public static Peak_KnowledgeFilter_SearchResults doSearch(String searchTerm, List<String> topicFilterOne, List<String> topicFilterTwo, List<String> topicFilterThree, List<String> topicFilterFour, String orderByField, String orderByDirection) {
        Peak_KnowledgeFilter_SearchResults searchResult = Peak_KnowledgeFilter_Search.doSearch(searchTerm, topicFilterOne, topicFilterTwo, topicFilterThree, topicFilterFour, orderByField, orderByDirection);

        return searchResult;
    }


}