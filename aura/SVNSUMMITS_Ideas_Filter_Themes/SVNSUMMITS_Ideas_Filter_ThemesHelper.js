// Copyright ©2016-2017 7Summits Inc. All rights reserved.
/**
 * Created by francoiskorb on 9/21/16.
 */
({
    fetchThemeValues : function(component){
        try{
            var action = component.get("c.getobjValues");

            action.setParams({
                objName: "IdeaTheme",
                fieldName: "Title"
            });

            action.setCallback(this, function(actionResult) {
                component.set("v.themesList", actionResult.getReturnValue());
            });

            $A.enqueueAction(action);
        } catch(e) {
            this.debug(e);
        }
    },

    initializeDropdown: function(component) {
        try {
            $(".sortByThemes")
                .addClass("ui selection dropdown")
                .dropdown({
                placeholder: "Themes"
            });

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