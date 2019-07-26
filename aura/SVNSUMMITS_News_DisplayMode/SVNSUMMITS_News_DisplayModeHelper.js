// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	setListView: function (component) {
		var appEvent = $A.get("e.c:SVNSUMMITS_News_DisplayMode_Event");

		appEvent.setParams({
			"listViewMode": component.get('v.listViewMode')
		});

		appEvent.fire();
	}
})