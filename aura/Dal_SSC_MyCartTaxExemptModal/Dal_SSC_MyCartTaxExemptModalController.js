/**
 * Created by ranja on 18-01-2019.
 */
({
     handleCloseModal: function(cmp, evt, helper){
        var myCartResponsePageTwo = cmp.get('v.myCartResponsePageTwo');
        myCartResponsePageTwo.taxExempt = false;
        cmp.set('v.myCartResponsePageTwo', myCartResponsePageTwo);
        cmp.find('overlayLib').notifyClose();
     },

     doInit : function(cmp,event,helper) {
        debugger;

        try {
             cmp.set('v.showSpinner', true);

            var action = cmp.get("c.getTaxExemption");
            action.setCallback(this, function(actionResult) {
                var state = actionResult.getState();
                if (state === 'SUCCESS') {
                    var _resp = actionResult.getReturnValue();
                    console.log('RESPONSE from TaxExemptModal: ', _resp);

                    cmp.set('v.listOfTaxes',_resp);

                    cmp.set('v.showSpinner', false);
                } else {
                    cmp.set('v.showSpinner', false);
                }
            });
            $A.enqueueAction(action);

        } catch(ex) {
            cmp.set('v.showSpinner', false);
        }

     },

     chooseSelectedTax : function(cmp,event,helper) {
         debugger;
        var selectedIndex = event.currentTarget.id;
        var listOfTaxes = cmp.get('v.listOfTaxes');
        var myCartResponsePageTwo = cmp.get('v.myCartResponsePageTwo');

        myCartResponsePageTwo.taxExempt = true;
        myCartResponsePageTwo.jobName = listOfTaxes[selectedIndex].taxExemptionDesc;
        myCartResponsePageTwo.certificateId = listOfTaxes[selectedIndex].taxExemption || '';
        myCartResponsePageTwo.expirationDate = listOfTaxes[selectedIndex].expirationDate || '';
        cmp.set('v.myCartResponsePageTwo', myCartResponsePageTwo);

        if(myCartResponsePageTwo.jobName) {
            cmp.set('v.showJobNameError', false);
            cmp.set('v.isJobNameEmpty', false);
        } else {
            cmp.set('v.isJobNameEmpty', true);
            cmp.set('v.showJobNameError', true);
        }

        cmp.find('overlayLib').notifyClose();
     },

})