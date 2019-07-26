/**
 * Created by ranja on 20-08-2018.
 */
({
     doInitAddress: function(cmp){
            //console.log('INIT DATA HANDLER IN HELPER');
            cmp.set('v.isLoading', true);

            var self = this;

            // used for the add new address
            var states = this.getStatesOptions();
            cmp.set('v.states', states);
            //console.log('States--> ' , states);


            /*
            var country = this.doCallout(cmp,'c.getCountries');

            // handle results of the promise
            country.then(function(response){
     		var country = [];
                // create the address objects
                if(response !== undefined){
    				//console.log('response '+response);
    				cmp.set('v.countries', response);
                    //console.log('Countries--->' , cmp.get('v.countries'));
                }

            },
                function(response){
                //console.log('Dal_ChooseShippingAddress:init:getCountries:fail', response);
            });
            */

            // get all the existing shipping addresses
            var shippingAddresses = this.doCallout(cmp, 'c.getShipToAddressWrappersForCurrentLocation', {});

            // handle results of the promise
            shippingAddresses.then(function(response){
                var addresses = [];
                var _primaryAddress = cmp.get('v.primaryAddress');
                //console.log('_primaryAddress' ,JSON.stringify(_primaryAddress));
                if(_primaryAddress){
                    addresses.push(_primaryAddress);
                }
                // create the address objects
                if(response !== undefined && Array.isArray(response)){
                    response.forEach(function(item, index){
                        // create address object and add to array
                        var address = self.createAddressForView(item);
                        if(_primaryAddress){
                            address.isPrimary = false;
                        }
                        addresses.push(address);
                        //console.log('address----->',addresses);

                    });
                }

                // set view attributes
                cmp.set('v.addresses', addresses);
                cmp.set('v.isLoading', false);
            },
                function(response){
                //console.log('Dal_ChooseShippingAddress:init:shippingAddresses:fail', response);
            });

        },


        /**
         * User selects a new shipping address from the list
         * of existing addresses
         * @param cmp
         * @param index
         */
        changeShippingAddress: function(cmp, index){
            var addresses = cmp.get('v.addresses');
            var selectedAddress = '';

            // get the selected address from the list
            if(addresses[index] !== undefined){
                // get the selected address
                var selectedAddress = addresses[index];
                //console.log('Selected Address Index: ' , index);
                //console.log('Selected Address: ' , selectedAddress);
                // create the event address object
                var shippingAddress = this.createAddressForEvent(selectedAddress.name, selectedAddress.careOf, selectedAddress.street1, selectedAddress.street2, selectedAddress.city, selectedAddress.state, selectedAddress.zipcode, selectedAddress.country);
                cmp.set('v.selectedAddress',selectedAddress);
                //console.log('Selected Address: ' , cmp.get('v.selectedAddress'));
                var chooseShippingAddressEvt = $A.get('e.c:Dal_ChooseShippingAddressEvt');

                // fire event
                this.fireEvent(shippingAddress, chooseShippingAddressEvt);

                cmp.find('overlayLib').notifyClose();
            }

        },

        /**
         * Validate that the address the user entered is correct
         * @param cmp
         */
        handleSaveAddress: function(cmp){
            // aura:id's of input attributes
            var inputIds = ['name', 'street1', 'city', 'state', 'zipcode','country'];
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
                    lineOne: cmp.find('street1').get('v.value'),
                    lineTwo: cmp.find('street2').get('v.value'),
                    stateProvince: cmp.find('state').get('v.value'),
                    city: cmp.find('city').get('v.value'),
                    code: cmp.find('zipcode').get('v.value'),
                    country: cmp.find('country').get('v.value')
                };

                // make apex call for validation
                var getValidatedAddress = this.doCallout(cmp, 'c.getValidatedAddress', addressParams);

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
            cmp.set('v.newAddressId', addressToEdit.id);
            cmp.set('v.newAddressName', addressToEdit.name);
            cmp.set('v.newAddressName2', addressToEdit.name2);
            cmp.set('v.newAddressCareOf', addressToEdit.careOf);
            cmp.set('v.newAddressStreet1', addressToEdit.street1);
            cmp.set('v.newAddressStreet2', addressToEdit.street2);
            cmp.set('v.newAddressCity', addressToEdit.city);
            cmp.set('v.newAddressState', addressToEdit.state);
            cmp.set('v.newAddressZipcode', addressToEdit.zipcode);
    		cmp.set('v.newAddressCountry', addressToEdit.country);
            // show the new address form
            cmp.set('v.showNewAddress', true);
            cmp.set('v.isEditingExistingAddress', true);
        },

        /**
         * Delete an address
         * @param cmp
         * @param addressIndex
         */
        handleDeleteAddress: function(cmp, addressIndex){
            // get the existing address
            var addresses = cmp.get('v.addresses');
            var addressToDelete = addresses[addressIndex];

            // set loading to true
            cmp.set('v.isLoading', true);

            //  prepare data to save to server
            var addressForServer = this.createAddressForServer(addressToDelete.id, addressToDelete.name, addressToDelete.careOf,
                addressToDelete.street1, addressToDelete.street2, addressToDelete.city, addressToDelete.state, addressToDelete.zipcode);

            var params = {
                'shipAddress': JSON.stringify(addressForServer)
            };

            // make request to save address
            var deleteShipToOverride = this.doCallout(cmp, 'c.deleteShipToOverride', params);

            deleteShipToOverride.then(function(response){
                // remove the address from the array
                addresses.splice(addressIndex, 1);
                cmp.set('v.addresses', addresses);
                cmp.set('v.isLoading', false);
            }, function(response){
                cmp.set('v.isLoading', false);
                helper.showtoast ('Error Occured While Deleting the address','error');
                //console.log('handleDeleteAddress:Error deleting address:', response);
            });

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
            var name = cmp.get('v.newAddressName') || '';
            var name2 = cmp.get('v.newAddressName2') || '';
            var careOf = cmp.get('v.newAddressCareOf') || '';
            var street1 = cmp.get('v.newAddressAdjustedStreet1') || '';
            var street2 = cmp.get('v.newAddressAdjustedStreet2') || '';
            var city = cmp.get('v.newAddressAdjustedCity') || '';
            var state = cmp.get('v.newAddressAdjustedState') || '';
            var zipcode = cmp.get('v.newAddressAdjustedZipcode') || '';
    		var country = cmp.get('v.newAddressAdjustedCountry') || '';
            // create address object for the server save
            var addressForServer = this.createAddressForServer(id, name, careOf, street1, street2, city, state, zipcode, country);

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
                id: address.ID,
                name: address.Name,
                name2: address.Name2,
                careOf: address.CareOf,
                street1: address.Address1,
                street2: address.Address2,
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
        createAddressForEvent: function(name, careOf, street1, street2, city, state, zipcode, country){
            return {
                address: {
                    name: name,
                    careOf: careOf,
                    street1: street1,
                    street2: street2,
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
        createAddressForServer: function(id, name, careOf, street1, street2, city, state, zipcode, country){
            return {
                ID: id,
                Name: name,
                CareOf: careOf,
                Address1: street1,
                Address2: street2,
                City: city,
                State: state,
                PostalCode: zipcode,
                country: country
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
            cmp.set('v.newAddressName', '');
            cmp.set('v.newAddressName2', '');
            cmp.set('v.newAddressCareOf', '');
            cmp.set('v.newAddressStreet1', '');
            cmp.set('v.newAddressStreet2', '');
            cmp.set('v.newAddressCity', '');
            cmp.set('v.newAddressState', '');
            cmp.set('v.newAddressZipcode', '');
            cmp.set('v.newAddressCountry', '');
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

    searchAddress : function(cmp)
    {
       cmp.set('v.isLoading', true);
       var self= this;
       // get all the existing shipping addresses
       var params = {
                'SearchText': cmp.get('v.searchAddText') || ''
            };
       var shippingAddresses = this.doCallout(cmp, 'c.searchAddressForCurrentLocation', params);
	   // handle results of the promise
       shippingAddresses.then(function(response){
            var addresses = [];
            
            // create the address objects
            if(response !== undefined && Array.isArray(response)){
                response.forEach(function(item, index){
                    // create address object and add to array
                    var address = self.createAddressForView(item);
                    //if(_primaryAddress){
                        //address.isPrimary = false;
                    //}
                    addresses.push(address);
                    console.log('address----->',address);
                });
            }
            // set view attributes
            cmp.set('v.addresses', addresses);
            cmp.set('v.isLoading', false);                                                                             
            }, 
            function(response){
            console.log('Dal_ChooseShippingAddress:init:shippingAddresses:fail', response);
        });       
    },
})