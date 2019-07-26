// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	isAuthenticated: function (component) {
		var action = component.get("c.isAuthenticated");

		action.setCallback(this, function (actionResult) {
			component.set("v.isAuthenticated", actionResult.getReturnValue());
		});

		$A.enqueueAction(action);
	},

	getZoneId: function (component) {
		var action = component.get("c.getZoneId");

		action.setParams({
			nameValue: component.get("v.zoneName")
		});

		var self = this;
		action.setCallback(this, function (actionResult) {
			var zoneId = actionResult.getReturnValue();
			component.set("v.zoneId", zoneId);

			if (zoneId !== "") {
				self.getIdea(component);
			}
		});

		$A.enqueueAction(action);
	},

	getCommonSettings: function (component) {
		var action = component.get("c.getCommonSettings");

		action.setCallback(this, function (actionResult) {
			var common = actionResult.getReturnValue();
			component.set("v.debugMode", common.debugMode);
		});

		$A.enqueueAction(action);
	},

	getIdea: function (component) {
		var self = this;
		var action = component.get("c.getIdea");

		action.setParams({
			recordId: component.get("v.recordId"),
			zoneId: component.get("v.zoneId")
		});

		action.setCallback(this, function (actionResult) {
			var idea = self.parseNamespace(component, actionResult.getReturnValue());
			// Salesforce stores multi pick data as a semicolon separated string.
			// Break the categories apart so we can iterate over them properly
			// in the view.
			if (idea.Categories) {
				idea.Categories = idea.Categories.split(";");
			}

			component.set("v.idea", idea);
			self.getCurrentStep(component);
		});

		$A.enqueueAction(action);
	},

	getCurrentStep: function (component) {
		var idea,
			statusSet;

		idea = component.get("v.idea");
		statusSet = component.get("v.statusSet");

		// Set the current step to the index of this idea's status, adding one
		// to the value for a friendlier output for the user.
		component.set("v.currentStep", statusSet.indexOf(idea.Status) + 1);
	},

	getPicklistValues: function (component) {
		var action = component.get("c.getPicklistValues");

		action.setParams({
			objName: "Idea",
			fieldName: "Status"
		});

		action.setCallback(this, function (actionResult) {
			var statusSet = actionResult.getReturnValue();
			component.set("v.statusSet", statusSet);
		});

		$A.enqueueAction(action);
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