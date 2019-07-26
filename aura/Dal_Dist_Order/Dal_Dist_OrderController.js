/**
 * Created by 7Summits on 4/13/18.
 */
({
    init: function(cmp, evt, helper){
        helper.init(cmp);
    },

    handleSubmit: function(cmp, evt, helper){
        helper.submitOrder(cmp);
    },

    handleBack: function(cmp){
        var store = cmp.get('v.store');
        store.previousStep();
    },

    handleBackToSku: function(cmp){
        var store = cmp.get('v.store');
        store.goToStep(1);
    },

    handleRemoveProduct: function(cmp){
        var store = cmp.get('v.store');
        store.removeProductByCartId(0);
    },

    toggleAvailabiltyDetails: function(cmp, evt){
        var store = cmp.get('v.store');
        var cartId = evt.currentTarget.dataset.cartid;
        var products = cmp.get('v.products');
        var showProductSupply = products[cartId].showProductSupply;

        if(showProductSupply === false){
            var promise = store.getProductSupplyData(cartId);
        } else {
            store.setShowProductSupply(cartId, false);
        }
    }

})