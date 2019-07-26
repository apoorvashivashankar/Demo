/**
 * Created by ranja on 14-01-2019.
 */
({

    /**
     * Initial page
     * @param cmp
     * @param evt
     * @param helper
     */
    init: function(cmp, evt, helper){
        cmp.set('v.showNewAddress', true);
        cmp.set('v.isNewAddress', true);
        cmp.set('v.isLoading', false);
        helper.doInit(cmp,evt,helper);

    },


    /**
     *
     * @param cmp
     * @param evt
     * @param helper
     */
    editAddress: function(cmp, evt, helper){
        var selectedItem = evt.currentTarget;
        var selectedIndex = selectedItem.dataset.index;
        helper.handleEditAddress(cmp, selectedIndex);
    },


    /**
     * Click handle when user submits new address
     * @param cmp
     * @param evt
     * @param helper
     */
    handleSaveAddress: function(cmp, evt, helper){
        helper.handleSaveAddress(cmp);
    },

    /**
     * Cancel adding new address
     * @param cmp
     */
    handleCancel: function(cmp, evt, helper){
        helper.clearAddressForm(cmp);
        cmp.set('v.showNewAddress', false);
        cmp.set('v.isEditingExistingAddress', false);
    },

    /**
     * Close modal
     * @param cmp
     */
    handleClose: function(cmp){
        cmp.find('overlayLib').notifyClose();
    },

    /**
     * Click handler when use enters in new address
     * that isn't valid and they want to edit it
     * @param cmp
     */
    editValidationAddress: function(cmp){
        cmp.set('v.newAddressValidWithUpdate', false);
    },

    /**
     *  Handle use selecting adjusted address returned
     *  from the service
     * @param cmp
     * @param evt
     * @param helper
     */
    useUpdatedAddress: function(cmp, evt, helper){
        debugger;
        var appEvent = $A.get("e.c:Dal_SSC_CreateOrderSaveShippingAddress");
        var params = {
            "companyName" : cmp.get('v.newCompanyAdjustedName'),
            "streetAddress" : cmp.get('v.newAddressAdjustedStreet1'),
            "city" : cmp.get('v.newAddressAdjustedCity'),
            "state" : cmp.get('v.newAddressAdjustedState'),
            "zipCode" : cmp.get('v.newAddressAdjustedZipcode'),
            "country" : cmp.get('v.newAddressAdjustedCountry'),
            "orderNumber" : cmp.get('v.orderNumber')
        };
        appEvent.setParams(params);
        appEvent.fire();
        cmp.find('overlayLib').notifyClose();
        //helper.handleUseUpdatedAddress(cmp);
    },
})