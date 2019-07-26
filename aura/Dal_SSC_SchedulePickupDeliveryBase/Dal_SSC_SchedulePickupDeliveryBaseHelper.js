/**
 * Created by 7Summits on 4/26/18.
 */
({

    paramOrderIds: 'orderIds',

    /**
     * Initialize the quick order process. Will be checking the URL to determine if we aree
     * starting from a draft order, if not, we will then check to see if there is a open order
     * in the current session, if not, we will start a new session order.
     * @param cmp
     */
    initStore: function (cmp) {
         debugger;
        //reschedule
        var pageUrl = window.location.href;

        var hashIndex = pageUrl.lastIndexOf('#');
        if(hashIndex) {

            var selectedProductType = pageUrl.substring(hashIndex+1,pageUrl.length);

            if(selectedProductType == 'reschedule') {
             cmp.set("v.isReschedule",true);
            } else {
                cmp.set("v.isReschedule",false);
            }
            if(selectedProductType == 'multiple') {
               cmp.set('v.isMultiple',true);
            } else {
               cmp.set('v.isMultiple',false);
            }

        } else {
            cmp.set("v.isReschedule",false);
            cmp.set('v.isMultiple',false);
        }

        var self = this;

        // get the url params and generate orderNumber list
        var orderNumbers = this.getUrlParamByName(this.paramOrderIds);

        var orderNumbersList = (orderNumbers !== null) ? orderNumbers.split(',') : [];

        // make sure we have order numbers to schedule
        if(orderNumbersList.length > 0){
            var store = self.createStore(cmp, self);

            orderNumbersList.forEach(function(order){
                var placeholderOrder = store.createPlaceholderOrder(order);
                store.addOrderToStore(placeholderOrder);
            });

            // init the first order
            var getOrderFromServer = store.getOrderFromServer(0);

            getOrderFromServer.then(function(){
                cmp.set('v.isPickupDeliveryBaseLoading', false);
            }, function(response){
                console.log('Dal_SSC_SchedulePickupDeliveryBase:initStore:error', response);
            });

        } // end check for order numbers

        else {
            console.log('Dal_SSC_SchedulePickupDeliveryBase:initStore:error:no order numbers');
        }

    },

    /**
     * Create store which will control state of the application
     * @param cmp
     * @param self
     * @returns {{getHelper: getHelper}}
     */
    createStore: function(cmp, self){

        // -----------------------------------------------------
        // Private Variables
        // -----------------------------------------------------

        // reference to the Dal Base Helpers
        var helper = self;

        // current order the user is current interacting with
        var currentOrderPosition = 0;

        // is a server request in process
        var isLoading = false;

        // all orders the user selected
        var orders = [];

        // views active tab
        var activeTab = 'pickupAll';

        // -----------------------------------------------------
        // constants
        // -----------------------------------------------------

            // main tabs
            var TAB_PICKUPALL = 'pickupAll';
            var TAB_DELIVERALL = 'deliverAll';
            var TAB_SCHEDULEBYLINEITEM = 'scheduleByLineItem';

            // schedule by line item tabs
            var TAB_SELECTITEMS = 'selectItems';

            // schedule types
            var TYPE_PICKUP = 'pickup';
            var TYPE_DELIVERY = 'delivery';
            var TYPE_SCHEDULEBYITEM = 'scheduleByItem';

        // -----------------------------------------------------
        // Model Data
        // -----------------------------------------------------

            /**
             * Create default orderInfo model object
             * @param order
             * @param deliveryLocation
             * @returns {object}
             */
            function createOrder(order, deliveryLocation){
//                
                // if order info is undefined set it to empty
                order = order || {};

                // create the skus
                var skus = [];
                if(order.OrderLineWrappers !== undefined && Array.isArray(order.OrderLineWrappers)){
                    order.OrderLineWrappers.forEach(function(orderLine){
                        var orderLine = createSku(orderLine);
                        skus.push(orderLine);
                    });
                }

                // create pickup/delivery date objects
                var pickupDateObject = initPickupDate(order);
                var deliveryDateObject = createDeliveryDate(order);
				console.log('pickupDateObject',pickupDateObject);
                // create delivery location
                var formattedDeliveryLocation = createDeliveryLocation({
                    name: order.FFLocationName,
                    name2: order.FFLocationName2,
                    careOf: order.FFLocationline3,
                    streetAddress1: order.FFLocationline1,
                    streetAddress2: deliveryLocation.FFLocationline2,
                    city: order.FFLocationCity,
                    state: order.FFLocationState,
                    zipCode: order.FFLocationZIP,
                    country: order.FFLocationCountry

                });

                return {
					
                    // general attributes
                    submitted: false,
                    submittedType: undefined,
                    orderNumber: order.OrderNumber,
                    salesOrderKey: order.SalesOrderKey,
                    poNumber: order.PurchaseOrder,
                    jobName: order.JobName,
                    skus: skus,
                    sscLocation: createSscLocation(order),
                    mfstarthours: order.mfstarthours,
                    mfendhours: order.mfendhours,
                    satstarthours: order.satstarthours,
                    satendhours: order.satendhours,
                    sunstarthours: order.sunstarthours,
                    sunendhours: order.sunendhours,
                    mfAppointStartHours : order.mfAppointStartHours,
                    mfAppointEndhours : order.mfAppointEndhours,
                    satAppointStarthours : order.satAppointStarthours, 
                    satAppointEndhours : order.satAppointEndhours, 
                    sunAppointStarthours : order.sunAppointStarthours, 
                    sunAppointEndhours : order.sunAppointEndhours, 
                    


                    // pickup order attributes
                    pickupDate: pickupDateObject.pickupDate,
                    pickupDateEarliestDate: pickupDateObject.pickupDateEarliestDate,
                    pickupTimesAvailable: pickupDateObject.pickupTimesAvailable,
                    pickupTimeSelected: order.pickupTimeSelected,
                    pickupWhoWill: order.pickupWhoWill || 'me',
                    pickupFirstName: order.pickupFirstName,
                    pickupLastName: order.pickupLastName,
                    pickupPhone: order.pickupPhone,
                    pickupShouldSendTxt: order.pickupShouldSendTxt || false,

                    // delivery order attributes
                    deliveryDate: deliveryDateObject.deliveryDate,
                    deliveryDateEarliestDate: deliveryDateObject.deliveryDateEarliestDate,
                    deliveryLocation: formattedDeliveryLocation,

                    // schedule by line item attributes
                    scheduleByItemPackages: [],
                    scheduleByItemActiveTab: 'selectItems',
                    scheduleByItemType: 'pickup'
                }
            }

            /**
             *
             * @param pickupTime
             * @param disabled
             * @returns {{label: undefined, value: undefined, disabled: boolean}}
             */
            function createTimeObject(pickupTime, disabled){

                // map for each hour of the day
                var label = undefined;
                var labelHour = undefined;
                var value = undefined;
                switch(pickupTime){
                    case 0:
                        label = '12:00 AM';
                        labelHour = '12AM';
                        value = '0:00';
                        break;
                    case 1:
                        label = '1:00 AM';
                        labelHour = '1AM';
                        value = '1:00';
                        break;
                    case 2:
                        label = '2:00 AM';
                        labelHour = '2AM';
                        value = '2:00';
                        break;
                    case 3:
                        label = '3:00 AM';
                        labelHour = '3AM';
                        value = '3:00';
                        break;
                    case 4:
                        label = '4:00 AM';
                        labelHour = '4AM';
                        value = '4:00';
                        break;
                    case 5:
                        label = '5:00 AM';
                        labelHour = '5AM';
                        value = '5:00';
                        break;
                    case 6:
                        label = '6:00 AM';
                        labelHour = '6AM';
                        value = '6:00';
                        break;
                    case 7:
                        label = '7:00 AM';
                        labelHour = '7AM';
                        value = '7:00';
                        break;
                    case 8:
                        label = '8:00 AM';
                        labelHour = '8AM';
                        value = '8:00';
                        break;
                    case 9:
                        label = '9:00 AM';
                        labelHour = '9AM';
                        value = '9:00';
                        break;
                    case 10:
                        label = '10:00 AM';
                        labelHour = '10AM';
                        value = '10:00';
                        break;
                    case 11:
                        label = '11:00 AM';
                        labelHour = '11AM';
                        value = '11:00';
                        break;
                    case 12:
                        label = '12:00 PM';
                        labelHour = '12PM';
                        value = '12:00';
                        break;
                    case 13:
                        label = '1:00 PM';
                        labelHour = '1PM';
                        value = '13:00';
                        break;
                    case 14:
                        label = '2:00 PM';
                        labelHour = '2PM';
                        value = '14:00';
                        break;
                    case 15:
                        label = '3:00 PM';
                        labelHour = '3PM';
                        value = '15:00';
                        break;
                    case 16:
                        label = '4:00 PM';
                        labelHour = '4PM';
                        value = '16:00';
                        break;
                    case 17:
                        label = '5:00 PM';
                        labelHour = '5PM';
                        value = '17:00';
                        break;
                    case 18:
                        label = '6:00 PM';
                        labelHour = '6PM';
                        value = '18:00';
                        break;
                    case 19:
                        label = '7:00 PM';
                        labelHour = '7PM';
                        value = '19:00';
                        break;
                    case 20:
                        label = '8:00 PM';
                        labelHour = '8PM';
                        value = '20:00';
                        break;
                    case 21:
                        label = '9:00 PM';
                        labelHour = '9PM';
                        value = '21:00';
                        break;
                    case 22:
                        label = '10:00 PM';
                        labelHour = '10PM';
                        value = '22:00';
                        break;
                    case 23:
                        label = '11:00 PM';
                        labelHour = '11PM';
                        value = '23:00';
                        break;
                }

                return {
                    label: label,
                    labelHour: labelHour,
                    value: value,
                    disabled: disabled || false
                }
            }

            /**
             * Given a list of server sku object will return a formatted list of skus for the view
             */
            function createSku(orderLine){
                return {
                    lineNumber: orderLine.LineNumber,
                    lineKey: orderLine.linekey,
                    quantity: orderLine.Quantity,
                    description: orderLine.SkuName,
                    sku: orderLine.SkuNumber,
                    uom: orderLine.UOM,
                    status: orderLine.status,
                    fulfillmentType: undefined,
                    fulfillmentPos: undefined,
                    fulfillmentId: undefined,
                    selected: false
                };
            }

            /**
             * Given a ssc location format for the view
             */
            function createSscLocation(sscLocation){
                // format store hours
                var mfStartHour = formatStoreHour(sscLocation.mfstarthours);
                var mfEndHour = formatStoreHour(sscLocation.mfendhours);
                var satStartHour = formatStoreHour(sscLocation.satstarthours);
                var satEndHour = formatStoreHour(sscLocation.satendhours);
                var sunStartHour = formatStoreHour(sscLocation.sunstarthours);
                var sunEndHour = formatStoreHour(sscLocation.sunendhours);

                return {
                    name: sscLocation.SSCLocationName,
                    streetAddress1: sscLocation.SSCLocationStreet,
                    streetAddress2: sscLocation.SSCLocationStreet2,
                    streetAddress3: sscLocation.SSCLocationStreet3,
                    city: sscLocation.SSCLocationCity,
                    state: sscLocation.SSCLocationState,
                    zipCode: sscLocation.SSCLocationZIP,
                    country: sscLocation.SSCLocationCountry,
                    phoneNumber: sscLocation.SSCLocationPhone,
                    faxNumber: sscLocation.SSCLocationFax,
                    mfStartHour: mfStartHour,
                    mfEndHour: mfEndHour,
                    satStartHour: satStartHour,
                    satEndHour: satEndHour,
                    sunStartHour: sunStartHour,
                    sunEndHour: sunEndHour
                }
            }

            /**
             *
             * @returns
             */
            function createDeliveryLocation(deliveryLocation){
                return {
                    name: deliveryLocation.name,
                    name2: deliveryLocation.name2,
                    careOf: deliveryLocation.careOf,
                    streetAddress1: deliveryLocation.streetAddress1,
                    streetAddress2: deliveryLocation.streetAddress2,
                    city: deliveryLocation.city,
                    state: deliveryLocation.state,
                    zipCode: deliveryLocation.zipCode,
                    country: deliveryLocation.country

                }
            }

            /**
             * Look at current time and determine the available earliest pickup date
             */
            function initPickupDate(order){
				debugger;

                var isvalid = true;
                // check if the is past the cutoff time, if so the earliest pickup is tomorrow, if not user can pickup today.
                var today = new Date(new Date().setHours(0,0,0,0));
                var tomorrow = new Date(today.getTime() + 24 * 60 * 60 * 1000);
                var currentTime = new Date();
                var currentHour = currentTime.getHours()+1;
                if(currentHour >= 15 )
                { 
                    var earliestPickupDate = tomorrow;
                }else{
                    var earliestPickupDate = today;
                }
                //var earliestPickupDate = (order.cutoffcrossed === true) ? tomorrow : today;

                if(today.getDay() == '6' && order.satAppointStarthours == '0' && order.satAppointEndhours == '0' && earliestPickupDate == tomorrow) {
                    earliestPickupDate.setDate(earliestPickupDate.getDate() + 1);
                    var formattedPickupDate = earliestPickupDate.getFullYear() + '-' + (earliestPickupDate.getMonth() + 1) + '-' + (earliestPickupDate.getDate());
                    
                }
                else if(today.getDay() == '6' && order.satAppointStarthours == '0' && order.satAppointEndhours == '0' && earliestPickupDate == today) {
                    earliestPickupDate.setDate(earliestPickupDate.getDate() + 2);
                    var formattedPickupDate = earliestPickupDate.getFullYear() + '-' + (earliestPickupDate.getMonth() + 1) + '-' + (earliestPickupDate.getDate());
                    
                }
                else if(today.getDay() == '0' && order.sunAppointStarthours == '0' && order.sunAppointEndhours == '0' && earliestPickupDate == tomorrow ){
                    earliestPickupDate.setDate(earliestPickupDate.getDate());
                    var formattedPickupDate = earliestPickupDate.getFullYear() + '-' + (earliestPickupDate.getMonth() + 1) + '-' + (earliestPickupDate.getDate());
                    
                }
                else if(today.getDay() == '0' && order.sunAppointStarthours == '0' && order.sunAppointEndhours == '0' && earliestPickupDate == today){
                    earliestPickupDate.setDate(earliestPickupDate.getDate() + 1);
                    var formattedPickupDate = earliestPickupDate.getFullYear() + '-' + (earliestPickupDate.getMonth() + 1) + '-' + (earliestPickupDate.getDate());
                    
                }
                else if(today.getDay() == '5' && order.sunAppointStarthours == '0' && order.sunAppointEndhours == '0' && earliestPickupDate == tomorrow ){
                    earliestPickupDate.setDate(earliestPickupDate.getDate() + 2);
                    var formattedPickupDate = earliestPickupDate.getFullYear() + '-' + (earliestPickupDate.getMonth() + 1) + '-' + (earliestPickupDate.getDate());
                    
                }
                else{
                    var formattedPickupDate = earliestPickupDate.getFullYear() + '-' + (earliestPickupDate.getMonth() + 1) + '-' + earliestPickupDate.getDate();
                }


                // create the available times for pickup, if we are passed the cutoff time we are using tomorrow as the pickup date,
                // so set the current hour of the day to 0 which is midnight, if we are not past the cutoff, we will send in the
                // current hour of the day, this is used to set the times that are available for pickup.
                var pickupTimes = createStoreHours(earliestPickupDate, order);

                return {
                    pickupDate: formattedPickupDate,
                    pickupDateEarliestDate: earliestPickupDate,
                    pickupTimesAvailable: pickupTimes
                };
            }

            /**
             *
             * @param pickupDateObject
             * @param orderObject
             */
            function createStoreHours(pickupDateObject, orderObject){

                    // get current time data
                    var today = new Date(new Date().setHours(0,0,0,0));
                    var currentTime = new Date();
                    var currentHourOfDay = currentTime.getHours();

                    // get selected time data
                    var pickupDateDayOfTheWeek = pickupDateObject.getDay();
                    var isPickupDateToday = $A.localizationService.isSame(pickupDateObject, today, 'day');

                    // create store hours objects
              /*      var weekDayHours = {open: orderObject.mfstarthours, close: orderObject.mfendhours};
                    var satHours = {open: orderObject.satstarthours, close: orderObject.satendhours};
                    var sunHours = {open: orderObject.sunstarthours, close: orderObject.sunendhours};*/

                     // create store hours objects
                   	var weekDayHours = {open: orderObject.mfAppointStartHours, close: orderObject.mfAppointEndhours};
                    var satHours = {open: orderObject.satAppointStarthours, close: orderObject.satAppointEndhours};
                    var sunHours = {open: orderObject.sunAppointStarthours, close: orderObject.sunAppointEndhours};
                if(satHours == '0')
                {
                    satHours = undefined;
                }
                if(sunHours == '0')
                {
                    sunHours = undefined;
                }
                    // figure out which day of the week we need the hours for
                    var storeHoursForPickupDay = (
                        (pickupDateDayOfTheWeek > 0 && pickupDateDayOfTheWeek < 6) ? weekDayHours
                            : (pickupDateDayOfTheWeek === 0) ? sunHours : satHours );

                    // store open close times
                    var openTime = storeHoursForPickupDay.open;
                    var closeTime = storeHoursForPickupDay.close;
                	var timeOfCutOff ;
					if(pickupDateObject > new Date(new Date().setHours(0,0,0,0)))
                    {
                        timeOfCutOff = 0;
                    }
                    else{
                        timeOfCutOff = 23;
                    }
                    // what is the cutoff hour
                    var cutoffHour = (isPickupDateToday === true) ? (currentHourOfDay + 2) : timeOfCutOff;

                    return createStoreHoursList(openTime, closeTime,  cutoffHour);
                }

            /**
             *
             * @param openTime
             * @param closeTime
             * @param cutoffHour
             * @returns {Array}
             */
            function createStoreHoursList(openTime, closeTime, cutoffHour){

            var storeHours = [];

            if(openTime !== undefined && closeTime !== undefined && openTime !== '0' && closeTime !== '0') {
                var openHour = parseInt(openTime.split(':')[0], 10);
                var closeHour = parseInt(closeTime.split(':')[0], 10);

                for(var x=openHour; x < closeHour + 1; x++){
                    // create pickup object, if the cutoff hours is greater than the
                    // current hour we are creating we want to set it as a disabled option
                    storeHours.push(createTimeObject(x, (x < cutoffHour)));
                }
            }

            return storeHours;
        }

            /**
             * Look at current time and determine the available earliest pickup date
             */
            function createDeliveryDate(order){
				debugger;
                var today = new Date(new Date().setHours(0,0,0,0));
                var tomorrow = new Date(today.getTime() + 24 * 60 * 60 * 1000);
                var dayAfterTomorrow = new Date(today.getTime() + 48 * 60 * 60 * 1000);
                var twoDaysfromToday = new Date(today.getTime() + 72 * 60 * 60 * 1000);
                var deliveryDateEarliestDate = tomorrow;
                var currentTimeInMinutes=0;
                var currentTime=0;
                var currentTime=new Date().getHours();
                var currentTimeInMinutes=new Date().getMinutes();

                if(today.getDay() == '5' && tomorrow.getDay() == '6') {
                    tomorrow.setDate(tomorrow.getDate() + 2);
                    var formattedDeliveryDate = tomorrow.getFullYear() + '-' + (tomorrow.getMonth() + 1) + '-' + (tomorrow.getDate());
                    deliveryDateEarliestDate = twoDaysfromToday;
                }

                else if(today.getDay() == '6' && tomorrow.getDay() == '0') {
                    tomorrow.setDate(tomorrow.getDate() + 1);
                    var formattedDeliveryDate = tomorrow.getFullYear() + '-' + (tomorrow.getMonth() + 1) + '-' + (tomorrow.getDate());
                    deliveryDateEarliestDate = dayAfterTomorrow;
                }
                else if(today.getDay() == '0' && tomorrow.getDay() == '1') {
                    var formattedDeliveryDate = tomorrow.getFullYear() + '-' + (tomorrow.getMonth() + 1) + '-' + tomorrow.getDate();
                }else{
                    var formattedDeliveryDate = tomorrow.getFullYear() + '-' + (tomorrow.getMonth() + 1) + '-' + tomorrow.getDate();

                }

                return {
                    deliveryDate: formattedDeliveryDate,
                    deliveryDateEarliestDate: deliveryDateEarliestDate
                };
            }

            /**
             *
             * @param packageData
             * @returns
             */
            function createScheduleByItemPickup(packageData){

                    var parsedTime = $A.localizationService.parseDateTime(packageData.pickupTimeSelected, 'H:m');

                    return {
                        id: packageData.id,
                        pickupDate: packageData.pickupDate,
                        pickupDateFormatted: $A.localizationService.formatDate(packageData.pickupDate, 'EEEE, MMM DD'),
                        pickupTimeSelected: packageData.pickupTimeSelected,
                        pickupTimeFormatted: $A.localizationService.formatDate(parsedTime, 'h:mm a'),
                        pickupWhoWill: packageData.pickupWhoWill,
                        pickupFirstName: packageData.pickupFirstName,
                        pickupLastName: packageData.pickupLastName,
                        pickupPhone: packageData.pickupPhone,
                        pickupShouldSendTxt: packageData.pickupShouldSendTxt || false,
                        pickupLocation: packageData.pickupLocation || {},
                        skus: packageData.skus || [],
                        submittedType: packageData.scheduleByItemType,
                        pos: packageData.pos
                    }
                }

            /**
             *
             * @param packageData
             * @returns
             */
            function createScheduleByItemDelivery(packageData){
				console.log('packageData',packageData);
                // create delivery location object
                var deliveryLocation = createDeliveryLocation({

                    name: packageData.shipToName,
                    name2: packageData.shipToName2,
                    careOf: packageData.shipToCareOf,
                    streetAddress1: packageData.shipToStreet1,
                    streetAddress2: packageData.shipToStreet2,
                    city: packageData.shipToCity,
                    state: packageData.shipToState,
                    zipCode: packageData.shipToZipcode,
                    country: packageData.shipToCountry

                });

                return {
                    id: packageData.id,
                    deliveryDate: packageData.deliveryDate,
                    deliveryDateFormatted: $A.localizationService.formatDate(packageData.deliveryDate, 'EEEE, MMM DD'),
                    deliveryLocation: deliveryLocation,
                    skus: packageData.skus || [],
                    submittedType: packageData.scheduleByItemType,
                    pos: packageData.pos
                }
            }

        // -----------------------------------------------------
        // End Model Data
        // -----------------------------------------------------

        // -----------------------------------------------------
        // Save To Server Functions
        // -----------------------------------------------------

            function mapScheduledOrderToFulfillmentWrapper(scheduleData){
                console.log('mapScheduledOrderWrapperToServer:scheduleData:', scheduleData);

                // create line wrapper list
                var lineItems  = [];
                if(scheduleData.skus !== undefined && Array.isArray(scheduleData.skus)){
                    scheduleData.skus.forEach(function(item){
                        lineItems.push({
                            Quantity: item.quantity,
                            SalesOrderLine: item.lineNumber,
                            SalesOrderLineKey: item.lineKey
                        });
                    });
                }

                // create pickup time by using pickup date and pickup time
                var pickupTimeFormatted = undefined;
                var deliveryDateFormatted = undefined;

                if(scheduleData.pickupDate !== undefined && scheduleData.pickupTimeSelected !== undefined){
                    var pickupTime = $A.localizationService.parseDateTime(scheduleData.pickupDate + ' ' + scheduleData.pickupTimeSelected, 'yyyy-M-d H:m');
                    pickupTimeFormatted = $A.localizationService.formatDate(pickupTime, 'yyyy-MM-dd HH:mm');
                }

                if(scheduleData.deliveryDate !== undefined){
                    var deliveryDate = $A.localizationService.parseDateTime(scheduleData.deliveryDate, 'yyyy-M-d');
                    deliveryDateFormatted = $A.localizationService.formatDate(deliveryDate, 'yyyy-MM-dd');
                }

                var TYPE_PICKUP = 'pickup';
                var TYPE_DELIVERY = 'delivery';

                return {
                    // general attributes
                    SalesOrder: scheduleData.orderNumber,
                    SalesOrderKey: scheduleData.salesOrderKey,
                    FulfilmentMethod: scheduleData.submittedType,
                    lineWrapperList: lineItems,
                    ScheduleTime: (TYPE_DELIVERY === scheduleData.submittedType) ? deliveryDateFormatted  : pickupTimeFormatted,

                    // Ship to address needs to be populated with either the delivery location or the SSC Location
                    ShipToAddress_Name: (TYPE_DELIVERY === scheduleData.submittedType) ? scheduleData.deliveryLocation.name : scheduleData.sscLocation.name,
                    ShipToAddress_Line1: (TYPE_DELIVERY === scheduleData.submittedType) ? scheduleData.deliveryLocation.streetAddress1 : scheduleData.sscLocation.streetAddress1,
                    ShipToAddress_Line2:(TYPE_DELIVERY === scheduleData.submittedType) ? scheduleData.deliveryLocation.streetAddress2 : scheduleData.sscLocation.streetAddress2,
                    ShipToAddress_Line3: (TYPE_DELIVERY === scheduleData.submittedType) ? scheduleData.deliveryLocation.careOf : undefined,
                    ShipToAddress_City: (TYPE_DELIVERY === scheduleData.submittedType) ? scheduleData.deliveryLocation.city : scheduleData.sscLocation.city,
                    ShipToAddress_StateProvince: (TYPE_DELIVERY === scheduleData.submittedType) ? scheduleData.deliveryLocation.state : scheduleData.sscLocation.state,
                    ShipToAddress_PostalCode: (TYPE_DELIVERY === scheduleData.submittedType) ? scheduleData.deliveryLocation.zipCode : scheduleData.sscLocation.zipCode,
                    ShipToAddress_Country: (TYPE_DELIVERY === scheduleData.submittedType) ? scheduleData.deliveryLocation.country : scheduleData.sscLocation.country,

                    // pickup type only attributes
                    ContactFirstName: (TYPE_PICKUP === scheduleData.submittedType) ? scheduleData.pickupFirstName : undefined,
                    ContactLastName: (TYPE_PICKUP === scheduleData.submittedType) ? scheduleData.pickupLastName : undefined,
                    ContactPhMobile:  (TYPE_PICKUP === scheduleData.submittedType)  ? scheduleData.pickupPhone :  undefined,
                    sendSMS: (TYPE_PICKUP === scheduleData.submittedType) ? scheduleData.pickupShouldSendTxt : undefined,
                }
            }

        // -----------------------------------------------------
        // End Save To Server Functions
        // -----------------------------------------------------

        /**
         *
         * @param order
         * @param pickupData
         */
        function savePickupToStore(order, pickupData){
            debugger;
            console.log('first name in update store after change step 2--'+pickupData.pickupFirstName);
            order.pickupDate = (pickupData.pickupDate !== undefined) ? pickupData.pickupDate : order.pickupDate;
            order.pickupDateEarliestDate = (pickupData.pickupDateEarliestDate !== undefined) ? pickupData.pickupDateEarliestDate : order.pickupDateEarliestDate;
            order.pickupTimesAvailable = (pickupData.pickupTimesAvailable !== undefined) ? pickupData.pickupTimesAvailable : order.pickupTimesAvailable;
            order.pickupTimeSelected = (pickupData.pickupTimeSelected !== undefined) ? pickupData.pickupTimeSelected : order.pickupTimeSelected;
            order.pickupWhoWill = (pickupData.pickupWhoWill !== undefined) ? pickupData.pickupWhoWill : order.pickupWhoWill;
            order.pickupFirstName = (pickupData.pickupFirstName !== undefined) ? pickupData.pickupFirstName : order.pickupFirstName;
            order.pickupLastName = (pickupData.pickupLastName !== undefined) ? pickupData.pickupLastName : order.pickupLastName;
            order.pickupPhone = (pickupData.pickupPhone !== undefined) ? pickupData.pickupPhone : order.pickupPhone;
            order.pickupShouldSendTxt = (pickupData.pickupShouldSendTxt !== undefined) ? pickupData.pickupShouldSendTxt : order.pickupShouldSendTxt;
        }

        /**
         *
         * @param order
         * @param deliveryData
         */
        function saveDeliveryToStore(order, deliveryData){
            order.deliveryDate = (deliveryData.deliveryDate !== undefined) ? deliveryData.deliveryDate : order.deliveryDate;
            order.deliveryLocation = (deliveryData.deliveryLocation !== undefined) ? deliveryData.deliveryLocation : order.deliveryLocation;
        }


        /**
         *
         * @param orderData
         * @returns {Promise}
         */
        function savePickupAllOrderToServer(orderData){
            return new Promise($A.getCallback(function (resolve, reject) {
                var fulfillmentWrapper = mapScheduledOrderToFulfillmentWrapper(orderData);
                console.log('savePickupAllOrderToServer:fulfillmentWrapper:', fulfillmentWrapper);

                var params = {
                    fulfilWrapper: JSON.stringify(fulfillmentWrapper)
                };

                var promise = helper.doCallout(cmp, 'c.submitOrderForDelivery', params);

                promise.then(function(response){
                    console.log('savePickupAllOrderToServer:submitOrderForDelivery:', response);
                    if(response.success === true){
                        resolve(orderData);
                    } else {
                        reject(response);
                    }
                }, function(response){
                    console.log('Dal_SSC_SchedulePickupDeliveryBase:savePickupAllOrderToServer:error', response);
                    reject(response);
                });
            }));
        }

        /**
         *
         * @param orderData
         * @returns {Promise}
         */
        function saveDeliverAllOrderToServer(orderData){
            return new Promise($A.getCallback(function (resolve, reject) {
                var fulfillmentWrapper = mapScheduledOrderToFulfillmentWrapper(orderData);
                console.log('saveDeliverAllOrderToServer:fulfillmentWrapper:', fulfillmentWrapper);

                var params = {
                    fulfilWrapper: JSON.stringify(fulfillmentWrapper)
                };

                var promise = helper.doCallout(cmp, 'c.submitOrderForDelivery', params);

                promise.then(function(response){
                    console.log('saveDeliverAllOrderToServer:submitOrderForDelivery:', response);
                    if(response.success === true){
                        resolve(orderData);
                    } else {
                        reject(response);
                    }
                }, function(response){
                    console.log('Dal_SSC_SchedulePickupDeliveryBase:saveDeliverAllOrderToServer:error', response);
                    reject(response)
                });
            }));
        }

        /**
         *
         * @param orderData
         * @returns {Promise}
         */
        function saveScheduleByItemToServer(orderData) {
            return new Promise($A.getCallback(function (resolve, reject) {
                // iterate all the schedule by item packages and create a fulfillment wrapper for each
                var fulfillmentWrappers = [];
                orderData.scheduleByItemPackages.forEach(function(scheduledOrder){
                    // add the orderNumber
                    scheduledOrder.orderNumber = orderData.orderNumber;
                    scheduledOrder.salesOrderKey = orderData.salesOrderKey;
                    scheduledOrder.sscLocation = orderData.sscLocation;
                    var fulfillmentWrapper = mapScheduledOrderToFulfillmentWrapper(scheduledOrder);
                    fulfillmentWrappers.push(fulfillmentWrapper);
                });

                console.log('saveScheduleByItemToServer:fulfillmentWrapper:', fulfillmentWrappers);

                var params = {
                    fulfilWrapper: JSON.stringify(fulfillmentWrappers)
                };

                var promise = helper.doCallout(cmp, 'c.submitOrderForDelivery', params);

                promise.then(function(response){
                    console.log('saveScheduleByItemToServer:submitOrderForDelivery:', response);
                    if(response.success === true){
                        resolve(orderData);
                    } else {
                        reject(response);
                    }
                }, function(response){
                    console.log('Dal_SSC_SchedulePickupDeliveryBase:saveScheduleByItemToServer:error', response);
                    reject(response)
                });

            }));
        }

        /**
         *
         * @param orderPos
         * @param scheduleData
         */
        function updateSkusWithPackageData(orderPos, scheduleData){
            var order = orders[orderPos];

            // get the order and schedule skus
            var allOrderSkus = order.skus;
            var scheduleSkus = scheduleData.skus;

            // iterate all the schedule skus looking for a match in the order skus
            for(var s=0; s < scheduleSkus.length; s++){
                var sSkuNumber = scheduleSkus[s].sku;
                var sSkuLine = scheduleSkus[s].lineNumber;

                // iterate the order skus looking for a match
                for(var a=0; a < allOrderSkus.length; a++){
                    var aSkuNumber = allOrderSkus[a].sku;
                    var aSkuLine = allOrderSkus[a].lineNumber;

                    // check for a match
                    if(sSkuNumber === aSkuNumber && sSkuLine === aSkuLine){
                        // update the order sku attributes
                        allOrderSkus[a].fulfillmentType = scheduleData.submittedType;
                        allOrderSkus[a].fulfillmentId = scheduleData.id;
                        allOrderSkus[a].fulfillmentPos = scheduleData.pos;
                        break;
                    }
                } // end innerloop
            } // end outerloop
        }

        /**
         *
         * @param orderPos
         * @param dateStringFromPicker
         * @param earliestDateAvailable
         * @returns {*}
         */
        function isDateValid(orderPos, dateStringFromPicker, earliestDateAvailable){
            // make sure we can get a valid order
            if(orders[orderPos] !== undefined){
                var order = orders[orderPos];

                // first check is if the date is in the YYYY-MM-DD format
                // when there is a valid date entered in the component it
                // is returned in this format.
                var regEx = /^\d{4}-\d{1,2}-\d{1,2}$/;

                // check if format is incorrect
                if(!dateStringFromPicker.match(regEx)){
                    return {isValid: false, errors: [{message:'Invalid Date'}]};
                }

                // now we know the format is correct, lets check if it is a valid date
                var jsDateObject = $A.localizationService.parseDateTime(dateStringFromPicker, 'yyyy-M-d');
                if(!jsDateObject.getTime() && jsDateObject.getTime() !== 0){
                    return {isValid: false, errors: [{message:'Invalid Date'}]};
                }

                // now we know we have a valid date but lets make sure it is not before the earliest pickup date.
                var isDateAfter = $A.localizationService.isAfter(jsDateObject, earliestDateAvailable, 'day');
                var isDateSame = $A.localizationService.isSame(jsDateObject, earliestDateAvailable, 'day');

                // if date isn't after/same as earliest pickup date, return false and set errors
                if(isDateAfter === false && isDateSame === false){
                    return {isValid: false, errors: [{message:'Date must be in the future'}]};
                }

                // date is valid clear errors and return true
                else {
                    return {isValid: true, errors: []};
                }

            } // end check if we get valid order

            return {isValid: false, errors: []};
        }

        /**
         *
         * @param storeHour
         * @returns {}
         */
        function formatStoreHour(storeHour){
            var timeObject = {};

            if(storeHour !== undefined && typeof storeHour.split === 'function'){
                var hour = parseInt(storeHour.split(':')[0], 10);
                timeObject = createTimeObject(hour);
            }

            return timeObject.labelHour;
        }

        // -----------------------------------------------------
        // End Private Variables
        // -----------------------------------------------------

        // -----------------------------------------------------
        // Public Function/Variables
        // -----------------------------------------------------
        return {

            // -----------------------------------------------------
            // getters
            // -----------------------------------------------------
            getHelper: function(){return helper;},
            getActiveTab: function(){return activeTab;},
            getCurrentOrderPosition: function(){return currentOrderPosition;},
            getIsLoading: function(){return isLoading},
            getPickupType: function(){return TYPE_PICKUP;},
            getDeliveryType: function(){return TYPE_DELIVERY;},
            getScheduleByItemType: function(){return TYPE_SCHEDULEBYITEM;},
            getTabPickupAll: function(){return TAB_PICKUPALL},
            getOrders: function () {return JSON.parse(JSON.stringify(orders));}, // return copy not reference, prevent mutation
            getScheduleByItemNextId: function(orderPos, type){
                if(orders[orderPos] !== undefined){
                    var packages = orders[orderPos].scheduleByItemPackages;

                    // find out how many current deliveries are in the
                    var count = 0;
                    if(packages) {                       
                        packages.forEach(function(item){
                            if(item.submittedType === type){
                                count++;
                            } 
                        });
                    }
                    
                    return {
                        id: type + (count + 1),
                        pos: count + 1
                    }
                }
            },
            getIsLastOrder: function(){
              return (currentOrderPosition === (orders.length - 1))
            },

            // -----------------------------------------------------
            // setters
            // -----------------------------------------------------
            setActiveTab: function(tabId){
                console.log('tabId in set method is '+tabId);
                activeTab = tabId;
                cmp.set('v.store', this);
            },

            setScheduleByItemActiveTab: function(orderPos, tabId){
                debugger;
                console.log('setScheduleByItemActiveTab');
                if(orders[orderPos] !== undefined){
                    orders[orderPos].scheduleByItemActiveTab = tabId;
                    cmp.set('v.store', this);
                }
            },
            setScheduleByItemType: function(orderPos, type){
                if(orders[orderPos] !== undefined){
                    orders[orderPos].scheduleByItemType = type;
                    cmp.set('v.store', this);
                }
            },
            setAllSkusSelected: function(orderPos, isSelected){
                if(orders[orderPos] !== undefined){
                    orders[orderPos].skus.forEach(function(sku){
                        // set the selected value, if item already has fulfillmentId keep it false
                        sku.selected = (sku.fulfillmentId === undefined) ? isSelected : false;
                    });
                    cmp.set('v.store', this);
                }
            },
            toggleSkuSelected: function(orderPos, skuIndex){
                if(orders[orderPos] !== undefined && orders[orderPos].skus[skuIndex] !== undefined){
                    orders[orderPos].skus[skuIndex].selected = !orders[orderPos].skus[skuIndex].selected;
                    cmp.set('v.store', this);
                }
            },

            /**
             *
             * @param orderPos
             * @param pickupData
             */
            updatePickupToStore: function(orderPos, pickupData){
                debugger;
                if(orders[orderPos] !== undefined){
                    console.log('first name in update store after change step 1--'+pickupData.pickupFirstName);
                    savePickupToStore(orders[orderPos], pickupData);
                    cmp.set('v.store', this);
                }
            },

            /**
             *
             * @param orderPos
             * @param deliveryData
             */
            updateDeliveryToStore: function(orderPos, deliveryData){
                if(orders[orderPos] !== undefined){
                    saveDeliveryToStore(orders[orderPos], deliveryData);
                    cmp.set('v.store', this);
                }
            },

            /**
             *
             * @param orderPos
             * @param pickupDate
             */
            updatePickupTimesByDate: function(orderPos, pickupDate){

                var order = orders[orderPos];

                // create pickup date object from string
                var pickupDateTimeObject = $A.localizationService.parseDateTime(pickupDate, 'yyyy-M-d');

                // update the list of available pickup times, and reset the pickup selected
                order.pickupTimesAvailable = createStoreHours(pickupDateTimeObject, order);
                order.pickupTimeSelected = undefined;
                cmp.set('v.store', this);
            },

            createPickupTimesByDate: function(orderPos, pickupDate){
                var order = orders[orderPos];
                var pickupDateTimeObject = $A.localizationService.parseDateTime(pickupDate, 'yyyy-M-d');
                return createStoreHours(pickupDateTimeObject, order);
            },
 
            /**
             *
             */
            nextOrderPosition: function(){
                if(orders.length > (currentOrderPosition + 1)){
                    currentOrderPosition += 1;
                }
            },

/**
             *
             * @param orderPos
             * @returns {*}
             */
            submitPickupAllInOne: function(orderPos, totalOrders,cmp, helper){
                debugger;
                var self = this;
                var store = cmp.get('v.store');
                var baseHelper = store.getHelper();
                console.log('Reached: ',orderPos);

                    //var promise = helper.doCallout(cmp, 'c.getMultipleOrder', params);
                try{

                    var action = cmp.get("c.getMultipleOrder");
                    action.setParams({
                      salesOrderList: JSON.stringify(orderPos)
                    });
                    action.setCallback(this, function(response){

                var state = response.getState();
                if(state === "SUCCESS"){
                    console.log('SUCCESS');
                    var _resp = response.getReturnValue();

                    var _successedSkus = [];
                    var _failedSkus = [];
                    if(_resp.length > 0) {

                    for(var i=0;i<_resp.length;i++) {
                        if(_resp[i].isSuccess) {
                             _successedSkus.push(_resp[i].orderNumber);
                        } else {
                            _failedSkus.push(_resp[i].orderNumber);
                        }
                    }
                    cmp.set('v.successedSkus',_successedSkus);
                    cmp.set('v.failedSkus',_failedSkus);
                    console.log('Response Succ: ', _resp);
                    console.log('_successedSkus: ',_successedSkus);
                    cmp.set('v.showSpinner',false);
                        cmp.set('v.isMultipleOrderSuccess',true);
                        cmp.set('v.showModalDelivery',true);
                    }
                } else {
                    console.log('Failure');
                    cmp.set('v.showSpinner',false);
                    cmp.set('v.isMultipleOrderSuccess',false);
                    cmp.set('v.showModalDelivery',true);
                    console.log('Response Fail: ', response.getReturnValue());
                }
               });
                $A.enqueueAction(action);

                } catch(ex) {
                    cmp.set('v.showSpinner',false);
                     cmp.set('v.isMultipleOrderSuccess',false);
                     cmp.set('v.showModalDelivery',true);
                }
                /*
                    promise.then(function(response){
                        if(response.success){

                           //helper.openModal(cmp, 'c:Dal_SSC_OrderScheduleMultipleMsgModal', {isSuccess : true}, true, 'dal-modal_small');
                        } else {

                           //helper.openModal(cmp, 'c:Dal_SSC_OrderScheduleMultipleMsgModal', {isSuccess : false}, true, 'dal-modal_small');
                        }
                    }, function(response){
                        console.log('Dal_SSC_SchedulePickupDeliveryBase:getMultipleOrder:error', response);
                        reject(response);
                    });*/

                /*
                return new Promise($A.getCallback(function (resolve, reject) {
                    if(orders[orderPos] !== undefined){
                        console.log('Orders--->',orders);
                        // set the submitted type
                        orders[orderPos].submittedType = TYPE_PICKUP;
                        
                        var promise = savePickupAllOrderInOneToServer(orders, orderPos, totalOrders);

                        promise.then(function(){
                            orders[orderPos].submitted = true;
                            self.scrollToTop();
                            resolve(orders[orderPos]);
                        }, function(response){
                            console.log('Dal_SSC_SchedulePickupDeliveryBase:submitPickupAll:error:', response);
                            reject(response);
                        });

                    } else {
                        console.log('Dal_SSC_SchedulePickupDeliveryBase:submitPickupAll:error:invalid order position');
                        reject();
                    }
                }));*/


            },
            /**
             *
             * @param orderPos
             * @returns {*}
             */
            submitPickupAll: function(orderPos){
               
                var self = this;

                return new Promise($A.getCallback(function (resolve, reject) {
                    if(orders[orderPos] !== undefined){

                        // set the submitted type
                        orders[orderPos].submittedType = TYPE_PICKUP;

                        var promise = savePickupAllOrderToServer(orders[orderPos]);

                        promise.then(function(){
                            orders[orderPos].submitted = true;
                            self.scrollToTop();
                            resolve(orders[orderPos]);
                        }, function(response){
                            console.log('Dal_SSC_SchedulePickupDeliveryBase:submitPickupAll:error:', response);
                            reject(response);
                        });

                    } else {
                        console.log('Dal_SSC_SchedulePickupDeliveryBase:submitPickupAll:error:invalid order position');
                        reject();
                    }
                }));
            },

            /**
             *
             * @param orderPos
             * @returns {*}
             */
            submitDeliverAll: function(orderPos){
                var self = this;

                return new Promise($A.getCallback(function (resolve, reject) {
                    if(orders[orderPos] !== undefined){
                        // set the submitted type
                        orders[orderPos].submittedType = TYPE_DELIVERY;

                        var promise = saveDeliverAllOrderToServer(orders[orderPos]);

                        promise.then(function(){
                            orders[orderPos].submitted = true;
                            self.scrollToTop();
                            resolve(orders[orderPos]);
                        }, function(response){
                            console.log('Dal_SSC_SchedulePickupDeliveryBase:submitDeliverAll:error:', response);
                            reject(response);
                        });

                    } else {
                        console.log('Dal_SSC_SchedulePickupDeliveryBase:submitDeliverAll:error:invalid order position');
                        reject();
                    }
                }));
            },

            /**
             *
             * @param orderPos
             * @returns {*}
             */
            submitScheduleByItem: function(orderPos){
                var self = this;

                return new Promise($A.getCallback(function (resolve, reject) {
                    if(orders[orderPos] !== undefined){
                        orders[orderPos].submittedType = TYPE_SCHEDULEBYITEM;

                        var promise = saveScheduleByItemToServer(orders[orderPos]);

                        promise.then(function(){
                            orders[orderPos].submitted = true;
                            self.scrollToTop();
                            resolve(orders[orderPos]);
                        }, function(response){
                            console.log('Dal_SSC_SchedulePickupDeliveryBase:submitScheduleByItem:error:', response);
                            reject(response);
                        });

                    } else {
                        console.log('Dal_SSC_SchedulePickupDeliveryBase:submitScheduleByItem:error:invalid order position');
                        reject();
                    }
                }));
            },

            /**
             * Determine if the pickup date is valid based on the current date time
             * @param orderPos
             * @param dateStringFromPicker
             */
            isPickupDateValid: function(orderPos, dateStringFromPicker){
                var order = (orders[orderPos] !== undefined) ?  orders[orderPos] : {};
                return isDateValid(orderPos, dateStringFromPicker, order.pickupDateEarliestDate);
            },

            /**
             * Determine if the delivery date is valid based on the current date time
             * @param orderPos
             * @param dateStringFromPicker
             */
            isDeliveryDateValid: function(orderPos, dateStringFromPicker){
                var order = (orders[orderPos] !== undefined) ?  orders[orderPos] : {};
                return isDateValid(orderPos, dateStringFromPicker, order.deliveryDateEarliestDate);
            },

            /**
             *
             * @param orderPos
             * @returns {Array}
             */
            getScheduleByItemPackages: function(orderPos){
                if(orders[orderPos] !== undefined){
                    return orders[orderPos].scheduleByItemPackages;
                }
            },

            /**
             *
             * @param orderPos
             * @param scheduleData
             */
            saveToStoreScheduleByItem: function(orderPos, scheduleData){
                if(orders[orderPos] !== undefined) {
                    // create the schedule data
                    var scheduleByItemPackage = (scheduleData.scheduleByItemType === TYPE_PICKUP) ? createScheduleByItemPickup(scheduleData) : createScheduleByItemDelivery(scheduleData);

                    // add the scheduled item to the array
                    orders[orderPos].scheduleByItemPackages.push(scheduleByItemPackage);

                    // update the skus, with data package data
                    updateSkusWithPackageData(orderPos, scheduleByItemPackage);

                    // set all the sku selected states to false
                    this.setAllSkusSelected(orderPos, false);

                    // set the view back to the select items tab
                    this.setScheduleByItemActiveTab(orderPos, TAB_SELECTITEMS);

                    // scoll back to the top of the page
                    this.scrollToTop();

                    cmp.set('v.store', this);
                }
            },

            /**
             * Temp order used to just hold the order number, once the user begins to
             * schedule this order we will replace the placeholder order with the actual
             * order information
             * @param orderNumber
             * @returns {{orderNumber: *, placeHolder: boolean}}
             */
            createPlaceholderOrder: function(orderNumber){
                return {
                    orderNumber: orderNumber,
                    isPlaceHolder: true,
                    hasLoadingError: false
                }
            },

            /**
             *
             * @param orderPos
             * @returns {Promise}
             */
            getOrderFromServer: function(orderPos){
                debugger;
                var self = this;

                return new Promise($A.getCallback(function (resolve, reject) {

                    if(orders[orderPos] !== undefined && orders[orderPos].isPlaceHolder === true) {



                    var params = {
                        orderNumberList: [orders[orderPos].orderNumber]
                    };


                      //For Reschedule Order
                      var listOfOrderNumber = [];
                      if(orders && orders.length > 0) {
                          for(var i=0;i<orders.length;i++) {
                              listOfOrderNumber.push(orders[i].orderNumber);
                           }
                          cmp.set('v.listOfOrderNumber',listOfOrderNumber);
                      }

                        var isReschedule = cmp.get('v.isReschedule');

                        if(isReschedule) {

                            //getParams
                            var pageUrl = window.location.href;
                            var hashIndex = pageUrl.lastIndexOf('#');
                            var selectedProductType = pageUrl.substring(hashIndex+1,pageUrl.length);
                            var selectedIndex = 0;
                            var query = pageUrl.substring(pageUrl.lastIndexOf('?')+1,hashIndex);
                            var vars = query.split("&");
                            for (var i=0;i<vars.length;i++) {
                               var pair = vars[i].split("=");
                               if(pair[0] == 'sku'){
                                   selectedIndex = pair[1];
                               }
                            }

                            var _param = selectedIndex.split('%2C');
                            var skuN = '';
                            console.log('_param sku for reschedule method',_param);
                            if(_param.length > 1)
                                skuN = 'ALL';
                            else
                                skuN = _param[0];

                            var params = {
                                orderNumberList: [orders[orderPos].orderNumber],
                                lineNumber : skuN
                            };
                            console.log('SKU PARAM for Reschedule: ',params );
                            var getAllOrdersToSchedule = helper.doCallout(cmp, 'c.getReSecheduleData', params);
                        } else {
                             var getAllOrdersToSchedule = helper.doCallout(cmp, 'c.getScheduleinfo', params);
                        }
                        //var getAllOrdersToSchedule = helper.doCallout(cmp, 'c.getScheduleinfo', params);
                        var getUserSelectedLocation = helper.getUserSelectedLocation(cmp);

                        Promise.all([getAllOrdersToSchedule, getUserSelectedLocation]).then(function(response){

                            // make sure we have response[0] data, will return an array even though currently there will
                            // only be one result but in the future there could potentially be a list of results.
                            if(response[0] !== undefined && Array.isArray(response[0]) && response[0].length > 0){
                                console.log('response from server '+response[0][0]);
                                var order = self.mapOrderFromServer(response[0][0], response[1]);
                                self.addOrderToStoreByPosition(order, orderPos);
                                resolve();
                            } else {
                                console.log('Dal_SSC_SchedulePickupDeliveryBase:getOrderFromServer:error:no response data', response);
                                orders[orderPos].hasLoadingError = true;
                                reject();
                            }
                        }, function(response){
                            console.log('Dal_SSC_SchedulePickupDeliveryBase:getOrderFromServer:error', response);
                            orders[orderPos].hasLoadingError = true;
                            reject();
                        });

                    } else {
                        console.log('Dal_SSC_SchedulePickupDeliveryBase:getOrderFromServer:error:invalid order position');
                        reject();
                    }
                }));
            },

            /**
             *
             * @param order
             * @param deliveryLocation
             * @returns {}
             */
            mapOrderFromServer: function(order, deliveryLocation){
                return createOrder(order, deliveryLocation);
            },

            /**
             *
             * @param order
             */
            addOrderToStore: function(order){
                orders.push(order);
            },

            /**
             *
             * @param order
             * @param orderPos
             */
            addOrderToStoreByPosition: function(order, orderPos){
                if(orders[orderPos] !== undefined) {
//                
                    orders[orderPos] = order;
                    cmp.set('v.store', this);
                } else {
                    console.log('Dal_SSC_SchedulePickupDeliveryBase:addOrderToStoreByPosition:error:invalid order position');
                }
            },

            /**
             * Scroll to top of view
             */
            scrollToTop: function(){
                document.body.scrollTop = document.documentElement.scrollTop = 0;
            },

            /*  updateQuantityValues : function(index,val,orderPos){
                    debugger;
                    orders[orderPos].skus[index].quantity = val;
                    cmp.set('v.store', this);
              }
*/
        }
        // -----------------------------------------------------
        // End Public Function/Variables
        // -----------------------------------------------------
    } // end create store


})