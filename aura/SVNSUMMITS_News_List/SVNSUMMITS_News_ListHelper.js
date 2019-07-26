// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	getNewsList: function (component) {
		var self = this;
		this.debug(component, "Fetch News Called..", null);
		component.set("v.strError", null);

		var groupId = component.get("v.groupID");
		if (groupId !== '') {
			component.set('v.topicName', groupId);
		}

		var action = component.get("c.getNews");
		action.setParams({
			numberOfNews: 0,
			numberOfNewsPerPage: component.get("v.numberOfNewsPerPage"),
			strfilterType: '',
			strRecordId: component.get("v.filterId"),
			networkId: '',
			sortBy: component.get("v.sortBy"),
			filterByTopic: component.get("v.filterByTopic"),
			filterByAuthor: component.get("v.filterByAuthor"),
			topicName: component.get("v.topicName"),
			filterOn: component.get("v.filterOn"),
			searchTerm: component.get("v.searchstr"),
			fromDate: component.get("v.fromDate"),
			toDate: component.get("v.toDate"),
		});


		action.setCallback(this, function (response) {
			var state = response.getState();

			if (component.isValid() && state === "SUCCESS") {

				var newsListWrapper = self.parseNewsNameSpace(component, response.getReturnValue());

				//updated to catch exception if any occurred in apex
				if (newsListWrapper.field !== '' && newsListWrapper.field !== null) {
					if (newsListWrapper.field === 'Date') {
						self.debug(component, "Exception occurred", newsListWrapper.errorMsg);

						if (newsListWrapper.errorMsg !== '' && newsListWrapper.errorMsg !== null) {
							if (newsListWrapper.errorMsg === 'List index out of bounds: 1') {
								component.set("v.strError", 'Invalid Date.');
							} else {
								component.set("v.strError", 'Unexpected Error Occured, Please contact your Administrator.');
							}
						}
					} else {
						self.debug(component, "Exception occured", newsListWrapper.errorMsg);
						if (newsListWrapper.errorMsg !== '' && newsListWrapper.errorMsg !== null)
							component.set("v.strError", 'Unexpected Error Occured, Please contact your Administrator.');
					}
				}

				//updated code to hide recommended component if no records found
				if (component.get("v.displayMode") === 'Compact') {
					if (newsListWrapper.newsList.length === 0) {

						self.debug(component, "No records to display in list - Hide()");
						$('.CCNEWSLCSVNSUMMITS_News_List').hide();
					}
				}

				var appEvent = $A.get("e.c:SVNSUMMITS_News_Header_Event");
				appEvent.setParams({
					"totalResults": newsListWrapper.totalResults,
				});
				appEvent.fire();

				component.set("v.totalNews", newsListWrapper.totalResults);
				component.set("v.newsListWrapper", this.updateNewsWrapper(component, newsListWrapper));
			}
		});
		$A.enqueueAction(action);
	},

	debug: function (component, msg, variable) {
		var debugMode = component.get("v.debugMode");
		if (debugMode) {
			if (msg) {
				console.log(msg);
			}
			if (variable) {
				console.log(variable);
			}
		}
	},

	getNextPage: function (component) {
		var self = this;
		this.debug(component, "Next Page Clicked...", null);

		var action = component.get("c.nextPage");

		action.setParams({
			numberOfNews: 0,
			numberOfNewsPerPage: component.get("v.numberOfNewsPerPage"),
			pageNumber: component.get("v.newsListWrapper").pageNumber,
			strfilterType: '',
			strRecordId: component.get("v.filterId"),
			networkId: '',
			sortBy: component.get("v.sortBy"),
			filterByTopic: component.get("v.filterByTopic"),
			filterByAuthor: component.get("v.filterByAuthor"),
			topicName: component.get("v.topicName"),
			filterOn: component.get("v.filterOn"),
			searchTerm: component.get("v.searchstr"),
			fromDate: component.get("v.fromDate"),
			toDate: component.get("v.toDate"),
		});

		action.setCallback(this, function (actionResult) {
			var newsListWrapper = self.parseNewsNameSpace(component, actionResult.getReturnValue());

			component.set("v.newsListWrapper", this.updateNewsWrapper(component, newsListWrapper));
			var pageNumberComp = self.component.find("pageNumber");
			pageNumberComp.set("v.value", newsListWrapper.pageNumber);

		});

		$A.enqueueAction(action);
	},

	getPreviousPage: function (component) {
		var self = this;
		this.debug(component, "Previous Page Clicked...", null);

		var action = component.get("c.previousPage");

		action.setParams({
			numberOfNews: 0,
			numberOfNewsPerPage: component.get("v.numberOfNewsPerPage"),
			pageNumber: component.get("v.newsListWrapper").pageNumber,
			strfilterType: '',
			strRecordId: component.get("v.filterId"),
			networkId: '',
			sortBy: component.get("v.sortBy"),
			filterByTopic: component.get("v.filterByTopic"),
			filterByAuthor: component.get("v.filterByAuthor"),
			topicName: component.get("v.topicName"),
			filterOn: component.get("v.filterOn"),
			searchTerm: component.get("v.searchstr"),
			fromDate: component.get("v.fromDate"),
			toDate: component.get("v.toDate"),
		});

		action.setCallback(this, function (actionResult) {
			var newsListWrapper = self.parseNewsNameSpace(component, actionResult.getReturnValue());

			component.set("v.newsListWrapper", this.updateNewsWrapper(component, newsListWrapper));

			var pageNumberComp = self.component.find("pageNumber");
			pageNumberComp.set("v.value", newsListWrapper.pageNumber);

		});

		$A.enqueueAction(action);
	},

	parseNewsNameSpace: function (component, newsListWrapper) {
		var wrapper = this.parseNamespace(component, newsListWrapper);

		wrapper.newsList = this.parseNamespace(component, wrapper.newsList);

		return wrapper;
	},

	updateNewsWrapper: function (component, newsListWrapper) {
		var nameSpace = component.get('v.nameSpace');

		for (var i = 0; i < newsListWrapper.newsList.length; i++) {

			newsListWrapper.newsList[i].commentCount = newsListWrapper.newsToCommentCountMap[newsListWrapper.newsList[i].Id];
			newsListWrapper.newsList[i].strTime =
				moment(newsListWrapper.newsList[i][nameSpace + 'Publish_DateTime__c']).fromNow();

			// if (newsListWrapper.newsList[i].Name.length > 70) {
			// 	newsListWrapper.newsList[i].Name = newsListWrapper.newsList[i].Name.substring(0, 70);
			// }

			newsListWrapper.newsList[i].topics1 = [];
			newsListWrapper.newsList[i].topics1.push(newsListWrapper.newsToTopicsMap[newsListWrapper.newsList[i].Id]);
			newsListWrapper.newsList[i].topics = [];
			newsListWrapper.newsList[i].groupName =
				newsListWrapper.groupIdToName[newsListWrapper.newsList[i][nameSpace + 'GroupId__c']];

			/* Logic for topics will be displayed till 27 characters only */
			if (newsListWrapper.newsList[i].topics1 !== undefined) {
				for (var j = 0; j < newsListWrapper.newsList[i].topics1.length; j++) {
					if (newsListWrapper.newsList[i].topics1[j] !== undefined) {
						for (var jj = 0; jj < newsListWrapper.newsList[i].topics1[j].length; jj++) {
							if (newsListWrapper.newsList[i].topics !== undefined) {
								newsListWrapper.newsList[i].topics.push(newsListWrapper.newsList[i].topics1[j][jj]);
							}
						}
					}
				}
			}
		}
		return newsListWrapper;
	},

	get_SitePrefix: function (component) {
		var action = component.get("c.getSitePrefix");
		action.setCallback(this, function (actionResult) {
			var sitePath = actionResult.getReturnValue();
			component.set("v.sitePath", sitePath);
			component.set("v.sitePrefix", sitePath.replace("/s", ""));
		});
		$A.enqueueAction(action);
	},

	isNicknameDisplayEnabled: function (component) {
		var action = component.get("c.isNicknameDisplayEnabled");
		action.setCallback(this, function (actionResult) {
			component.set("v.isNicknameDisplayEnabled", actionResult.getReturnValue());
			this.debug(component, "Nick Name for Community Boolean : ", component.get("v.isNicknameDisplayEnabled"));
		});
		$A.enqueueAction(action);
	},

	sortByShowHide: function () {

		$(window).click(function () {
			$('#dropDwnBtn_menu').hide();
		})

		$('#dropDwnBtn').click(function (even) {
			even.stopPropagation();
		})

		$('#dropDwnBtn').click(function () {
			$('#dropDwnBtn_menu').toggle();
		});

		$('#dropDwnBtn_menu').click(function () {
			if ($('#dropDwnBtn_menu').show()) {
				$('#dropDwnBtn_menu').hide();
			} else {
				$('#dropDwnBtn_menu').show();
			}
		});
	}

})