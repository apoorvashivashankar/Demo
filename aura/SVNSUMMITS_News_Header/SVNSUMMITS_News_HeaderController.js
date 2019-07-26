// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	onInit: function (component, event, helper) {
		helper.isObjectCreatable(component);
	},

	itemCount: function (component, event, helper) {
		var totalResults = event.getParam("totalResults");
		component.set("v.numberOfResults", totalResults);
	},

	clickSearchButton: function (component, event, helper) {
		helper.sendFilterEvent(component);
	},

	createNewItem: function (component, event, helper) {
		var createUrl = component.get('v.createNewsURL');
		helper.gotoUrl(component, createUrl);
	}
})