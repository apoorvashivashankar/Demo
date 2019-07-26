// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	doInit : function(component, event, helper) { 
        helper.getCommonSettings(component);
        helper.getZoneId(component);
	},
    
    voteUp : function(component, event, helper) {
        helper.vote(component, true);
    },
    
    voteDown : function(component, event, helper) {
        helper.vote(component, false);
    }
})