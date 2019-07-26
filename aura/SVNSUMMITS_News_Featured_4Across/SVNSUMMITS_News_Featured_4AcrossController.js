// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	doInit : function(component, event, helper) {
		helper.isNicknameDisplayEnabled(component);
		helper.get_SitePrefix(component);
		helper.getFeaturedNews(component);
	}
})