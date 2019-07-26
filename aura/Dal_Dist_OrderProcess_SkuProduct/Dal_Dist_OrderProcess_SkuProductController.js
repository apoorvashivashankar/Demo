/**
 * Created by 7Summits on 3/6/18.
 */
({

    init: function(cmp, evt, helper){
        cmp.set("v.isSSC", ((window.location.href.indexOf('SSC') > -1) || (window.location.href.indexOf('tradeproexchange') > -1)));
        console.log('isSSC', cmp.get("v.isSSC"));
        helper.handleStoreUpdate(cmp);
    },

    addProduct: function(cmp){
        var store = cmp.get('v.store');
        store.addProducts(1);
    },

    addTenProducts: function(cmp){
        var store = cmp.get('v.store');
        store.addProducts(10);
    },

    handleSaveOrderClick: function(cmp){
        // before we save we need to show a modal window, and allow the use to populate their PO and Job Name.
        var store = cmp.get('v.store');
        var baseHelper = store.getHelper();
        var orderInfo = store.getOrderInfo();
        baseHelper.openModal(cmp, 'c:Dal_Dist_OrderSave', {
            poNumber: orderInfo.poNumber,
            jobName: orderInfo.jobName
        }, true, 'dal-modal_large');
    },

    handleSaveOrderEvent: function(cmp, evt, helper){
        helper.saveOrder(cmp, evt);
    },

    saveContinue:function(cmp, evt, helper){
        helper.saveContinueOrder(cmp);
    },

    handleDefaultShippingChange: function(cmp, evt, helper){
        var defaultShippingDate = cmp.find('defaultShippingDate');
        var defaultShippingDateValue = defaultShippingDate.get('v.value');

        // check if shipping date is valid
        var isValidShippingDate = helper.isValidShippingDate(cmp, defaultShippingDateValue);

        // now we know the changed shipping date is valid, but since the shipping
        // date changed we need to make a request to get the new price records.
        if(isValidShippingDate === true){
            var store = cmp.get('v.store');
            store.setDefaultPriceRecordsByDate(defaultShippingDateValue);
            store.setDefaultShippingDate(defaultShippingDateValue);
        }
    },

    handlePriceBySkuDefaultShippingChange: function(cmp, evt, helper){
        var defaultShippingDate = cmp.find('defaultShippingDate');
        var defaultShippingDateValue = defaultShippingDate.get('v.value');

        // check if shipping date is valid
        var isValidShippingDate = helper.isValidShippingDate(cmp, defaultShippingDateValue);

        // now we know the changed shipping date is valid, but since the shipping
        // date changed we need to make a request to get the new price records.
        if(isValidShippingDate === true){
            var store = cmp.get('v.store');
            store.setPriceBySkuDefaultPriceRecordsByDate(defaultShippingDateValue);
            store.setDefaultShippingDate(defaultShippingDateValue);
        }
    },

    handleDefaultPriceRecordChange: function(cmp){
        var store = cmp.get('v.store');
        var value = cmp.find('defaultPriceRecord').get('v.value');
        store.setDefaultPriceRecord(value);
    },

    handlePriceBySkuPriceRecordChange: function(cmp){
        var store = cmp.get('v.store');
        var value = cmp.find('defaultPriceRecord').get('v.value');
        store.setAllCartProductsPriceRecord(value);
    },

    handleAddToOrder: function(cmp, evt, helper){
        cmp.set('v.isSaving', true);

        var store = cmp.get('v.store');
        var baseHelper = store.getHelper();
        var promise = store.saveOrder();

        promise.then(function(response){
            helper.doGotoURL('/quick-order?draftId=' + response);
        }, function(){
            // handle error logic if needed
            cmp.set('v.isSaving', false);
            baseHelper.showMessage('Error', 'Unable to Add Items To Orders.');
        });

    },

    showProductSearch: function(cmp, evt, helper){
        var store = cmp.get('v.store');
        var cartId = cmp.get('v.cartId');
        var priceBySku = cmp.get('v.priceBySku');
        var baseHelper = store.getHelper();

        // open product search window
        baseHelper.openModal(cmp, 'c:Dal_Dist_OrderProductSearch', {store: store, cartId: cartId, priceBySku: priceBySku}, true, 'dal-modal_large');
    },

    handleCheckPricing: function(cmp, evt, helper){
         var store = cmp.get('v.store');

         store.getCartProductsPriceBySku();
    }

})