// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	getFeaturedGroups: function (component) {
		var self = this;

		var action = component.get("c.getFeaturedGroups");

		action.setParams({
			recordId1: component.get("v.recordId1"),
			recordId2: component.get("v.recordId2"),
			recordId3: component.get("v.recordId3"),
			recordId4: component.get("v.recordId4"),
			recordId5: component.get("v.recordId5"),
			recordId6: component.get("v.recordId6"),
			recordId7: component.get("v.recordId7"),
			recordId8: component.get("v.recordId8"),
		});

		action.setCallback(this, function (response) {
			var state = response.getState();

			if (component.isValid() && state === "SUCCESS") {
				var groupsListWrapper = response.getReturnValue();

				component.set("v.groupsListWrapper", self.updateListWrapper(component, groupsListWrapper));
			}

		});
		$A.enqueueAction(action);
	},

	updateListWrapper: function(component, groupsListWrapper) {
		for (var i = 0; i < groupsListWrapper.groupsList.length; i++) {
			groupsListWrapper.groupsList[i].strTime = moment(groupsListWrapper.groupsList[i].LastFeedModifiedDate).fromNow();

			// Show Join Button Truth Table
			//              ------- Group -------
			// 	            Private	Public	None
			// isOwner	    No	    No	    No
			// isMember	    Yes	    Yes	    No
			// Not Member	No	    Yes	    No

			var isMember = !!groupsListWrapper.groupMembership[groupsListWrapper.groupsList[i].Id];
			var isOwner  = groupsListWrapper.groupMembership[groupsListWrapper.groupsList[i].Id] === 'Owner';
			var isPublic = groupsListWrapper.groupsList[i].CollaborationType === 'Public';

			groupsListWrapper.groupsList[i].isMember = isMember;
			groupsListWrapper.groupsList[i].showJoinButton = !isOwner && (isPublic || isMember);
		}

		return groupsListWrapper;
	},


	isNicknameDisplayEnabled: function (component) {
		var action = component.get("c.isNicknameDisplayEnabled");

		action.setCallback(this, function (actionResult) {
			component.set("v.isNicknameDisplayEnabled", actionResult.getReturnValue());
		});
		$A.enqueueAction(action);
	},

	initializeSlider: function (component) {
		var recordIds = [];

		// inserting group records in respective order
		if (component.get("v.recordId1").length > 0) {
			recordIds.push(component.get("v.recordId1"));
		}
		if (component.get("v.recordId2").length > 0) {
			recordIds.push(component.get("v.recordId2"));
		}
		if (component.get("v.recordId3").length > 0) {
			recordIds.push(component.get("v.recordId3"));
		}
		if (component.get("v.recordId4").length > 0) {
			recordIds.push(component.get("v.recordId4"));
		}
		if (component.get("v.recordId5").length > 0) {
			recordIds.push(component.get("v.recordId5"));
		}
		if (component.get("v.recordId6").length > 0) {
			recordIds.push(component.get("v.recordId6"));
		}
		if (component.get("v.recordId7").length > 0) {
			recordIds.push(component.get("v.recordId7"));
		}
		if (component.get("v.recordId8").length > 0) {
			recordIds.push(component.get("v.recordId8"));
		}

		var itemNum = recordIds.length;

		if (recordIds.length === 3) {
			itemNum = 2;
		} else if (recordIds.length >= 4) {
			itemNum = 3;
		}

		// method called for slider component to display all records in featured groups
		window.setTimeout(
			$A.getCallback(function () {
				$('#responsive').lightSlider({
					item: itemNum,
					loop: false,
					slideMove: 2,
					easing: 'cubic-bezier(0.25, 0, 0.25, 1)',
					speed: 600,
					responsive: [
						{
							breakpoint: 800,
							settings: {
								item: 3,
								slideMove: 1,
							}
						},
						{
							breakpoint: 600,
							settings: {
								item: 2,
								slideMove: 1
							}
						},
						{
							breakpoint: 480,
							settings: {
								item: 1,
								slideMove: 1
							}
						}
					]
				});

			}), 1000
		);


	},

	debug: function (component, msg, variable) {
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