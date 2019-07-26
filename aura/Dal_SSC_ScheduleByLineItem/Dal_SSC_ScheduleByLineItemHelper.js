/**
 * Created by 7Summits on 5/10/18.
 */
({

    handleStoreUpdate: function(cmp){
        debugger;

        var store = cmp.get('v.store');
        var currentOrder = cmp.get('v.currentOrder');
        var currentOrderPos = store.getCurrentOrderPosition();

        // get the current scheduled fulfillment buckets
        var scheduleByItemScheduled = store.getScheduleByItemPackages(currentOrderPos);

        // get the skus not yet scheduled for a pickup or deliver
        var skusToSchedule = 0;
        if(currentOrder.skus) {

        for(var x=0; x<currentOrder.skus.length; x++){
            if(currentOrder.skus[x].fulfillmentId === undefined){
                skusToSchedule++;
            }
        }

        }
        cmp.set('v.skusToSchedule', skusToSchedule);
        cmp.set('v.activeTab', currentOrder.scheduleByItemActiveTab);
        cmp.set('v.scheduleByItemPackages', scheduleByItemScheduled);

    },

    handleSaveNext: function(cmp){
        
        var store = cmp.get('v.store');
        var baseHelper = store.getHelper();
        var currentOrderPos = store.getCurrentOrderPosition();
        var scheduleByItemType = store.getScheduleByItemType();

        // open modal, which will save order
        baseHelper.openModal(cmp, 'c:Dal_SSC_SchedulePickupDeliveryConfirm', {
            store: store,
            currentOrderPos: currentOrderPos,
            type: scheduleByItemType
        }, false, 'dal-modal_large');
    }

})