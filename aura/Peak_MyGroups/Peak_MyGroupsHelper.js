({
    // Determine if in a group, then call the appropriate controller function to either get groups you're in or a recommended group
    isInAGroup : function(component) {
        var action = component.get("c.isInAGroup");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var isInGroup = response.getReturnValue();
                component.set("v.inGroup",isInGroup);
                console.log('isInGroup',isInGroup);
                if (isInGroup){
                    this.getMyGroups(component);
                } else {
                    this.getFeaturedGroup(component);
                }
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },
    // Get groups you're in
    getMyGroups : function(component) {
        var action = component.get("c.getMyGroups");
        var queryLimit = component.get("v.numberOfResults");
        action.setParams({
            "numResultsString": queryLimit
        });
        action.setCallback(this, function(response) {
            var state = response.getState();

            if (component.isValid() && state === "SUCCESS") {
                component.set("v.peakResponse",response.getReturnValue());
                console.log('getMyGroups', response.getReturnValue());
                this.setInit(component);
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },
    // Get a featured group (specified)
    getFeaturedGroup : function(component) {
        var action = component.get("c.getFeaturedGroup");
        action.setParams({
            "groupIdString": component.get("v.RecommendedGroup")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.peakResponse",response.getReturnValue());
                this.setInit(component);
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },
    // Init the function to avoid the flash of one view and then another
    setInit:function(component){
        component.set("v.isInit",true);
    },
    goToUrl: function (component, event) {
        var link = event.currentTarget.dataset.link;
        var event = $A.get("e.force:navigateToURL");
        event.setParams({
            "url": link
        });
        event.fire();
    }
})