({
	getDetailWithId : function(component, recordId) {
        debugger
		var action = component.get("c.getIndividualJobDetail");
        action.setParams({
            'recordId': recordId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
				component.set("v.user", response.getReturnValue());
				console.log('>>>',response.getReturnValue());
            } else {
                console.log("Detail never loaded");
            }
        });
        $A.enqueueAction(action);
    },
    updateclick : function(component, event, helper) {

        var action = component.get("c.saveUserRecord");
        action.setParams({"user": component.get("v.user")});

        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS"){
                var c = response.getReturnValue();
                component.set("v.user", c);
                component.set("v.isOpen", false);
                $A.get('e.force:refreshView').fire();
            } else {
                console.log('There was a problem : '+response.getError());
            }
        });
        $A.enqueueAction(action);
	}
})