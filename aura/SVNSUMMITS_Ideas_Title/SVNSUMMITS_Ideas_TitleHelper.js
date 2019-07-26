// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	getCommonSettings: function (component) {
		var action = component.get("c.getCommonSettings");

		action.setCallback(this, function (actionResult) {
			var settings = actionResult.getReturnValue();
			component.set("v.debugMode", settings.debugMode);
		});

		$A.enqueueAction(action);
	},

	getSitePrefix: function (component) {
		var action = component.get("c.getSitePrefix");

		action.setCallback(this, function (actionResult) {
			var sitePath = actionResult.getReturnValue();
			component.set("v.sitePath", sitePath);
		});

		$A.enqueueAction(action);
	},

	getZoneId: function (component) {
		var self = this;
		var action = component.get("c.getZoneId");

		action.setParams({
			nameValue: component.get("v.zoneName")
		});

		action.setCallback(this, function (actionResult) {
			var zoneId = actionResult.getReturnValue();

			component.set("v.zoneId", zoneId);

			if (zoneId !== "") {
				self.getIdea(component);
			}
		});

		$A.enqueueAction(action);
	},

	isNicknameDisplayEnabled: function (component) {
		var action = component.get("c.isNicknameDisplayEnabled");

		action.setCallback(this, function (actionResult) {
			component.set("v.isNicknameDisplayEnabled", actionResult.getReturnValue());
		});

		$A.enqueueAction(action);
	},

	getTopicMap: function (component, topicName) {
		var self = this;
		var action = component.get("c.getTopicMap");

		action.setParams({
			topicName: topicName
		});

		action.setCallback(this, function (actionResult) {
			var topicMap = actionResult.getReturnValue();
			self.debug(component, 'Topic map for ' + topicName + ' : ', topicMap);

			var linkCmp = component.find("topicLink");
			var sitePath = component.get("v.sitePath");
			var topicId = topicMap[topicName];

			if (topicName && topicId) {
				linkCmp.set("v.label", topicName);
				linkCmp.set("v.value", sitePath + "/topic/" + topicId + "/" + encodeURIComponent(topicName));
			}
			else if (topicName && !topicId) {
				linkCmp.set("v.label", topicName);
				linkCmp.set("v.value", "#");
			}
		});

		$A.enqueueAction(action);
	},

	getIdea: function (component) {
		var self = this;
		var action = component.get("c.getIdea");

		action.setParams({
			zoneId: component.get("v.zoneId"),
			recordId: component.get("v.recordId")
		});

		action.setCallback(this, function (actionResult) {
			var idea = self.parseNamespace(component, actionResult.getReturnValue());

			if (idea.Related_Topic_Name__c) {
				self.getTopicMap(component, idea.Related_Topic_Name__c);
			}

			if (idea.Categories) {
				idea.Categories = idea.Categories.split(";");
			}

			idea.fromNow = moment.utc(idea.CreatedDate).fromNow();

			self.debug(component, "Title Helper.getIdea:", idea);
			component.set("v.idea", idea);

			// self.isFollowingIdea(component);
		});

		$A.enqueueAction(action);
	},

	isFollowingIdea: function (component) {
		var action = component.get('c.isFollowing');

		action.setParams({
			recordId: component.get('v.recordId')
		});

		action.setCallback(this, function (actionResult) {
			var result = actionResult.getReturnValue();
			self.debug(component, "is following = " + result);

			component.set("v.isFollowing", result);
		});

		$A.enqueueAction(action);
	},

	followIdea: function (component) {
		var recordId = component.get("v.recordId");
		var isFollowing = component.get('v.isFollowing');

		var action = isFollowing
			? component.get('c.unfollowRecord')
			: component.get('c.followRecord');

		action.setParams({
			recordId: component.get('v.recordId')
		});

		action.setCallback(this, function (actionResult) {
			var state = actionResult.getState();

			if (state === 'SUCCESS') {
				component.set("v.isFollowing", !isFollowing);
			}
		});

		$A.enqueueAction(action);
	},

	getCanEdit: function (component) {
		var self = this;
		var action = component.get("c.isRecordEditable");

		action.setParams({
			recordId: component.get("v.recordId")
		});

		action.setCallback(this, function (actionResult) {
			var result = actionResult.getReturnValue();
			self.debug(component, "Can edit = " + result);

			component.set("v.canEdit", result);
		});

		$A.enqueueAction(action);
	},

	getCanDelete: function (component) {
		var self = this;
		var action = component.get("c.isRecordDeletable");

		action.setParams({
			recordId: component.get("v.recordId")
		});

		action.setCallback(this, function (actionResult) {
			var result = actionResult.getReturnValue();
			self.debug(component, "Can delete = " + result);

			component.set("v.canDelete", result);
		});

		$A.enqueueAction(action);
	},

	deleteIdea: function (component) {
		var self = this;
		var action = component.get("c.deleteIdea");
		var idea = component.get("v.idea");
		var message = component.get("v.deleteRecordMessage");

		var confirmDelete = confirm(message);

		if (!confirmDelete) {
			return;
		}

		this.debug(component, "Deleting idea " + idea.Title);

		action.setParams({
			ideaId: idea.Id
		});

		action.setCallback(this, function (actionResult) {
			var resultMessage = component.find("resultOutput");
			var deleteTitle = component.get('v.labelDelete');

			if (actionResult.getState() === 'SUCCESS') {

				self.debug(component, "Deleted idea");
				var deleteToast = component.get('v.deleteRecordToast').replace('{0}', idea.Title);
				self.showMessage('success', deleteTitle, deleteToast);

				self.gotoUrl(component, component.get("v.ideasListURL"));
			} else {
				self.debug(component, "Delete Idea failed: ", actionResult.getError());

				var errors = actionResult.getError();

				var deleteFailed = component.get('v.deleteRecordFailed')
											.replace('{0}', idea.Title)
											.replace('{1}', errors[0]);

				self.showMessage('error', deleteTitle, deleteFailed);

				var errorMessage = '<ul>';

				for (var i = 0; i < errors.length; i++) {
					errorMessage += '<li>' + errors[i].message + '</li>';
				}
				errorMessage += '</ul>';

				resultMessage.set("v.value", errorMessage);
			}
		});

		$A.enqueueAction(action);
	},

	editIdea: function (component) {
		var body = component.find('editView');
		body.set("v.body", []);

		try {
			$A.createComponent('c:SVNSUMMITS_Ideas_New', {
					'zoneName': component.get("v.zoneName"),
					'zoneId': component.get("v.zoneId"),
					'sObjectId': component.get("v.recordId"),
					'ideaDetailURL': component.get("v.ideaDetailURL"),
					'currIdea': component.get("v.idea"),
					'allowImages': component.get("v.allowImages"),
					'allowThemes': component.get("v.allowThemes"),
					'allowCategories': component.get("v.allowCategories"),
					'useTopics': true,
					'isEditing': true
				},
				function (editView) {
					var placeHolder = component.find("editView");
					body = placeHolder.get('v.body');

					body.push(editView);
					placeHolder.set("v.body", body);

					component.set("v.isEditing", true);
				}
			);
		} catch (e) {
			this.debug(component, "initialize Idea for Edit exception:", e);
		}
	}
})