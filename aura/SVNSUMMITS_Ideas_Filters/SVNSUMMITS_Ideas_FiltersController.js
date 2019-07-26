// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	toggleFilters : function(component, event, helper) {
		var theFilters = component.find("theFilters");
		var theToggle = component.find("filterToggle");

        $A.util.toggleClass(theFilters, "slds-max-medium-hide");
		$A.util.toggleClass(theToggle, "open");

        var cmpSpinnerSubmit = component.find("spinnerSearch");
        $A.util.addClass(cmpSpinnerSubmit, "hide");
	}
})