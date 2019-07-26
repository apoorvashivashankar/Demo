// Copyright ©2016-2017 7Summits Inc. All rights reserved.
/**
 * Created by francois korb on 9/21/16.
 */
({
    // Initialize page filters
    initializeFilters : function(component, event, helper) {
        helper.fetchThemeValues(component);
 	},

    // Method to filter list of ideas on basis of themes
  	filterByThemes :function(component,event,helper){
      	helper.debug(component, '----Filter by Theme called----');
      	var appEvent = $A.get("e.c:SVNSUMMITS_Ideas_Filters_Event");

      	if (component.find("selectedThemes").get("v.value")) {
      	    var theme = component.find("selectedThemes").get("v.value");
            var clear  = component.get("v.labelFilter");

        	helper.debug(component, '====>>>Values  ==> ' + theme);

        	appEvent.setParams({"searchByThemes" :
        	    theme === clear ? ' ' : component.find("selectedThemes").get("v.value")});
        }

        appEvent.fire();
  }
})