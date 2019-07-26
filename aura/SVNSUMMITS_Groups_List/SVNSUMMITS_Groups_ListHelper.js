// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	getGroups: function (component, event) {
		var self = this;
		this.showSpinner(component);

		this.debug(component, 'getGroup');
		this.debug(component, "===== sort by ", component.get("v.sortBy"));
		this.debug(component, "===== my group", component.get("v.searchMyGroups"));
		this.debug(component, "===== search  ", component.get("v.searchString"));

		var action = component.get("c.getGroups");

		action.setParams({
			numberOfGroups: component.get("v.numberOfGroups"),
			sortBy:         component.get("v.sortBy"),
			searchMyGroups: component.get("v.searchMyGroups"),
			searchString:   component.get("v.searchString"),
		});

		action.setCallback(this, function (response) {
			self.hideSpinner(component);

			var state = response.getState();

			if (state === "SUCCESS") {
				var groupsListWrapper = response.getReturnValue();

				if (!!groupsListWrapper.errorMsg) {
					component.set("v.strError", 'Unexpected Error, Please contact your Administrator.');
				}

				var appEvent = $A.get("e.c:SVNSUMMITS_Groups_Header_Event");

				appEvent.setParams({
					"totalResults": groupsListWrapper.totalResults,
				});

				appEvent.fire();

				self.debug(component, '==== List total: ', groupsListWrapper.totalResults);
				component.set("v.groupsListWrapper", self.updateListWrapper(component, groupsListWrapper));
			}
		});

		$A.enqueueAction(action);
	},

	updateListWrapper: function(component, groupsListWrapper) {
		for (var i = 0; i < groupsListWrapper.groupsList.length; i++) {
			groupsListWrapper.groupsList[i].strTime = moment(groupsListWrapper.groupsList[i].LastFeedModifiedDate).fromNow();

			// Join Button Truth Table
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

	getNextPage: function (component) {
		this.debug(component, "Next page...");
		var self = this;
		this.showSpinner(component);

		var action = component.get("c.nextPage");

		action.setParams({
			numberOfGroups: component.get("v.numberOfGroups"),
			pageNumber:     component.get("v.groupsListWrapper").pageNumber,
			sortBy:         component.get("v.sortBy"),
			searchMyGroups: component.get("v.searchMyGroups"),
			searchString:   component.get("v.searchString"),
		});

		action.setCallback(this, function (actionResult) {
			self.hideSpinner(component);
			var state = actionResult.getState();

			if (state === "SUCCESS") {
				var groupsListWrapper = actionResult.getReturnValue();
				component.set("v.groupsListWrapper", self.updateListWrapper(component, groupsListWrapper));
			}
		});

		$A.enqueueAction(action);
	},

	getPreviousPage: function (component) {
		this.debug(component, "Previous page...");
		var self = this;
		this.showSpinner(component);

		var action = component.get("c.previousPage");

		action.setParams({
			numberOfGroups: component.get("v.numberOfGroups"),
			pageNumber:     component.get("v.groupsListWrapper").pageNumber,
			sortBy:         component.get("v.sortBy"),
			searchMyGroups: component.get("v.searchMyGroups"),
			searchString:   component.get("v.searchString"),
		});

		action.setCallback(this, function (actionResult) {
			self.hideSpinner(component);
			var state = actionResult.getState();

			if (state === "SUCCESS") {
				var groupsListWrapper = actionResult.getReturnValue();
				component.set("v.groupsListWrapper", self.updateListWrapper(component, groupsListWrapper));
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

	showSpinner: function (component) {
		this.debug(component, 'Spinner on...');
		$A.util.removeClass(component.find('listSpinner'), 'slds-hide');
	},

	hideSpinner: function (component) {
		this.debug(component, 'Spinner off...');
		$A.util.addClass(component.find('listSpinner'), 'slds-hide');
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