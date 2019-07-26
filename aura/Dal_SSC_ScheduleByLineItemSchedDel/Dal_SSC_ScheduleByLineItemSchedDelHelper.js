/**
 * Created by 7Summits on 5/14/18.
 */
({

    handleStoreUpdate: function(cmp){
        var store = cmp.get('v.store');

        // current order attributes
        var currentOrder = cmp.get('v.currentOrder');
        var skus = currentOrder.skus;

        // store called attributes
        var currentOrderPos = store.getCurrentOrderPosition();
        var deliveryType = store.getDeliveryType();
        var deliveryId = store.getScheduleByItemNextId(currentOrderPos, deliveryType);

        // check how many skus are selected
        var skusSelected = [];
        if(skus) { 
            skus.forEach(function(sku){
                if(sku.selected === true){
                    skusSelected.push(sku);
                }
            });
        }

        // set/format the delivery date, if there isn't one set yet
        if(cmp.get('v.deliveryDate') === ''){
            this.setDeliveryDate(cmp, currentOrder.deliveryDate);
        }

        // set delivery location, if there isn't one set yet
        if(cmp.get('v.shipToStreet1') === ''
            || cmp.get('v.shipToCity') === ''
            || cmp.get('v.shipToState') === ''
            || cmp.get('v.shipToZipcode') === ''
            || cmp.get('v.shipToCountry') === ''){
            this.setDeliveryLocation(cmp, currentOrder.deliveryLocation);
        }

        cmp.set('v.deliveryId', deliveryId.id);
        cmp.set('v.deliveryPos', deliveryId.pos);
        cmp.set('v.skus', skus);
        cmp.set('v.skusSelected', skusSelected);
    },

    handleSaveDelivery: function(cmp){
    	
        // valid form
        var isValid = this.isFormValid(cmp);

        if(isValid === true){
            var store = cmp.get('v.store');
            var baseHelper = store.getHelper();
            var currentOrderPos = store.getCurrentOrderPosition();

            // create data object
            var scheduleData = this.createScheduleData(cmp);

            // reset page data
            this.resetData(cmp);

            // update the store
            store.saveToStoreScheduleByItem(currentOrderPos, scheduleData);
        }

    },

    createScheduleData: function(cmp){
    
        var store = cmp.get('v.store');
        var deliveryType = store.getDeliveryType();

        return {
            id: cmp.get('v.deliveryId'),
            deliveryDate: cmp.get('v.deliveryDate'),
            shipToName: cmp.get('v.shipToName'),
            shipToName2: cmp.get('v.shipToName2'),
            shipToCareOf: cmp.get('v.shipToCareOf'),
            shipToStreet1: cmp.get('v.shipToStreet1'),
            shipToStreet2: cmp.get('v.shipToStreet2'),
            shipToCity: cmp.get('v.shipToCity'),
            shipToState: cmp.get('v.shipToState'),
            shipToZipcode: cmp.get('v.shipToZipcode'),
            shipToCountry: cmp.get('v.shipToCountry'),
            skus: cmp.get('v.skusSelected'),
            scheduleByItemType: deliveryType,
            pos: cmp.get('v.deliveryPos')
        }
    },

   handleDeliveryChange: function(cmp){
       var store = cmp.get('v.store');
       var currentOrderPos = store.getCurrentOrderPosition();
       var deliveryDate = cmp.find('requestPickupDate').get('v.value');

       var tempDate = new Date(deliveryDate);
        var baseHelper = store.getHelper();
       cmp.set('v.deliveryDate',deliveryDate);
        var deliveryDateFormatted = baseHelper.formatPickupDeliveryDate(deliveryDate);

       if(tempDate.getUTCDay() == 6 || tempDate.getUTCDay() == 0){
              //don't remove below line, this is to stop selecting weekends
              deliveryDate.getUTCDay();
       }else{
           // is pickup date valid
           var results = store.isDeliveryDateValid(currentOrderPos, deliveryDate);
        cmp.set('v.deliveryDateFormatted',deliveryDateFormatted);
           // set pickup date to store, will update store, so component will update
           if(results.isValid === true){
               this.setDeliveryDate(cmp, deliveryDate);
           }

           // set/reset the errors
           cmp.set('v.deliveryDateErrors', results.errors || []);
       }

       // is pickup date valid
/*        var results = store.isDeliveryDateValid(currentOrderPos, deliveryDate);

       // set pickup date to store, will update store, so component will update
       if(results.isValid === true){
           this.setDeliveryDate(cmp, deliveryDate);
       }*/

       // set/reset the errors
       cmp.set('v.deliveryDateErrors', results.errors || []);
   },

    setDeliveryDate: function(cmp, dateString){
        debugger;
        if(dateString !== undefined){
            var store = cmp.get('v.store');
            var baseHelper = store.getHelper();
            var deliveryDateFormatted = baseHelper.formatPickupDeliveryDate(dateString);

            cmp.set('v.deliveryDate', dateString);
            cmp.set('v.deliveryDateFormatted', deliveryDateFormatted);
        }
    },

    setDeliveryLocation: function(cmp, deliveryLocation){
        console.log('Set delivery location:');
        console.log('deliveryLocation',deliveryLocation);
        cmp.set('v.shipToName', deliveryLocation.name);
        cmp.set('v.shipToName2', deliveryLocation.name2);
        cmp.set('v.shipToCareOf', deliveryLocation.careOf);
        cmp.set('v.shipToStreet1', deliveryLocation.streetAddress1);
        cmp.set('v.shipToStreet2', deliveryLocation.streetAddress2);
        cmp.set('v.shipToCity', deliveryLocation.city);
        cmp.set('v.shipToState', deliveryLocation.state);
        cmp.set('v.shipToZipcode', deliveryLocation.zipCode);
        cmp.set('v.shipToCountry', deliveryLocation.country);
    },

    isFormValid: function(cmp){
        // check delivery date
        var deliveryDate = cmp.get('v.deliveryDate');
        var hasDeliveryDate = (deliveryDate !== undefined && deliveryDate !== '');

        // has shipping address
        var streetAddress1 = cmp.get('v.shipToStreet1');
        var city = cmp.get('v.shipToCity');
        var state = cmp.get('v.shipToState');
        var zipCode = cmp.get('v.shipToZipcode');
        var country = cmp.get('v.shipToCountry');

        var hasDeliveryAddress = ((streetAddress1 !== undefined && streetAddress1 !== '')
            && (city !== undefined && city !== '')
            && (state !== undefined && state !== '')
            && (zipCode !== undefined && zipCode !== '')
            && (country !== undefined && country !== '')
        );

        return (hasDeliveryDate && hasDeliveryAddress);
    },

    resetData: function(cmp){
        cmp.set('v.deliveryId', '');
        cmp.set('v.deliveryPos', '');
        cmp.set('v.skus', []);
        cmp.set('v.skusSelected', []);
        cmp.set('v.deliveryDate', '');
        cmp.set('v.deliveryDateFormatted', '');
        cmp.set('v.deliveryDateErrors', []);
        cmp.set('v.shipToName', '');
        cmp.set('v.shipToName2', '');
        cmp.set('v.shipToCareOf', '');
        cmp.set('v.shipToStreet1', '');
        cmp.set('v.shipToStreet2', '');
        cmp.set('v.shipToCity', '');
        cmp.set('v.shipToState', '');
        cmp.set('v.shipToZipcode', '');
        cmp.set('v.shipToCountry', '');
    }

})