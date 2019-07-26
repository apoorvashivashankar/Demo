/**
 * Created by 7Summits on 4/12/18.
 */
({

    init: function(cmp){
    debugger;
        var store = cmp.get('v.store');

        // set shipping list
        var shippingInfo = store.getShippingInfo();
        //console.log('shippingInfo:', JSON.parse(JSON.stringify(shippingInfo)));
        cmp.set('v.shippingInfo', shippingInfo);

        // set order info
        var orderInfo = store.getOrderInfo();
        console.log('orderInfo:', JSON.parse(JSON.stringify(orderInfo)));
        cmp.set('v.orderInfo', orderInfo);
        
        if(orderInfo && orderInfo.BDC.includes('BDC')){
            cmp.set('v.isSSC', false);
        }


        // set products list
        var products = store.getCartProducts();

        // format needed values
        for(var x=0; x<products.length; x++){

            // format shipped date
            if(products[x].shippedDate !== undefined){
                //var parsedDateTime = $A.localizationService.parseDateTime(products[x].shippedDate, 'yyyy-M-d');h:mm a
                products[x].shippedDate = $A.localizationService.formatDate(products[x].shippedDate, 'MM/dd/YYYY');
            }

            // format fulfillmentScheduleTime date
            if(products[x].fulfillmentScheduleTime !== undefined){
                if(products[x].fulfillmentMethod === 'SHP'){
                    products[x].fulfillmentScheduleTime = $A.localizationService.formatDate(products[x].fulfillmentScheduleTime, 'MM/dd/YYYY');
                } else {
                    //products[x].fulfillmentScheduleTime = $A.localizationService.formatDate(products[x].fulfillmentScheduleTime, 'MM/dd/YYYY h:mm a');
                }


            }

            // format contact phone
            if(products[x].fulfillmentContactPhone !== undefined){

            }

        }

        console.log('products:', products);
        cmp.set('v.products', products);
    }

})