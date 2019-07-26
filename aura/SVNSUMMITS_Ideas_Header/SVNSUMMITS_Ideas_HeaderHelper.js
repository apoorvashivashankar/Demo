// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
    getCommonSettings: function(component) {
        var action = component.get("c.getCommonSettings");

        action.setCallback(this, function(actionResult) {
            var settings = actionResult.getReturnValue();
            component.set("v.debugMode", settings.debugMode);
        });

        $A.enqueueAction(action);
    },

    getIdeaText : function(component) {
        var ideaTitleText = component.get("v.ideaTitle");
        var ideaTitleSet  = '';

        if (ideaTitleText.length > 16) {
            ideaTitleSet = ideaTitleText.substring(0, 16);
        } else {
            ideaTitleSet = ideaTitleText;
        }

        component.set("v.ideaTitle", ideaTitleSet);
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