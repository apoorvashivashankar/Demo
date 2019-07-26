// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	doInit : function(component, event, helper) {
		var action = component.get("c.getModel");
		action.setCallback(this, function(response){
			component.set("v.baseModel", JSON.stringify(response.getReturnValue()));
			component.getEvent("baseReady").fire();
            svg4everybody();
		})
		$A.enqueueAction(action);
	}
})