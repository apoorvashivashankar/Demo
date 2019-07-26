/* Copyright ©2016-2017 7Summits Inc. All rights reserved. */

/**
* \arg ClassName        : SVNSUMMITS_IdeaFiltersController
* \arg CreatededBy      : Nikhil
* \arg Dscription      : Apex class for lightning components for filter components section
**/
global with sharing class SVNSUMMITS_IdeaFiltersController {

    @AuraEnabled
    global static Boolean isAuthenticated() {
        return !Auth.CommunitiesUtil.isGuestUser();
    }

    @AuraEnabled
    global static String getSitePrefix(){
        return System.Site.getPathPrefix();
    }


    @AuraEnabled
    global static List<String> getobjValues(String objName, String fieldName){
        List<String> lstFieldValues = new List<String>();
        if(String.isBlank(objName)) {
            return null;
        }
        String Query = 'Select Id';
        if(String.isNotBlank(fieldName)) {
            Query += ',' + fieldName;
        }
        Query += ' FROM ' + objName;
        for(sobject sobj: Database.Query(Query.trim())) {
            lstFieldValues.add(String.valueOf(sobj.get(fieldName)));
        }
        system.debug('====test Query==='+Query);
        return lstFieldValues;
    }
    /*
        * MethodName        : getTopicNamesList
        * param             :
        * Description       : Method for fetching all Topics values from any sObject.
    */
    @AuraEnabled
    global static List<String> getTopicNamesList()
    {
        return SVNSUMMITS_IdeasTopicController.getTopicNamesList();
    }
    /*
        * MethodName        : getPicklistValues
        * param             : objName, fieldName
        * Description       : Method for fetching all picklist values from any sObject.
    */
    @AuraEnabled
    global static List<String> getPicklistValues(String objName, String fieldName){
        List<String> options = new List<String>();
        // Get the object type of the SObject.
        Schema.sObjectType objType = Schema.getGlobalDescribe().get(objName);
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        // Get a map of fields for the SObject
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        // Get the list of picklist values for this field.
        list<Schema.PicklistEntry> values = fieldMap.get(fieldName).getDescribe().getPickListValues();
        // Add these values to the selectoption list.

        for (Schema.PicklistEntry a : values)
        {
            options.add(a.getLabel());
        }
        return options;
     }

}