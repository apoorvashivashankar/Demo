/**
 * Created by ranja on 08-08-2018.
 */
({

    clearSelectedValue : function (cmp,event,helper) {
        //console.log('IN CLEAR VALUE METHOD');
        //console.log('SELECTED INDEX TO CLEAR: ', event.currentTarget.value);

        var indexSelected = event.currentTarget.value;
        var listOfIdsOfOrderLine = cmp.get('v.listOfIdsOfOrderLine');
        var productOrderLines = cmp.get('v.productOrderLines');
        var productResponse = cmp.get('v.productResponse');

        productOrderLines.splice(indexSelected,1);
        listOfIdsOfOrderLine.splice(indexSelected,1);

        cmp.set('v.productOrderLines',productOrderLines);
        cmp.set('v.listOfIdsOfOrderLine',listOfIdsOfOrderLine);
        helper.updateTheQuantity(cmp,event,helper);
        //console.log('Product Length: ' ,productOrderLines.length );
    },

    updateQuantity : function (cmp,event,helper) {
        var qtySelected = event.getSource().get('v.value');
        var selIndex = event.getSource().get('v.name');

        //console.log('qtySelected: ', qtySelected);
        //console.log('selIndex: ', selIndex);

        var productOrderLines = cmp.get('v.productOrderLines');
        productOrderLines[selIndex].variableQuantity = qtySelected * productOrderLines[selIndex].ExtendedWeight;
        productOrderLines[selIndex].variableQuantity.toFixed(2);
        cmp.set('v.productOrderLines',productOrderLines);

        helper.updateTheQuantity(cmp,event,helper);
    },


})