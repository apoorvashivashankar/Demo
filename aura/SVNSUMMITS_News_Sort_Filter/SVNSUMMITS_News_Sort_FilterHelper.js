// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	sortItems: function (component, sortBy) {
		var appEvent = $A.get("e.c:SVNSUMMITS_News_SortBy_Filter_Event");

		appEvent.setParams({
			"sortBy": sortBy
		});

		appEvent.fire();
	}
})