/**
 * Created by 7Summits on 4/30/18.
 */
({

    submit: function(cmp){
        var store = cmp.get('v.store');
        var currentOrderPos = cmp.get('v.currentOrderPos');
        var type = cmp.get('v.type');

        // get available types
        var pickupType = store.getPickupType();
        var deliveryType = store.getDeliveryType();
        var scheduleByItemType = store.getScheduleByItemType();
        var isLastOrder = store.getIsLastOrder();

        cmp.set('v.typePickup', pickupType);
        cmp.set('v.typeDelivery', deliveryType);
        cmp.set('v.typeScheduleByItem', scheduleByItemType);
        cmp.set('v.isLastOrder', isLastOrder);

        console.log('pickupType: ',pickupType);

        // check the type
        switch(type){
            case pickupType:
                this.handleSubmitPickupAll(cmp, store, currentOrderPos);
                break;
            case deliveryType:
                this.handleSubmitDeliverAll(cmp, store, currentOrderPos);
                break;
            case scheduleByItemType:
                this.handleSubmitScheduleByItem(cmp, store, currentOrderPos);
                break;
        }
    },

    handleSubmitPickupAll: function(cmp, store, currentOrderPos){
        debugger;

        var self = this;
        var promise = store.submitPickupAll(currentOrderPos);

        promise.then(function(response){
            var submittedSkus = self.prepareSkus(cmp, response);
            cmp.set('v.hasSavingError', false);
            cmp.set('v.submittedType', response.submittedType);
            cmp.set('v.submittedSkus', submittedSkus);

            // Save was successful now get the next order.
            var handleGetNextOrder = self.handleGetNextOrder(cmp);
            handleGetNextOrder.finally(function(){
                cmp.set('v.isLoading', false);
            });
        }, function(response){
            self.handleSubmitError(cmp, response);
        });
    },

    handleSubmitDeliverAll: function(cmp, store, currentOrderPos){
        var self = this;
        var promise = store.submitDeliverAll(currentOrderPos);

        promise.then(function(response){
            var submittedSkus = self.prepareSkus(cmp, response);
            cmp.set('v.hasSavingError', false);
            cmp.set('v.submittedType', response.submittedType);
            cmp.set('v.submittedSkus', submittedSkus);

            // Save was successful now get the next order.
            var handleGetNextOrder = self.handleGetNextOrder(cmp);
            handleGetNextOrder.finally(function(){
                var pickupAllType = store.getTabPickupAll();
                store.setActiveTab(pickupAllType);
                cmp.set('v.isLoading', false);
            });

        }, function(response){
            self.handleSubmitError(cmp, response);
        });
    },

    handleSubmitScheduleByItem: function(cmp, store, currentOrderPos){
        var self = this;
        var promise = store.submitScheduleByItem(currentOrderPos);

        promise.then(function(response){
            var submittedSkus = self.prepareSkus(cmp, response);
            cmp.set('v.hasSavingError', false);
            cmp.set('v.submittedType', response.submittedType);
            cmp.set('v.submittedSkus', submittedSkus);

            // Save was successful now get the next order.
            var handleGetNextOrder = self.handleGetNextOrder(cmp);
            handleGetNextOrder.finally(function(){
                var pickupAllType = store.getTabPickupAll();
                store.setActiveTab(pickupAllType);
                cmp.set('v.isLoading', false);
            });

        }, function(response){
            self.handleSubmitError(cmp, response);
        });
    },

    handleGetNextOrder: function(cmp){
        return new Promise($A.getCallback(function (resolve, reject) {
            var store = cmp.get('v.store');
            var isLastOrder = store.getIsLastOrder();

            if(isLastOrder === false){
                store.nextOrderPosition();
                var orderPos = store.getCurrentOrderPosition();
                var getOrderFromServer = store.getOrderFromServer(orderPos);
                getOrderFromServer.finally(function(){
                    resolve();
                });
            } else {
                console.log('nothing to do');
                resolve();
            }
        }));
    },

    prepareSkus: function(cmp, response){
        debugger;
        var type = response.submittedType;
        var preparedSkus = [];

        // get available types
        var pickupType =  cmp.get('v.typePickup');
        var deliveryType = cmp.get('v.typeDelivery');
        var scheduleByItemType = cmp.get('v.typeScheduleByItem');

        // labels
        var labelPickup = cmp.get('v.labelPickup');
        var labelDelivery = cmp.get('v.labelDelivery');
        var labelNotScheduled = cmp.get('v.labelNotScheduled');

        // If type is pickup or delivery
        if(type === pickupType || type === deliveryType){
            response.skus.forEach(function(sku){
                preparedSkus.push({
                    lineNumber: sku.lineNumber,
                    description: sku.description,
                    sku: sku.sku,
                    uom: sku.uom,
                    quantity : sku.quantity,
                    status: (type === pickupType) ? labelPickup : labelDelivery
                });
            });
        } // end if
		
        // if type is schedule by item
        else if(type === scheduleByItemType){
			
            // if type is schedule by item, in order to get the status we will look at the
            // fulfillmentType which will be pickup/delivery or empty
            response.skus.forEach(function(sku){
                preparedSkus.push({
                    lineNumber: sku.lineNumber,
                    description: sku.description,
                    sku: sku.sku,
                    uom: sku.uom,
                    quantity : sku.quantity,
                    status: ((sku.fulfillmentType === pickupType) ? labelPickup : ((sku.fulfillmentType === deliveryType) ? labelDelivery : labelNotScheduled))
                });
            });
        } // end elseIf

        return preparedSkus;
    },

    handleSubmitError: function(cmp, response){
        console.log('Dal_SSC_SchedulePickupDeliveryConfirm:handleSubmitError', response);
        cmp.set('v.hasSavingError', true);
        cmp.set('v.isLoading', false);
    }


})