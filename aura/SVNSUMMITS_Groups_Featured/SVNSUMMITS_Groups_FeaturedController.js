// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
    //Method called after scripts loaded
	doInit : function(component, event, helper) {
        
        helper.getFeaturedGroups(component);
        helper.isNicknameDisplayEnabled(component);
        
	},
    goToAllGroups: function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        var allGroupsUrl = component.get("v.allGroupsUrl");
        urlEvent.setParams({
            "url": allGroupsUrl
        });
        urlEvent.fire();
    }
})