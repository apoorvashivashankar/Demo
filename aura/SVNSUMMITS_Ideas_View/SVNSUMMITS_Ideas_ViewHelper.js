// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
    getCommonSettings: function(component) {
        var action = component.get("c.getCommonSettings");

        action.setCallback(this, function(actionResult) {
            var common = actionResult.getReturnValue();

            component.set("v.debugMode", common.debugMode);
        });

        $A.enqueueAction(action);
    },

	getSitePrefix: function(component) {
		var action = component.get("c.getSitePrefix");

		action.setCallback(this, function(actionResult) {
			var sitePath = actionResult.getReturnValue();

			component.set("v.sitePath", sitePath);
			component.set("v.sitePrefix", sitePath.replace("/s",""));
		});

		$A.enqueueAction(action);
	},

	isAuthenticated: function(component) {
		var self   = this;
		var action = component.get("c.isAuthenticated");

		action.setCallback(this, function(actionResult) {
		    var isAuthenticated = actionResult.getReturnValue();

            component.set("v.isAuthenticated", isAuthenticated);

            if ((component.get("v.authenticatedOnly") && isAuthenticated ) ||
                 !component.get("v.authenticatedOnly")) {
            	self.getZoneId(component);
            }
		});

		$A.enqueueAction(action);
	},

    getZoneId: function(component) {
        var action = component.get("c.getZoneId");

        action.setParams({
            nameValue: component.get("v.zoneName")
        });

        var self = this;
        action.setCallback(this, function(actionResult) {
            var zoneId = actionResult.getReturnValue();
            component.set("v.zoneId", zoneId);

            if (zoneId !== "") {
            	self.getIdea(component);

//            	if (component.get("v.displayMerged")) {
//            	    self.getMergedIdeas(component);
//                }
            }
        });

        $A.enqueueAction(action);
    },

	getIdea: function(component) {
	    var self   = this;
		var action = component.get("c.getIdea");

		action.setParams({
			recordId: component.get("v.recordId"),
			zoneId:   component.get("v.zoneId")
		});

		action.setCallback(this, function(actionResult) {
		    if (actionResult.getState() === "SUCCESS") {
                var idea = self.parseNamespace(component, actionResult.getReturnValue());

                // Salesforce stores multi pick data as a semicolon separated string.
                if (idea.Categories) {
                    idea.Categories = idea.Categories.split(";");
                }

                component.set("v.idea", idea);
            }
		});

		$A.enqueueAction(action);
	},

	getMergedIdeas: function(component)	{
	    var action = component.get("c.getMergedIdeas");

		action.setParams({
			recordId: component.get("v.recordId"),
			zoneId:   component.get("v.zoneId")
		});

        action.setCallback(this, function(actionResult) {
            var mergedIdeas = actionResult.getReturnValue();
            component.set("v.mergedIdeas", mergedIdeas);
        });

        $A.enqueueAction(action);
    },

	debug: function(component, msg, variable) {
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