/**
 * Created by 7Summits on 4/20/18.
 */
({
    
    handleViewShade: function(cmp, evt, helper){
        var store = cmp.get('v.store');
        var cartId = cmp.get('v.cartId');
        var sku = cmp.get('v.sku');
        var sourceOfSupplySelectedName = cmp.get('v.sourceOfSupplySelectedName');

        // get the base component helper
        var baseHelper = store.getHelper();

        // required params viewShadeModal needs
        var params = {
            store: store,
            cartId: cartId,
            sku: sku,
            sourceOfSupplySelectedName: sourceOfSupplySelectedName
        };

        baseHelper.openModal(cmp, 'c:Dal_ViewShadeModal', params, true, '');
    }

})