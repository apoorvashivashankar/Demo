// Copyright ©2016-2017 7Summits Inc. All rights reserved.
/**
 * Created by francoiskorb on 9/21/16.
 */
({
    // Initialize page filters
    initializeFilters : function(component, event, helper) {
    	var targetContentDiv = component.find("contentDiv");

        if ($A.util.hasClass(targetContentDiv,"activeState")) {
            $A.util.removeClass(targetContentDiv, "activeState");
            $A.util.addClass(targetContentDiv, "deactiveState");
        }
 	},

    setListView: function(component, event, helper) {
        var appEvent = $A.get("e.c:SVNSUMMITS_Ideas_Set_Display_Mode_Filter");
        var listBTN = component.find("listBTN");
        var gridBTN = component.find("gridBTN");

        $A.util.addClass(listBTN, "active");
        $A.util.removeClass(gridBTN, "active");

        appEvent.setParams({"displayMode" : 'List View'});
        appEvent.fire();
     },

    setGridView: function(component, event, helper) {
        var appEvent = $A.get("e.c:SVNSUMMITS_Ideas_Set_Display_Mode_Filter");
        var gridBTN = component.find("gridBTN");
        var listBTN = component.find("listBTN");

        $A.util.addClass(gridBTN, "active");
        $A.util.removeClass(listBTN, "active");
        appEvent.setParams({"displayMode" : 'Tile View'});
        appEvent.fire();
    }
})