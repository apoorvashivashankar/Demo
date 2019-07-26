// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
    getCommonSettings: function(component) {
        var action = component.get("c.getCommonSettings");

        action.setCallback(this, function(actionResult) {
            var common = actionResult.getReturnValue();

            component.set("v.debugMode", common.debugMode);
            component.set("v.disableDownVoting", common.allowDownVoting == false);
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

            if (zoneId != '') {
                self.getIdea(component);
                self.getVote(component);
            }
        });

        $A.enqueueAction(action);
    },

    getIdea : function(component) {
        var action = component.get("c.getIdea");

        action.setParams({
            recordId: component.get("v.recordId"),
            zoneId: component.get("v.zoneId")
        });

        action.setCallback(this, function(actionResult) {
            component.set("v.idea", actionResult.getReturnValue());
        });

        $A.enqueueAction(action);
    },

    getVote : function(component) {
        var self   = this;
        var action = component.get("c.getVote");

        action.setParams({
            recordId: component.get("v.recordId")
        });

        action.setCallback(this, function(actionResult) {
            component.set("v.currentVote", actionResult.getReturnValue());
        });

        $A.enqueueAction(action);
    },

    vote : function(component, isUp) {
        var self   = this;
        var action = component.get("c.vote");

        action.setParams({
            recordId: component.get("v.recordId"),
            isUp:     isUp
        });

        action.setCallback(this, function(actionResult) {
            if (actionResult.getState() == 'SUCCESS' && actionResult.getReturnValue()) {
            	component.set("v.currentVote", actionResult.getReturnValue());
                self.getIdea(component);
            } else {
                var errors = actionResult.getError();

                for (var i=0; i < errors.length; i++) {
	                self.debug(component, 'Error: ', errors[i].message);
                }
            }
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