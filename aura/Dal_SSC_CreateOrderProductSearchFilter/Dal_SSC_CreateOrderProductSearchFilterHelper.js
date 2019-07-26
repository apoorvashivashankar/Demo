/**
 * Created by ranja on 14-01-2019.
 */
({
    getVendorsResultHelper : function(cmp,event,helper) {
        var createOrderWrapper = cmp.get('v.createOrderWrapper');
        var _params = [];
        var _vendors = [];
        var selectedVendor = '';
        var selVendor = createOrderWrapper.selectedVendor;
        var skuKeyword = createOrderWrapper.skuKeyword;

        if(selVendor) {
            if(selVendor.toUpperCase() === 'ALL') {
                selectedVendor = '';


            } else {
                selectedVendor = selVendor;
            }

            if(!skuKeyword)
                skuKeyword = '';

            var _params = {
                searchParameter : skuKeyword,
                vendor : selectedVendor
            };

        } else if(skuKeyword) {

            var _params = {
               searchParameter : skuKeyword,
               vendor : ''
            };
        }

        helper.getListOfVendorProducts(cmp,event,helper,_params);

    },
})