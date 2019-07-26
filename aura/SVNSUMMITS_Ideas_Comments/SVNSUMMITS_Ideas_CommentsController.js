// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	doInit: function (component, event, helper) {
		helper.isNicknameDisplayEnabled(component);
		helper.getZoneId(component);
		helper.getSitePrefix(component);
	},

	addNewIdeaComment: function (component, event, helper) {
		var commentValue = component.get('v.newComment');

		if (!commentValue || commentValue.trim() === "") {
			component.set('v.validity', false);
		} else {
			helper.addComment(component);
		}
	},

	likeComment: function (component, event, helper) {
		var linkCmp = event.currentTarget;
		var ideaCommentId = linkCmp.dataset.recordid;

		helper.likeComment(component, ideaCommentId);
	},

	unlikeComment: function (component, event, helper) {
		var linkCmp = event.currentTarget;
		var ideaCommentVoteId = linkCmp.dataset.recordid;

		helper.unlikeComment(component, ideaCommentVoteId);
	},


})