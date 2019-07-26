/* Copyright ©2016-2017 7Summits Inc. All rights reserved. */

/*
@Class Name          : SVNSUMMITS_NewsTopicsList
@Created by          :
@Description         : Apex class for creating dynamic Topic dropdown in SVNSUMMITS_News_List component
*/
global class SVNSUMMITS_NewsTopicsList extends VisualEditor.DynamicPickList{

    global override VisualEditor.DataRow getDefaultValue() {
        // set the default value of the picklist
        VisualEditor.DataRow defaultValue = new VisualEditor.DataRow('None', '');

        return defaultValue;
    }

    global override VisualEditor.DynamicPickListRows getValues() {
        // query string to get all the Topics that are associated to a community
        String queryTopic = 'SELECT name, id FROM Topic WHERE networkid != null';

        // do the query
        List<Topic> topicList = DataBase.query(queryTopic);

        // create picklist
        VisualEditor.DynamicPickListRows myValues = new VisualEditor.DynamicPickListRows();

        // add the default picklist value
        VisualEditor.DataRow defaultTopic = new VisualEditor.DataRow('None', '');
        myValues.addRow(defaultTopic);

        // iterate all the Topics adding them to the picklist
        for(Topic topic : topicList) {
            String idString = String.valueOf(topic.Id);
            VisualEditor.DataRow row = new VisualEditor.DataRow(topic.name, idString);
            myValues.addRow(row);
        }

        return myValues;
    }
}