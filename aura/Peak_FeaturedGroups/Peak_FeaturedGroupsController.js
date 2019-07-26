/**
 * Created by brianpoulsen on 12/4/17.
 */
({
    initPeakFeaturedGroups : function(component, event, helper) {
        helper.getFeaturedGroup(component);
    },
    linkClick: function(component, event, helper) {
        helper.goToUrl(component, event);
    },
})