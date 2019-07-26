/**
 * Created by ranja on 19-08-2018.
 */
({

    doInit : function (cmp,event,helper) {
        //console.log('### ON SECOND PAGE ###');
        cmp.set('v.isSearching',true);

        helper.getAddressForAccount(cmp,event,helper);
        helper.doInitAddress(cmp,event,helper);
        //var selectedAddress = cmp.get('v.selectedAddress');
        cmp.set('v.isSearching',false);
        //var shippingAddress = helper.createAddressForEvent(selectedAddress.name, selectedAddress.careOf, selectedAddress.street1,
        //selectedAddress.street2, selectedAddress.city, selectedAddress.state, selectedAddress.zipcode, selectedAddress.country);
    },

    changeShippingAddress : function (cmp,event,helper) {
        //console.log('Change address method called');

        //helper.openModal(cmp,'c:Dal_Dist_SampleOrderProductSearch', {}, true,'slds-modal_medium');

        try {
          helper.openModal(cmp,'c:Dal_Dist_SamplOrdChooseShippingAddress', {currentPosition : cmp.getReference('v.currentPosition'),
            productOrderLines : cmp.get('v.productOrderLines'), selectedAddress : cmp.getReference('v.selectedAddress'),
            addresses : cmp.getReference('v.addresses'), states : cmp.getReference('v.states'), countries : cmp.getReference('v.countries')
          }, true,'slds-modal_medium');
        }
        catch(err) {
            //console.log('ERRLOG ' , err.getMessage());
        }

    },

    handleChooseShippingAddressEvent: function(cmp, evt, helper){

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

        //cmp.set('v.selectedAddress', address);

        console.log('Selected Address IN Event: ' ,address.name);
        console.log('Selected Address IN Event: ' ,address.careOf);
        console.log('Selected Address IN Event: ' ,address.state);

        // close the modal


    },

    handleBack : function (cmp,event,helper) {
        var orderProcessStepEvt = $A.get('e.c:Dal_Dist_OrderProcessStepEvt');
        //console.log('Event Fired: ' , orderProcessStepEvt);
        // prepare the params for the the orderProcessStepEvt event
        var currentPosition = cmp.get('v.currentPosition');
        currentPosition--;
        orderProcessStepEvt.setParams({
            'currentPos': currentPosition
        });
        orderProcessStepEvt.fire();
        cmp.set('v.currentPosition',currentPosition);
    },

    handleChange : function(cmp,event,helper) {

    },

    handleSmallPackageShipChange : function(cmp,event,helper) {
        var isSmallPackage = cmp.get('v.isSmallPackage');
        // if small package is set to false we want to clear the carrier field as well
        if(isSmallPackage == 'no'){
            cmp.set('v.carrier', '');
        }else{
            cmp.set('v.carrier', 'UPS Ground');
        }
    },

    saveContinue : function(cmp,event,helper) {
        var orderProcessStepEvt = $A.get('e.c:Dal_Dist_OrderProcessStepEvt');
        var selectedAddress = cmp.get('v.selectedAddress');

        //console.log('PRODUCT ORDER LINES: ' , cmp.get('v.productOrderLines'));
        //console.log('Selected Address: ' , selectedAddress.name);

        var currentPosition = cmp.get('v.currentPosition');
        currentPosition++;
        orderProcessStepEvt.setParams({
            'currentPos': currentPosition
        });
        orderProcessStepEvt.fire();
        cmp.set('v.currentPosition',currentPosition);

    },

})