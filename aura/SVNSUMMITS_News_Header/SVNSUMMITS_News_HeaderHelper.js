// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	isObjectCreatable: function (component) {
		var actionCreate = component.get("c.isObjectCreatable");

		actionCreate.setCallback(this, function (actionResultCreate) {
			var isObjectCreatable = actionResultCreate.getReturnValue();
			component.set("v.isObjectCreatable", isObjectCreatable);
		});

		$A.enqueueAction(actionCreate);
	},

	sendFilterEvent: function (component) {
		var searchText = component.get("v.searchText");

		if (searchText === undefined) {
			searchText = '';
		}

		var appEvent = $A.get("e.c:SVNSUMMITS_News_Text_Filter_Event");

		appEvent.setParams({
			"searchText": searchText
		});

		appEvent.fire();
	},

	debug: function (component, msg, variable) {
		var debugMode = component.get("v.debugMode");
		if (debugMode) {
			if (msg) {
				console.log(msg);
			}
			if (variable) {
				console.log(variable);
			}
		}
	}
})