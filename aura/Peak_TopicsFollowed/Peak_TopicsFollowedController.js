({
    doInit : function(component, event, helper){
        helper.init(component);
    },

    navigateToTopic : function(component, event, helper){
        var urlEvent = $A.get("e.force:navigateToSObject");
        urlEvent.setParams({
            "recordId": event.getSource().get("v.value"),
        });
        urlEvent.fire();
    }
})