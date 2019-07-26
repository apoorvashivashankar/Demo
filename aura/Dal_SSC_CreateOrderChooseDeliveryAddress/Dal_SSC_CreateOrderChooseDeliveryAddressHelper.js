/**
 * Created by ranja on 14-01-2019.
 */
({
    doInit: function(cmp,event,helper){
        cmp.set('v.isLoading', true);
        var varStates = this.getStatesOptions();
        cmp.set('v.statesList', varStates);


        var country = this.doCallout(cmp,'c.getCountries');

        // handle results of the promise
        country.then(function(response){
        var country = [];
            // create the address objects
            if(response !== undefined){
                console.log('response '+response);
                cmp.set('v.countries', response);
                console.log(cmp.get('v.countries'));
            }

        },
         function(response){
         //console.log('Dal_ChooseShippingAddress:init:shippingAddresses:fail', response);
        });
        cmp.set('v.isLoading', false);
    },


    /**
     * Validate that the address the user entered is correct
     * @param cmp
     */
    handleSaveAddress: function(cmp){
        debugger;

        // aura:id's of input attributes
        var inputIds = ['companyName', 'street1', 'city', 'state', 'zipcode','country'];

        // call isValid in base helper
        var isValid = this.validateForm(cmp, null, inputIds, true);

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
                companyName : cmp.find('companyName').get('v.value'),
                lineOne: cmp.find('street1').get('v.value'),
                stateProvince: cmp.find('state').get('v.value'),
                city: cmp.find('city').get('v.value'),
                country: cmp.find('country').get('v.value'),
                code: cmp.find('zipcode').get('v.value')
            };

            // make apex call for validation
            var getValidatedAddress = this.doCallout(cmp, 'c.getAddress', addressParams);

            // handle apex response
            getValidatedAddress.then(function(response){
                self.handleValidateAddressSuccess(cmp, response, chooseShippingAddressEvt);
            }, function(response){

                cmp.set('v.showNewAddress',true);
                cmp.set('v.isLoading', true);
                console.log('Dal_SSC_CreateOrderChooseDeliveryAddress:handleSaveAddress:getValidatedAddress:fail', response);

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
        debugger;
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
        debugger;
        var self = this;

        // check if we are in edit mode, if so get the id
        var isEditMode = cmp.get('v.isEditingExistingAddress');
        var id = (isEditMode === true) ? cmp.get('v.newAddressId') : undefined;

        var name = cmp.get('v.newCompanyName') || '';
        var street1 = response.lineOne || '';
        var city = response.city || '';
        var state = response.stateProvince || '';
        var zipcode = response.PostalCode || '';
        var country = response.Country || '';

        //  prepare data to save to server
        var addressForServer = this.createAddressForServer(name, street1, city, state, zipcode);

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
        debugger;
        // set the adjusted address
        cmp.set('v.newCompanyAdjustedName', cmp.get('v.newCompanyName') || '');
        cmp.set('v.newAddressAdjustedStreet1', response.lineOne || '');
        cmp.set('v.newAddressAdjustedCity', response.city || '');
        cmp.set('v.newAddressAdjustedState', response.stateProvince || '');
        cmp.set('v.newAddressAdjustedZipcode', response.PostalCode || '');
        cmp.set('v.newAddressAdjustedCountry', response.country || '');
        cmp.set('v.newAddressValidWithUpdate', true);
    },

    /**
     *  Edit an existing address
     * @param cmp
     * @param addressIndex
     */
    handleEditAddress: function(cmp, addressIndex){
        // get the existing address
        var addresses = cmp.get('v.addresses');
        var addressToEdit = addresses[addressIndex];

        // populate the new address for with the address to edit
        cmp.set('v.newCompanyName', addressToEdit.companyName);
        cmp.set('v.newAddressStreet1', addressToEdit.street1);
        cmp.set('v.newAddressCity', addressToEdit.city);
        cmp.set('v.newAddressState', addressToEdit.state);
        cmp.set('v.newAddressZipcode', addressToEdit.zipcode);
        cmp.set('v.newAddressCountry', addressToEdit.country);

        // show the new address form
        cmp.set('v.showNewAddress', true);
        cmp.set('v.isEditingExistingAddress', true);
    },


    /**
     * User selected an altenate address returned from the validation
     * service. Save that address to the server and set it to the view
     * @param cmp
     */
    handleUseUpdatedAddress: function(cmp){
        var self = this;

        // set loading to true
        cmp.set('v.isLoading', true);

        // check if we are in edit mode, if so get the id
        var isEditMode = cmp.get('v.isEditingExistingAddress');
        var id = (isEditMode === true) ? cmp.get('v.newAddressId') : undefined;

        // get the adjusted address values
        var name = cmp.get('v.newCompanyAdjustedName') || '';
        var street1 = cmp.get('v.newAddressAdjustedStreet1') || '';
        var city = cmp.get('v.newAddressAdjustedCity') || '';
        var state = cmp.get('v.newAddressAdjustedState') || '';
        var zipcode = cmp.get('v.newAddressAdjustedZipcode') || '';
        var country = cmp.get('v.newAddressAdjustedCountry') || '';

        // create address object for the server save
        var addressForServer = this.createAddressForServer(name, street1, city, state, zipcode);

        // make server call to save address
        var storeNewAddressToServer = this.storeNewAddressToServer(cmp, addressForServer);

        // check server response
        storeNewAddressToServer.then(function(){
            self.clearAddressForm(cmp);
            cmp.set('v.newAddressValidWithUpdate', false);
            cmp.set('v.showNewAddress', false);
            cmp.set('v.isLoading', false);
        }, function(response){
            //console.log('handleUseUpdatedAddress:Error saving address to server:', response);
        });
    },

    /**
     * Create address object for card view
     * @param address
     * @returns {}
     */
    createAddressForView: function(address){
        return {
            companyName: address.companyName,
            careOf: address.CareOf,
            street1: address.Address1,
            city: address.City,
            state: address.State,
            zipcode: address.PostalCode,
            country: address.Country,
            isActive: address.Isactive,
            isPrimary: address.IsPrimaryLocation || false
        }
    },

    /**
     * Create address object that will be passed along with the change address event
     * @param name
     * @param careOf
     * @param street1
     * @param street2
     * @param city
     * @param state
     * @param zipcode
     * @param country
     * @returns {{address: {name: *, careOf: *, street: *, street2: *, city: *, state: *, zipcode: *, country: *}}}
     */
    createAddressForEvent: function(name, street1, city, state, zipcode){
        return {
            address: {
                companyName: name,
                street1: street1,
                city: city,
                state: state,
                zipcode: zipcode,
                country: country
            }
        }
    },

    /**
     *
     * @param name
     * @param careOf
     * @param street1
     * @param street1
     * @param city
     * @param state
     * @param zipcode
     * @returns {{Name: *, CareOf: *, Address1: *, Address2: *, City: *, State: *, PostalCode: *}}
     */
    createAddressForServer: function(name, street1, city, state, zipcode){
        return {
            CompanyName: name,
            Address1: street1,
            City: city,
            State: state,
            PostalCode: zipcode
        };
    },

    /**
     *
     * @param cmp
     * @param address
     * @returns {Promise}
     */
    storeNewAddressToServer: function(cmp, address){
        var self = this;

        return new Promise($A.getCallback(function (resolve, reject) {

            var params = {
                'shipAddress': JSON.stringify(address) || ''
            };

            // make request to save address
            var createShipToOverride = self.doCallout(cmp, 'c.createShipToOverride', params);

            // handle save response
            createShipToOverride.then(function(response){
                var addresses = cmp.get('v.addresses');
                var addressFound = false;
                var addressFoundIndex = undefined;

                // create address for view
                var addressForView = self.createAddressForView(response);

                // loop through the existing addresses to check if the address already exists in the view addresses array
                for(var x=0; x<addresses.length; x++){
                    if(addresses[x].id === response.ID){
                        addressFound = true;
                        addressFoundIndex = x;
                        break;
                    }
                }

                // if the address was found replace it with the new updated address, if
                // the address wasn't found add as a new address
                if(addressFound === true){
                    addresses[addressFoundIndex] = addressForView;
                } else {
                    // add the new address to the existing
                    addresses.push(addressForView);
                }

                // set the addresses to the view
                cmp.set('v.addresses', addresses);

                resolve(response);
            }, function(response){
                reject(response);
            });

        }));
    },

    clearAddressForm: function(cmp){
        cmp.set('v.newAddressId', '');
        cmp.set('v.newCompanyName', '');
        cmp.set('v.newAddressStreet1', '');
        cmp.set('v.newAddressCity', '');
        cmp.set('v.newAddressState', '');
        cmp.set('v.newAddressCountry', '');
        cmp.set('v.newAddressZipcode', '');
    },

    /**
     * Fire an event
     * @param params
     * @param eventToFire
     */
    fireEvent: function(params, eventToFire){
        eventToFire.setParams(params);
        eventToFire.fire();
    },

    showtoast : function(_msg, _type){
        var _toastEvent = $A.get("e.force:showToast");
        _toastEvent.setParams({
            message: _msg,
            type : _type,
        });
        _toastEvent.fire();
     },
})