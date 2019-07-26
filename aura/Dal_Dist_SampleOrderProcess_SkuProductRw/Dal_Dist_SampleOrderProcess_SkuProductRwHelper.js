/**
 * Created by ranja on 16-08-2018.
 */
({
    updateTheQuantity : function (cmp,event,helper) {

        var productOrderLines = cmp.get('v.productOrderLines');
        var cumulativeOrderWeight = 0.00;
        //console.log('productOrderLines Helper: ', productOrderLines);

        if (productOrderLines) {
            for (var i=0;i<productOrderLines.length; i++) {
                cumulativeOrderWeight = (parseFloat(cumulativeOrderWeight) +
                (parseFloat(productOrderLines[i].ExtendedWeight) * parseFloat(productOrderLines[i].selectedQuantity)));
            }
        }
        //console.log('cumulativeOrderWeight: ' , cumulativeOrderWeight);
        cmp.set('v.cumulativeOrderWeight',cumulativeOrderWeight.toFixed(2));

    },
})