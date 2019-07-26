// Copyright ©2016-2017 7Summits Inc. All rights reserved.
/**
 * Created by francoiskorb on 9/21/16.
 */
({
	fetchTopicNames : function(component) {
        var action = component.get("c.getTopicNamesList");
        action.setCallback(this, function(actionResult) {
            component.set("v.topicNamesList", actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
    },

    initializeDropdown: function(component) {
        try {
            $(".topic")
                .addClass("ui selection dropdown")
                .dropdown({placeholder: "Topics"});

            var statusCmp = component.find("selectedStatus");

            $A.util.removeClass(statusCmp,"slds-hide");
            $A.util.addClass(statusCmp, "ui");
            $(statusCmp.getElement()).dropdown({placeholder: "Stages"});
        } catch(e) {
            this.debug(component,null,e);
        }
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