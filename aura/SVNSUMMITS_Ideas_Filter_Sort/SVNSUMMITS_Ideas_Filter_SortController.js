// Copyright ©2016-2017 7Summits Inc. All rights reserved.
/**
 * Created by francois korb on 9/21/16.
 */
({
    // Initialize page filters
    initializeFilters : function(component, event, helper) {

 	},

	setInitialSort : function(component, event, helper) {
		var sortBy = event.getParam("sortBy");
		component.find("sortByInput").set("v.value", sortBy);
    },

    // Method to filter sort of ideas on basis of category
   	handleSortChange : function(component, event, helper) {
     	helper.debug(component, '----Sort called----');

        var appEvent = $A.get("e.c:SVNSUMMITS_Ideas_Filters_Event");
		//var appEvent = component.getEvent("ideasFilters");
        var sort  = component.find("sortByInput").get("v.value");
        component.set("v.sortBy", sort);

        if (component.find("sortByInput").get("v.value")) {
            helper.debug(component, ' sort by: ' + sort);

        	appEvent.setParams({"sortBy" : sort});
	        appEvent.fire();
        }
	}
})