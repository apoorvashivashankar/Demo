// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
    doInit: function (component, event, helper) {
        helper.getNewsRecord(component);
        helper.get_SitePrefix(component);
        helper.getIsObjectEditable(component);
        helper.getIsRecordEditable(component);
        helper.getIsRecordDeletable(component);
    },

    closeEditPage: function (component) {
        component.set("v.isEdit", false);
    },

    setRecordId: function (component) {
        var body = component.find('editView');
        body.set("v.body", []);

        var topics = '';
        if (component.get("v.recordId") && component.get("v.recordId") !== '') {
            topics = JSON.stringify(component.get('v.newsListWrapper.newsList')[0].topics[0]);
        }

        $A.createComponent('c:SVNSUMMITS_News_Create', {
            'isEdit': true,
            'sObjectId': component.get("v.recordId"),
            'selectedTopics': topics,
            'limitToSpecificGroups' : component.get("v.limitToSpecificGroups")
        }, function (editView) {
            var op = component.find("editView");
            body = op.get('v.body');
            body.push(editView);
            op.set('v.body', body);
            component.set("v.isEdit", true);
        });
    },

    goToNewsList: function (component, event, helper) {
        helper.goToNewsList(component);
    },

    deleteNewsRecord: function (component, event, helper) {
        var title = component.get('v.newsListWrapper.newsList[0].Name');

        if (confirm('Deleting news item: ' + title + '\n\nAre you sure?')) {
            helper.deleteNewsRecord(component);
        }
    }
})