/**
 * Created by 7Summits on 5/14/18.
 */
({

    handleStoreUpdate: function(cmp){
        debugger;
        var store = cmp.get('v.store');

        // current order attributes
        var currentOrder = cmp.get('v.currentOrder');
        var skus = currentOrder.skus;
        var sscLocation = currentOrder.sscLocation;

        // store called attributes
        var currentOrderPos = store.getCurrentOrderPosition();
        var pickupType = store.getPickupType();
        var pickupId = store.getScheduleByItemNextId(currentOrderPos, pickupType);
        
        console.log("pickupId",JSON.stringify(pickupId));

        // check how many skus are selected
        var skusSelected = [];
        skus.forEach(function(sku){
            if(sku.selected === true){
                skusSelected.push(sku);
            }
        });

        // set/format the pickup date, if there isn't one set yet
        if(cmp.get('v.pickupDate') === ''){
            this.setPickupDate(cmp, currentOrder.pickupDate);
        }

        var pickupTimesAvailable = store.createPickupTimesByDate(currentOrderPos, cmp.get('v.pickupDate'));

        // set view attributes
        cmp.set('v.pickupId', pickupId.id);
        cmp.set('v.pickupPos', pickupId.pos);
        cmp.set('v.skus', skus);
        cmp.set('v.sscLocation', sscLocation);
        cmp.set('v.skusSelected', skusSelected);
        cmp.set('v.pickupTimesAvailable', pickupTimesAvailable);
        cmp.set('v.pickupFirstName',currentOrder.pickupFirstName);
        cmp.set('v.pickupLastName',currentOrder.pickupLastName);
        cmp.set('v.pickupPhone',currentOrder.pickupPhone);
    },

    handleSavePickup: function(cmp){
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
        var pickupType = store.getPickupType();

        return {
            id: cmp.get('v.pickupId'),
            pickupDate: cmp.get('v.pickupDate'),
            pickupTimeSelected: cmp.get('v.pickupTimeSelected'),
            pickupWhoWill: cmp.get('v.pickupWhoWillValue'),
            pickupFirstName: cmp.get('v.pickupFirstName'),
            pickupLastName: cmp.get('v.pickupLastName'),
            pickupPhone: cmp.get('v.pickupPhone'),
            pickupShouldSendTxt: cmp.get('v.pickupShouldSendTxt'),
            pickupLocation: cmp.get('v.sscLocation'),
            skus: cmp.get('v.skusSelected'),
            scheduleByItemType: pickupType,
            pos: cmp.get('v.pickupPos')
        }
    },

    setPickupDate: function(cmp, dateString){
        if(dateString !== undefined){
            var store = cmp.get('v.store');
            var baseHelper = store.getHelper();
            var pickupDateFormatted = baseHelper.formatPickupDeliveryDate(dateString);
            
            cmp.set('v.pickupDate', dateString);
            cmp.set('v.pickupDateFormatted', pickupDateFormatted);
            cmp.set('v.pickupTimeSelected', undefined);
        }
    },

    updateStore: function(cmp){
        var store = cmp.get('v.store');
        var currentOrderPos = store.getCurrentOrderPosition();

        store.updatePickupToStore(currentOrderPos, {
          pickupDate: cmp.get('v.pickupDate'),
          pickupTimeSelected: cmp.get('v.pickupTimeSelected'),
          pickupWhoWill: cmp.get('v.pickupWhoWillValue'),
          pickupFirstName: cmp.get('v.pickupFirstName'),
          pickupLastName: cmp.get('v.pickupLastName'),
          pickupPhone: cmp.get('v.pickupPhone'),
          pickupShouldSendTxt: cmp.get('v.pickupShouldSendTxt')
        });

        var pickupDateFormatted = $A.localizationService.formatDate(cmp.get('v.pickupDate'), 'EEEE, MMM DD');
        cmp.set('v.pickupDate', cmp.get('v.pickupDate'));
        cmp.set('v.pickupDateFormatted', pickupDateFormatted);
    },

    handlePickupDateChange: function(cmp){
        var store = cmp.get('v.store');
        var currentOrderPos = store.getCurrentOrderPosition();
        var pickupDate = cmp.get('v.pickupDate');
        

        // is pickup date valid
        var results = store.isPickupDateValid(currentOrderPos, pickupDate);

        // set pickup date to store, will update store, so component will update
        if(results.isValid === true){
            cmp.set('v.pickupTimeSelected', undefined);
            store.updatePickupTimesByDate(currentOrderPos, pickupDate);
            this.updateStore(cmp);
            this.setPickupDate(cmp, pickupDate);
        }else{
            store.updatePickupTimesByDate(currentOrderPos, pickupDate);
        }
        var currentOrder = store.getOrders();

        // set/reset the errors
        cmp.set('v.pickupDateErrors', results.errors || []);
        cmp.set('v.pickupTimesAvailable',currentOrder[currentOrderPos].pickupTimesAvailable);
    },

    isFormValid: function(cmp){
        var store = cmp.get('v.store');
        var baseHelper = store.getHelper();

        // check pickup date
        var pickupDate = cmp.get('v.pickupDate');
        var hasPickupDate = (pickupDate !== undefined && pickupDate !== '');

        // check pickup selected
        var pickupTimeSelected = cmp.get('v.pickupTimeSelected');
        var hasPickupTimeSelected = (pickupTimeSelected !== undefined && pickupTimeSelected !== '');

        // if pickup  date isn't selected show message
        cmp.set('v.pickupTimeErrors', (hasPickupTimeSelected === false) ? [{message: 'Pickup time required'}] : []);

        // validate input fields
        var formInputs = ['pickupFirstName', 'pickupLastName', 'pickupPhone'];
        var lightningInputValid = baseHelper.validateForm(cmp, null, formInputs, true);

        return (hasPickupDate && hasPickupTimeSelected && lightningInputValid);
    },

    resetData: function(cmp){
        cmp.set('v.pickupId', '');
        cmp.set('v.pickupPos', '');
        cmp.set('v.skus', []);
        cmp.set('v.skusSelected', []);
        cmp.set('v.sscLocation', {});
        cmp.set('v.pickupDate', '');
        cmp.set('v.pickupDateFormatted', '');
        cmp.set('v.pickupDateErrors', []);
        cmp.set('v.pickupTimesAvailable', []);
        cmp.set('v.pickupTimeSelected', '');
        cmp.set('v.pickupTimeErrors', []);
        cmp.set('v.pickupWhoWillValue', 'me');
        cmp.set('v.pickupFirstName', '');
        cmp.set('v.pickupLastName', '');
        cmp.set('v.pickupPhone', '');
        cmp.set('v.pickupShouldSendTxt', undefined);
    }

})