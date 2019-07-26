// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	doInit : function(component, event, helper) {
		var topicNameToIdMap = component.get("v.topicNameToId");
        helper.debug(component,"topicNameToIdMap",topicNameToIdMap);

        var topicName = component.get("v.topicName");
        helper.debug(component,"topicName",topicName);

        var sitePath = component.get("v.sitePath");
        helper.debug(component,"sitePath",sitePath);

        var linkCmp = component.find("topicLink");
        
        var topicId = topicNameToIdMap[topicName];
        helper.debug(component,"topicId",topicId);
        
        if (topicName && topicId) {
        	linkCmp.set("v.label",topicName);
        	linkCmp.set("v.value", sitePath+"/topic/"+topicId+"/"+topicName);
        }
        else if (topicName && !topicId) {
            linkCmp.set("v.label",topicName);
        	linkCmp.set("v.value", "#");
        }
	}
})