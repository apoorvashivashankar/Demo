({
    getUser: function(component) {
        // Create the action
        if (component.get("v.userId") != '') {
            var action = component.get("c.getUserInformation");
            action.setParams({
                "userId": component.get("v.userId")
            });
            // Add callback behavior for when response is received
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (component.isValid() && state === "SUCCESS") {
                    component.set("v.user", response.getReturnValue());
                }
                else {
                    console.log("Failed with state: " + state);
                }
            });

            // Send action off to be executed
            $A.enqueueAction(action);
        }
    },
    goToProfile : function (component, event) {
        var id = event.currentTarget.dataset.id;
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": id,
        });
        navEvt.fire();
    },
    goToUrl : function (component, event) {
        var link = event.currentTarget.dataset.link;
        var event = $A.get("e.force:navigateToURL");
        event.setParams({
            "url": link
        });
        event.fire();
    }
})