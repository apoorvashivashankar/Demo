/**
 * Created by abdoundure on 4/17/18.
 */
({
    init: function(cmp, evt, helper){
        //cmp.set('v.isLoading', true);

        // get the order number and make request to get the order data
        var orderNumber = helper.getUrlParamByName('ordernumber');
        var getSubmittedOrder = helper.doCallout(cmp, 'c.getSubmittedOrder', {orderNumber: orderNumber});
        console.log(getSubmittedOrder);
        // initialize the store with the order data, this
            // will cause a store refresh, which will cause a
            // page refresh and the data will be there voila!
            getSubmittedOrder.then(function(response){
                helper.initDetailStore(cmp, response);
                cmp.set('v.isLoading', false);
            }, function(response){
                console.log('Dal_SSC_OrderDetail:Init:getSubmitOrder:failed', response);
            });

    }
})