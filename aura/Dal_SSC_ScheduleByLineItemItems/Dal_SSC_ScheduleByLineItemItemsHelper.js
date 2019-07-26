/**
 * Created by 7Summits on 5/14/18.
 */
({

    handleStoreUpdate: function(cmp){
        var currentOrder = cmp.get('v.currentOrder');
        var skus = currentOrder.skus;

        // check how many skus are selected
        var skusSelected = 0;

        if(skus) {


        skus.forEach(function(sku){
            skus.isError = false;
            sku.originalQuantity = sku.quantity;
            if(sku.selected === true){
                skusSelected++;
            }
        });

        }
        cmp.set('v.skus', skus);
        cmp.set('v.skusSelected', skusSelected);
    }

})