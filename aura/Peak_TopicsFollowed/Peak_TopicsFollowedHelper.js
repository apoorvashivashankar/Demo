({
    init : function(component){
        var action;

        action = component.get("c.getMyFollowedTopics");

        action.setParams({
            "recordToShow" : component.get("v.recordsToShow")
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.followedTopics", response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    }
})