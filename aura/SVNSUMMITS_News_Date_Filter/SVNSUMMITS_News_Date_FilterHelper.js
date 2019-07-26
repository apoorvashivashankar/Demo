// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	sendFilterEvent: function (component) {
		var appEvent = $A.get("e.c:SVNSUMMITS_News_Date_Filter_Event");

		var startDate = component.get('v.startDate');
		var endDate   = component.get('v.endDate');

		appEvent.setParams({
			"fromDate": startDate,
			"toDate":   endDate
		});

		appEvent.fire();
	}
})