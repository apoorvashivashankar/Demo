// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
    isNicknameDisplayEnabled : function(component) {
        var action = component.get("c.isNicknameDisplayEnabled");
        
        var self = this;
        action.setCallback(this, function(actionResult) {
            component.set("v.isNicknameDisplayEnabled", actionResult.getReturnValue());            
        });
        $A.enqueueAction(action);
    },
    
    get_SitePrefix : function(component) {
    	var action = component.get("c.getSitePrefix");
        var self = this;
        action.setCallback(this, function(actionResult) {
            var sitePath = actionResult.getReturnValue();
            component.set("v.sitePath", sitePath);
            component.set("v.sitePrefix", sitePath.replace("/s/","/"));
		});
        $A.enqueueAction(action);    
    },
    
    getZoneId : function(component) {
        var action = component.get("c.getZoneId");

        action.setParams({
            nameValue: component.get("v.zoneName")
        });

        var self = this;
        action.setCallback(this, function(actionResult) {
            var zoneId = actionResult.getReturnValue();
            component.set("v.zoneId", zoneId);
            
            if(zoneId != "")
            {
                self.isValidIdeaId(component);
            }

        });
        $A.enqueueAction(action);
    },
    
    isValidIdeaId : function(component) {
        var action = component.get("c.isValidIdeaId");
        action.setParams({
            ideaId : component.get("v.recordId"),
            zoneId : component.get("v.zoneId")
        });
        var self = this;
        action.setCallback(this, function(actionResult) {
            component.set("v.isValidIdeaId", actionResult.getReturnValue());            
        });
        $A.enqueueAction(action);
    },
    
    getTotalVoterCount : function(component) {
        var action = component.get("c.getTotalVoterCount");
        action.setParams({
            recordId: component.get("v.recordId")
        });
        
        var self = this;
        action.setCallback(this, function(actionResult) {
            component.set("v.totalVoterCount", actionResult.getReturnValue());            
        });
        $A.enqueueAction(action);
    },
    
    getIdeaVoters : function(component) {
        var action = component.get("c.getIdeaVoters");
        action.setParams({
            recordId: component.get("v.recordId"),
            numResults: component.get("v.numResults")
        });
        
        var self = this;
        action.setCallback(this, function(actionResult) {
            component.set("v.voters", actionResult.getReturnValue()); 
        });
        $A.enqueueAction(action);
    },
    
    debug: function(component, msg, variable) {
        
        var debugMode = component.get("v.debugMode");
        
        if(debugMode)
        {
            if(msg)
            {
            	console.log(msg);
            }
            
            if(variable)
            {
            	console.log(variable);
            }
        }
        
    }
})