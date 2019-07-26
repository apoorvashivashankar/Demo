({
	buttonClick : function(component, event, helper) {
		// Set loading to true
		component.set("v.isLoading",true);
		var action = component.get("c.isGuestUser");
		action.setCallback(this, function(response) {
			// Callback finished, set loading to false
			component.set("v.isLoading",false);
		    var state = response.getState();
		    if (component.isValid() && state === "SUCCESS") {
		    	// actually do something
		    }
		    else {
		    }
		});

		$A.enqueueAction(action);
	},
	slowButtonQuick : function(component, event, helper) {
		component.set("v.isLoading",true);
		setTimeout(function(){ 
			component.set("v.isLoading",false); 
		}, 3000);
	}
})