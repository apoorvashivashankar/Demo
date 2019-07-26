/*
@Class Name          : PEAK_NavigationalTopicsList
@Created by          :
@Description         : Apex class for creating dynamic navigational topic
*/
global class Peak_NavigationalTopicsList extends VisualEditor.DynamicPickList{

    //Pull this out and make static to prevent rerunning through all of our topics to get ids
    public static Set<Id> navigationalTopicSubTopicIds = new Set<Id>();

    global override VisualEditor.DataRow getDefaultValue() {
        // set the default value of the picklist
        VisualEditor.DataRow defaultValue = new VisualEditor.DataRow('Select', '');

        return defaultValue;
    }

    global override VisualEditor.DynamicPickListRows getValues() {
        List<Network> customerNetwork = [SELECT id, name FROM Network WHERE name = 'Basecamp'];

        String network;
        if (!Peak_Utils.isNullOrEmpty(customerNetwork)) {
            network = customerNetwork[0].id;
        }

        if(Test.isRunningTest()){
            List<Network> networks = [SELECT id FROM Network];
            network = networks[0].id;
        }

        // create picklist
        VisualEditor.DynamicPickListRows myValues = new VisualEditor.DynamicPickListRows();

        // add the default picklist value
        VisualEditor.DataRow defaultTopic = new VisualEditor.DataRow('Select', '');
        myValues.addRow(defaultTopic);

        // Make API call to get managed topics (navigational topics)
        ConnectApi.ManagedTopicCollection topics = ConnectApi.ManagedTopics.getManagedTopics(network, ConnectApi.ManagedTopicType.Navigational, 3);

        // populate picklist
        myValues = populatePickListWithTopics(topics.managedTopics, myValues);

        return myValues;
    }

    private static VisualEditor.DynamicPickListRows populatePickListWithTopics(List<ConnectApi.ManagedTopic> managedTopicList, VisualEditor.DynamicPickListRows pickList){
        // iterate all the topics
        for (ConnectApi.ManagedTopic managedTopic : managedTopicList) {

            // create datarow row and add it to picklist
            VisualEditor.DataRow topic = new VisualEditor.DataRow(managedTopic.topic.name, managedTopic.topic.Id);
            pickList.addRow(topic);

            // recursively check children
            if(!managedTopic.children.isEmpty()) {
                populatePickListWithTopics(managedTopic.children, pickList);
            }
        }

        return pickList;
    }

}