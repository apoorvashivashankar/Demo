/**
 * Created by 7Summits on 3/27/18.
 */
({

    init: function(cmp, evt, helper){
        helper.handleStoreUpdate(cmp);
        helper.handleOrderInfoUpdate(cmp);
        helper.updateStore(cmp);
    },

    handleChange: function(cmp, evt, helper){
        helper.updateStore(cmp);
    },

    handleSaveOrderClick: function(cmp, evt, helper){
        // check if the form is valid
        var isFormValid = helper.isFormValid(cmp);
		if(isFormValid === true){
            // before we save we need to show a modal window, and allow the use to populate their PO and Job Name.
            var store = cmp.get('v.store');
            var baseHelper = store.getHelper();
            var orderInfo = store.getOrderInfo();
            baseHelper.openModal(cmp, 'c:Dal_Dist_OrderSave', {
                poNumber: orderInfo.poNumber,
                jobName: orderInfo.jobName
            }, true, 'dal-modal_large');
        }
    },

    handleSaveOrderEvent: function(cmp, evt, helper){
        helper.saveOrder(cmp, evt);
    },

    saveContinue:function(cmp, evt, helper){
        helper.saveContinue(cmp);
    },

    changeShippingAddress: function(cmp, evt, helper){
        var store = cmp.get('v.store');

        // get the base component helper
        var baseHelper = store.getHelper();

        // modal attributes
        var showCloseButton = true;
        var customClasses = 'slds-modal_medium';

        // open the modal
        baseHelper.openModal(cmp, 'c:Dal_ChooseShippingAddress', {}, showCloseButton, customClasses);
    },

    handleChooseShippingAddressEvent: function(cmp, evt, helper){
        var store = cmp.get('v.store');

        // get the new address selected
        var address = evt.getParam('address');

        // set shipping attributes
        cmp.set('v.shipToName', address.name);
        cmp.set('v.shipToCareOf', address.careOf);
        cmp.set('v.shipToStreet1', address.street1);
        cmp.set('v.shipToStreet2', address.street2);
        cmp.set('v.shipToCity', address.city);
        cmp.set('v.shipToState', address.state);
        cmp.set('v.shipToZipcode', address.zipcode);
        cmp.set('v.shipToCountry', address.country);

        // close the modal
        var baseHelper = store.getHelper();
        baseHelper.closeModal(cmp);
        helper.updateStore(cmp);
    },

    handleBack: function(cmp){
        var store = cmp.get('v.store');
        store.previousStep();
    },

    handleSmallPackageShipChange: function(cmp, evt, helper){
        debugger;
        var isSmallPackage = cmp.get('v.isSmallPackage');
		// if small package is set to false we want to clear the carrier field as well
        if(isSmallPackage == 'no'){
            cmp.set('v.carrier', '');
        }else{
          cmp.set('v.carrier', 'UPS Ground');
        }
        helper.updateStore(cmp);
    }

})