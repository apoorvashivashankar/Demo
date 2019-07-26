({
    myAction : function(component, event, helper) {
        
    },
    
    handleCancel : function(cmp,event,helper) {
    
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/my-opportunities'
        });
        urlEvent.fire();
    },
    
    updateRecords : function(cmp,event,helper) {
    //    debugger;
        
        event.preventDefault();
        var record = event.getParams().fields;
        if(cmp.get("v.recordId"))
            record.recordId = cmp.get("v.recordId");
        else
            record.recordId = '';
        
        record.Bid_Date = cmp.find('opp-form-bidDate').get('v.value');
        record.Description = cmp.find('opp-description').get('v.value');
        
        var par = JSON.stringify(record);
        var _params = {
            oppData : par
        };
        
        var action = cmp.get("c.editOpportunity");
        action.setParams(_params);
        console.log('PARAMS: ', _params);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var _resp = response.getReturnValue();
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": '/opportunity/'+_resp
                });
                urlEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
})