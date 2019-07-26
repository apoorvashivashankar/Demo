// Copyright © 2016-2018 7Summits, Inc. All rights reserved.
({
	doInit : function(component, event, helper){
        component.set('v.pageTitle', document.title);
        component.set('v.pageURL', window.location);
	},
    
    doPopup : function(component, event, helper){
    	helper.launchPopup(component.get('v.titletext'), event.currentTarget.dataset.href);
	}
})