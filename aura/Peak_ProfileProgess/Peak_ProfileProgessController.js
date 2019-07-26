({
    init : function(component, event, helper) {
        helper.getProfileInfo(component);
    },
    linkClick : function(component, event, helper) {
        helper.goToPath(component, event);
    }
})