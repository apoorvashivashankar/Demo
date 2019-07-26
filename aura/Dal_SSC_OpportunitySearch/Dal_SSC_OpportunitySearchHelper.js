/**
 * Created by presh on 22-11-2018.
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
            var self = this;

            var today = new Date();
            var startDate = new Date(new Date().setDate(new Date().getDate() - 30));

            cmp.set('v.oppDateStart', startDate.getFullYear() + "-" + (startDate.getMonth() + 1) + "-" + startDate.getDate());
            cmp.set('v.oppDateEnd', today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate());

            // set the controller action type
            var actionName = 'c.getStatusPickListValues';

            var params = {};
            // make call to controller to get open items
            var promise = self.doCallout(cmp, actionName, params);

            // set callbacks for callout response
            promise.then(function(response){
                console.log('Opp Stages: ',response);
               self.handleGetStatusOptions(cmp, response);
            });
     },
         handleGetStatusOptions: function(cmp, response){
                console.log(response);
               cmp.set('v.oppStages', response);

         },

        searchOpportunity : function(component, event, helper) {
        //    debugger;
        	console.log('In SearchOpportunity');
               var listComponent = component.find("oppListComponent");

               var name = component.get("v.name");
               var account = component.get("v.account");
               console.log('dates in search controller before '+component.get("v.oppDateEnd")+'--'+component.get("v.oppDateStart"));
               var oppDateStart = component.get("v.oppDateStart");
               var oppDateEnd = component.get("v.oppDateEnd");
               var oppStage = component.get("v.oppStage");
               //console.log('dates in search controller after '+orderDateStart+'--'+orderDateEnd);
                console.log('oppStage:'+oppStage);
                listComponent.searchOpportunityList(name, account, oppDateStart, oppDateEnd, oppStage);
        }


})