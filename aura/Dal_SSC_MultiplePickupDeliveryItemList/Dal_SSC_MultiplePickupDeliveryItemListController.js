/**
 * Created by ranja on 07-12-2018.
 */
({
    doInit : function(cmp,event,helper) {
    //    debugger;

        var store = cmp.get('v.store');

        var orders = store.getOrders();
        console.log('Store Order: ',orders);
        cmp.set('v.orders',orders);
        cmp.set('v.totalOrders',orders.length);

        console.log('items: ',JSON.stringify(cmp.get('v.items')));
        var store = cmp.get('v.store');
        var orders = store.getOrders();
        cmp.set('v.showSpinner',true);
        var _listOfOrders = [];
        for(var i=0;i<orders.length;i++) {
            _listOfOrders.push(orders[i].orderNumber);
        }

        var action = cmp.get("c.getSkusData");
        action.setParams({
            orderNumber : _listOfOrders
        });

        action.setCallback(this, function(response){

            var state = response.getState();
            if(state === "SUCCESS"){
                console.log('IN METHOD');
                var rtnValue = response.getReturnValue();
                console.log('orderWrapper: ',rtnValue);
                cmp.set('v.orderWrapper',rtnValue);
                var count = 0;
                for(var i=0;i<rtnValue.length;i++) {
                    count = count + rtnValue[i].countOfSkus;
                }
                cmp.set('v.totalSkus',count);
                cmp.set('v.showSpinner',false);
            } else {
                cmp.set('v.showSpinner',false);
                console.log('Failed to retrieve.');
            }
        });
        $A.enqueueAction(action);

    },

     handleToggleMore: function(cmp){
     //   debugger;
        cmp.set('v.showMoreItems', !cmp.get('v.showMoreItems'));

     },

     openProductSkus : function(cmp,event,helper) {
         var selectedIndex = event.currentTarget.name;
         var orderWrapper = cmp.get('v.orderWrapper');

          helper.openModal(cmp, 'c:Dal_SSC_MultiplePickupDeliveryItemModal',
                            {skuData : orderWrapper[selectedIndex].skuswithData, orderNumber : orderWrapper[selectedIndex].orderNumber},
                            true, 'dal-modal_small');

     }

})