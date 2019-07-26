({
	handleSaveAddress : function(cmp,event,helper,params) {
		try{ 
            this.startSpinner(cmp);
            this.doCallout(cmp, "c.getAddress", params, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
               var _resp = response.getReturnValue();

               if(_resp && _resp.length>0) {
                    cmp.set('v.deliveryAddress',_resp);
               }
               console.log('Response for Address: ',_resp );

               this.stopSpinner(cmp);
            } else {
               this.stopSpinner(cmp);
            }
        });
        } catch(ex) {
            this.stopSpinner(cmp);
        }
	},

	/**
     * Validate that the address the user entered is correct
     * @param cmp
     */
	handleSaveAddress: function(cmp){
	    debugger;
        // aura:id's of input attributes
        var inputIds = ['companyName', 'street', 'city', 'state', 'zipCode'];
        //console.log('Save Address');
        // call isValid in base helper
        var isValid = this.validateForm(cmp, null, inputIds, true);
        //console.log('isValid: ' + isValid);
        // if the form is valid make request to see if address is valid
        if(isValid === true){
            cmp.set('v.isLoading', true);
            cmp.set('v.newAddressInvalid', false);
            //console.log('is valid');
            var self = this;

            // need to get reference to event now because cant inside promise, where it is needed.
            var chooseShippingAddressEvt = $A.get('e.c:Dal_ChooseShippingAddressEvt');

            // create address object to send to apex service for validation
            var addressParams = {
                companyName: cmp.find('companyName').get('v.value'),
                lineOne: cmp.find('street').get('v.value'),
                city: cmp.find('city').get('v.value'),
                state: cmp.find('state').get('v.value'),
                code: cmp.find('zipCode').get('v.value')

            };

            // make apex call for validation
            var getValidatedAddress = this.doCallout(cmp, 'c.getAddress', addressParams);

            // handle apex response
            getValidatedAddress.then(function(response){
                self.handleValidateAddressSuccess(cmp, response, chooseShippingAddressEvt);
            }, function(response){
                //console.log('Dal_ChooseShippingAddress:handleSaveAddress:getValidatedAddress:fail', response);
            });

        } // end is valid check

    },

    /**
     * Handle response from getValidatedAddress apex call
     * @param cmp
     * @param response
     * @param chooseShippingAddressEvt
     */
    handleValidateAddressSuccess: function(cmp, response, chooseShippingAddressEvt){
        // address is valid as is
        if(response.isValid === true){
            this.handleNewAddressValid(cmp, response, chooseShippingAddressEvt);
        }

        // address isn't valid as is, but we found alternative
        else if(response.isValidWithUpdate === true){
            this.handleNewAddressValidWithUpdate(cmp, response);
            cmp.set('v.isLoading', false);
        }

        // address is invalid
        else {
            cmp.set('v.newAddressInvalid', true);
            cmp.set('v.isLoading', false);
        }
    },

    /**
     * If the user added address is validate, send the address back to the
     * order form and close the modal
     * @param cmp
     * @param response
     * @param chooseShippingAddressEvt
     */
    handleNewAddressValid: function(cmp, response, chooseShippingAddressEvt){
        var self = this;

        // check if we are in edit mode, if so get the id
        var isEditMode = cmp.get('v.isEditingExistingAddress');
        var id = (isEditMode === true) ? cmp.get('v.newAddressId') : undefined;

        var name = cmp.get('v.newAddressName') || '';
        var name2 = cmp.get('v.newAddressName2') || '';
        var careOf = cmp.get('v.newAddressCareOf') || '';
        var street1 = response.lineOne || '';
        var street2 = response.lineOne2 || '';
        var city = response.city || '';
        var state = response.stateProvince || '';
        var zipcode = response.PostalCode || '';
        var country = response.country || '';
        //  prepare data to save to server
        var addressForServer = this.createAddressForServer(id, name, careOf, street1, street2, city, state, zipcode, country);

        // store address to server, returns promise that can be handled if needed
        var storeNewAddressToServer = this.storeNewAddressToServer(cmp, addressForServer);

        // wait for server save to complete
        storeNewAddressToServer.then(function(){
            self.clearAddressForm(cmp);
            cmp.set('v.showNewAddress', false);
            cmp.set('v.isLoading', false);
        }, function(response){
            //console.log('Dal_ChooseShippingAddress:Error saving address to server:', response);
        });

    },

    /**
     * User added address isn't valid but we found an alternative,
     * display that view to the user.
     * @param cmp
     * @param response
     */
    handleNewAddressValidWithUpdate: function(cmp, response){
        // set the adjusted address
        cmp.set('v.newAddressAdjustedName', cmp.get('v.newAddressName') || '');
        cmp.set('v.newAddressAdjustedName2', cmp.get('v.newAddressName2') || '');
        cmp.set('v.newAddressAdjustedCareOf', cmp.get('v.newAddressCareOf') || '');
        cmp.set('v.newAddressAdjustedStreet1', response.lineOne || '');
        cmp.set('v.newAddressAdjustedStreet2', response.lineOne2 || '');
        cmp.set('v.newAddressAdjustedCity', response.city || '');
        cmp.set('v.newAddressAdjustedState', response.stateProvince || '');
        cmp.set('v.newAddressAdjustedZipcode', response.PostalCode || '');
        cmp.set('v.newAddressAdjustedCountry', response.country || '');
        cmp.set('v.newAddressValidWithUpdate', true);
    },


})