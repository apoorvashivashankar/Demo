/**
 * Created by francoiskorb on 9/21/17.
 */
({
	doInit : function(component, event, helper) {
		helper.setIsFollowing(component);
	},

	handleFollowClick: function(component, event, helper) {
		if (component.get("v.isFollowing")) {
			helper.unfollow(component);
		} else {
			helper.follow(component);
		}
	}
})