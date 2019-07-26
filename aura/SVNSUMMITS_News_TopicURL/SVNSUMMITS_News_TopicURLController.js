// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	doInit : function(component) {

    	var action = component.get("c.getSitePrefix");
        action.setCallback(this, function(actionResult) {
            var sitePath = actionResult.getReturnValue();
            component.set("v.sitePath", sitePath);

            var topicNameToIdMap = component.get("v.topicNameToId");
            var topicName = component.get("v.topicName");
            var linkCmp = component.find("topicLink");
            var topicId = topicNameToIdMap[topicName];

            if(topicName && topicId)
            {
                linkCmp.set("v.label",topicName);
                linkCmp.set("v.value", sitePath+"/topic/"+topicId+"/"+encodeURIComponent(topicName));
            }
            else if(topicName && !topicId)
            {
                linkCmp.set("v.label",topicName);
                linkCmp.set("v.value", "#");
            }

		});
        $A.enqueueAction(action);
	}
})