({
    // Determine if guest
    initUtilityNavigation: function(component, event, helper) {
        component.set('v.extended', true);
    },
    handleMobileUtilNav: function(component, event, helper) {
        helper.toggleMobileNav(component);
    }
})