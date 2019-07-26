// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	getNewsRecord: function (component) {
		this.debug(component, "News Record for detail called...", null);

		var action = component.get("c.getNewsRecord");
		action.setParams({
			newsRecordId: component.get("v.recordId"),
		});

		action.setCallback(this, function (response) {
			var state = response.getState();

			if (component.isValid() && state === "SUCCESS") {
				var newsListWrapper = response.getReturnValue();
				var nameSpace = component.get('v.nameSpace');

				this.debug(component, "News Record : ", response.getReturnValue());

				for (var i = 0; i < newsListWrapper.newsList.length; i++) {
					newsListWrapper.newsList[i].strTime =
						moment.utc(newsListWrapper.newsList[i][nameSpace + 'Publish_DateTime__c']).fromNow();
					component.set("v.newsDetails", newsListWrapper.newsList[i][nameSpace + 'Details__c']);
					component.set("v.newsGroupId", newsListWrapper.newsList[i][nameSpace + 'GroupId__c'] || '');
					component.set('v.newsPrivate', newsListWrapper.newsList[i][nameSpace + 'Private_Group__c']);

					newsListWrapper.newsList[i].topics = [];
					newsListWrapper.newsList[i].topics.push(newsListWrapper.newsToTopicsMap[newsListWrapper.newsList[i].Id]);
				}

				component.set("v.newsListWrapper", newsListWrapper);
				component.set("v.groupName",
					newsListWrapper.groupIdToName[newsListWrapper.newsList[0][nameSpace + 'GroupId__c']] || '');
			}
		});

		$A.enqueueAction(action);
	},

	get_SitePrefix: function (component) {
		var action = component.get("c.getSitePrefix");

		action.setCallback(this, function (actionResult) {
			var sitePath = actionResult.getReturnValue();
			component.set("v.sitePath", sitePath);
			component.set("v.sitePrefix", sitePath.replace("/s", ""));
		});

		$A.enqueueAction(action);

		var action1 = component.get("c.isObjectEditable");

		action1.setCallback(this, function (actionResult1) {
			var isObjectEditable = actionResult1.getReturnValue();
			component.set("v.isObjectEditable", isObjectEditable);
		});

		$A.enqueueAction(action1);

		var action2 = component.get("c.isRecordEditable");

		action2.setParams({
			recordId: component.get("v.recordId"),
		});

		action2.setCallback(this, function (actionResult1) {
			var isRecordEditable = actionResult1.getReturnValue();
			component.set("v.isRecordEditable", isRecordEditable);
		});

		$A.enqueueAction(action2);
	},

	setRecordId: function (component) {
		this.debug(component, 'Detail page header called..', null);

		var action = component.get("c.getNewsRecord");
		action.setParams({
			newsRecordId: component.get("v.recordId"),
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {
				var newsListWrapper = this.parseNamespace(component, response.getReturnValue());

				component.set("v.newsListWrapper", newsListWrapper);
				document.title = component.get('v.newsListWrapper.newsList[0].Name');
			}
		});
		$A.enqueueAction(action);

		var action1 = component.get("c.getSitePrefix");

		action1.setCallback(this, function (actionResult) {
			var sitePath = actionResult.getReturnValue();
			component.set("v.sitePath", sitePath);
		});

		$A.enqueueAction(action1);
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

	goToURL: function (url) {
		var urlEvent = $A.get("e.force:navigateToURL");

		urlEvent.setParams({
			"url": url,
		});
		urlEvent.fire();
	}
})