/**
 * Created by ranja on 21-11-2018.
 */
({
    doInit : function(cmp,event,helper) {

        helper.doCallout(cmp,"c.getRecordTypeIdForLead",{}, function(response){
            var state = response.getState();
            if(state === 'SUCCESS') {
                var _resp = response.getReturnValue();
                cmp.set('v.recordTypeId',_resp);
            }
        });

    },

    handleOnLoad : function(cmp,event,helper) {
        var inputLeadName = cmp.find('inputLeadName').get('v.value');
        var appEvent = $A.get("e.c:Dal_SSC_LeadManagement_BreadCrumbEvent");
        appEvent.setParams({ "pageName" : JSON.stringify(inputLeadName) });
        appEvent.fire();
    },

    handleEditClick : function(cmp,event,helper) {
        //cmp.set('v.isOutput',false);

        var recordId = cmp.get('v.recordId');


        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": '/editlead#'+recordId
        });
        urlEvent.fire();

        /*
        var newLead = $A.get("e.c:Dal_SSC_CreateNewLeadEvent");
        newLead.setParam({'isEdit' : true});
        newLead.fire();
        */
    },

    convertToOpportunity : function(cmp,event,helper) {
     //  debugger;

       var recordId = cmp.get('v.recordId');
       var companyName = cmp.find("companyValue").get("v.value");
       var oppName = companyName+'-';
       var providedName = JSON.parse(JSON.stringify(cmp.find('leadNameInput').get('v.value')));
       var fullName = providedName.FirstName + ' ' + providedName.LastName;
       var statusOfLead = cmp.find('inputStatus').get('v.value');
       var scoreOfLead = cmp.find('inputLeadScore').get('v.value');

       helper.doCallout(cmp, 'c.fetchLeadOwner', {leadId : recordId}, function(response){
           var state = response.getState();
           if(state === "SUCCESS"){
               var _resp = response.getReturnValue();
               console.log('RESP: ', _resp);
               helper.openModal(cmp, 'c:Dal_SSC_ConvertLeadToOpportunity', {recordId : recordId, selectedOwnerName : _resp.Name,
                                selectedOwner : _resp.Id, newAccountName : companyName, newContactName: fullName,selectedScoreOfLead :scoreOfLead,
                                recordTypeId : cmp.get('v.recordTypeId'), opportunityName : oppName, selectedStatusOfLead : statusOfLead },
                                true, 'dal-modal_medium');
           }
        });
    },

})