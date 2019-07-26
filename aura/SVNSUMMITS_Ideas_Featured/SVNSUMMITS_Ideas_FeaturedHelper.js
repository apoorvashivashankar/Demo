// Copyright ©2016-2017 7Summits Inc. All rights reserved.
/**
 * Created by francoiskorb on 10/5/16.
 */
({
    getFeaturedIdeasList: function(component, event) {
        var action = component.get("c.getFeaturedIdeas");

        action.setParams({
            recordId1: component.get("v.recordId1"),
            recordId2: component.get("v.recordId2"),
            recordId3: component.get("v.recordId3")
        });

        action.setCallback(this, function(actionResult) {
            var ideaListWrapper = actionResult.getReturnValue();

            component.set("v.ideaListWrapper", ideaListWrapper);
            var cmpSpinner = component.find("spinner");
            $A.util.addClass(cmpSpinner, "hide");
        });

        $A.enqueue(action);
    },

    debug: function(component, msg, variable) {
        if (component.get("v.debugMode")) {
            if (msg) {
                console.log(msg);
            }
            if(variable) {
                console.log(variable);
            }
        }
    }
})