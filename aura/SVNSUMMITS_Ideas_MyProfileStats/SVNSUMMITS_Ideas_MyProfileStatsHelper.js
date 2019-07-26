// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	getZoneId : function(component) {
        var action = component.get("c.getZoneId");

        action.setParams({
            nameValue: component.get("v.zoneName")
        });

        action.setCallback(this, function(actionResult) {
            component.set("v.zoneid", actionResult.getReturnValue());
        });

        $A.enqueueAction(action);
    },
    
    get_UserId : function(component) {
        var action = component.get("c.getUserId");
        
        action.setCallback(this, function(actionResult) {
            var userId = actionResult.getReturnValue();
            userId = userId.substring(0,15);            
			component.set("v.userId", userId);
            
        });

        $A.enqueueAction(action);
    }
})