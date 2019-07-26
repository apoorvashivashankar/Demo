({
    getUsers: function (component) {
        var action = component.get("c.getUsersWithPublicPhotos");
        action.setParams({ desiredResultsCount : "7" });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.users",response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);

    }
})