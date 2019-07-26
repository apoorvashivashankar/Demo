// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
    doInit : function(component, event, helper) { 
        var url = encodeURIComponent(window.location.href);
        component.set("v.currentURL",url);
        helper.get_SitePrefix(component);
        helper.getZoneId(component);
    },
})