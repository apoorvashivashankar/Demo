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

        helper.doCallout(cmp,"c.getRecordTypeIdForOpportunity",{}, function(response){
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

         cmp.set('v.showSpinner',true);
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
                 cmp.set('v.showSpinner',false);
                 var urlEvent = $A.get("e.force:navigateToURL");
                 urlEvent.setParams({
                   "url": '/opportunity/'+_resp
                 });
                 urlEvent.fire();
             } else {
                 cmp.set('v.showSpinner',false);
             }
          });
          $A.enqueueAction(action);
     },

     handleCancelFromEdit : function(cmp,event,helper) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
          "recordId": cmp.get('v.recordId'),
          "slideDevName": "detail"
        });
        navEvt.fire();
     },

     handleStageChange : function(cmp,event,helper) {
     //   debugger;
        var stageNameInput = cmp.find('stageNameInput').get('v.value');

        if(stageNameInput==='2 - Specification')
            cmp.find('probability-input').set('v.value','25');

     }

})