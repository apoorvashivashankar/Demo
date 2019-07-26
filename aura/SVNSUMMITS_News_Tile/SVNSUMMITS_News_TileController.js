// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	setSitePrefix : function(component, event, helper) {
        helper.get_SitePrefix(component);
    },

	goToNewsRecord : function(component, event, helper) {
		var navEvt = $A.get("e.force:navigateToSObject");
	    navEvt.setParams({
	      "recordId": component.get("v.wrapperNewsObj.newsList[0].Id")
	    });
	    navEvt.fire();
	},
    goToRecord : function(component, event, helper){
        $A.get("e.force:navigateToSObject")
            .setParams({
                "recordId": $(event.currentTarget).data("id"),
                "slideDevName": "related"})
            .fire();
    },
	goToNewsAuthor : function(component, event, helper) {
		var navEvt = $A.get("e.force:navigateToSObject");
	    navEvt.setParams({
	      "recordId": component.get("v.wrapperNewsObj.newsList[0].Author__c")
	    });
	    navEvt.fire();
	}
})