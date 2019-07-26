/**
 * Created by 7Summits on 4/26/18.
 */
({
   doAllDeliveryInit : function(cmp, evt, helper){
		debugger;
        var pageUrl = window.location.href;
       var hashIndex = pageUrl.lastIndexOf('#');
       var selectedProductType = pageUrl.substring(hashIndex+1,pageUrl.length);

       if(selectedProductType == 'reschedule') {
           cmp.set("v.isReschedule",true);
       } else {
           cmp.set("v.isReschedule",false);
       }

       if(selectedProductType == 'multiple') {
           cmp.set('v.isMultiple',true);
       } else {
           cmp.set('v.isMultiple',false);
       }
       
   },

     handleSaveDiff: function(cmp, evt, helper){
        helper.handleSaveDiff(cmp,evt, helper);
     },

    changeShippingAddress: function(cmp, evt, helper){
        debugger;
        var store = cmp.get('v.store');
        var baseHelper = store.getHelper();
        var _currentOrder = cmp.get("v.currentOrder");

        console.log('_shippingAddress: ',_shippingAddress);
        console.log('deliveryLocation:  ',_currentOrder.deliveryLocation);


        var _shippingAddress = {
            id: _currentOrder.deliveryLocation.careOf,
            name: _currentOrder.deliveryLocation.name,
            name2: _currentOrder.deliveryLocation.name2,
            careOf: _currentOrder.deliveryLocation.careOf,
            street1: _currentOrder.deliveryLocation.streetAddress1,
            street2: _currentOrder.deliveryLocation.streetAddress2,
            city: _currentOrder.deliveryLocation.city,
            state: _currentOrder.deliveryLocation.state,
            zipcode: _currentOrder.deliveryLocation.zipCode,
            country: _currentOrder.deliveryLocation.country,
            isPrimary: true
        }
        // open the modal
        baseHelper.openModal(cmp, 'c:Dal_ChooseShippingAddress', {primaryAddress: _shippingAddress}, true, 'dal-modal_large');
    },

    handleDeliveryDateChange: function(cmp, evt, helper){
        debugger;
        helper.handleDeliveryChange(cmp,evt);
    },

    handleSaveNext: function(cmp, evt, helper){
        helper.handleSaveNext(cmp);
    },

    handleCancel: function(cmp, evt, helper){
        var store = cmp.get('v.store');
        var baseHelper = store.getHelper();
        baseHelper.doGotoURL('/my-orders?tabset-5c42f=3');
    },
    
    handleChooseDeliveryAddressEvent: function(cmp, evt, helper){
        var store = cmp.get('v.store');
        var baseHelper = store.getHelper();

        // get the new address selected
        var address = evt.getParam('address');

        // set shipping attributes
        cmp.set('v.shipToName', address.name);
        cmp.set('v.shipToName2', address.name2);
        cmp.set('v.shipToCareOf', address.careOf);
        cmp.set('v.shipToStreet1', address.street1);
        cmp.set('v.shipToStreet2', address.street2);
        cmp.set('v.shipToCity', address.city);
        cmp.set('v.shipToState', address.state);
        cmp.set('v.shipToZipcode', address.zipcode);
		cmp.set('v.shipToCountry', address.country);
        // close the modal
        baseHelper.closeModal(cmp);

        // update store
        helper.updateStore(cmp);
    }

})