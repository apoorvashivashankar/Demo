// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
    getNewsRecord: function (component) {
        this.debug(component, "News Record for detail called...", null);
        //console.log("called from header getNewsRecord");
        var self = this;

        var action = component.get("c.getNewsRecord");

        action.setParams({
            newsRecordId: component.get("v.recordId"),
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (component.isValid() && state === "SUCCESS") {
	            self.debug(component, "News Record : ", response.getReturnValue());
	            var newsListWrapper = this.parseNamespace(component,response.getReturnValue());
	            var nameSpace = component.get('v.nameSpace');

                for (var i = 0; i < newsListWrapper.newsList.length; i++) {
	                newsListWrapper.newsList[i].strTime =
		                moment.utc(newsListWrapper.newsList[i][nameSpace + 'Publish_DateTime__c']).fromNow();
                    component.set("v.news.Details__c", newsListWrapper.newsList[0][nameSpace + 'Details__c']);
                    newsListWrapper.newsList[i].topics = [];
                    newsListWrapper.newsList[i].topics.push(newsListWrapper.newsToTopicsMap[newsListWrapper.newsList[i].Id]);
                }
                component.set("v.newsListWrapper", newsListWrapper);
            }

            document.title = component.get('v.newsListWrapper.newsList[0].Name');
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
    },

    getIsObjectEditable: function (component) {
        var action = component.get("c.isObjectEditable");

        action.setCallback(this, function (actionResult1) {
            var isObjectEditable = actionResult1.getReturnValue();
            component.set("v.isObjectEditable", isObjectEditable);
        });

        $A.enqueueAction(action);
    },

    getIsRecordEditable: function (component) {
        var action = component.get("c.isRecordEditable");

        action.setParams({
            recordId: component.get("v.recordId"),
        });

        action.setCallback(this, function (actionResult1) {
            var isRecordEditable = actionResult1.getReturnValue();
            component.set("v.isRecordEditable", isRecordEditable);
        });

        $A.enqueueAction(action);
    },

    getIsRecordDeletable: function (component) {
        var action = component.get("c.isRecordDeletable");

        action.setParams({
            recordId: component.get("v.recordId"),
        });

        action.setCallback(this, function (actionResult1) {
            var isRecordDeletable = actionResult1.getReturnValue();
            component.set("v.isRecordDeletable", isRecordDeletable);
        });

        $A.enqueueAction(action);
    },

    deleteNewsRecord: function (component) {
        var action = component.get("c.deleteRecord");
        var self = this;

        action.setParams({
            recordId: component.get("v.recordId"),
        });

        action.setCallback(this, function (actionResult1) {
            var isDeleted = actionResult1.getReturnValue();
            if (isDeleted) {
                self.goToNewsList();
            }
        });

        $A.enqueueAction(action);
    },

    goToNewsList: function (component) {
        var homeEvent = $A.get("e.force:navigateToObjectHome");

        homeEvent.setParams({
            "scope": "News__c"
        });

        homeEvent.fire();
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
    }
})