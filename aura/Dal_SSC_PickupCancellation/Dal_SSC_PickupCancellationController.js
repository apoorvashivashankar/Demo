/**
 * Created by ranja on 06-12-2018.
 */
({
    handleClose : function(cmp,event,helper) {
        cmp.find('overlayLib').notifyClose();
    },

     handleCancel : function(cmp,event,helper) {
        debugger;

        var orderNumberThis = cmp.get('v.orderNumber');
        var indexToCancel = cmp.get('v.indexToCancel');

        var action = cmp.get("c.removeOrderLine");
        action.setParams({
            orderNumber : orderNumberThis,
            orderLineNumber : indexToCancel
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('Response: ', response.getReturnValue());
                var _url = '';
                if(!(indexToCancel.toUpperCase() === 'ALL'))
                    _url = '/order-detail?ordernumber='+ orderNumberThis
                else
                    _url = '/my-orders';

                //Navigate
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                  "url": _url
                });
                urlEvent.fire();

            }
        });
        $A.enqueueAction(action);
    },

})