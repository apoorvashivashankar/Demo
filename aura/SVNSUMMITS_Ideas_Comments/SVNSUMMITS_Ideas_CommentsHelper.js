// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	isNicknameDisplayEnabled: function (component) {
		var action = component.get("c.isNicknameDisplayEnabled");

		action.setCallback(this, function (actionResult) {
			component.set("v.isNicknameDisplayEnabled", actionResult.getReturnValue());
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
			component.set("v.zoneId", actionResult.getReturnValue());
			self.isValidIdeaId(component);

		});

		$A.enqueueAction(action);
	},

	getSitePrefix: function (component) {
		var action = component.get("c.getSitePrefix");

		action.setCallback(this, function (actionResult) {
			var sitePath = actionResult.getReturnValue();

			component.set("v.sitePath", sitePath);
			//component.set("v.sitePrefix", sitePath.replace("/s/", "/"));
		});

		$A.enqueueAction(action);
	},

	isValidIdeaId: function (component) {
		var self = this;
		var action = component.get("c.isValidIdeaId");

		action.setParams({
			zoneId: component.get("v.zoneId"),
			ideaId: component.get("v.recordId")
		});

		action.setCallback(this, function (actionResult) {
			var isValidIdeaId = actionResult.getReturnValue();
			component.set("v.isValidIdeaId", isValidIdeaId);

			if (isValidIdeaId) {
				self.getTotalCommentCount(component);
				self.getIdeaComments(component);
			}
		});

		$A.enqueueAction(action);
	},

	getTotalCommentCount: function (component) {
		var action = component.get("c.getTotalCommentCount");

		action.setParams({
			zoneId: component.get("v.zoneId"),
			ideaId: component.get("v.recordId")
		});

		action.setCallback(this, function (actionResult) {
			component.set("v.totalCommentCount", actionResult.getReturnValue());
		});

		$A.enqueueAction(action);
	},

	getIdeaComments: function (component) {
		var self = this;
		var action = component.get("c.getIdeaComments");

		action.setParams({
			zoneId: component.get("v.zoneId"),
			ideaId: component.get("v.recordId"),
			numComments: component.get("v.numComments")
		});

		action.setCallback(this, function (actionResult) {
			var commentsList = actionResult.getReturnValue();

			for (var i = 0; i < commentsList.length; i++) {
				commentsList[i].fromNow = moment.utc(commentsList[i].CreatedDate).fromNow();
			}

			self.getIdeaCommentVotes(component, commentsList);
		});

		$A.enqueueAction(action);
	},

	getIdeaCommentVotes: function (component, commentsList) {
		var action = component.get("c.getIdeaCommentVotes");

		action.setParams({
			zoneId: component.get("v.zoneId"),
			ideaId: component.get("v.recordId"),
			numComments: component.get("v.numComments")
		});

		action.setCallback(this, function (actionResult) {
			var commentVotesMap = actionResult.getReturnValue();

			component.set("v.commentVotesMap", commentVotesMap);

			for (var i = 0; i < commentsList.length; i++) {
				if (commentVotesMap[commentsList[i].Id]) {
					commentsList[i].likedByUser = true;
					commentsList[i].voteByUser = commentVotesMap[commentsList[i].Id];
				}
			}

			component.set("v.comments", commentsList);

		});

		$A.enqueueAction(action);
	},

	likeComment: function (component, ideaCommentId) {
		var self = this;
		var action = component.get("c.likeIdeaComment");

		action.setParams({
			ideaCommentId: ideaCommentId
		});

		action.setCallback(this, function (actionResult) {
			if (actionResult.getState() === 'SUCCESS' &&
				actionResult.getReturnValue()) {
				self.getIdeaComments(component);
			} else {
				var errors = actionResult.getError();

				for (var i = 0; i < errors.length; i++) {
					self.debug(component, 'Error: ', errors[i].message);
				}
			}
		});

		$A.enqueueAction(action);
	},

	unlikeComment: function (component, ideaCommentVoteId) {
		var self = this;
		var action = component.get("c.unlikeIdeaComment");

		action.setParams({
			ideaCommentVoteId: ideaCommentVoteId
		});

		action.setCallback(this, function (actionResult) {
			if (actionResult.getState() === 'SUCCESS' &&
				actionResult.getReturnValue()) {
				self.getIdeaComments(component);
			} else {
				var errors = actionResult.getError();

				for (var i = 0; i < errors.length; i++) {
					self.debug(component, 'Error: ', errors[i].message);
				}
			}
		});

		$A.enqueueAction(action);
	},

	addComment: function (component) {
		var self = this;
		var action = component.get("c.addComment");

		action.setParams({
			ideaId: component.get("v.recordId"),
			commentBody: component.get("v.newComment")
		});

		action.setCallback(this, function (actionResult) {
			if (actionResult.getState() === 'SUCCESS' &&
				actionResult.getReturnValue()) {
				self.debug(component, "Added comment:" + component.get("v.newComment"));

				// clear form
				component.set("v.newComment", "");

				// refresh comment list
				self.getIdeaComments(component);
			} else {
				var errors = actionResult.getError();

				for (var i = 0; i < errors.length; i++) {
					self.debug(component, 'Error: ', errors[i].message);
				}
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
	}
})