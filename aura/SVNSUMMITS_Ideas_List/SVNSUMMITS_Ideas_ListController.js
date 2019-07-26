// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
    doInit : function(component, event, helper) {
        var baseLoaded = component.get("v.baseLoaded");

        // searchString       = Filter by Search string
	    // searchByTopics     = Filter by Topic string
	    // searchByTheme      = Filter by Theme string
	    // searchByStatus     = filter by status string
	    // searchByCategories = filter by category string
	    // searchMyIdeas      = No,Display My Ideas Only,Display My Voted Ideas Only

	    if (!baseLoaded) {
           component.set("v.baseLoaded", true);
	        helper.getCommonSettings(component);

	        var url = window.location.href;
	        component.set("v.currentURL", encodeURIComponent(url));
	        helper.debug(component, "List URL = " + encodeURIComponent(url));

		    var topicValue = '';
	        var urlParts = url.split('/');
	        if (urlParts[urlParts.length - 3] == 'topic') {
	        	topicValue = urlParts[urlParts.length - 1];
		        topicValue = decodeURIComponent(topicValue);
	        }

	        var searchByTopics = component.get("v.searchByTopics");

	        if (topicValue) {
				component.set("v.topicValue", topicValue);
	        } else {
		        component.set("v.topicValue", searchByTopics);
	        }

	        var searchTerm = component.get('v.searchString');
	        if (searchTerm) {
		        component.set("v.searchTermValue", searchTerm);
	        }

	        if (component.get("v.filterOn") === 'Search Term') {
	            component.set("v.searchTermValue", topicValue);
	        }

	        if (component.get("v.searchMyIdeas") === 'Topic') {
	            component.set("v.topicValue", topicValue);
	            helper.debug(component, "Search by Topic: " + component.get("v.searchByTopics"));
	        }

			helper.showSpinner(component);
	        helper.getUserId(component);
	        helper.isNicknameDisplayEnabled(component);
	        helper.getSitePrefix(component);
	        helper.getZoneId(component);
         }
    },

	setIdeasFilters : function(component, event, helper) {
        var searchString        = event.getParam("searchString");
        var searchMyIdeas       = event.getParam("searchMyIdeas");
        var searchByCategories  = event.getParam("searchByCategories");
        var searchByTopics      = event.getParam("searchByTopics");
        var searchByStatus      = event.getParam("searchByStatus");
        var searchByThemes      = event.getParam("searchByThemes");
        var sortBy              = event.getParam("sortBy");

		var prevSearch = component.get("v.previousSearch");

		if (searchString) {
            component.set("v.searchString",   searchString.trim());
		    component.set("v.previousSearch", searchString);
        }
        else {
            if (prevSearch) {
                helper.debug(component, '--> clear prev search');
                component.set("v.searchString", "");
                component.set("v.previousSearch", "");
            }
        }

		//send a ' ' character to clear the filter
        if (searchMyIdeas)
            component.set("v.searchMyIdeas",      searchMyIdeas.trim());
        if (searchByCategories)
            component.set("v.searchByCategories", searchByCategories.trim());
        if (searchByTopics)
            component.set("v.searchByTopics",     searchByTopics.trim());
        if (searchByStatus)
            component.set("v.searchByStatus",     searchByStatus.trim());
        if (searchByThemes)
            component.set("v.searchByTheme",      searchByThemes.trim());
        if (sortBy)
            component.set("v.sortBy",             sortBy.trim());

        helper.showSpinner(component);
        helper.getIdeasList(component);
    },

    handleSortChange : function(component, event, helper) {
        helper.debug(component,"handleSortChange called");
        component.set("v.ideaListWrapper.ideaList",null);

        var sortByCmp = component.find("sortByInput");
	    component.set("v.sortBy",sortByCmp.get("v.value"));

	    helper.showSpinner(component)
        helper.getIdeasList(component);
    },

    getNextPage : function(component, event, helper) {
        helper.debug(component,"nextPage called", null);
        component.set("v.ideaListWrapper.ideaList",null);

	    helper.showSpinner(component)
        helper.getNextPage(component);
    },

    getPreviousPage : function(component, event, helper) {
        helper.debug(component,"previousPage called",null);
        component.set("v.ideaListWrapper.ideaList",null);

	    helper.showSpinner(component)
        helper.getPreviousPage(component);
    },

    updateCategories : function(component,event,helper){
        component.set("v.ideaListWrapper.ideaList",null);

        var cmpCategoriesFilter = component.find("categoriesFilter");
        var selectedCategories = cmpCategoriesFilter.get("v.value");

        component.set("v.categories", selectedCategories);

	    helper.showSpinner(component)
        helper.getIdeasList(component);
    },

    handle_VoteUp : function(component,event,helper) {
        var linkCmp = event.currentTarget;
        var ideaId = linkCmp.dataset.recordid;

        helper.submitVote(component,ideaId,"Up");
    },

    handle_VoteDown : function(component,event,helper) {
        var linkCmp = event.currentTarget;
        var ideaId = linkCmp.dataset.recordid;

        helper.submitVote(component,ideaId,"Down");
    },

	gotoListView : function(component, event, helper) {
    	helper.gotoUrl(component, component.get('v.ideasListURL'));
	}
})