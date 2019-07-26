// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	doInit: function (component, event, helper) {
		helper.setListView(component);
	},

	setListView: function (component, event, helper) {
		component.set("v.listViewMode", "List");
		helper.setListView(component);

	},

	setTileView: function (component, event, helper) {
		component.set("v.listViewMode", "Tile");
		helper.setListView(component);
	},

	setDisplayMode: function (component, event, helper) {
		var listViewMode = event.getParam("listViewMode");
		component.set("v.listViewMode", listViewMode);
	}
})