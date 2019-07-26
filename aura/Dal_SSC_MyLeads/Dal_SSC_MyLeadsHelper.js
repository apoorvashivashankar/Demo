/**
 * Created by presh on 20-11-2018.
 */
({
     getIndexFrmParent : function(target,helper,attributeToFind){
        	//User can click on any child element, so traverse till intended parent found
        	var SelIndex = target.getAttribute(attributeToFind);
        	while(!SelIndex){
            	target = target.parentNode ;
           	 	SelIndex = helper.getIndexFrmParent(target,helper,attributeToFind);
        	}
        	return SelIndex;
     },

     getLineStatusOptions: function(cmp){
     //    debugger;
            var self = this;

            var today = new Date();
            var startDate = new Date(new Date().setDate(new Date().getDate() - 30));

            cmp.set('v.leadDateStart', startDate.getFullYear() + "-" + (startDate.getMonth() + 1) + "-" + startDate.getDate());
            cmp.set('v.leadDateEnd', today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate());

            // set the controller action type
            var actionName = 'c.getStatusPickListValues';

            var params = {};
            // make call to controller to get open items
            var promise = self.doCallout(cmp, actionName, params);

            // set callbacks for callout response
            promise.then(function(response){
                console.log('Line Status: ',response);
               //self.handleGetStatusOptions(cmp, response);
               cmp.set('v.lineStatuses', response.Status);
                cmp.set('v.leadSources', response.leadSource);
            });
     },
     /*getPicklistValues : function(component,event,helper){
          var action = component.get("c.getRecordTypeIdForLead");
          //action.setParams({ firstName : cmp.get("v.firstName") });
          action.setCallback(this, function(response) {
              var state = response.getState();
              if (state === "SUCCESS") {
                    component.set('v.recordTypeId', response);
              }
              else if (state === "INCOMPLETE") {

              }
              else if (state === "ERROR") {

              }
          });
          $A.enqueueAction(action);
      },*/
    /* handleGetStatusOptions: function(cmp, response){
           console.log(response);
           cmp.set('v.lineStatuses', response);
     },*/
    /*getLeadSourceOptions : function(cmp){
             var self = this;
             var actionName = 'c.getLeadSourcePickListValues';
             console.log('-------leadsource')
             var params = {};
             // make call to controller to get open items
             var promise = self.doCallout(cmp, actionName, params);

             // set callbacks for callout response
             promise.then(function(response){
                 console.log('LeadSource:----- ',response);
                //self.handleGetStatusOptions(cmp, response);
                cmp.set('v.leadSources', response);
             });
    },
*/
    searchLeads : function(component, event, helper) {
    //    debugger;
    	console.log('In SearchOrders');
           var listComponent = component.find("leadListComponent");

           var firstname = component.get("v.firstName");
           var lastname = component.get("v.lastName");
           var leadSource = component.get("v.leadSource");
           var leadScore = component.get("v.leadScore");
           console.log('dates in search controller before '+component.get("v.leadDateEnd")+'--'+component.get("v.leadDateStart"));

           var leadDateStart = component.get("v.leadDateStart");
           var leadDateEnd = component.get("v.leadDateEnd");
           var leadStatus = component.get("v.leadStatus");
           //console.log('dates in search controller after '+orderDateStart+'--'+orderDateEnd);
            console.log('oleadStatus:'+leadStatus);
            listComponent.searchLeadList(firstname,lastname, leadSource, leadScore, leadDateStart, leadDateEnd, leadStatus);
    }


})