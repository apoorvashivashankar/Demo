/**
 * Created by 7Summits on 3/29/18.
 */
({
    /**
     * Initial page
     * @param cmp
     * @param evt
     * @param helper
     */
    init: function(cmp, evt, helper){
        helper.doInitAddress(cmp);
    },
    //search for a company,address
    searchAddress :function(cmp, evt, helper){
        if(cmp.get('v.searchAddText').length>=1)
        	helper.searchAddress(cmp);
        else if(cmp.get('v.searchAddText').length==0)
            helper.doInitAddress(cmp);
    },
    
    /**
     * Click handler when user selects a new shipping address
     * from the list
     * @param cmp
     * @param evt
     * @param helper
     */
    changeAddress: function(cmp, evt, helper){
        var selectedItem = evt.currentTarget;
        var selectedIndex = selectedItem.dataset.index;
        helper.changeShippingAddress(cmp, selectedIndex);
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
     *
     * @param cmp
     * @param evt
     * @param helper
     */
    deleteAddress: function(cmp, evt, helper){
        var selectedItem = evt.currentTarget;
        var selectedIndex = selectedItem.dataset.index;
        helper.handleDeleteAddress(cmp, selectedIndex);
        
    },

    /**
     * Click handler for user adding new address
     * @param cmp
     */
    addAddress: function(cmp, evt, helper){
        helper.doInitAddress(cmp);
        cmp.set('v.searchAddText', '');
        cmp.set('v.showNewAddress', true);
        
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
        helper.handleUseUpdatedAddress(cmp);
    }

})