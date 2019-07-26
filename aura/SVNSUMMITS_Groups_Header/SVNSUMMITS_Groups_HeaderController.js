// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	onInit: function (component, event, helper) {
		//svg4everybody();
	},

	// Method to set no of groups
	setNoOfGroups: function (component, event, helper) {
		var numberOfGroups = event.getParam("totalResults");
		component.set("v.numberOfGroups", numberOfGroups);

		helper.getCreatePermission(component);
		//helper.initializeDropdown(component);
	},


	// Method to search groups for search text box
	getSearchString: function (component, event, helper) {
		var searchString = component.get("v.searchString");
		var appEvent = $A.get("e.c:SVNSUMMITS_Groups_Filters_Event");

		appEvent.setParams({
			"searchString": searchString,
		});

		if (component.get("v.filterMyGroups") === true) {
			appEvent.setParams({
				"searchMyGroups": component.find("myGrps").get("v.value"),
			});
		}
		appEvent.fire();
	},

	createNewGroup: function (component, event, helper) {
		var evt = $A.get("e.force:createRecord");

		evt.setParams({
			'entityApiName': 'CollaborationGroup',
		});

		evt.fire();
	}
})