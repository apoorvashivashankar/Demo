// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	doInit: function (component, event, helper) {
		helper.isNicknameDisplayEnabled(component);
		helper.getGroups(component, event);
	},

	getNextPage: function (component, event, helper) {
		component.set("v.groupsListWrapper.groupsList", null);
		helper.getNextPage(component);
	},

	getPreviousPage: function (component, event, helper) {
		component.set("v.groupsListWrapper.groupsList", null);
		helper.getPreviousPage(component);
	},

	setSortBy: function (component, event, helper) {
		var sortBy = event.getParam("sortBy");

		component.set("v.sortBy", sortBy);
		helper.getGroups(component, event);
	},

	setGroupsFilters: function (component, event, helper) {
		var searchString = event.getParam("searchString");
		var searchMyGroups = event.getParam("searchMyGroups");

		component.set("v.searchString", searchString);
		component.set("v.searchMyGroups", searchMyGroups);

		helper.getGroups(component, event);
	}
})