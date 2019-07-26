// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
    doInit : function(component, event, helper) {
        var url = encodeURIComponent(window.location.href);
        component.set("v.currentURL", url);

        helper.getCommonSettings(component);
        helper.getSitePrefix(component);
        helper.isAuthenticated(component);
    },

    // Handles showing and hiding main tab content.
    handleTabClick: function(component, event, helper) {
        var clickedTabId        = event.target.id;
        var clickedComponentLi  = component.find(clickedTabId+"-li");
        var clickedComponentDiv = component.find(clickedTabId+"-div");

        $A.util.addClass(clickedComponentLi,"slds-active");
        $A.util.addClass(clickedComponentDiv,"slds-show");
        $A.util.removeClass(clickedComponentDiv,"slds-hide");

        var otherTabId = (clickedTabId == "tab-comments") ? "tab-overview" : "tab-comments" ;
        var otherComponentLi  = component.find(otherTabId+"-li");
        var otherComponentDiv = component.find(otherTabId+"-div");

        $A.util.removeClass(otherComponentLi,"slds-active");
        $A.util.addClass(otherComponentDiv,"slds-hide");
        $A.util.removeClass(otherComponentDiv,"slds-show");
    }
})