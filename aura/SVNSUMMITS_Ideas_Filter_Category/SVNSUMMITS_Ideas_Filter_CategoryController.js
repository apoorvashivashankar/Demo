// Copyright ©2016-2017 7Summits Inc. All rights reserved.
/**
 * Created by francois korb on 9/21/16.
 */
({
    // Initialize page filters
    initializeFilters : function(component, event, helper) {
       helper.getCategoryValues(component);
 	},

    // Method to filter list of ideas on basis of category
  	filterByCategories : function(component, event, helper) {
        helper.debug(component, '----Filter By Categories called ----');

        var appEvent = $A.get("e.c:SVNSUMMITS_Ideas_Filters_Event");

        if (component.find("categories").get("v.value")) {
            var filter = component.find("categories").get("v.value");
            var clear  = component.get("v.labelFilter");

            helper.debug(component, '    Filter: ' + filter);
            appEvent.setParams({"searchByCategories" :
                filter === clear ? ' ' : component.find("categories").get("v.value")});
        }

        appEvent.fire();
    }
})