({
// List required fields here - match on 'aura:id' attribute
    requiredFields: ['SayHello'],
    validateForm: function (component) {
        return peakAuraHelpers.validateForm(component,null,this.requiredFields);
    },
    submitForm: function (component) {
        component.set("v.isLoading",true);
        var action = component.get("c.handleSubmit");
        action.setParams({
            inputText: component.get("v.inputText")
        })
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var peakResponse = response.getReturnValue();

                if (peakResponse.success){
                    // congrats. Do something now
                } else {
                    component.set("v.hasErrors",true);
                    component.set("v.peakResponse",peakResponse);
                }

            }
            else {
                console.log("Failed with state: " + state);
            }
            component.set("v.isLoading",false);
        });
        $A.enqueueAction(action);
    }
})