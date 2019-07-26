// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	onInit: function (component, event, helper) {
		helper.getCommonSettings(component);
	},

	setNoOfIdeasGet: function (component, event, helper) {
		helper.getIdeaText(component);

		var numberOfIdeas = event.getParam("totalResults");
		component.set("v.numberOfIdeas", numberOfIdeas);
	},

	getSearchString: function (component, event, helper) {
		var appEvent = $A.get("e.c:SVNSUMMITS_Ideas_Filters_Event");

		var searchString = component.get("v.searchText");
		helper.debug(component, "Search " + searchString);
		component.set("v.searchString", searchString);

		appEvent.setParams({
			"searchString": searchString
		});

		appEvent.fire();
	},

	gotoUrl: function (component, event, helper) {
		var urlEvent = $A.get("e.force:navigateToURL");
		var url = component.get('v.newIdeaURL');

		urlEvent.setParams({
			"url": url,
			"isredirect": true
		});

		urlEvent.fire();
	}
})