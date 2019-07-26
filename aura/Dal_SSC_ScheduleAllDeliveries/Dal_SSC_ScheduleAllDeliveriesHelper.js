/**
 * Created by 7Summits on 4/30/18.
 */
({

    handleStoreUpdate: function(cmp){
        debugger;
        var currentOrder = cmp.get('v.currentOrder');
		var store = cmp.get('v.store');
        var deliveryDate;
        // set/format the pickup date
        if(cmp.get('v.isReschedule')){
            deliveryDate = cmp.find('requestPickupDate').get('v.value');
            if(deliveryDate != '' && deliveryDate != undefined){
                deliveryDate = deliveryDate.substring(0,4)+"/"+deliveryDate.substring(5,7)+"/"+deliveryDate.substring(8,10);
            }
            
        }else{
            deliveryDate = currentOrder.deliveryDate;
            cmp.set('v.dlDate',deliveryDate);
        }
        //var deliveryDate = //cmp.find('requestPickupDate').get('v.value');
        
        if(deliveryDate)
        	currentOrder.deliveryDate = deliveryDate;
        
        if(currentOrder.deliveryDate)
            this.setDeliveryDate(cmp, currentOrder.deliveryDate);
        if(currentOrder.deliveryDate)
            this.setDeliveryLocation(cmp, currentOrder.deliveryLocation);
        
        var pageUrl = window.location.href;
        var flag = false;
        var isFirstTime = cmp.get('v.isFirstTime');
        
        
        var _url = new URL(pageUrl).searchParams.get("futuredate");
        if(_url && isFirstTime){ 
            var _urlStr = _url.toString();
            var _dlDate = _urlStr.substring(0,4)+"-"+_urlStr.substring(4,6)+"-"+_urlStr.substring(6,8);
            var _pickDate = _urlStr.substring(0,4)+"/"+_urlStr.substring(4,6)+"/"+_urlStr.substring(6,8);
            var pickNewDate = new Date(_pickDate);
            
            if(pickNewDate > Date.now()){
                cmp.set("v.tempDeliveryDate",_pickDate);
                flag = true;
            }
            
        }
        //var load = window.onload();
        var _deliveryDate = cmp.get("v.tempDeliveryDate");
        if(flag){
            
            var baseHelper = store.getHelper();
            var dateFormatted1 = baseHelper.formatPickupDeliveryDate(_pickDate);
            cmp.set("v.deliveryDateFormatted",dateFormatted1);
            cmp.set('v.deliveryDate',_pickDate);
            cmp.set('v.dlDate',_dlDate);
            cmp.set("v.tempDeliveryDate","");  
        }
        
    },

    updateStore: function(cmp){
        var store = cmp.get('v.store');
        var currentOrderPos = store.getCurrentOrderPosition();

        store.updateDeliveryToStore(currentOrderPos, {
            deliveryDate: cmp.get('v.deliveryDate'),
            deliveryLocation: {
                name: cmp.get('v.shipToName'),
                name2: cmp.get('v.shipToName2'),
                careOf: cmp.get('v.shipToCareOf'),
                streetAddress1: cmp.get('v.shipToStreet1'),
                streetAddress2: cmp.get('v.shipToStreet2'),
                city: cmp.get('v.shipToCity'),
                state: cmp.get('v.shipToState'),
                zipCode: cmp.get('v.shipToZipcode'),
                country: cmp.get('v.shipToCountry')
            }
        });
    },

    handleSaveDiff: function(cmp,evt, helper){
        debugger;
        // valid form
         var isValid = this.isFormValid(cmp);
         if(isValid){
        var store = cmp.get('v.store');
        var total = cmp.get('v.totalOrdersToSchedule');
        var orders = store.getOrders();
        //console.log('Orders: ', store.getOrders());
        cmp.set('v.showSpinner',true);
        var listOfOrderDetail = [];
        var orderNumbers = [];
        for(var i=0;i<orders.length;i++) {
            var orderDetail = {};
            orderDetail = orders[i];
            orderDetail.scheduleType = "SHP";
            orderNumbers.push(orderDetail.orderNumber);
            listOfOrderDetail.push(orderDetail);
        }

        console.log('Params send: ',listOfOrderDetail);
        console.log('Order Numbers: ',orderNumbers );
        store.submitPickupAllInOne(listOfOrderDetail,orderNumbers,cmp,helper);
    }
     },


    handleSaveNext: function(cmp){
        // valid form
        var isValid = this.isFormValid(cmp);
        if(isValid === true){
            var store = cmp.get('v.store');
            var baseHelper = store.getHelper();
            var currentOrderPos = store.getCurrentOrderPosition();
            var deliveryType = store.getDeliveryType();

            // open modal, which will save order
            baseHelper.openModal(cmp, 'c:Dal_SSC_SchedulePickupDeliveryConfirm', {
                store: store,
                currentOrderPos: currentOrderPos,
                type: deliveryType
            }, false, 'dal-modal_large');
        }
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
        if(deliveryLocation) {
            
            cmp.set('v.shipToName', deliveryLocation.name);
            cmp.set('v.shipToName2', deliveryLocation.name2);
            cmp.set('v.shipToCareOf', deliveryLocation.careOf);
            cmp.set('v.shipToStreet1', deliveryLocation.streetAddress1);
            cmp.set('v.shipToStreet2', deliveryLocation.streetAddress2);
            cmp.set('v.shipToCity', deliveryLocation.city);
            cmp.set('v.shipToState', deliveryLocation.state);
            cmp.set('v.shipToZipcode', deliveryLocation.zipCode);
            cmp.set('v.shipToCountry', deliveryLocation.country);
            
        }
    },

    handleDeliveryChange: function(cmp, evt){
        debugger;
        var store = cmp.get('v.store');
        var currentOrderPos = store.getCurrentOrderPosition();
         var deliveryDate = cmp.find('requestPickupDate').get('v.value');
        var tempDate = new Date(deliveryDate);
        var baseHelper = store.getHelper();
        
        
        if(tempDate.getUTCDay() == 6 || tempDate.getUTCDay() == 0){
               //don't remove below line, this is to stop selecting weekends
               cmp.set('v.isFirstTime', true);
               console.log(' deliveryDate.getUTCDay();', deliveryDate.getUTCDay());
               //deliveryDate.getUTCDay();
            	
            console.log('In If');
        }else{
            cmp.set('v.deliveryDate',deliveryDate);
            cmp.set('v.isFirstTime', false);
            var deliveryDateFormatted = baseHelper.formatPickupDeliveryDate(deliveryDate);
            // is pickup date valid
            var results = store.isDeliveryDateValid(currentOrderPos, deliveryDate);
            console.log('In Else');
            // set pickup date to store, will update store, so component will update
            //console.log('Date String',deliveryDateFormatted );
            cmp.set('v.deliveryDateFormatted',deliveryDateFormatted);
            if(results.isValid === true){
                this.updateStore(cmp);
            }

            // set/reset the errors
            cmp.set('v.deliveryDateErrors', results.errors || []);
        }
    },

    isFormValid: function(cmp){
        // check delivery date
        console.log('checking form valid');
        var deliveryDate = cmp.get('v.deliveryDate');
        var hasDeliveryDate = (deliveryDate !== undefined && deliveryDate !== '');
		console.log('checking form valid--hasDeliveryDate--'+hasDeliveryDate);
        // has shipping address
        var streetAddress1 = cmp.get('v.shipToStreet1');
        var city = cmp.get('v.shipToCity');
        var state = cmp.get('v.shipToState');
        var zipCode = cmp.get('v.shipToZipcode');
        console.log('address--'+streetAddress1+'--'+city+'--'+state+'--'+zipCode);

        var hasDeliveryAddress = ((city !== undefined && city !== '')
            && (state !== undefined && state !== '')
            && (zipCode !== undefined && zipCode !== '')
        );
		console.log('checking form valid--hasDeliveryAddress--'+hasDeliveryAddress);
        return (hasDeliveryDate && hasDeliveryAddress);
    }

})