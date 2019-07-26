// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	fetchUrl: function (component, event, helper) {
		helper.getCommonSettings(component);
		helper.getSitePrefix(component);
		helper.getZoneId(component);
		helper.isNicknameDisplayEnabled(component);
		helper.getCanEdit(component);
		helper.getCanDelete(component);
	},

	closeEditPage: function (component) {
		component.set("v.isEditing", false);
	},

	handleEdit: function (component, event, helper) {
		helper.editIdea(component);
	},

	handleDelete: function (component, event, helper) {
		helper.deleteIdea(component);
	},

	handleExploreIdeas: function (component, event, helper) {
		helper.gotoUrl(component, component.get('v.ideasListURL'));
	},

	handleFollow: function (component, event, helper) {
		// helper.followIdea(component);
	}
})