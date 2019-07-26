/**
 * Created by brianpoulsen on 12/4/17.
 */
({
    // Get a featured group (specified)
    getFeaturedGroup : function(component) {
        var action = component.get("c.getFeaturedGroups");
        action.setParams({
            "groupIdsString": component.get("v.RecommendedGroups")
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