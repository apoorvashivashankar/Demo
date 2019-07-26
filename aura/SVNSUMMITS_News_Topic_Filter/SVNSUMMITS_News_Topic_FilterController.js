// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	doInit: function (component, event, helper) {
		helper.getTopics(component);
	},

	selectTopic: function (component, event, helper) {
		helper.sendFilterEvent(component);
	}
})