// Copyright ©2016-2017 7Summits Inc. All rights reserved.
/**
 * Created by francoiskorb on 9/21/16.
 */
({
   // Fetch Category Values from Idea object
    getCategoryValues : function(component) {
        var action = component.get("c.getPicklistValues");

        action.setParams({
            objName: "Idea",
            fieldName: "Categories"
        });

        action.setCallback(this, function(actionResult) {
            component.set("v.categoriesSet", actionResult.getReturnValue());
        });

        $A.enqueueAction(action);
    },


    initializeDropdown: function(component) {
        try {
            $(".categories")
                .addClass("ui selection dropdown")
                .dropdown({placeholder: "Categories"});

            var statusCmp = component.find("selectedStatus");
            $A.util.removeClass(statusCmp,"slds-hide");
            $A.util.addClass(statusCmp, "ui");

            $(statusCmp.getElement()).dropdown({
                placeholder: "Stages"
            });

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