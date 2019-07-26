/**
 * Created by ranja on 23-08-2018.
 */
({
    init: function(cmp,event,helper){
        //var store = cmp.get('v.store');
        helper.initLoadData(cmp);
    },

    handleSubmit: function(cmp, evt, helper){
        //console.log('handleSubmit clicked');
        helper.submitOrder(cmp,evt,helper);
    },

    handleBack: function(cmp,event,helper){
        var currentPosition = cmp.get('v.currentPosition');
        currentPosition--;
        //console.log('currentPosition: ',currentPosition);
        cmp.set('v.currentPosition',currentPosition );
        helper.fireAnEvent(cmp,currentPosition);

    },

    handleBackToSku: function(cmp,event,helper){
        var currentPosition = cmp.get('v.currentPosition');
        currentPosition = 1;
        cmp.set('v.currentPosition',currentPosition );
        helper.fireAnEvent(cmp,currentPosition);
    },

    handleRemoveProduct: function(cmp,event,helper){
        var listOfIdsOfOrderLine = cmp.get('v.listOfIdsOfOrderLine');
        var products = cmp.get('v.products');
        var productOrderLines = cmp.get('v.productOrderLines');
        var indexSelected = event.target.id;
        var cumulativeOrderWeight = cmp.get('v.cumulativeOrderWeight');

        if(productOrderLines[indexSelected]) {

            cumulativeOrderWeight = cumulativeOrderWeight -
                    (productOrderLines[indexSelected].ExtendedWeight  * productOrderLines[indexSelected].selectedQuantity);
            productOrderLines.splice(indexSelected,1);
            listOfIdsOfOrderLine.splice(indexSelected,1);
        }
        cmp.set('v.listOfIdsOfOrderLine',listOfIdsOfOrderLine);
        cmp.set('v.cumulativeOrderWeight',cumulativeOrderWeight.toFixed(2));
        cmp.set('v.productOrderLines',productOrderLines);
        helper.checkWeight(cmp);
        helper.initLoadData(cmp);
    },

    handleLineItemDetailChange : function (cmp,event,helper) {
        var showLineDetail = cmp.get('v.showLineDetail');
        if(showLineDetail==true) {
            cmp.set('v.showLineDetail' , false);
        } else {
            cmp.set('v.showLineDetail' , true);
        }
    }

})