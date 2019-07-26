// Copyright ©2016-2017 7Summits Inc. All rights reserved.
/**
 * Created by francoiskorb on 2/3/17.
 */
({
	doInit : function(component, event, helper) {
		var action = component.get("c.getModel");

		action.setCallback(this, function(response){
			if (response.getState() === 'SUCCESS') {
				try {
					var model = response.getReturnValue();
					component.set("v.baseModel", JSON.stringify(response.getReturnValue()));
					component.getEvent("baseReady").fire();
					svg4everybody();
				}
				catch (e) {
					helper.debug(component, 'Exception Get base model', e);
				}
			}
			else {
				helper.debug(component, 'Failed to get base model');
			}
		});

		$A.enqueueAction(action);
	}
})