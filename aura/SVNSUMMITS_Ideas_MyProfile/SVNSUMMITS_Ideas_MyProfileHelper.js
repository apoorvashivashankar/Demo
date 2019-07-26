// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	getZoneId : function(component) {
        var action = component.get("c.getZoneId");

        action.setParams({
            nameValue: component.get("v.zoneName")
        });

        var self = this;
        action.setCallback(this, function(actionResult) {
            var zoneId = actionResult.getReturnValue();
            component.set("v.zoneid", zoneId);
            
            if (zoneId !== "") {
                self.get_AttributeCount(component);
            }
        });

        $A.enqueueAction(action);
    },
    
    get_AttributeCount : function(component) {
        var action = component.get("c.getIdeasAttributeCount");
        
        action.setParams({
            zoneId: component.get("v.zoneid"),
            type: component.get("v.type"),
            userId: component.get("v.recordId")
        });
        
        action.setCallback(this, function(actionResult) {
            component.set("v.count", actionResult.getReturnValue());            
        });

        $A.enqueueAction(action);
    },

    get_UserId : function(component) {
        var action = component.get("c.getUserId");
        
        action.setCallback(this, function(actionResult) {
            var userId = actionResult.getReturnValue();
            userId = userId.substring(0,15);            
			component.set("v.userId", userId);
            
        });

        $A.enqueueAction(action);
    },

    get_SitePrefix : function(component) {
    	var action = component.get("c.getSitePrefix");

        action.setCallback(this, function(actionResult) {
            var sitePath = actionResult.getReturnValue();
            component.set("v.sitePath", sitePath);
            component.set("v.sitePrefix", sitePath.replace("/s/","/"));
		});

        $A.enqueueAction(action);
    },
    
    toggle_LinkTo : function(component) {
        var recordId = component.get("v.recordId");
        var userId = component.get("v.userId");
        var linkTo = component.find("myIdeasLink").getElement();
        var doNotLink = component.get("v.doNotLink");
        
        if (recordId != userId || doNotLink) {
            linkTo.setAttribute('disabled','true');
         	linkTo.removeAttribute('href');
        } else {
            var sitePath = component.get("v.sitePath");
            var linkToURL = component.get("v.linkToURL");
            var url = sitePath + linkToURL;
            linkTo.removeAttribute('disabled');
            linkTo.setAttribute('href',url);
        }
    },
    
    debug: function(component, msg, variable) {
        var debugMode = component.get("v.debugMode");
        if(debugMode) {
            if (msg) {
            	console.log(msg);
            }
            
            if (variable) {
            	console.log(variable);
            }
        }
    }
})