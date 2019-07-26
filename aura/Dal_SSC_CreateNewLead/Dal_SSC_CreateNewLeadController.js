/**
 * Created by ranja on 21-11-2018.
 */
({
    doInit : function(cmp,event,helper) {

        helper.doCallout(cmp,"c.getRecordTypeIdForLead",{}, function(response){
            var state = response.getState();
            if(state === 'SUCCESS') {
                var _resp = response.getReturnValue();
                console.log('RecordType: ', _resp);
                cmp.set('v.recordTypeId',_resp);
            }
        });

    },

    handleLeadEditEvent : function(cmp,event,helper) {
        cmp.set('v.isOutput',true);
        cmp.set('v.isEdit',true);
    },

    handleCancel : function(cmp,event,helper) {
        cmp.set('v.isEdit',false);
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": '/my-leads'
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
        cmp.set('v.showSpinner',true);

        if(cmp.get("v.recordId"))
            record.recordId = cmp.get("v.recordId");
        else
            record.recordId = '';

         record.Job_Title = cmp.find('jobTitle').get('v.value');
         record.Disqual_Reason = cmp.find('disqualReason').get('v.value');
         record.Lead_Score = cmp.find('leadScore').get('v.value');
         var par = JSON.stringify(record);
         var _params = {
             leadValue : par
         };

        var action = cmp.get("c.createLead");
         action.setParams(_params);
         console.log('PARAMS: ', _params);
         action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var _resp = response.getReturnValue();
                cmp.set('v.showSpinner',false);
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                  "recordId": _resp,
                  "slideDevName": "detail"
                });
                navEvt.fire();

            } else {
                cmp.set('v.showSpinner',false);
            }
         });
         $A.enqueueAction(action);
   },


})