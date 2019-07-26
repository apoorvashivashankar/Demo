// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	doInit: function (component, event, helper) {
		var nameSpace = helper.getNameSpacePrefix(component);
		component.set('v.nameSpace', nameSpace);

		helper.getNewsRecord(component);
		helper.get_SitePrefix(component);
	},
	closeEditPage: function (component) {
		component.set("v.isEdit", false);
	},
	goToRecord: function (component, event, helper) {
		$A.get("e.force:navigateToSObject")
			.setParams({
				"recordId": $(event.currentTarget).data("id"),
				"slideDevName": "related"
			})
			.fire();
	},

	setRecordId: function (component) {

		var body = component.find('editView');
		body.set("v.body", []);

		var topics = '';
		if (component.get("v.recordId") && component.get("v.recordId") !== '') {
			topics = JSON.stringify(component.get('v.newsListWrapper.newsList')[0].topics[0]);
		}

		var author = component.get("v.newsListWrapper.newsList[0].Author__c");
		$A.createComponent('c:SVNSUMMITS_News_Create',
			{
				'isEdit': true,
				'sObjectId': component.get("v.recordId"),
				'selectedTopics': topics,
				'limitToSpecificGroups' : component.get('limitToSpecificGroups'),
			}, function (editView) {
				var op = component.find("editView");
				body = op.get('v.body');
				body.push(editView);
				op.set('v.body', body);
				component.set("v.isEdit", true);
			});
	}

})