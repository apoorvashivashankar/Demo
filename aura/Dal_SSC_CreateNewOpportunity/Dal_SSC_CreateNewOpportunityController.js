/**
 * Created by ranja on 21-11-2018.
 */
({

    handleLeadEditEvent : function(cmp,event,helper) {
        cmp.set('v.isOutput',true);
        cmp.set('v.isEdit',true);


    },

    handleCancel : function(cmp,event,helper) {
        cmp.set('v.isEdit',false);
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": '/my-opportunity'
        });
        urlEvent.fire();
    },

   handleCancelFromEdit : function(cmp,event,helper) {
        cmp.set('v.isEdit',false);


        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
          "recordId": cmp.get('v.recordId'),
          "slideDevName": "detail"
        });
        navEvt.fire();
   },

   updateRecords : function(cmp,event,helper) {
   //     debugger;

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