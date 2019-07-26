({
    initPeakVerifyToProceed: function(component, event, helper){
        helper.setClassName(component);
    },
    hideOverlay: function (component) {
        component.set("v.readyToProceed",true);
    }
})