// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	toggleMembership : function (component) {
		var userId   = component.get('v.wrapperGroupsObj.currentUserId')
		var group    = component.get('v.group');
		var isMember = group.isMember;
		var action   = isMember ? component.get('c.leaveGroup') : component.get('c.joinGroup');

		action.setParams({
			'groupId': group.Id,
			'userId': userId
		});

		action.setCallback(this, function (actionResult) {
			var state = actionResult.getState();

			if (state === "SUCCESS") {
				$A.get('e.c:SVNSUMMITS_Groups_Load_Event').fire();
			}
		});

		$A.enqueueAction(action);
	}

})