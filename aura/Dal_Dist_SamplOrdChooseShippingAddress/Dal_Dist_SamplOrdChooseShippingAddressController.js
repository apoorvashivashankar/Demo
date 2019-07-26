/**
 * Created by ranja on 20-08-2018.
 */
({
    addAddress : function(cmp,event,helper) {
        cmp.set('v.searchAddText', '');
        helper.doInitAddress(cmp);;
        cmp.set('v.showNewAddress', true);
        cmp.set('v.isNewAddress', true);
    },

    /**
         * Initial page
         * @param cmp
         * @param evt
         * @param helper
         */
        init: function(cmp, evt, helper){
            cmp.set('v.isLoading', false);
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
            //console.log('IN address change');
            var selectedItem = evt.currentTarget;
            var selectedIndex = selectedItem.dataset.index;
            //console.log('selectedIndex: ' , selectedIndex);
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
        },

})