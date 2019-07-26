/**
 * Created by ranja on 22-08-2018.
 */
({
    doInitAddress: function(cmp,event,helper){
        //console.log('INIT DATA HANDLER IN HELPER');
        cmp.set('v.isLoading', true);

        var self = this;

        // used for the add new address
        var states = helper.getStatesOptions();
        cmp.set('v.states', states);
        //console.log('States--> ' , states);


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

        // get all the existing shipping addresses
        var shippingAddresses = helper.doCallout(cmp, 'c.getShipToAddressWrappersForCurrentLocation', {});

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
                    if(address.isPrimary) {
                        var shippingAddress = helper.setPrimaryAddress(cmp, address.name, address.careOf, address.street1, address.street2, address.city,
                                        address.state, address.zipcode, address.country);
                    }
                    addresses.push(address);
                    if(address.isPrimary) {
                        cmp.set('v.selectedAddress',address);
                    }
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

    setPrimaryAddress : function(cmp, name, careOf, street1, street2, city, state, zipcode, country){
        cmp.set('v.shipToName', name);
        cmp.set('v.shipToCareOf', careOf);
        cmp.set('v.shipToStreet1', street1);
        cmp.set('v.shipToStreet2', street2);
        cmp.set('v.shipToCity', city);
        cmp.set('v.shipToState', state);
        cmp.set('v.shipToZipcode', zipcode);
        cmp.set('v.shipToCountry', country);
    },


    createDefaultAddress : function(name, careOf, street1, street2, city, state, zipcode, country){
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

     showtoast : function(_msg, _type){
        var _toastEvent = $A.get("e.force:showToast");
        _toastEvent.setParams({
            message: _msg,
            type : _type,
        });
        _toastEvent.fire();
     },

/*
     isFormValid : function(cmp){

         var canShipSmallPackage = cmp.get('v.canShipSmallPackage');

         // fields to validate
         var fieldsToValidate = ['shipCompleteInput', 'poNumberInput'];

         // if the user can ship small package we need to add a field to validate
         if(canShipSmallPackage === true){
             fieldsToValidate.push('shipSmallPackageInput');
         }

         // call the validation helper
         return helper.validateForm(cmp, null, fieldsToValidate, true);
     }
*/
})