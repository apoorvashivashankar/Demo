// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
    setDisplayMode : function(component, event, helper) {
        var displayStyle = event.getParam("displayMode");
        helper.debug(component, "Tile display mode = " + displayStyle);

        component.set("v.displayMode", displayStyle);
    },

	handle_VoteUp : function(component, event, helper) {
        var linkCmp = event.currentTarget;
        var ideaId  = linkCmp.dataset.recordid;

        helper.submitVote(component, event, ideaId, "Up");
    },

    handle_VoteDown : function(component, event, helper) {
        var linkCmp = event.currentTarget;
        var ideaId  = linkCmp.dataset.recordid;

        helper.submitVote(component, event, ideaId, "Down");
    },

})