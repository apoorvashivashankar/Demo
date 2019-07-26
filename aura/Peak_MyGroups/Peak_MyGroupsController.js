({
    initPeakMyGroups : function(component, event, helper) {
        helper.isInAGroup(component);
        component.set('v.extended', true);
    },
    linkClick: function(component, event, helper) {
        helper.goToUrl(component, event);
    },
})