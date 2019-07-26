/**
 * Created by 7Summits on 4/12/18.
 */
({

    init: function(cmp){
        var store = cmp.get('v.store');

        // set shipping list
        var shippingInfo = store.getShippingInfo();

        // if we are coming from the quick order process we have to
        // map the freight terms backend value to a more user friendly value
        if(shippingInfo.freightTerms === '1A1'){
            shippingInfo.freightTerms = 'Prepaid';
        } else if(shippingInfo.freightTerms === '1A2'){
            shippingInfo.freightTerms = 'Prepaid & Add';
        } else if(shippingInfo.freightTerms === '1A3'){
            shippingInfo.freightTerms = 'Collect';
        }

        console.log('shippingInfo:', JSON.parse(JSON.stringify(shippingInfo)));
        cmp.set('v.shippingInfo', shippingInfo);

        // set order info
        var orderInfo = store.getOrderInfo();
        console.log('orderInfo:', JSON.parse(JSON.stringify(orderInfo)));
        cmp.set('v.orderInfo', orderInfo);

        // set products list
        var products = store.getCartProducts();

        var tempProducts = [];

        for(var x=0; x<products.length; x++){
            if((typeof(products[x].sku) != undefined && products[x].sku != null && products[x].sku != '') &&
                (typeof(products[x].quantity) != undefined && products[x].quantity != null && products[x].quantity != '')){

                tempProducts.push(products[x]);
            }
        }

        console.log('tempProducts:', tempProducts);
        cmp.set('v.products', tempProducts);
    },

    submitOrder: function(cmp){
        var store = cmp.get('v.store');
        var baseHelper = store.getHelper();

        // set spinner icon
        cmp.set('v.isSaving', true);

        // submit the order
        var promise = store.submitOrder();

        // set callbacks for callout response
        promise.then(function(response){
            if(response.success === true && response.messages !== undefined && Array.isArray(response.messages) && response.messages.length > 0){
                baseHelper.doGotoURL('/order-detail?ordernumber=' + response.messages[0]);
            } else {
                console.log('Dal_Dist_Order:submitOrder:response:error', response);
                cmp.set('v.isSaving', false);
                baseHelper.showMessage('Error', 'Unable to Submit Order');
            }
        }, function(response){
            console.log('Dal_Dist_Order:submitOrder:error', response);
            cmp.set('v.isSaving', false);
            baseHelper.showMessage('Error', 'Unable to Submit Order');
        });

    }

})