({
    getUser: function(component){
        // Create the action
        if (component.get("v.userId") != '' && component.get("v.userId").indexOf('$Label') == -1){
            var action = component.get("c.getUserInformation");
            var userId = component.get("v.userId");
            action.setParams({
                "userId": userId
            });
            // Add callback behavior for when response is received
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (component.isValid() && state === "SUCCESS") {
                    component.set("v.user", response.getReturnValue());
                }
                else {
                    console.log("Failed with state: " + state);
                    component.set('v.isError', true);
                    component.set('v.userId', 'There was an error when retrieving the User: ' + userId);
                }
            });

            // Send action off to be executed
            $A.enqueueAction(action);
        }else{
            component.set('v.isError', true);
            if(component.get("v.userId") == ''){
                component.set('v.userId', 'User ID is empty. Please enter a valid ID');
            }else{
                component.set('v.userId', 'You cannot use a custom label in the ID field. Please enter a valid ID');
            }
        }

    },
    goToPath: function(component, event){
        var cta = event.currentTarget.dataset.cta;
        if(cta == ''){
            this.goToProfile(component);
        }else{
            this.goToUrl(component, cta);
        }
    },
    goToProfile : function (component) {
        var user = component.get('v.user');
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": user.Id,
        });
        navEvt.fire();
    },
    goToUrl : function (component, cta) {
        var event = $A.get("e.force:navigateToURL");
        event.setParams({
            "url": cta
        });
        event.fire();
    }
})