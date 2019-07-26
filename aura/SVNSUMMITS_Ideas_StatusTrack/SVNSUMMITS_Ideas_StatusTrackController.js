// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	doInit: function (component, event, helper) {
		helper.getCommonSettings(component);
		helper.getZoneId(component);
		helper.getPicklistValues(component);
	},


	afterScriptsLoaded: function (component) {
		var intCountActive = 0;
		var intCountActiveWidth = 0;
		var intCountNumberOfBar = 0;
		var intTotalNumberPercentage = 0;

		setTimeout(function () {
			$(".slds-wizard__item").each(function (index) {
				intCountNumberOfBar = ++index;
			});

			intTotalNumberPercentage = 100 / (--intCountNumberOfBar);

			$(".slds-is-active").each(function (index) {
				intCountActive = ++index;
			});

			if (intTotalNumberPercentage > 1) {
				intCountActiveWidth = intTotalNumberPercentage * (--intCountActive);
			}

			component.set("v.intCountWidth", intCountActiveWidth);
		}, 3000);
	}

})