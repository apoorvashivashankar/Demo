// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
    doInit : function(component, event, helper) {      
        helper.getZoneId(component);
        helper.get_UserId(component);
        helper.get_SitePrefix(component);
    }
})