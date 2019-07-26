// Copyright ©2016-2017 7Summits Inc. All rights reserved.
/**
 * Created by francoiskorb on 9/21/16.
 */
({
    // Initialize page filters
    initializeFilters : function(component, event, helper) {
 	},

    // Method to fetch ideas for current logged in user
	filterByMyIdeas : function(component, event, helper) {
     	helper.debug(component, '---- MyIdeas filter called ----');

        var appEvent = $A.get("e.c:SVNSUMMITS_Ideas_Filters_Event");

        component.set("v.isSortBySelected", true);

        var filter = component.find("myIdeas").get("v.value");
        helper.debug(component, "    Filter: " + filter);

        appEvent.setParams({"searchMyIdeas" :
            filter ? 'Display My Ideas Only' : ' '});

        appEvent.fire();
    }
})