/**
 * Created by ranja on 28-11-2018.
 */
({
     doInit : function(cmp,event,helper) {

        var pageUrl = window.location.href;
        var hashIndex = pageUrl.lastIndexOf('#');
        var recordId = pageUrl.substring(hashIndex+1,pageUrl.length);

        if(recordId) {
            cmp.set('v.recordId',recordId);
        }


        helper.doCallout(cmp,"c.getRecordTypeIdForLead",{}, function(response){
            var state = response.getState();
            if(state === 'SUCCESS') {
                var _resp = response.getReturnValue();
                console.log('RecordType: ', _resp);
                cmp.set('v.recordTypeId',_resp);
            }
        });

     },

     updateRecords : function(cmp,event,helper) {
     //    debugger;

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

     handleCancelFromEdit : function(cmp,event,helper) {

        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": '/lead/'+cmp.get('v.recordId')
        });
        urlEvent.fire();
     },

})