({
	initFeaturedUser: function(component, event, helper) {
		helper.getUser(component);
	},
    profileClick: function(component, event, helper) {
        helper.goToProfile(component, event);
    },
    ctaClick: function(component, event, helper) {
        helper.goToUrl(component, event);
    },
})