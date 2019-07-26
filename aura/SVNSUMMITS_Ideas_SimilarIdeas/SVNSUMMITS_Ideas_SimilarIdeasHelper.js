// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	getSitePrefix : function(component) {
    	var action = component.get("c.getSitePrefix");

        action.setCallback(this, function(actionResult) {
            var sitePath = actionResult.getReturnValue();
            component.set("v.sitePath", sitePath);
            component.set("v.sitePrefix", sitePath.replace("/s/","/"));
		});

        $A.enqueueAction(action);
    },

    getZoneId : function(component) {
        var self   = this;
        var action = component.get("c.getZoneId");

        action.setParams({
            nameValue: component.get("v.zoneName")
        });

        action.setCallback(this, function(actionResult) {
            var zoneId = actionResult.getReturnValue();
            component.set("v.zoneId", zoneId);

            if (zoneId !== "") {
				self.getIdea(component);
            }
        });

        $A.enqueueAction(action);
    },

    getIdea : function(component) {
        var self   = this;
        var action = component.get("c.getIdea");

        action.setParams({
            zoneId: component.get("v.zoneId"),
            recordId: component.get("v.recordId")
        });

        action.setCallback(this, function(actionResult) {
            var idea = self.parseNamespace(component,actionResult.getReturnValue());

            if (idea.Categories) {
                idea.Categories = idea.Categories.split(";");
            }

            self.debug(component, "SimilarIdeas.Idea: ", idea);
            component.set("v.idea", idea);
        });

        $A.enqueueAction(action);
    },

    debug: function(component, msg, variable) {
        if (component.get("v.debugMode")) {
            if (msg) {
            	console.log(msg);
            }
            if (variable) {
            	console.log(variable);
            }
        }
    }
})