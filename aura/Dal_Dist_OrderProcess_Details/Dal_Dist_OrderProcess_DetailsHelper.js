/**
 * Created by 7Summits on 4/13/18.
 */
({

    handleStoreUpdate: function(cmp){
        var store = cmp.get('v.store');
        var shippingInfo = store.getShippingInfo();

        console.log('Dal_Dist_OrderProcess_Details:handleStoreUpdate::', JSON.parse(JSON.stringify(shippingInfo)));

        var isShipComplete = (shippingInfo.isShipComplete === 'true' || shippingInfo.isShipComplete === true) ? 'yes'
            : (shippingInfo.isShipComplete === 'false' || shippingInfo.isShipComplete === false) ? 'no' : '';

        var isSmallPackage = (shippingInfo.isSmallPackage === 'true' || shippingInfo.isSmallPackage === true) ? 'yes'
            : (shippingInfo.isSmallPackage === 'false' || shippingInfo.isSmallPackage === false) ? 'no' : '';

        // set the shipping info attributes
        cmp.set('v.shipToName', shippingInfo.shipToName);
        cmp.set('v.shipToCareOf', shippingInfo.shipToCareOf);
        cmp.set('v.shipToStreet1', shippingInfo.shipToStreet1);
        cmp.set('v.shipToStreet2', shippingInfo.shipToStreet2);
        cmp.set('v.shipToCity', shippingInfo.shipToCity);
        cmp.set('v.shipToState', shippingInfo.shipToState);
        cmp.set('v.shipToZipcode', shippingInfo.shipToZipcode);
        cmp.set('v.shipToCountry', shippingInfo.shipToCountry);
        cmp.set('v.freightTerms', shippingInfo.freightTerms);
        cmp.set('v.carrier', shippingInfo.carrier);
        cmp.set('v.isShipComplete', isShipComplete);
        cmp.set('v.isSmallPackage', isSmallPackage);
        cmp.set('v.canShipSmallPackage', shippingInfo.canShipSmallPackage);
    },

    handleOrderInfoUpdate: function(cmp){
        var store = cmp.get('v.store');
        var orderInfo = store.getOrderInfo();
        console.log('handleOrderInfoUpdate', JSON.parse(JSON.stringify(orderInfo)));

        // set order info
        cmp.set('v.poNumber', orderInfo.poNumber);
        cmp.set('v.jobName', orderInfo.jobName);
        cmp.set('v.contactName', orderInfo.contactName);
        cmp.set('v.contactNumber', orderInfo.contactNumber);
    },
    
    updateStore: function(cmp){
        var store = cmp.get('v.store');
        console.log('updatestore', JSON.stringify(store));
        var isShipComplete = (cmp.get('v.isShipComplete') === 'yes') ? true : (cmp.get('v.isShipComplete') === 'no') ? false  : '';
        var isSmallPackage = (cmp.get('v.isSmallPackage') === 'yes') ? true : (cmp.get('v.isSmallPackage') === 'no') ? false  : '';

        var shippingInfoParams = {
            shipToName: cmp.get('v.shipToName'),
            shipToCareOf: cmp.get('v.shipToCareOf'),
            shipToStreet1:cmp.get('v.shipToStreet1'),
            shipToStreet2:cmp.get('v.shipToStreet2'),
            shipToCity:cmp.get('v.shipToCity'),
            shipToState:cmp.get('v.shipToState'),
            shipToZipcode:cmp.get('v.shipToZipcode'),
            shipToCountry:cmp.get('v.shipToCountry'),
            freightTerms: cmp.get('v.freightTerms'),
            isShipComplete: isShipComplete,
            isSmallPackage: isSmallPackage,
            carrier: cmp.get('v.carrier')
        };

        var orderInfoParams = {
            poNumber: cmp.get('v.poNumber'),
            jobName: cmp.get('v.jobName'),
            contactName: cmp.get('v.contactName'),
            contactNumber: cmp.get('v.contactNumber')
        };

        store.updateShippingInfoToStore(shippingInfoParams);
        store.updateOrderInfoToStore(orderInfoParams);
    },

    saveOrder: function(cmp, evt){
        var store = cmp.get('v.store');
        var baseHelper = store.getHelper();
        var poNumber = evt.getParam('poNumber');
        var jobName = evt.getParam('jobName');

        // close the modal
        baseHelper.closeModal(cmp);

        // show loading
        cmp.set('v.isSaving', true);

        // update the poNumber and jobName to the store
        store.updateOrderInfoToStore({
            poNumber: poNumber,
            jobName: jobName
        });

        // save the order to the server
        var promise = store.saveOrder();
        promise.then(function(){
            var savedOrdersUrl = cmp.get('v.savedOrdersUrl');
            baseHelper.doGotoURL(savedOrdersUrl);
        }, function(response){
            // handle error logic if needed
            console.log('Dal_Dist_OrderProcess_SkuProduct:save:error', response);
            cmp.set('v.isSaving', false);
            baseHelper.showMessage('Error', 'Unable to Save Products.');
        });

    },

    saveContinue: function(cmp){
        // check if the form is valid
        var isFormValid = this.isFormValid(cmp);

        // if the form is valid continue
        if(isFormValid === true){
            var store = cmp.get('v.store');

            cmp.set('v.isSaving', true);

            // save the order to the server
            var promise = store.saveContinueDetail();

            promise.then(function(){
                // no need to handle success, will go to confirmation page upon success
            }, function(response){
                console.log('Dal_Dist_OrderProcess_Details:saveContinue:error', response);
                var baseHelper = store.getHelper();
                cmp.set('v.isSaving', false);
                baseHelper.showMessage('Error', 'Unable to Save Order.');
            });
        }

    },

    getShippingInfo: function(cmp){
        
        Console.log('freightTerms--->',cmp.get('v.isShipComplete'));
        return {

            shipToName: cmp.get('v.shipToName'),
            shipToCareOf: cmp.get('v.shipToCareOf'),
            shipToStreet1: cmp.get('v.shipToStreet1'),
            shipToStreet2:  cmp.get('v.shipToStreet2'),
            shipToCity: cmp.get('v.shipToCity'),
            shipToState: cmp.get('v.shipToState'),
            shipToZipcode: cmp.get('v.shipToZipcode'),
            shipToCountry: cmp.get('v.shipToCountry'),
            freightTerms: cmp.get('v.freightTerms'),
            carrier: cmp.get('v.carrier'),
            isShipComplete: cmp.get('v.isShipComplete'),
            isSmallPackage: cmp.get('v.isSmallPackage')
        }
    },

    getOrderInfo: function(cmp){
        return {
            poNumber: cmp.get('v.poNumber'),
            jobName: cmp.get('v.jobName'),
            contactName: cmp.get('v.contactName'),
            contactNumber: cmp.get('v.contactNumber')
        }
    },

    isFormValid: function(cmp){
        var store = cmp.get('v.store');
        var baseHelper = store.getHelper();
        var canShipSmallPackage = cmp.get('v.canShipSmallPackage');

        // fields to validate
        var fieldsToValidate = ['shipCompleteInput', 'poNumberInput', 'contactNumberInput'];

        // if the user can ship small package we need to add a field to validate
        if(canShipSmallPackage === true){
            fieldsToValidate.push('shipSmallPackageInput');
        }

        // call the validation helper
        return baseHelper.validateForm(cmp, null, fieldsToValidate, true);
    }

})