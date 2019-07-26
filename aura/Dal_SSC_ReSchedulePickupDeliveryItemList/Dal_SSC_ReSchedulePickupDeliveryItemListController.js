/**
 * Created by ranja on 06-12-2018.
 */
({
    doInit : function(cmp,event,helper) {
        debugger;

        console.log('items: ',JSON.stringify(cmp.get('v.itemList')));
        console.log('orderNumber: ', cmp.get('v.orderNumber'));

        try {

        var pageUrl = window.location.href;
        var hashIndex = pageUrl.lastIndexOf('#');
        var selectedProductType = pageUrl.substring(hashIndex+1,pageUrl.length);
        var selectedIndex = 0;
        var query = pageUrl.substring(pageUrl.lastIndexOf('?')+1,hashIndex);
        var vars = query.split("&");
        cmp.set('v.showSpinner',true);
        for (var i=0;i<vars.length;i++) {
           var pair = vars[i].split("=");
           if(pair[0] == 'sku'){
               console.log('sku by met: ',pair[1] );
               selectedIndex = pair[1];
           }
        }
        cmp.set('v.selectedIndex',selectedIndex);

        var _param = selectedIndex.split('%2C');
        console.log('_param sku ',_param);
        var store = cmp.get('v.store');
        var orders = store.getOrders();
        var orderNumber = orders[0].orderNumber;
        console.log('selectedIndex: ',selectedIndex);
        console.log('store: ',JSON.stringify(store));
        cmp.set('v.showSpinner',true);
        cmp.set('v.totalOrders',orders.length);


        var action = cmp.get("c.getSkusReScheduleData");
        var _ordersList = [];
        _ordersList.push(orderNumber);
        action.setParams({
            orderNumber : _ordersList
        });

        action.setCallback(this, function(response){

            var state = response.getState();
            if(state === "SUCCESS"){
                var rtnValue = response.getReturnValue();
                console.log('orderWrapper Back resp: ',rtnValue);
                var _params = [];
                var count = 0;
                for(var j=0;j<_param.length;j++) {
                    for(var i=0;i<rtnValue[0].skuswithData.length;i++) {
                        console.log('i',i); 
                        console.log('parseInt(_param[j]): ',parseInt(_param[j]));
                        
                        if((i) === parseInt(_param[j])) {
                            _params.push(rtnValue[0].skuswithData[i]);
                            count = count + 1;
                            console.log('_params: ', _params);
                        }
                    }
                }
                
                
                cmp.set('v.skuNumber',count);
                cmp.set('v.orderWrapper',_params);
                cmp.set('v.orderNumber',rtnValue[0].OrderNumber);
                cmp.set('v.showSpinner',false);
                console.log('Details: ',rtnValue[0].skuswithData[selectedIndex]);

                cmp.set('v.showSpinner',false);
            } else {
                cmp.set('v.showSpinner',false);
                console.log('Failed to retrieve.');
            }
        });
        $A.enqueueAction(action);

        } catch(Ex) {
            console.log('Failed-Dal_SSC_ReSchedulePickupDeliveryItemList:init')
        }
    },

     handleToggleMore: function(cmp){
        debugger;
        cmp.set('v.showMoreItems', !cmp.get('v.showMoreItems'));

     }
})