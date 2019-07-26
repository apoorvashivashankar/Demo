/**
 * Created by 7Summits on 4/11/18.
 */

({
    getShadeDetails : function(cmp){
        var store = cmp.get('v.store');
        var cartId = cmp.get('v.cartId');
        var getProductShadeData = store.getProductShadeData(cartId);

        getProductShadeData.then(function(response){
            console.log('Successfully got shade data:', response);
            cmp.set('v.shadeDetails', response);

        }, function(response){
            // TODO handle fail
            console.log('Failed to get shade data:', response);
        });
    }

})