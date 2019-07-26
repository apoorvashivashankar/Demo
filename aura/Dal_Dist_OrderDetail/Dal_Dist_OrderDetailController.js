/**
 * Created by 7Summits on 3/28/18.
 */
({
    init: function(cmp, evt, helper){
        cmp.set('v.isLoading', true);
        
        // get the order number and make request to get the order data
        var orderNumber = helper.getUrlParamByName('ordernumber');
        var getSubmittedOrder = helper.doCallout(cmp, 'c.getSubmittedOrder', {orderNumber: orderNumber});

        // initialize the store with the order data, this
        // will cause a store refresh, which will cause a
        // page refresh and the data will be there voila!
        getSubmittedOrder.then(function(response){
            helper.initDetailStore(cmp, response);
            cmp.set('v.isLoading', false);
        }, function(response){
            console.log('Dal_Dist_OrderDetail:Init:getSubmitOrder:failed', response);
        });

    }
})