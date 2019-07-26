({
	initFeaturedUserList : function(component, event, helper) {
		// Convert string into an actual array since SFDC won't let you use an array as a design token
		var userIdsString = component.get('v.userIdsInput');
		var userIdsArray = userIdsString.split(',');
		component.set('v.userIds',userIdsArray);
	}
})