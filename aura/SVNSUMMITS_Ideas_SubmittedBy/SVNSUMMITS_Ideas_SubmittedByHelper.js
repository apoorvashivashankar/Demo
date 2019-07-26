// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	get_SitePrefix : function(component) {
    	var action = component.get("c.getSitePrefix");

        action.setCallback(this, function(actionResult) {
            var sitePath = actionResult.getReturnValue();

            component.set("v.sitePath", sitePath);
            component.set("v.sitePrefix", sitePath.replace("/s/","/"));
		});

        $A.enqueueAction(action);
    },

    getZoneId : function(component) {
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
            }
        });

        $A.enqueueAction(action);
    },

    getCommonSettings: function(component) {
        var action = component.get("c.getCommonSettings");

        action.setCallback(this, function(actionResult) {
            var common = actionResult.getReturnValue();
            component.set("v.debugMode", common.debugMode);
        });

        $A.enqueueAction(action);
    },

    isNicknameDisplayEnabled : function(component) {
        var action = component.get("c.isNicknameDisplayEnabled");

        action.setCallback(this, function(actionResult) {
            component.set("v.isNicknameDisplayEnabled", actionResult.getReturnValue());
        });

        $A.enqueueAction(action);
    },

    getIdea : function(component) {
        var self = this;
        var action = component.get("c.getIdea");

        action.setParams({
            recordId: component.get("v.recordId"),
            zoneId: component.get("v.zoneId")
        });

        action.setCallback(this, function(actionResult) {
            var idea = self.parseNamespace(component, actionResult.getReturnValue());
            component.set("v.idea", idea);
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