// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
    isNicknameDisplayEnabled : function(component) {
        var action = component.get("c.isNicknameDisplayEnabled");

        action.setCallback(this, function(actionResult) {
            component.set("v.isNicknameDisplayEnabled", actionResult.getReturnValue());
        });

        $A.enqueueAction(action);
    },

    getUserId : function(component) {
        var action = component.get("c.getUserId");

        action.setCallback(this, function(actionResult) {
            component.set("v.userId", actionResult.getReturnValue());
        });

        $A.enqueueAction(action);
    },

    getSitePrefix : function(component) {
        var action = component.get("c.getSitePrefix");

        action.setCallback(this, function(actionResult) {
            var sitePath   = actionResult.getReturnValue();
            component.set("v.sitePath", sitePath);

            var sitePrefix = sitePath.replace("/s","");
            component.set("v.sitePrefix", sitePrefix);
        });

        $A.enqueueAction(action);
    },

    getZoneId : function(component) {
        var self = this;
        var action = component.get("c.getZoneId");

        action.setParams({
            nameValue: component.get("v.zoneName")
        });

        action.setCallback(this, function(actionResult) {
            var zoneId = actionResult.getReturnValue();
            component.set("v.zoneId", zoneId);
            self.getPickListValues(component);
        });

        $A.enqueueAction(action);
    },

    getCommonSettings: function(component) {
        var action = component.get("c.getCommonSettings");

        action.setCallback(this, function(actionResult) {
            var common = actionResult.getReturnValue();
            component.set("v.debugMode", common.debugMode);
        });

        $A.enqueueAction(action);
    },

    getPickListValues : function(component) {
        var self = this;
        var action = component.get("c.getPicklistValues");

        action.setParams({
            objName: "Idea",
            fieldName: "Categories"
        });

        action.setCallback(this, function(actionResult) {
            component.set("v.categoriesSet", actionResult.getReturnValue());

            var catSetValue = component.get("v.categoriesSet");
            var topicValue  = component.get("v.topicValue");

            if (catSetValue.indexOf(topicValue) !== -1 && component.get("v.filterOn") === 'Topic') {
                component.set("v.categories",topicValue);
            }

            self.getIdeasList(component);
        });

        $A.enqueueAction(action);
    },

    getIdeasList: function(component) {
        this.dumpIdeaListOptions('getIdeasList', component);

        var self = this;
        var action = null;
        var searchByTopic = (component.get("v.topicValue") && component.get("v.topicValue").trim().length > 0)
	        ? component.get("v.topicValue")
	        : component.get("v.searchByTopics");

	    var displayMode = component.get("v.displayMode");

        if (displayMode === 'Featured') {
            action = component.get("c.getFeaturedIdeas");
            action.setParams(this.updateFeaturedParams(component));
        } else {
            action = component.get("c.getIdeas");
            action.setParams(this.updateListParams(component, false));
        }

        action.setCallback(this, function(actionResult) {
	        var ideaListWrapper = self.updateListWrapper(component, actionResult);

	        component.set("v.ideaListWrapper", ideaListWrapper);

            component.set("v.debugMode", ideaListWrapper.debugMode);
            component.set("v.enableDownVoting", ideaListWrapper.allowDownVoting);

            var appEvent = $A.get("e.c:SVNSUMMITS_Ideas_Header_Event");
            appEvent.setParams({
                "totalResults" : ideaListWrapper.totalResults,
            });
            appEvent.fire();

	        var sortEvent = $A.get("e.c:SVNSUMMITS_Ideas_Filter_Sort_Event");
	        sortEvent.setParams({
		        "sortBy" : component.get("v.sortBy")
	        });
	        sortEvent.fire();

	        self.hideSpinner(component);
        });

        $A.enqueueAction(action);
    },

	updateFeaturedParams: function (component) {
    	var params = {
		    recordId1: component.get("v.recordId1"),
		    recordId2: component.get("v.recordId2"),
		    recordId3: component.get("v.recordId3")
	    };

    	return params;
	},

	updateListParams: function(component, paginate) {
		var searchByTopic = (component.get("v.topicValue") && component.get("v.topicValue").trim().length > 0)
			? component.get("v.topicValue")
			: component.get("v.searchByTopics");

		var params = {
			listSize            : component.get("v.listSize"),
			categories          : component.get("v.categories"),
			zoneId              : component.get("v.zoneId"),
			filterByTopic       : (searchByTopic && searchByTopic.trim().length > 0) ? true : false,
			topicName           : component.get("v.topicValue"),
			filterBySearchTerm  : component.get("v.filterOn") === 'Search Term' ? true : false,
			searchTerm          : component.get("v.searchString"),
			searchMyIdeas       : component.get("v.searchMyIdeas")  === 'Display My Voted Ideas Only' ? '' : component.get("v.searchMyIdeas"),
			searchByCategories  : component.get("v.searchByCategories"),
			searchByTopics      : searchByTopic,
			searchByStatus      : component.get("v.searchByStatus"),
			searchByThemes      : component.get("v.searchByTheme"),
			filterOnUserOwned   : component.get("v.filterOn") === 'Display My Ideas Only' ? true : false,
			filterOnUserVoted   : component.get("v.filterOn") === 'Display My Voted Ideas Only' ? true : false,
			sortBy              : component.get("v.sortBy"),
			limitVoteToEmailDomain  : component.get("v.limitVoteToEmailDomain")
		};

		if (paginate) {
			params['pageNumber'] = component.get("v.ideaListWrapper").pageNumber;
		}

		return params;
	},

	updateListWrapper: function(component, actionResult) {
		var ideaListWrapper = this.parseNamespace(component, actionResult.getReturnValue());

		var sortBy = component.get("v.sortBy");

		for (var i = 0; i < ideaListWrapper.ideaList.length; i++) {
			if (ideaListWrapper.ideaList[i].Categories) {
				ideaListWrapper.ideaList[i].Categories = ideaListWrapper.ideaList[i].Categories.split(";");
			}

			ideaListWrapper.ideaList[i].fromNow = moment.utc(ideaListWrapper.ideaList[i].CreatedDate).fromNow();

			if (sortBy === "Recent Comments") {
				ideaListWrapper.ideaList[i].LastComment.fromNow = moment.utc(ideaListWrapper.ideaList[i].LastComment.CreatedDate).fromNow();
			}
		}

		return ideaListWrapper;
	},

    getNextPage: function(component) {
	    this.dumpIdeaListOptions('getNextPage', component);

	    var self = this;
        var action = component.get("c.nextPage");

        action.setParams(this.updateListParams(component, true));

        action.setCallback(this, function(actionResult) {
	        component.set("v.ideaListWrapper", self.updateListWrapper(component, actionResult));

	        self.hideSpinner(component);
        });

        $A.enqueueAction(action);
    },

    getPreviousPage: function(component) {
	    this.dumpIdeaListOptions('getPreviousPage', component);

	    var self = this;
        var action = component.get("c.previousPage");

        action.setParams(this.updateListParams(component, true));

        action.setCallback(this, function(actionResult) {
	        component.set("v.ideaListWrapper", self.updateListWrapper(component, actionResult));

	        self.hideSpinner(component);
        });

        $A.enqueueAction(action);
    },

	showSpinner: function (component) {
		console.log('Spinner on...');
		$A.util.removeClass(component.find('listSpinner'), 'slds-hide');
	},

	hideSpinner: function (component) {
		console.log('Spinner off...');
		$A.util.addClass(component.find('listSpinner'), 'slds-hide');
	},

    submitVote: function(component, ideaId, voteType) {
        var self = this;
        var action = component.get("c.submitVote");

        action.setParams({
            ideaId: ideaId,
            voteType: voteType
        });

        action.setCallback(this, function(actionResult) {
            var currIdea = self.parseNamespace(component, actionResult.getReturnValue());

            if (currIdea) {
                if (currIdea.Categories) {
                    currIdea.Categories = currIdea.Categories.split(";");
                }

                var ideaListWrapper = component.get("v.ideaListWrapper");

                for (var i=0;i<ideaListWrapper.ideaList.length;i++) {
                    if (ideaListWrapper.ideaList[i].Id === ideaId) {
                        ideaListWrapper.ideaList[i] = currIdea;
                        break;
                    }
                }

                component.set("v.ideaListWrapper",ideaListWrapper);
            }
        });

        $A.enqueueAction(action);
    },

    initializeDropdown: function(component) {
        try{
            var catCmp = component.find("categoriesFilter");

            $A.util.removeClass(catCmp,"slds-hide");
            $A.util.addClass(catCmp, "ui");

            $(catCmp.getElement()).dropdown({
                placeholder: "All Categories"
            });
        } catch (e) {
            this.debug(component,null,e);
        }
    },

    dumpIdeaListOptions: function(title, component) {
        this.debug(component, ' ');
        this.debug(component, title);
        this.debug(component, '======================================');
        this.debug(component, 'DisplayMode:     ' + component.get("v.displayMode"));
        this.debug(component, 'ListSize:        ' + component.get("v.listSize"));
        this.debug(component, 'Categories:      ' + component.get("v.categories"));
        this.debug(component, 'ZoneId:          ' + component.get("v.zoneId"));
        this.debug(component, 'LimitVote:       ' + component.get("v.limitVoteToEmailDomain"));
        this.debug(component, component.get("v.filterOn") === 'Topic' ? 'Topic filter:    true' : 'Topic filter:    false');
        this.debug(component, 'Topic Value:     ' + component.get("v.topicValue"));
        this.debug(component, component.get("v.filterOn") === 'Search Term' ? 'Search Term:     true' : 'Search Term:     false');
        this.debug(component, 'Search string:   ' + component.get("v.searchString"));
        this.debug(component, component.get("v.filterOn") === 'Display My Ideas Only' ? 'MyIdeas:         true' : 'MyIdeas:         false');
        this.debug(component, component.get("v.filterOn") === 'Display My Voted Ideas Only' ? 'MyVotedIdeas:    true' : 'MyVotedIdeas:    false');
        this.debug(component, 'SearchMyIdeas:   ' + component.get("v.searchMyIdeas"));
        this.debug(component, 'SearchCategories:' + component.get("v.searchByCategories"));
        this.debug(component, 'SearchTopics:    ' + component.get("v.searchByTopics"));
        this.debug(component, 'SearchStatus:    ' + component.get("v.searchByStatus"));
        this.debug(component, 'SearchTheme:     ' + component.get("v.searchByTheme"));
        this.debug(component, 'SortBy:          ' + component.get("v.sortBy"));
        this.debug(component, '---------------------------------------');
    },

    debug: function(component, msg, variable) {
        if (component.get("v.debugMode")) {
            if (msg) {
                console.log(msg);
            }
            if (variable) {
                console.log(variable);
            }
        }
    }
})