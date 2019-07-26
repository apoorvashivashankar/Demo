/**
 * Created by Yadav on 2/8/2019.
 */
({
    changeSelectedAccount : function (cmp,event,helper) {
        debugger;
        var self = this;
        
        var cartIdValue = cmp.get('v.cartId');
        var id = cmp.get('v.accountId');
        var action = cmp.get("c.deleteCart");
        
        action.setParams({ cartId : cartIdValue });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                console.log('Succesfully Deleted Cart');
                //
                helper.changeSelectedAcc(cmp,event,helper);
                cmp.find('overlayLib').notifyClose();
                
            }else{
                console.log('Failed');
                cmp.find('overlayLib').notifyClose();
            }
        });
        
        $A.enqueueAction(action);
        
    },
    
    changeSelectedAcc : function (cmp,event,helper) {
                // Get the application event by using the
                // e.<namespace>.<event> syntax
                debugger;
                var id = cmp.get('v.accountId');

                var LocationSwitcherCartEvent = $A.get("e.c:Dal_SSC_LocationSwitcherCartEvent");
                LocationSwitcherCartEvent.setParams({
                    "selectedAccountId" : id
                    });
                LocationSwitcherCartEvent.fire();
    },
})