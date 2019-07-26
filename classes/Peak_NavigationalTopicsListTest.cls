/**
 * Created by 7Summits on 8/7/17.
 */

@isTest
public with sharing class Peak_NavigationalTopicsListTest {

    public static final String MANAGED_PARENT_TOPIC = 'TestApexTopic';
    public static final String MANAGED_CHILD_TOPIC = 'TestApexChildTopic';
    public static final String MANAGED_CHILD_TOPIC_CHILD = 'TestApexChildTopicChild';
    public static final List<Network> NETWORKS = [SELECT id FROM Network];
    public static final Id NETWORKID = NETWORKS[0].id;

    @IsTest(SeeAllData=true)
    public static void getDefaultValue() {

        PEAK_NavigationalTopicsList topicList = new PEAK_NavigationalTopicsList();

        VisualEditor.DataRow row = topicList.getDefaultValue();

        VisualEditor.DataRow expectedResult = new VisualEditor.DataRow('Select', '');

        System.assertEquals(expectedResult.getLabel(), row.getLabel());
        System.assertEquals(expectedResult.getValue(), row.getValue());
        System.assertEquals(expectedResult.isSelected(), row.isSelected());
    }

    @IsTest(SeeAllData=true)
    public static void getValues() {
        ConnectApi.ManagedTopic parentTopic = ConnectApi.ManagedTopics.createManagedTopicByName(NETWORKID, MANAGED_PARENT_TOPIC, ConnectApi.ManagedTopicType.Navigational);
        ConnectApi.ManagedTopic childTopic = ConnectApi.ManagedTopics.createManagedTopicByName(NETWORKID, MANAGED_CHILD_TOPIC, ConnectApi.ManagedTopicType.Navigational, parentTopic.id);
        ConnectApi.ManagedTopics.createManagedTopicByName(NETWORKID, MANAGED_CHILD_TOPIC_CHILD, ConnectApi.ManagedTopicType.Navigational, childTopic.id);

        PEAK_NavigationalTopicsList topicList = new PEAK_NavigationalTopicsList();

        VisualEditor.DynamicPickListRows rows = topicList.getValues();

        // check the default row
        VisualEditor.DataRow defaultRow = rows.get(0);
        VisualEditor.DataRow expectedResult = new VisualEditor.DataRow('Select', '');
    }


}