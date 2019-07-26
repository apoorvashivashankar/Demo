/**
 * Created by 7Summits on 8/7/17.
 */

@IsTest
public with sharing class Peak_KnowledgeFilterAllDataTest {
    public static final String MANAGED_PARENT_TOPIC = 'TestApexTopicOne';
    public static final String MANAGED_CHILD_TOPIC = 'TestApexChildTopicTwo';
    public static final String MANAGED_CHILD_TOPIC_CHILD = 'TestApexChildTopicChildThree';
    public static final List<Network> NETWORKS = [SELECT id FROM Network];
    public static final Id NETWORKID = NETWORKS[0].id;

    @IsTest(SeeAllData=true)
    static void testGetNavigationalTopics() {
        // create parent managed topic
        ConnectApi.ManagedTopic parentTopic = ConnectApi.ManagedTopics.createManagedTopicByName(NETWORKID, MANAGED_PARENT_TOPIC, ConnectApi.ManagedTopicType.Navigational);

        // create child managed topic
        ConnectApi.ManagedTopic childTopic = ConnectApi.ManagedTopics.createManagedTopicByName(NETWORKID, MANAGED_CHILD_TOPIC, ConnectApi.ManagedTopicType.Navigational, parentTopic.id);

        // create third level managed topic
        ConnectApi.ManagedTopics.createManagedTopicByName(NETWORKID, MANAGED_CHILD_TOPIC_CHILD, ConnectApi.ManagedTopicType.Navigational, childTopic.id);

        // get the newly create topics
        ConnectApi.ManagedTopicCollection topics = ConnectApi.ManagedTopics.getManagedTopics(NETWORKID, ConnectApi.ManagedTopicType.Navigational, 3);

        List<String> topicIds = new List<String>();
        for(ConnectApi.ManagedTopic managedTopic : topics.managedTopics) {
            topicIds.add(managedTopic.topic.id);
        }

        Test.startTest();
        List<Peak_KnowledgeFilter_TopicWrapper> results = Peak_KnowledgeFilterController.getNavigationalTopics(topicIds);
//        System.assertEquals(MANAGED_PARENT_TOPIC, results[0].topicName);
//        System.assertEquals(topicIds[0], results[0].topicId);
//        System.assertEquals(1, results[0].childTopicList.size());
        Test.stopTest();
    }

}