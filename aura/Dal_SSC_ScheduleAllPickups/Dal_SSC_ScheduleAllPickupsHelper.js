/**
 * Created by 7Summits on 4/26/18.
 */
({

    handleStoreUpdate: function(cmp){
        debugger;
        var store = cmp.get('v.store');
        var currentOrder = cmp.get('v.currentOrder');
        var currentOrderPos = store.getCurrentOrderPosition();


        // set/format the pickup date
        var pickupTimesAvailable = [];
        //pickupTimesAvailable = store.updatePickupTimesByDate(currentOrderPos, currentOrder.pickupDate);




        this.setPickupDate(cmp, currentOrder.pickupDate, currentOrder.pickupTimesAvailable);
        console.log('currentOrder.pickupTimesAvailable',currentOrder.pickupTimesAvailable);
        // set/format the pickup times available and selected time
        cmp.set('v.pickupTimeSelected', currentOrder.pickupTimeSelected);
        cmp.set('v.pickupWhoWillValue', currentOrder.pickupWhoWill);
        cmp.set('v.pickupShouldSendTxt', currentOrder.pickupShouldSendTxt);

        //clear value if pickup is by other and set values if its by self
        if(currentOrder.pickupWhoWill == 'me'){
            cmp.set('v.pickupFirstName', currentOrder.pickupFirstName);
            cmp.set('v.pickupLastName', currentOrder.pickupLastName);
            cmp.set('v.pickupPhone', currentOrder.pickupPhone);
        }
        if(currentOrder.pickupWhoWill == 'other'){
            cmp.set('v.pickupFirstName', '');
            cmp.set('v.pickupLastName', '');
            cmp.set('v.pickupPhone', '');
        }
		var pageUrl = window.location.href;
        var _url = new URL(pageUrl).searchParams.get("futuredate");
        var flag = false;
        var rescheduleType = new URL(pageUrl).searchParams.get("scheduleType") || 'pickupAll';
        cmp.set('v.activeTab',rescheduleType);
        
        if(_url){
            var _urlStr = _url.toString();
            var _pickDate = _urlStr.substring(0,4)+"-"+_urlStr.substring(4,6)+"-"+_urlStr.substring(6,8);
            
            var pickNewDate = new Date(_pickDate);
            if(pickNewDate > Date.now()){
                cmp.set("v.tempPickDate",_pickDate);
                flag = true;
            }
        }
      
        var _tempPickDate = cmp.get("v.tempPickDate");    
        if(flag){
            var baseHelper = store.getHelper();
            for(var i=0 ; i<currentOrder.pickupTimesAvailable.length ; i++){
                currentOrder.pickupTimesAvailable[i].disabled = false;
            }
            this.setPickupDate(cmp, currentOrder.pickupDate, currentOrder.pickupTimesAvailable);
            var dateFormatted1 = baseHelper.formatPickupDeliveryDate(_pickDate);
            cmp.set("v.pickupDateFormatted",dateFormatted1);
            cmp.set('v.pickupDate',_pickDate);
            cmp.set("v.tempPickDate",""); 
        }
        
    },

    updateStore: function(cmp){
        debugger;
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

        //var pickupDateFormatted = $A.localizationService.formatDate(cmp.get('v.pickupDate'), 'EEEE, MMM DD');

        // In place above commented which provide us formated date with standard function we use this custom one because its not f=give correct one..
        var dateString = cmp.get('v.pickupDate');

        var _getDay = ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'];
        var _getMonth = ['Jan','Feb','Mar','Apr','May','June','July','Aug','Sept','Oct','Nov','Dec'];
        /*
        var _convertedDate = new Date(Date.UTC(dateString));
        var _newDate = _convertedDate.getDate();
        */
        var d=dateString.split("-")
        if(d[2].indexOf('T') > -1){
           d[2] = d[2].substring(0, d[2].indexOf('T'));
        }
        var newDateByString = new Date(d[0],d[1]-1,d[2]);

        var dateFormatted1 =  _getDay[(newDateByString.getDay())] + ', ' + _getMonth[(newDateByString.getMonth())] + ' ' + newDateByString.getDate(); //( _newDate > 9 ? _newDate : ('0'+_newDate));

        cmp.set('v.pickupDate', cmp.get('v.pickupDate'));
        cmp.set('v.pickupDateFormatted', dateFormatted1);
    },

    handleSaveNext: function(cmp){
        // valid form
        debugger;
        var isValid = this.isFormValid(cmp);

        if(isValid){
            var store = cmp.get('v.store');
            var baseHelper = store.getHelper();
            var currentOrderPos = store.getCurrentOrderPosition();
            var pickupType = store.getPickupType();

            // open modal, which will save order
            baseHelper.openModal(cmp, 'c:Dal_SSC_SchedulePickupDeliveryConfirm', {
                store: store,
                currentOrderPos: currentOrderPos,
                type: pickupType
            }, false, 'dal-modal_large');
        }
    },

   handleSingleCall: function(cmp){
       var store = cmp.get('v.store');
       var total = cmp.get('v.totalOrdersToSchedule');
       var action = cmp.get("c.getMultipleOrder");

       var orderInfo = store.getOrderInfo();
       console.log('Order Info: ',orderInfo);
       console.log('Store: ', store.getOrders());
       /*
       action.setParams({

       });
       action.setCallback(this, function(response) {
           var state = response.getState();
           if (state === "SUCCESS") {
               console.log("Sucess");
           }
           else if (state === "INCOMPLETE") {
               console.log()
           }
               else if (state === "ERROR") {

               }
       });
       $A.enqueueAction(action);
       */
   },

     handleSaveDiff: function(cmp,event,helper){
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
            orderDetail.scheduleType = "PICK";
            orderNumbers.push(orderDetail.orderNumber);
            listOfOrderDetail.push(orderDetail);
        }
        cmp.set('v.listOfOrders',orderNumbers);
        console.log('Params send: ',listOfOrderDetail);
        console.log('Order Numbers: ',orderNumbers );
        store.submitPickupAllInOne(listOfOrderDetail,orderNumbers,cmp,helper);
        }
     },

    handlePickupDateChange: function(cmp){
        debugger;
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
        }else{
             store.updatePickupTimesByDate(currentOrderPos, pickupDate);
        }
        var currentOrder = store.getOrders();

        // set/reset the errors
        cmp.set('v.pickupDateErrors', results.errors || []);
        cmp.set('v.pickupTimesAvailable',currentOrder[currentOrderPos].pickupTimesAvailable);
    },

    setPickupDate: function(cmp, dateString, pickupTimesAvailable){

        console.log('dalSSCScheduleAllPickups:setPickupDate:', dateString, pickupTimesAvailable);
        if(dateString !== undefined){
            var store = cmp.get('v.store');
            var baseHelper = store.getHelper();
            var pickupDateFormatted = baseHelper.formatPickupDeliveryDate(dateString);

            cmp.set('v.pickupDate', dateString);
            cmp.set('v.pickupDateFormatted', pickupDateFormatted);
            if(pickupTimesAvailable !== undefined && Array.isArray(pickupTimesAvailable)){
                cmp.set('v.pickupTimesAvailable', pickupTimesAvailable);
            }

        }
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


})