// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	doInit: function (component, event, helper) {
		helper.debug(component, "List controller - doInit");

		var url = window.location.href;
		if (url.indexOf('?') !== -1) {
			url = url.substring(0, url.indexOf('?'));
		}
		component.set("v.currentURL", encodeURIComponent(url));

		var urlParts  = url.split("/");
		var urlLength = urlParts.length;

		var urlID = decodeURIComponent(urlParts[urlLength - 1]).replace(/#/g, "");

		var filterOn = component.get("v.filterOn");
		if (filterOn === "Search Term") {
			component.set("v.searchstr", component.get("v.filterId"));
		}
		else if (filterOn === "Topic Value") {
			// Topic uses the topic name (last param)
			component.set("v.topicName", urlID);
		}
		else if (filterOn === "Group") {
			// Group uses the ID (2nd last param)
			var groupId = urlParts[urlLength-2];
			component.set("v.groupID", groupId);
		}
		else {
			component.set("v.filterId", component.get("v.recordId"));
		}

		// check to see if the user set a default topic filter
		var filterNewsListByTopic = component.get("v.filterNewsListByTopic");
		if (filterNewsListByTopic !== undefined && filterNewsListByTopic !== '') {
			component.set("v.filterByTopic", filterNewsListByTopic);
		}

		helper.getNewsList(component, event);
		helper.get_SitePrefix(component);
		helper.isNicknameDisplayEnabled(component);
		//helper.sortByShowHide(component);
	},

	//Changed due to resolve the java script Error of Renderer/afterRender
	// so that added afterScriptsLoaded to call sortByShowHide() method
	afterScriptsLoaded: function (component, event, helper) {
		helper.sortByShowHide(component);
	},

	gotoList: function(component, event, helper) {
		helper.gotoUrl(component, component.get('v.newsListURL'));
	},

	setSortBy: function (component, event, helper) {
		var sortBy = event.getParam("sortBy");
		component.set("v.sortBy", sortBy);
		helper.getNewsList(component, event);

	},

	setDates: function (component, event, helper) {
		var fromDate = event.getParam("fromDate");
		var toDate = event.getParam("toDate");
		component.set("v.fromDate", fromDate);
		component.set("v.toDate", toDate);

		helper.getNewsList(component, event);
	},

	setTopic: function (component, event, helper) {
		var filterByTopic = event.getParam("filterByTopic");
		component.set("v.filterByTopic", filterByTopic);
		helper.getNewsList(component, event);
	},

	setAuthor: function (component, event, helper) {
		var filterByAuthor = event.getParam("filterByAuthor");
		component.set("v.filterByAuthor", filterByAuthor);
		helper.getNewsList(component, event);
	},

	setSearchText: function (component, event, helper) {
		var searchText = event.getParam("searchText");
		component.set("v.searchstr", searchText);
		helper.getNewsList(component, event);
	},

	getNextPage: function (component, event, helper) {
		component.set("v.newsListWrapper.newsList", null);
		helper.getNextPage(component);
	},

	getPreviousPage: function (component, event, helper) {
		component.set("v.newsListWrapper.newsList", null);
		helper.getPreviousPage(component);
	},

	setDisplayMode: function (component, event, helper) {
		var listViewModeGet = event.getParam("listViewMode");

		if (listViewModeGet === "Tile") {
			component.set("v.listViewMode", "List");
			component.set("v.displayMode", "Tile");
		} else if (listViewModeGet === "List") {
			component.set("v.listViewMode", "List");
			component.set("v.displayMode", "List");
		} else {
			component.set("v.listViewMode", listViewModeGet);
		}
	}
})