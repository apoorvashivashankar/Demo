// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
    // Initialize page filters
    onInit : function(component, event, helper) {
        helper.fetchStatusValues(component);
 	},

    // Method to filter list of ideas on basis of stages
  	filterByStatus : function(component, event, helper) {
    	helper.debug(component, '----Filter By Status called----');

      	var appEvent = $A.get("e.c:SVNSUMMITS_Ideas_Filters_Event");

      	if (component.find("selectedStatus").get("v.value")) {
            var filter = component.find("selectedStatus").get("v.value");
            var clear  = component.get("v.labelFilter");

            helper.debug(component, '    filter: ' + filter);

        	appEvent.setParams({"searchByStatus" :
        	    filter === clear ? ' ' : component.find("selectedStatus").get("v.value")});
        }

        appEvent.fire();
  	}
})