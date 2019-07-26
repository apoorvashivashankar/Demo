/**
 * Created by 7Summits on 5/14/18.
 */
({

    gotoSelectItems: function(cmp){
        var store = cmp.get('v.store');
        var currentOrderPos = store.getCurrentOrderPosition();
        store.setScheduleByItemActiveTab(currentOrderPos, 'selectItems');
    },

    handleSaveDelivery: function(cmp, evt, helper){
        helper.handleSaveDelivery(cmp);
    },

    handleDeliveryDateChange: function(cmp, evt, helper){
        helper.handleDeliveryChange(cmp);
    },

    changeShippingAddress: function(cmp, evt, helper){
        var store = cmp.get('v.store');
        var baseHelper = store.getHelper();

        // open the modal
        baseHelper.openModal(cmp, 'c:Dal_ChooseShippingAddress', {}, true, 'dal-modal_large');
    },

    handleChooseDeliveryAddressEvent: function(cmp, evt){

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
        cmp.set('v.shipToCountry',address.country);
        // close the modal
        baseHelper.closeModal(cmp);
    }

})