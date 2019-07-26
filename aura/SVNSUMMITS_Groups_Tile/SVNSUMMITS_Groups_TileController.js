// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	doInit : function(component, event, helper) {

	},

	handleMemberClick : function(component, event, helper) {
		helper.toggleMembership(component);
	},

	goToRecord : function(component, event, helper){
        $A.get("e.force:navigateToSObject")
		  .setParams({
		      "recordId": $(event.currentTarget).data("id"),
	          "slideDevName": "related"})
          .fire();
	},
})