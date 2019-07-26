/**
 * Created by 7Summits on 8/1/17.
 */

public with sharing class Peak_KnowledgeFilter_TopicFilters {

    //Pull this out and make static to prevent rerunning through all of our topics to get ids
    private static Set<Id> navigationalTopicSubTopicIds = new Set<Id>();

    public static List<Peak_KnowledgeFilter_TopicWrapper> getFiltersListByIds(List<String> topicIds){
        String network = System.Network.getNetworkId();

        if(Test.isRunningTest()){
            List<Network> networks = [SELECT id FROM Network];
            network = networks[0].id;
        }

        // get navigational topics
        ConnectApi.ManagedTopicCollection topics = getManagedTopics(network);

        // prepare topic wrappers
        List<Peak_KnowledgeFilter_TopicWrapper> topicWrappers = prepareTopicWrappers(topics.managedTopics);

        // filter results by topics Ids passed in
        List<Peak_KnowledgeFilter_TopicWrapper> results = filterTopicWrappersById(topicWrappers, topicIds);

        System.debug('----------------------> RESULTS' + results + topicIds);


        return results;
    }

    private static List<Peak_KnowledgeFilter_TopicWrapper> prepareTopicWrappers(List<ConnectApi.ManagedTopic> managedTopicList){
        List<Peak_KnowledgeFilter_TopicWrapper> topicWrappers = new List<Peak_KnowledgeFilter_TopicWrapper>();

        // iterate all the topics
        for (ConnectApi.ManagedTopic managedTopic : managedTopicList) {
            Peak_KnowledgeFilter_TopicWrapper wrapper = new Peak_KnowledgeFilter_TopicWrapper(managedTopic.topic.name, managedTopic.topic.Id);
            navigationalTopicSubTopicIds.add(wrapper.topicId);

            //recursively jump down children to build parent heirarchy
            if(!managedTopic.children.isEmpty()) {
                List<Peak_KnowledgeFilter_TopicWrapper> childTopicWrappers = prepareTopicWrappers(managedTopic.children);
                wrapper.childTopicList = childTopicWrappers;
            }

            topicWrappers.add(wrapper);
        }

        return topicWrappers;
    }

    private static List<Peak_KnowledgeFilter_TopicWrapper> filterTopicWrappersById(List<Peak_KnowledgeFilter_TopicWrapper> topicWrappers, List<String> topicIds){
        List<Peak_KnowledgeFilter_TopicWrapper> results = new List<Peak_KnowledgeFilter_TopicWrapper>();

        // iterate all the topics
        for (String topicId : topicIds) {

            for (Peak_KnowledgeFilter_TopicWrapper topicWrapper : topicWrappers) {
                Peak_KnowledgeFilter_TopicWrapper foundTopicWrapper = findTopicWrapperById(topicWrapper, topicId);
                if(foundTopicWrapper != null){
                    results.add(foundTopicWrapper);
                }
            }
        }

        return results;
    }


    private static Peak_KnowledgeFilter_TopicWrapper findTopicWrapperById(Peak_KnowledgeFilter_TopicWrapper topicWrapper, String topicId){

        if(topicWrapper.topicId == topicId){
            return topicWrapper;
        }

        else if(!topicWrapper.childTopicList.isEmpty()){
            for (Peak_KnowledgeFilter_TopicWrapper childTopicWrapper : topicWrapper.childTopicList) {
                return findTopicWrapperById(childTopicWrapper, topicId);
            }
        }

        return null;
    }

    private static ConnectApi.ManagedTopicCollection getManagedTopics(String network){
        if(network != '') {
            ConnectApi.ManagedTopicCollection topics = ConnectApi.ManagedTopics.getManagedTopics(network, ConnectApi.ManagedTopicType.Navigational, 3);

            return topics;
        }

        return null;
    }

}