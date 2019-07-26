// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
    doInit: function (component, event, helper) {
        helper.getAuthors(component);
    },

    selectAuthor: function (component, event, helper) {
	    helper.sendFilterEvent(component);
    }
})