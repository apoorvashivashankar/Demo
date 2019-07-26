// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
		doInit : function(component, event, helper) {
				helper.setSitePrefix(component);
		},

		clickSearchButton : function(component, event, helper) {
				helper.sendFilterEvent(component);
		}
})