({
    doInit: function(component, event, helper) {
        helper.getUser(component);
        component.set('v.isInit', true);
    },
    ctaClick: function(component, event, helper) {
        helper.goToPath(component, event);
    }
})