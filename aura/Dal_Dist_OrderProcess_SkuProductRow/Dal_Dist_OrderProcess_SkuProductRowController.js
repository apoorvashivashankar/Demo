/**
 * Created by 7Summits on 3/9/18.
 */
({

    /**
     * Shared handler for all row input fields
     */
    handleInputChange: function(cmp, evt, helper){
        var timer = cmp.get('v.searchDebounce');
        clearTimeout(timer);
        //var _prodName = cmp.get("v.productName");
        //if(_prodName){
            timer = setTimeout($A.getCallback(function () {
                helper.handleChange(cmp);
            }), 1000);
        //}
        cmp.set('v.searchDebounce', timer);
    },

    handlePriceRecordChange: function(cmp, evt, helper){
        var selectedValue = cmp.get('v.inputValuePriceRecordSelected');
        var priceRecords = cmp.get('v.priceRecord');
        helper.setSelectBox(selectedValue, priceRecords);
        helper.handleChange(cmp);
    },

    handleUnitOfMeasureChange: function(cmp, evt, helper){
        var selectedValue = cmp.get('v.inputValueUnitOfMeasureSelected');
        var unitOfMeasure = cmp.get('v.unitOfMeasure');
        helper.setSelectBox(selectedValue, unitOfMeasure);
        helper.handleChange(cmp);
    },

    handleSourceOfSupplyChange: function(cmp, evt, helper){
        var selectedValue = cmp.get('v.inputValueSourceOfSupplySelected');
        var sourceOfSupply = cmp.get('v.sourceOfSupply');
        helper.handleSourceOfSupplyChange(cmp);
    },

    handleShipDateChange: function(cmp, evt, helper){
        helper.handleShipDateChange(cmp);
    },

    handleSkuInputChange: function(cmp, evt, helper){
        var timer = cmp.get('v.skuDebounce');
        clearTimeout(timer);
		cmp.set("v.productInfoError", false);
        var sku = cmp.get('v.sku');
        cmp.set("v.productName", null);
        var _searchResultShown = cmp.get('v.showSkuSearchResults');
        timer = setTimeout($A.getCallback(function () {
            var priceBySku = cmp.get('v.priceBySku');

            // price by sku specific logic
            if(priceBySku === true){
                helper.resetPriceBySku(cmp);
            }

            // only consider input change when the length is greater than 3
            if(sku.length > 3){
                
                helper.handleSkuInputChange(cmp, sku);
            } else {
                if(cmp.find('productSku'))
                    cmp.find('productSku').getElement().focus();
                helper.clearSkuSearch(cmp);
                cmp.set('v.productName', '');
                if(_searchResultShown)
                    helper.helpers.updateProductToStore(cmp);
            }

        }), 1000);

        cmp.set('v.skuDebounce', timer);
    },

    handleSkuOnBlur: function(cmp, evt, helper){
        var timer = cmp.get('v.skuDebounce');
        clearTimeout(timer);
		//cmp.set("v.productInfoError", false);
        timer = setTimeout($A.getCallback(function () {
            helper.clearSkuSearch(cmp);
            //helper.handleChange(cmp);
        }), 500);

        cmp.set('v.skuDebounce', timer);
    },

    handleSkuOnFocus: function(cmp, evt, helper){
        // just clear the sku timeout in case the user, left and
        // now came back in time before the sku debounce happened
        var timer = cmp.get('v.skuDebounce');
        clearTimeout(timer);
    },

    handleOnSkuSelect: function(cmp, evt, helper){
        var cartId = evt.currentTarget.dataset.cartid;
        var skuId = evt.currentTarget.dataset.skuid;
        helper.setSelectedSku(cmp, cartId, skuId);
    },

    clearSelectedSku: function(cmp){
        cmp.set('v.skuObject', undefined);
        cmp.set('v.sku', '');
        cmp.set('v.showProductInfo', false);
    },

    handleDeleteProduct: function(cmp){
        var store = cmp.get('v.store');
        var cartId = cmp.get('v.cartId');
        store.removeProductByCartId(cartId);
    },

    toggleAvailabiltyDetails: function(cmp, evt, helper){
        if(!cmp.get('v.showProductSupply') === true){
            helper.getProductSupply(cmp);
        } else {
            var store = cmp.get('v.store');
            var cartId = cmp.get('v.cartId');
            store.setShowProductSupply(cartId, false);
        }
    },

    showProductSearch: function(cmp, evt, helper){
        var store = cmp.get('v.store');
        var cartId = cmp.get('v.cartId');
        var baseHelper = store.getHelper();

        // open product search window
        baseHelper.openModal(cmp, 'c:Dal_Dist_OrderProductSearch', {store: store, cartId: cartId}, true, 'dal-modal_large');
    }

})