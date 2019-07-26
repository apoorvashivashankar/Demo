/**
 * Created by francoiskorb on 9/21/17.
 */
({
	follow: function (component) {
		var action = component.get("c.followRecord");

		action.setParams({
			recordId: component.get("v.recordId")
		});

		action.setCallback(this, function (actionResult) {
			if (actionResult.getReturnValue()) {
				component.set("v.isFollowing", true);
			}
		});

		$A.enqueueAction(action);
	},

	unfollow: function (component) {
		var action = component.get("c.unfollowRecord");

		action.setParams({
			recordId: component.get("v.recordId")
		});

		action.setCallback(this, function (actionResult) {
			if (actionResult.getReturnValue()) {
				component.set("v.isFollowing", false);
			}
		});

		$A.enqueueAction(action);
	},

	setIsFollowing: function (component) {
		var action = component.get("c.isFollowing");

		action.setParams({
			recordId: component.get("v.recordId")
		});

		action.setCallback(this, function (actionResult) {
			component.set("v.isFollowing", action.getReturnValue());
		});

		$A.enqueueAction(action);
	}
})