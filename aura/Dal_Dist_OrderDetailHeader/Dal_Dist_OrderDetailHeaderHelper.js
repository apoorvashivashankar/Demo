/**
 * Created by 7Summits on 4/17/18.
 */
({
    getOrderInfo: function (cmp, evt, helper) {

        // get the order number and make request to get the order data
        var orderNumber = this.getUrlParamByName('ordernumber');
        console.log(orderNumber);
        cmp.set("v.orderNumber", orderNumber);
        // make call to controller to get order number
        var promise = this.doCallout(cmp,'c.getSubmittedOrder', {orderNumber: orderNumber});
        // set callbacks for callout response
        promise.then(function(response){
            if(response.orderLineList.length > 0) {
                cmp.set("v.showHeader", true);
                if(response.salesOrderTypeDesc === 'Sample')
                    cmp.set('v.selectOrderType','Sample')
            }
        }, function(response){
            console.log('Dal_DistOrderDetailHeader:handleGetOrders:Error:', response);
        });

    },
    getUrlParamByName: function getUrlHashByName(name) {
        var url = window.location.href;
        var regex = new RegExp('[?]' + name + '(=(.+))');
        var results = regex.exec(url);

        // The name was not a query string param
        if (!results) {
            return null;
        }

        // The name was a query string param but didn't have a value
        if (!results[2]) {
            return '';
        }

        // success return the value
        return decodeURIComponent(results[2].replace(/\+/g, ' '));
    },
    cloneOrder: function (cmp, evt, helper){
        var orderNumber = cmp.get("v.orderNumber");
        cmp.set('v.isLoading', true);
        var cloneOrder = helper.doCallout(cmp, 'c.cloneOrder', {orderNumber: orderNumber});
            console.log(cloneOrder);

            cloneOrder.then(function(response){
                cmp.set('v.isLoading', false);
                var quickOrderLink = cmp.get("v.quickOrderLink");
                helper.doGotoURL(quickOrderLink + '?draftId=' + response)

            }, function(response){
                console.log('Dal_Dist_OrderDetailHeader:cloneOrder:failed', response);
            });
        }
    
})