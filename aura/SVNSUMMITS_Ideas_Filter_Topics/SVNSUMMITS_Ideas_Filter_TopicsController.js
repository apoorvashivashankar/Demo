// Copyright ©2016-2017 7Summits Inc. All rights reserved.
/**
 * Created by francois korb on 9/21/16.
 */
({
    // Initialize page filters
    initializeFilters : function(component, event, helper) {
        helper.fetchTopicNames(component);
 	},

    // Method to filter list of ideas on basis of topics
    filterByTopics : function(component, event, helper) {
        helper.debug(component, '----Filter By Topics called----');

        var appEvent = $A.get("e.c:SVNSUMMITS_Ideas_Filters_Event");

        if (component.find("selectedTopic").get("v.value")) {
            var filter = component.find("selectedTopic").get("v.value");
            var clear  = component.get("v.labelFilter");

            helper.debug(component, '    filer: ' + filter);
            appEvent.setParams({"searchByTopics" :
                filter === clear ? ' ' : component.find("selectedTopic").get("v.value")});
        }

        appEvent.fire();
  }
})