/**
 * Created by ranja on 14-01-2019.
 */
({
    handleClose : function(cmp) {
        cmp.find('overlayLib').notifyClose();
    },
    
    doInit : function(cmp,event,helper) {
        
        
        try {
            cmp.set('v.showSpinner', true);
            
            var action = cmp.get("c.getMyCustomerCreditAndSalesRep");
            action.setCallback(this, function(actionResult) {
                let state = actionResult.getState(); 
                if (state === 'SUCCESS') {
                    var _resp = actionResult.getReturnValue();
                    console.log('RESPONSE from Account Hold Modal: ', _resp);
                    if(_resp)
                    	helper.handleMyTeamSuccess(cmp, _resp);
                    
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
    
    
})