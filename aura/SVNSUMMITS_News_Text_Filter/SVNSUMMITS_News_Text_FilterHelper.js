// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
		setSitePrefix : function(component) {
				var action = component.get("c.getSitePrefix");
				action.setCallback(this, function(actionResult) {
						var sitePath = actionResult.getReturnValue();
						component.set("v.sitePrefix", sitePath.replace("/s",""));
				});
				$A.enqueueAction(action);
		},

		sendFilterEvent : function(component) {
				var searchText = component.get("v.searchText");
				if (searchText === undefined) {
					searchText = '';
				}

		    var appEvent = $A.get("e.c:SVNSUMMITS_News_Text_Filter_Event");
		    appEvent.setParams({
		        "searchText" : searchText
		    });
		    appEvent.fire();
		}
})