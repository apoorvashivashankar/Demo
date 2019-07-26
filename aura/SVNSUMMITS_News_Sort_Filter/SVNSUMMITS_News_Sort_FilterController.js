// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	setSortOption: function (component, event, helper) {
		var sortBy = event.target.value;

		helper.sortItems(component, sortBy);
	}
})