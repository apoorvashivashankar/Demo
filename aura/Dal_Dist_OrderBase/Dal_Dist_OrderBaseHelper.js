/**
 * Created by 7Summits on 3/28/18.
 */
({

    paramOrderDraftId: 'draftId',

    /**
     * Initialize the quick order process. Will be checking the URL to determine if we aree
     * starting from a draft order, if not, we will then check to see if there is a open order
     * in the current session, if not, we will start a new session order.
     * @param cmp
     */
    initStore: function (cmp) {
        var self = this;

        // get the order process step event, need to be outside the store
        // object context so we can get a new instance of it every time it is called.
        var getOrderProcessStepEvent = function(){
            return $A.get('e.c:Dal_Dist_OrderProcessStepEvt');
        };

        // Read the URL to see if order ID is being passed in from draft order
        var orderId = this.getUrlParamByName(this.paramOrderDraftId);
        console.log('initStore called in dal dist order base helper and order id is : ', orderId);
        // request session, if orderId is null new session will be returned
        var getOrderWrapper = this.doCallout(cmp, 'c.startOrder', {'orderId': orderId});

        // get default price records
        var getDefaultPriceRecords = this.getDefaultPriceRecords(cmp);

        // wait for all promises to resolve then init store
        Promise.all([getOrderWrapper, getDefaultPriceRecords]).then(function(response){
            console.log('response in dal dist order base helper ', response);
            // let check if we have a valid default ship date we are getting from a
            // saved order if not we will use tomorrows date
            var currentDate = new Date(new Date().getTime() + 24 * 60 * 60 * 1000);
            var tomorrowsDate = currentDate.getFullYear() + '-' + (currentDate.getMonth() + 1) + '-' + currentDate.getDate();
            var splitRequestedShipDate = (response[0] !== undefined && response[0].defaultRequestedShipDate !== undefined) ? response[0].defaultRequestedShipDate.split('T') : [];
            var isRequestedShipDateValid = self.isValidShippingDate(cmp, splitRequestedShipDate[0]);
            console.log('isRequestedShipDateValid---',isRequestedShipDateValid);
            var defaultShipDate = (isRequestedShipDateValid === true) ? splitRequestedShipDate[0] : tomorrowsDate;

            // create store
            var store = self.createStore(cmp, self, defaultShipDate, getOrderProcessStepEvent);
            console.log('store created ', store);
            // Map the orderWrapper returned to the store
            if(response[0] !== undefined){
                store.mapOrderWrapperToStore(response[0]);
            }

            // create standard price record list, then set
            if(response[1] !== undefined){
                var formattedDefaultPriceRecords = store.createPriceRecordsList(response[1]);
                store.setDefaultPriceRecords(formattedDefaultPriceRecords, ((response[0] !== undefined) ? response[0].defaultPriceCode : undefined));
            }

            // if there are already products in the cart, we need to see if there
            // is enough data to make an ATP call, if so make the call.
            var products = store.getCartProducts();
            if(products.length > 0){
                store.initExistingProductRows();
            } else {
                store.addProducts(1);
            }

            // update store to view
            cmp.set('v.store', store);
            cmp.set('v.isOrderBaseLoading', false);
        }, function(response){
            cmp.set('v.errorOrderInit', true);
            cmp.set('v.isOrderBaseLoading', false);
            console.log('Error initializing quick order:', response);
        });

    }, // end init store

    /**
     *
     * @param cmp
     */
    initPriceBySku: function(cmp){
        var self = this;

        return new Promise(function (resolve, reject) {
            var getDefaultPriceRecords = self.getDefaultPriceRecords(cmp);

            getDefaultPriceRecords.then(function(response){

                // create standard price record list, then set
                if(response !== undefined){
                    var currentDate = new Date(new Date().getTime() + 24 * 60 * 60 * 1000);
                    var defaultShipDate = currentDate.getFullYear() + '-' + (currentDate.getMonth() + 1) + '-' + currentDate.getDate();

                    var store = self.createStore(cmp, self, defaultShipDate, null);

                    // default product row
                    store.addProducts(1);

                    // create standard price record list, then set
                    var formattedDefaultPriceRecords = store.createPriceRecordsList(response);
                    store.setDefaultPriceRecords(formattedDefaultPriceRecords);

                    cmp.set('v.store', store);
                    cmp.set('v.isOrderBaseLoading', false);
                    resolve(store);
                } else {
                    cmp.set('v.errorOrderInit', true);
                    cmp.set('v.isOrderBaseLoading', false);
                    console.log('Error initializing PriceBySku:', response);
                    reject();
                }
            }, function(response){
                cmp.set('v.errorOrderInit', true);
                cmp.set('v.isOrderBaseLoading', false);
                console.log('Error initializing PriceBySku:', response);
                reject();
            });

        });
    },

    /**
     * Given on orderWrapper from APEX service call will map
     * the order wrapper to the store model. Used for view order
     * detail pages.
     * @param cmp
     * @param orderWrapper
     */
    initDetailStore: function(cmp, orderWrapper){
        var store = this.createStore(cmp, this, null, null);
        store.mapOrderWrapperToStore(orderWrapper);
        cmp.set('v.store', store);
        cmp.set('v.isOrderBaseLoading', false);
    },

    getDefaultPriceRecords: function(cmp){
        var self = this;
        return new Promise(function (resolve, reject) {
            var getUserSelectedLocation = self.getUserSelectedLocation(cmp);

            getUserSelectedLocation.then(function(response){

                //get price records, //returns promise
                var getPriceRecords = self.doCallout(cmp, 'c.getPriceRecords', {customerId: response.DW_ID__c});

                // price records response
                getPriceRecords.then(function(response){
                    resolve(response);
                }, function(response){
                    reject(response);
                });

            }, function(response){
                reject(response);
            });
        });
    },

    createStore: function(cmp, self, defaultShipDate, getOrderProcessStepEvent2){
        // -----------------------------------------------------
        // Private Variables
        // -----------------------------------------------------

        // reference to the Dal Base Helpers
        var helper = self;

        // event used to notify other components of process step change
        var getOrderProcessStepEvent = getOrderProcessStepEvent2;

        // Default attributes for the order
        var defaults = {
            shipDate: defaultShipDate || new Date(new Date().getTime() + 24 * 60 * 60 * 1000),
            priceRecord: []
        };

        // Cart to hold the selected products
        var cart = {
            products: []
        };

        // Order shipping information
        var shippingInfo = createShippingInfo();

        // Order information
        var orderInfo = createOrderInfo();

        // is the default price records loading
        var loadingDefaultPriceRecords = false;

        // -----------------------------------------------------
        // End Private Variables
        // -----------------------------------------------------

        // -----------------------------------------------------
        // Private Functions
        // -----------------------------------------------------


        // -----------------------------------------------------
        // Model Data
        // -----------------------------------------------------

        /**
         * Model for the default product row
         * @returns object
         */
        function createProduct(product) {
        debugger;
            // if product is undefined set it to empty
            product = product || {};

            return {

                // attributes user generated
                sku: product.sku,
                productName: product.productName,
                quantity: product.quantity,
                unitOfMeasure: product.unitOfMeasure || [],
                sourceOfSupply: product.sourceOfSupply || [],
                requestShipDate: product.requestShipDate || defaults.shipDate,
                priceRecord: product.priceRecord || JSON.parse(JSON.stringify(defaults.priceRecord)),

                // derived values
                unitOfMeasureSelected: product.unitOfMeasureSelected,
                priceRecordSelected: product.priceRecordSelected,
                sourceOfSupplySelectedName: product.sourceOfSupplySelectedName,
                originalQuantityRequested: product.originalQuantityRequested,

                // display in view attributes only
                isValidData: product.isValidData || false,
                isValidAtp: product.isValidAtp || false,
                showProductInfo: product.showProductInfo || false,
                productInfoError: product.productInfoError || false,
                isAtpLoading: product.isAtpLoading || false,
                canPrimarySosFulfill: product.canPrimarySosFulfill || false,
                isPriceRecordsLoading: product.isPriceRecordsLoading || false,
                isProductSupplyLoading: product.isProductSupplyLoading || false,
                showProductSupply: product.showProductSupply || false,
                isPriceBySkuLoading: product.isPriceBySkuLoading || false,
                showPriceBySku: product.showPriceBySku || false,
                quantityRounded: product.quantityRounded || false,

                // attributes returned from service calls
                estimatedShipDate: product.estimatedShipDate,
                sos: product.sos,
                availableQty: product.availableQty,
                netPrice: product.netPrice || 0,
                onTimeFlag: product.onTimeFlag,
                isQtyAvailable: product.isQtyAvailable,
                qtyPrice: product.qtyPrice || 0,
                supplyPlant: product.supplyPlant,
                supplyPlantID: product.supplyPlantID,
                supplyPlantType: product.supplyPlantType,
                size: product.size,
                color: product.color,
                trim: product.trim,
                shade: product.shade,
                quantityShippedInvoiced: product.quantityShippedInvoiced,
                quantityCancelled: product.quantityCancelled,
                extendedWeight: product.extendedWeight || 0,
                cartonCount: product.cartonCount,
                pieceCount: product.pieceCount,
                carrier: product.carrier,
                countryOfOrigin: product.countryOfOrigin,
                futureProductSupply: product.futureProductSupply,
                salesOrderLineNo: product.salesOrderLineNo,
                lineItemStatus: product.lineItemStatus,
                shippedDate: product.shippedDate,
                trackingNumber: product.trackingNumber,
                sellingUom: product.sellingUom,
                sellingQty: product.sellingQty,
                sscqty: product.sscqty,
                sscuom: product.sscuom,
                sscunitpriceuom: product.sscunitpriceuom,
                sscunitprice: product.sscunitprice,
                pricedUom: product.pricedUom,
                fulfillmentMethod: product.fulfillmentMethod,
                fulfillmentScheduleTime: product.fulfillmentScheduleTime,
                fulfillmentContactFirstName: product.fulfillmentContactFirstName,
                fulfillmentContactLastName: product.fulfillmentContactLastName,
                fulfillmentContactPhone: product.fulfillmentContactPhone,
                fulfillmentContactTextMsgInd: product.fulfillmentContactTextMsgInd,
                InventoryItem_DocumentNumber : product.InventoryItem_DocumentNumber,
                InventoryItem_Width : product.InventoryItem_Width,
                InventoryItem_Length: product.InventoryItem_Length,
                isSlabOrder : product.isSlabOrder
            }
            console.log('createProduct + product:', product);
        }

        /**
         * Create default shippingInfo model object
         * @param shippingInfo
         * @returns {object}
         */
        function createShippingInfo(shippingInfo){
            // if shipping info is undefined set it to empty
            shippingInfo = shippingInfo || {};

            var isCarrier;
            if(shippingInfo.isShipComplete === true && shippingInfo.carrier === undefined){
                isCarrier = 'UPS Ground';
                console.log('------isCarrier-----',isCarrier);
            }
            return {
                shipToName: shippingInfo.shipToName,
                shipToName2: shippingInfo.shipToName2,
                shipToCareOf: shippingInfo.shipToCareOf,
                shipToStreet1: shippingInfo.shipToStreet1,
                shipToStreet2: shippingInfo.shipToStreet2,
                shipToStreet3: shippingInfo.shipToStreet3,
                shipToCity: shippingInfo.shipToCity,
                shipToState: shippingInfo.shipToState,
                shipToZipcode: shippingInfo.shipToZipcode,
                shipToCountry: shippingInfo.shipToCountry,
                shipFromName: shippingInfo.shipFromName,
                shipFromStreet: shippingInfo.shipFromStreet,
                shipFromStreet2: shippingInfo.shipFromStreet2,
                shipFromCity: shippingInfo.shipFromCity,
                shipFromState: shippingInfo.shipFromState,
                shipFromZipcode: shippingInfo.shipFromZipcode,
                shipFromCountry: shippingInfo.shipFromCountry,
                freightTerms: shippingInfo.freightTerms || '1A1',
                fulfilmentMethod: shippingInfo.fulfilmentMethod,
                carrier: shippingInfo.carrier,
                isShipComplete: shippingInfo.isShipComplete,
                isSmallPackage: shippingInfo.isSmallPackage,
                cumulativeOrderWeight: shippingInfo.cumulativeOrderWeight,
                plannedShipmentCompletionDate: shippingInfo.plannedShipmentCompletionDate,

                // display in view attributes
                canShipSmallPackage: shippingInfo.canShipSmallPackage || false
            }
        }

        /**
         * Create default orderInfo model object
         * @param orderInfo
         * @returns {object}
         */
        function createOrderInfo(orderInfo){
            // if order info is undefined set it to empty
            orderInfo = orderInfo || {};

            return {
                orderId: orderInfo.orderId,
                orderNumber: orderInfo.orderNumber,
                orderSubTotal: orderInfo.orderSubTotal || 0,
                orderTotalWeight: orderInfo.orderTotalWeight || 0,
                poNumber: orderInfo.poNumber,
                jobName: orderInfo.jobName,
                contactName: orderInfo.contactName,
                contactNumber: orderInfo.contactNumber,
                specialInstructions: orderInfo.specialInstructions,
                energySurcharge: orderInfo.energySurcharge,
                taxes: orderInfo.taxes,
                shippingAndHandling: orderInfo.shippingAndHandling,
                taxStatus: orderInfo.taxStatus,
                orderTotal: orderInfo.orderTotal,
                totalpayment: orderInfo.totalpayment,
                outstandingTotal: orderInfo.outstandingTotal,
                cashPayment: orderInfo.cashPayment,
                status: orderInfo.status,
                salesOrderTypeDesc : orderInfo.salesOrderTypeDesc,
                BDC : orderInfo.BDC,
                profileName : orderInfo.profileName
            }
        }

        // -----------------------------------------------------
        // End Model Data
        // -----------------------------------------------------

        // -----------------------------------------------------
        // Save Model Data
        // -----------------------------------------------------

        /**
         * Save a product to the cart
         */
        function saveToStoreProductByCartId(cartId, productUpdate){
            // make sure the product id is valid
            if(cart.products[cartId] !== undefined){
                var product = cart.products[cartId]; // id = index

                // User generated inputs
                product.sku = (productUpdate.sku !== undefined) ? productUpdate.sku.trim() : product.sku;
                product.productName = (productUpdate.productName !== undefined) ? productUpdate.productName : product.productName;
                product.quantity = (productUpdate.quantity !== undefined) ? productUpdate.quantity : product.quantity;
                product.unitOfMeasure = productUpdate.unitOfMeasure || product.unitOfMeasure;
                product.sourceOfSupply = productUpdate.sourceOfSupply || product.sourceOfSupply;
                product.requestShipDate = productUpdate.requestShipDate || product.requestShipDate;
                product.priceRecord = productUpdate.priceRecord || product.priceRecord;
                product.isValidData = (productUpdate.isValidData !== undefined) ? productUpdate.isValidData : product.isValidData;
                product.showPriceBySku = (productUpdate.showPriceBySku !== undefined) ? productUpdate.showPriceBySku : product.showPriceBySku

                // attributes returned from service calls
                product.size = productUpdate.size || product.size;
                product.color = productUpdate.color || product.color;
                product.trim = productUpdate.trim || product.trim;
                product.shade = productUpdate.shade || product.shade;

                // set derived value - unit of measure
                var selectedUnitOfMeasure = getSelectedUnitOfMeasureFromList(cartId) || {};
                product.unitOfMeasureSelected = selectedUnitOfMeasure.value;

                // set derived value - price record
                product.priceRecordSelected = getSelectedPriceRecordFromList(cartId) || undefined;

                // set derived value - source of supply
                var selectedSourceOfSupply = getSelectedSourceOfSupplyFromList(cartId) || {};
                product.sourceOfSupplySelectedName = selectedSourceOfSupply.label;

            }
        }

        function updateToStoreFromSourceOfSupply(cartId, sourceOfSupply){
        debugger;
            if(cart.products[cartId] !== undefined){
                var product = cart.products[cartId]; // id = index
                product.SOS = sourceOfSupply.SOS;
                product.availableQty = sourceOfSupply.availableQty;
                product.estimatedShipDate = sourceOfSupply.dateAtSupplyPlant;
                product.netPrice = sourceOfSupply.netPrice;
                product.onTimeFlag = sourceOfSupply.onTimeFlag;
                product.qtyPrice = sourceOfSupply.qtyPrice;
                product.supplyPlant = sourceOfSupply.supplyPlant;
                product.supplyPlantID = sourceOfSupply.supplyPlantID;
                product.supplyPlantType = sourceOfSupply.supplyPlantType;
                product.extendedWeight = sourceOfSupply.extendedWeight;
                product.isQtyAvailable = sourceOfSupply.isQtyAvailable;
                product.quantity = sourceOfSupply.pricedQuantity;
                product.pricedUom = sourceOfSupply.pricedUom;

                // set derived value - source of supply
                var selectedSourceOfSupply = getSelectedSourceOfSupplyFromList(cartId) || {};
                product.sourceOfSupplySelectedName = selectedSourceOfSupply.label;
                product.quantityRounded = ($A.util.isEmpty(product.originalQuantityRequested) === false &&  parseFloat(product.quantity) !== parseFloat(product.originalQuantityRequested))
            }
        }

        function saveToStoreShippingInfo(newShippingInfo){

            shippingInfo.shipToName = (newShippingInfo.shipToName !== undefined) ? newShippingInfo.shipToName : shippingInfo.shipToName;
            shippingInfo.shipToName2 = (newShippingInfo.shipToName2 !== undefined) ? newShippingInfo.shipToName2 : shippingInfo.shipToName2;
            shippingInfo.shipToCareOf = (newShippingInfo.shipToCareOf !== undefined) ? newShippingInfo.shipToCareOf : '';
            shippingInfo.shipToStreet1 = (newShippingInfo.shipToStreet1 !== undefined) ? newShippingInfo.shipToStreet1 : shippingInfo.shipToStreet1;
            shippingInfo.shipToStreet2 = (newShippingInfo.shipToStreet2 !== undefined) ? newShippingInfo.shipToStreet2 : shippingInfo.shipToStreet2;
            shippingInfo.shipToStreet3 = (newShippingInfo.shipToStreet3 !== undefined) ? newShippingInfo.shipToStreet3 : shippingInfo.shipToStreet3;
            shippingInfo.shipToCity = (newShippingInfo.shipToCity !== undefined) ? newShippingInfo.shipToCity : shippingInfo.shipToCity;
            shippingInfo.shipToState = (newShippingInfo.shipToState !== undefined) ? newShippingInfo.shipToState : shippingInfo.shipToState;
            shippingInfo.shipToZipcode = (newShippingInfo.shipToZipcode !== undefined) ? newShippingInfo.shipToZipcode : shippingInfo.shipToZipcode;
            shippingInfo.shipToCountry = (newShippingInfo.shipToCountry !== undefined) ? newShippingInfo.shipToCountry : shippingInfo.shipToCountry;
            shippingInfo.shipFromName = (newShippingInfo.shipFromName !== undefined) ? newShippingInfo.shipFromName : shippingInfo.shipFromName;
            shippingInfo.shipFromStreet = (newShippingInfo.shipFromStreet !== undefined) ? newShippingInfo.shipFromStreet : shippingInfo.shipFromStreet;
            shippingInfo.shipFromStreet2 = (newShippingInfo.shipFromStreet2 !== undefined) ? newShippingInfo.shipFromStreet2 : shippingInfo.shipFromStreet2;
            shippingInfo.shipFromCity = (newShippingInfo.shipFromCity !== undefined) ? newShippingInfo.shipFromCity : shippingInfo.shipFromCity;
            shippingInfo.shipFromState = (newShippingInfo.shipFromState !== undefined) ? newShippingInfo.shipFromState : shippingInfo.shipFromState;
            shippingInfo.shipFromZipcode = (newShippingInfo.shipFromZipcode !== undefined) ? newShippingInfo.shipFromZipcode : shippingInfo.shipFromZipcode;
            shippingInfo.shipFromCountry = (newShippingInfo.shipFromCountry !== undefined) ? newShippingInfo.shipFromCountry : shippingInfo.shipFromCountry;
            shippingInfo.freightTerms = (newShippingInfo.freightTerms !== undefined) ? newShippingInfo.freightTerms : shippingInfo.freightTerms;
            shippingInfo.fulfilmentMethod = (newShippingInfo.fulfilmentMethod !== undefined) ? newShippingInfo.fulfilmentMethod : shippingInfo.fulfilmentMethod;
            shippingInfo.carrier = (newShippingInfo.carrier !== undefined) ? newShippingInfo.carrier : shippingInfo.carrier;
            shippingInfo.isShipComplete = (newShippingInfo.isShipComplete !== undefined) ? newShippingInfo.isShipComplete : shippingInfo.isShipComplete;
            shippingInfo.isSmallPackage = (newShippingInfo.isSmallPackage !== undefined) ? newShippingInfo.isSmallPackage : shippingInfo.isSmallPackage;
            shippingInfo.cumulativeOrderWeight = (newShippingInfo.cumulativeOrderWeight !== undefined) ? newShippingInfo.cumulativeOrderWeight : shippingInfo.cumulativeOrderWeight;
        }

        function saveToStoreOrderInfo(newOrderInfo){
            orderInfo.orderNumber = (newOrderInfo.orderNumber !== undefined) ? newOrderInfo.orderNumber : orderInfo.orderNumber;
            orderInfo.orderSubTotal = (newOrderInfo.orderSubTotal !== undefined) ? newOrderInfo.orderSubTotal : orderInfo.orderSubTotal;
            orderInfo.poNumber = (newOrderInfo.poNumber !== undefined) ? newOrderInfo.poNumber : orderInfo.poNumber;
            orderInfo.jobName = (newOrderInfo.jobName !== undefined) ? newOrderInfo.jobName : orderInfo.jobName;
            orderInfo.contactName = (newOrderInfo.contactName !== undefined) ? newOrderInfo.contactName : orderInfo.contactName;
            orderInfo.contactNumber = (newOrderInfo.contactNumber !== undefined) ? newOrderInfo.contactNumber : orderInfo.contactNumber;
            orderInfo.status = (newOrderInfo.status !== undefined) ? newOrderInfo.status : orderInfo.status;
        }

        function saveShipToFromSelectedLocation(selectedLocation){
            saveToStoreShippingInfo({
                shipToName: selectedLocation.Name,
                shipToCareOf: selectedLocation.CareOf,
                shipToStreet1: selectedLocation.ShippingStreet,
                //shipToStreet2: selectedLocation.ShippingStreet,
                shipToCity: selectedLocation.ShippingCity,
                shipToState: selectedLocation.ShippingState,
                shipToZipcode: selectedLocation.ShippingPostalCode,
                shipToCountry: selectedLocation.ShippingCountry
            });
        }

        // -----------------------------------------------------
        // End Save Model Data
        // -----------------------------------------------------

        // -----------------------------------------------------
        // Save To Server Functions
        // -----------------------------------------------------

        /**
         * Save whole order to server
         */
        function saveOrderToServer(shippingInfo, orderInfo, products){

            // map order from the store to the APEX order wrapper
            var orderWrapper = mapOrderWrapperToServer(shippingInfo, orderInfo, products);
            console.log('saveOrderToServer:orderWrapper:', orderWrapper);

            var params = {
                wrapper: JSON.stringify(orderWrapper) || ''
            };

            return helper.doCallout(cmp, 'c.SaveOrder', params);
        }

        /**
         * Submit the order
         * @returns {*}
         */
        function submitOrderToServer(){
            return helper.doCallout(cmp, 'c.createOrder', {orderId: orderInfo.orderId});
        }

        /**
         * Create orderwrapper object that will be sent to the server for saving
         * @returns orderWrapper object
         * */
        function mapOrderWrapperToServer(shippingInfo, orderInfo, products){

            console.log('mapOrderWrapperToServer:shippingInfo:', shippingInfo);
            console.log('mapOrderWrapperToServer:orderInfo:', orderInfo);
            console.log('mapOrderWrapperToServer:products:', products);

            // create order list from products
            var orderLineList = [];
            products.forEach(function(product, index){
                orderLineList.push({
                    lineno: (index + 1),
                    skuNumber: product.sku,
                    quantity: product.quantity,
                    unitOfMeasure: product.unitOfMeasureSelected,
                    sourceOfSupply: product.sourceOfSupplySelectedName,
                    supplyplantid: product.supplyPlantID,
                    requestedShipDate: product.requestShipDate,
                    priceRecord: product.priceRecordSelected,
                    estimatedShipDate: product.estimatedShipDate,
                    size: product.size,
                    color: product.color,
                    trim: product.trim,
                    shade: product.shade,
                    quantityShippedInvoiced: product.quantityShippedInvoiced,
                    quantityCancelled: product.quantityCancelled,
                    extendedWeight: product.extendedWeight,
                    cartonCount: product.cartonCount,
                    pieceCount: product.pieceCount,
                    unitPrice: product.netPrice,
                    extendedPrice: product.qtyPrice,
                    status: product.status, // not mapped at all
                    trackingNumber: product.trackingNumber,
                    fulfillmentMethod: product.fulfillmentMethod,
                    lineitemstatus: product.lineItemStatus,
                    shippedDate: product.shippedDate,
                    productdesc: product.productName,
                    sellingUOM: product.sellingUom,
                    sellingQTY: product.sellingQty
                });
            });

            // get the default price record selected
            var defaultPriceRecordSelected = getDefaultPriceRecordSelected();

            // create order wrapper object
            return {
                orderId: orderInfo.orderId,
                orderLineList: orderLineList,
                defaultPriceCode: defaultPriceRecordSelected.priceRecordCode,
                defaultRequestedShipDate: defaults.shipDate,
                Account_Address_Name: shippingInfo.shipToName,
                Account_Address_Name2: shippingInfo.shipToName2,
                Account_Address_CareOf: shippingInfo.shipToCareOf,
                Account_Address_Line1: shippingInfo.shipToStreet1,
                Account_Address_Line2: shippingInfo.shipToStreet2,
                Account_Address_Line3: shippingInfo.shipToStreet3,
                Account_Address_City: shippingInfo.shipToCity,
                Account_Address_StateProvince: shippingInfo.shipToState,
                Account_Address_PostalCode: shippingInfo.shipToZipcode,
                Account_Address_Country: shippingInfo.shipToCountry,
                Account_From_Address_Line1: shippingInfo.shipFromStreet,
                Account_From_Address_City: shippingInfo.shipFromCity,
                Account_From_Address_StateProvince: shippingInfo.shipFromState,
                Account_From_Address_PostalCode: shippingInfo.shipFromZipcode,
                Account_From_Address_Country: shippingInfo.shipFromCountry,
                FreightTerms: shippingInfo.freightTerms,
                FulfilmentMethod: shippingInfo.fulfilmentMethod,
                Carrier: shippingInfo.carrier,
                smallPackage: shippingInfo.isSmallPackage,
                isShipComplete: shippingInfo.isShipComplete,
                plannedShipmentCompletionDate: shippingInfo.plannedShipmentCompletionDate,
                cumulativeShipmentWeight: shippingInfo.cumulativeOrderWeight,
                orderSubTotal: orderInfo.orderSubTotal,
                PONumber: orderInfo.poNumber,
                ordernumber: orderInfo.orderNumber,
                contactName: orderInfo.contactName,
                jobName: orderInfo.jobName,
                contactNumber: orderInfo.contactNumber,
                energySurcharge: orderInfo.energySurcharge,
                taxes: orderInfo.taxes,
                shippingandhandling: orderInfo.shippingAndHandling,
                taxstatus: orderInfo.taxStatus,
                outstandingtotal: orderInfo.outstandingTotal,
                totalpayment: orderInfo.totalpayment,
                orderTotal: orderInfo.orderTotal,
                cashpayment: orderInfo.cashPayment,
                status: orderInfo.status,
                salesOrderTypeDesc:orderInfo.salesOrderTypeDesc
            };
        }

        /**
         * Given a APEX orderWrapper object map it to the store
         * @param orderWrapper
         */
        function mapOrderWrapperToStore(orderWrapper){
            console.log('mapOrderWrapperToStore:', orderWrapper);

            // ----------------------------
            // ----------------------------
            // Map shipping information
            // ----------------------------
            // ----------------------------
            var shippingInfoParams = {
                shipToName: orderWrapper.Account_Address_Name,
                shipToName2: orderWrapper.Account_Address_Name2,
                shipToCareOf: orderWrapper.Account_Address_CareOf,
                shipToStreet1: orderWrapper.Account_Address_Line1,
                shipToStreet2: orderWrapper.Account_Address_Line2,
                shipToStreet3: orderWrapper.Account_Address_Line3,
                shipToCity: orderWrapper.Account_Address_City,
                shipToState: orderWrapper.Account_Address_StateProvince,
                shipToZipcode: orderWrapper.Account_Address_PostalCode,
                shipToCountry: orderWrapper.Account_Address_Country,
                shipFromName: orderWrapper.Account_From_Address_Name,
                shipFromStreet: orderWrapper.Account_From_Address_Line1,
                shipFromStreet2: orderWrapper.Account_From_Address_Line2,
                shipFromCity: orderWrapper.Account_From_Address_City,
                shipFromState: orderWrapper.Account_From_Address_StateProvince,
                shipFromZipcode: orderWrapper.Account_From_Address_PostalCode,
                shipFromCountry: orderWrapper.Account_From_Address_Country,
                freightTerms: orderWrapper.FreightTerms,
                fulfilmentMethod: orderWrapper.FulfilmentMethod,
                carrier: orderWrapper.Carrier,
                isSmallPackage: orderWrapper.smallPackage,
                isShipComplete: orderWrapper.isShipComplete,
                plannedShipmentCompletionDate: orderWrapper.plannedShipmentCompletionDate,
                cumulativeOrderWeight: orderWrapper.cumulativeShipmentWeight

            };

            // set the shipping info the the order model
            shippingInfo = createShippingInfo(shippingInfoParams);

            // ----------------------------
            // ----------------------------
            // End map shipping information
            // ----------------------------
            // ----------------------------

            // ----------------------------
            // ----------------------------
            // Map order information
            // ----------------------------
            // ----------------------------
            var orderInfoParams = {
                orderId: orderWrapper.orderId,
                orderNumber: orderWrapper.ordernumber,
                orderSubTotal: orderWrapper.orderSubTotal,
                poNumber: orderWrapper.PONumber,
                jobName: orderWrapper.jobName,
                contactName: orderWrapper.contactName,
                contactNumber: orderWrapper.contactNumber,
                specialInstructions: orderWrapper.specialInstructions,
                energySurcharge: orderWrapper.energySurcharge,
                taxes: orderWrapper.taxes,
                shippingAndHandling: orderWrapper.shippingandhandling,
                orderTotal: orderWrapper.orderTotal,
                totalpayment: orderWrapper.totalpayment,
                taxStatus: orderWrapper.taxstatus,
                outstandingTotal: orderWrapper.outstandingtotal,
                cashPayment: orderWrapper.cashpayment,
                status: orderWrapper.status,
                salesOrderTypeDesc : orderWrapper.salesOrderTypeDesc,
                BDC: orderWrapper.BDC,
                profileName : orderWrapper.profileName
            };

            // set the order info the the order model
            orderInfo = createOrderInfo(orderInfoParams);

            // ----------------------------
            // ----------------------------
            // End map order information
            // ----------------------------
            // ----------------------------

            // ----------------------------
            // ----------------------------
            // Map product information
            // ----------------------------
            // ----------------------------
            var products = [];
            if(orderWrapper !== undefined && orderWrapper.orderLineList !== undefined && Array.isArray(orderWrapper.orderLineList)){
                orderWrapper.orderLineList.forEach(function(item){

                    // generate UOM list if available
                    var availableUnitOfMeasure = [];
                    if(item.availableUnitOfMeasure !== undefined){
                        availableUnitOfMeasure = createUnitOfMeasureList(item.availableUnitOfMeasure, item.unitOfMeasure);
                    }
                    var productParams = {
                        salesOrderLineNo: item.lineno,
                        sku: item.skuNumber,
                        productName: item.productdesc,
                        quantity: item.quantity,
                        originalQuantityRequested: item.originalQuantityRequested,
                        unitOfMeasure: availableUnitOfMeasure || [],
                        unitOfMeasureSelected: item.unitOfMeasure,
                        supplyPlant: item.sourceOfSupply,
                        supplyPlantID: item.supplyPlantID,
                        sourceOfSupplySelectedName: item.sourceOfSupply,
                        supplyPlantType: 'SAP_Plant',
                        requestShipDate: item.requestedShipDate,
                        //priceRecord: item.priceRecord,
                        priceRecordSelected: item.priceRecord,
                        estimatedShipDate: item.estimatedShipDate,
                        size: item.size,
                        color: item.color,
                        trim: item.trim,
                        shade: item.shade,
                        quantityShippedInvoiced: item.quantityShippedInvoiced,
                        quantityCancelled: item.quantityCancelled,
                        extendedWeight: item.extendedWeight,
                        cartonCount: item.cartonCount,
                        pieceCount: item.pieceCount,
                        netPrice: item.unitPrice,
                        qtyPrice: item.extendedPrice,
                        lineItemStatus: item.lineitemstatus,
                        shippedDate: item.shippedDate,
                        trackingNumber: item.trackingNumber,
                        carrier: item.carrierName,
                        sellingUom: item.sellingUOM,
                        sellingQty: item.sellingQTY,
                        sscuom: item.sscuom,
                        sscqty: item.sscqty,
                        sscunitpriceuom: item.sscunitpriceuom,
                        sscunitprice: item.sscunitprice,
                        fulfillmentMethod: item.fulfillmentMethod,
                        fulfillmentScheduleTime: item.Fulfilment_ScheduleTime,
                        fulfillmentContactFirstName: item.Fulfillment_Contact_FirstName,
                        fulfillmentContactLastName: item.Fulfillment_Contact_LastName,
                        fulfillmentContactPhone: item.Fulfillment_Contact_Phone,
                        fulfillmentContactTextMsgInd: item.Fulfilment_TextMsgInd,
                        InventoryItem_DocumentNumber : item.InventoryItem_DocumentNumber,
                        InventoryItem_Width : item.InventoryItem_Width,
                        InventoryItem_Length : item.InventoryItem_Length,
                        isSlabOrder : item.isSlabOrder
                    };

                    // create and add the product to the products array
                    var product = createProduct(productParams);
                    products.push(product);                    
                    console.log('product:', products);

                });
            } // end order line list wrapper

            // add the products to the store
            cart.products = products;

            // ----------------------------
            // ----------------------------
            // End map product information
            // ----------------------------
            // ----------------------------
        }

        // -----------------------------------------------------
        // End save To Server Functions
        // -----------------------------------------------------

        // -----------------------------------------------------
        // Helper Functions
        // -----------------------------------------------------
        /**
         * Given a new product, which was retrieved from a saved
         * state, we need to inspect the object, making sure the
         * data is still valid and complete as well as make any
         * ATP calls if needed.
         * @param product
         * @param cartId
         */
        function initExistingProduct(product, cartId){
            product = (product !== undefined) ? product : {};
            var self = this;

            // lets check to make sure the requested ship date is valid and is in the future
            var splitRequestedShipDate = (product.requestShipDate !== undefined) ? product.requestShipDate.split('T') : [];
            var isRequestedShipDateValid = helper.isValidShippingDate(cmp, splitRequestedShipDate[0]);
            console.log('isRequestedShipDateValid---',isRequestedShipDateValid);
            var requestedShipDate = (isRequestedShipDateValid === true) ? splitRequestedShipDate[0] : defaults.shipDate;
            saveToStoreProductByCartId(cartId, {requestShipDate: requestedShipDate});

            // lets get the applied promotions (price records)
            var setPriceRecordsByDate = self.setPriceRecordsByDate(cartId, requestedShipDate);

            // all we are checking for is to, make sure the price record,
            // call completed, we don't care if it was a success or not
            setPriceRecordsByDate.then(function() {
                // now lets look if there is a selected price record, if there is
                // see if it is in the price record  array
                if(product.priceRecordSelected !== undefined){
                    var priceRecordList = cart.products[cartId].priceRecord;

                    // make sure we have a valid price records list
                    if(priceRecordList !== undefined && Array.isArray(priceRecordList)){
                        for(var x=0; x<priceRecordList.length; x++){
                            if(priceRecordList[x].priceRecordCode === product.priceRecordSelected){
                                priceRecordList[x].selected = true;
                                break;
                            }
                        }

                        // save updated price record list to the store
                        saveToStoreProductByCartId(cartId, {
                            priceRecord: priceRecordList
                        });

                        // need to update the store since we are in an async callback
                        cmp.set('v.store', self);
                    }
                } // end check if price record selected is not undefined

                // we need to check if the product has enough valid information to make ATP call
                if(product.sku !== undefined && product.productName !== undefined && product.quantity !== undefined && product.unitOfMeasureSelected !== undefined){
                    getAdditionalProductData.call(self, cartId);
                }

            });

        }

        /**
         * Given a result from a product search item selected, will map that
         * object into the product.
         * @param product
         * @returns {{sku: *, productName: *, unitOfMeasure: Array, unitOfMeasureSelected: *, color: *, size: *}}
         */
        function createProductFromSearchResult(product){
            product = (product !== undefined) ? product : {};

            // create UOM List
            var uomList = createUnitOfMeasureList(product.UOM__c, product.Base_UoM__c);

            return {
                sku: product.DW_ID__c,
                productName: product.Description,
                unitOfMeasure: uomList,
                unitOfMeasureSelected: product.Base_UoM__c,
                color: product.Color__c,
                size: product.Size__c
            }
        }

        /**
         * Given an UOM__c object from an APEX service call will
         * format and return list of unit of measure objects that will
         * be used by the front end to populate a unit of measure dropdown
         * @param UOM__c
         * @param selectedUnitOfMeasure
         * @returns {Array}
         */
        function createUnitOfMeasureList(UOM__c, selectedUnitOfMeasure){
            var uomList = [];
            var uomSplit = UOM__c.split(';');

            if(uomSplit !== undefined && Array.isArray(uomSplit)){
                uomSplit.forEach(function(item, index){
                    var uomItem = createUnitOfMeasure(item, item, item, (selectedUnitOfMeasure === item));
                    uomList.push(uomItem);
                });
            }

            return uomList;
        }

        /**
         * Given an id, value, label and selected attribute will generate a
         * unit of measure object that will be used by the front end to populate
         * a unit of measure dropdown
         * @param id
         * @param value
         * @param label
         * @param selected
         * @returns {object}
         */
        function createUnitOfMeasure(id, value, label, selected){
            return {
                id: id || '',
                value: value || '',
                label: label || '',
                selected: (selected === true)
            }
        }

        /**
         * Given a source of supply object for an APEX service call, will
         * format and return a source of supply object to be used in the
         * front end application.
         * @param source
         * @param selected
         * @returns {object}
         */
        function createSourceOfSupply(source, selected){
            return {
                id: source.supplyplantID || '',
                SOS: source.SOS || '',
                availableQty: source.availableQty || '',
                dateAtSupplyPlant: source.dateAtSupplyPlant || '',
                extendedWeight: source.extendedWeight || '',
                isQtyAvailable: source.isqtyAvailabe || '',
                netPrice: source.netPrice || '',
                onTimeFlag: source.onTimeFlag || '',
                pricedQuantity: source.pricedQuantity || '',
                pricedUom: source.priceduom || '',
                qtyPrice: source.qtyprice || '',
                supplyPlant: source.supplyPlant || '',
                supplyPlantID: source.supplyplantID || '',
                supplyPlantType: source.supplyplantType || '',
				
                // select box view attributes
                value: source.supplyplantID || '',
                label: source.supplyPlant || '',
                selected: (selected === true)
            }
        }

        /**
         * Given a list of DT_SYS_PriceRecord__x price records, will
         * return a list of formatted price records
         * @param List_DT_SYS_PriceRecord__x
         * @returns {Array}
         */
        function createPriceRecordsList(List_DT_SYS_PriceRecord__x) {
            var priceRecords = [];

            // add the first item in the list
            priceRecords.push({label: 'Select Special Pricing', value: ''});

            if(List_DT_SYS_PriceRecord__x !== undefined && Array.isArray(List_DT_SYS_PriceRecord__x)){
                List_DT_SYS_PriceRecord__x.forEach(function(priceRecord){
                    var result = createPriceRecord(priceRecord, false);
                    priceRecords.push(result);
                });
            }

            return priceRecords;
        }

        /**
         * Given a DT_SYS_PriceRecord object from an APEX service call,
         * will format and return a price record object to be used in the
         * front end application
         * @param DT_SYS_PriceRecord__x
         * @param selected
         * @returns {object}
         */
        function createPriceRecord(DT_SYS_PriceRecord__x, selected){
            return {
                id: DT_SYS_PriceRecord__x.id__c,
                label: DT_SYS_PriceRecord__x.PriceRecordDescription__c || '',
                value: DT_SYS_PriceRecord__x.id__c,
                priceRecordCode: DT_SYS_PriceRecord__x.PriceRecordCode__c || '',
                selected: (selected === true)
            }
        }

        /**
         * Given a cartId will return the source of supply selected,
         * will return undefined if not found
         * @param cartId
         * @returns {*}
         */
        function getSelectedSourceOfSupplyFromList(cartId){
            var sourceOfSupply = cart.products[cartId].sourceOfSupply;
            for(var x=0; x < sourceOfSupply.length; x++){
                if(sourceOfSupply[x].selected === true && sourceOfSupply[x].value !== ''){
                    return sourceOfSupply[x];
                }
            }
        }

        /**
         * Given a cartId will return the price record selected,
         * will return undefined if not found.
         * @param cartId
         * @returns {*}
         */
        function getSelectedPriceRecordFromList(cartId) {
            var priceRecord = cart.products[cartId].priceRecord;

            for(var x=0; x < priceRecord.length; x++){
                if(priceRecord[x].selected === true && priceRecord[x].value !== ''){
                    return priceRecord[x];
                }
            }
        }

        /**
         * Given a cartId will return the selected unit of measure
         * @param cartId
         */
        function getSelectedUnitOfMeasureFromList(cartId){
            var unitOfMeasure = cart.products[cartId].unitOfMeasure;

            for(var x=0; x < unitOfMeasure.length; x++){
                if(unitOfMeasure[x].selected === true){
                    return unitOfMeasure[x];
                }
            }
        }

        /**
         * Return the selected default price record
         * @returns {{}}
         */
        function getDefaultPriceRecordSelected(){
            var defaultPriceRecordSelected = {};
            if(defaults.priceRecord !== undefined && Array.isArray(defaults.priceRecord)){
                for(var x=0; x<defaults.priceRecord.length; x++){
                    if(defaults.priceRecord[x].selected === true){
                        defaultPriceRecordSelected = defaults.priceRecord[x];
                        break;
                    }
                }
            }

            return defaultPriceRecordSelected;
        }

        /**
         * Get product info
         */
        function getAdditionalProductData(cartId, isPriceBySku){
            var self = this;
            var product = cart.products[cartId];

            // if we are on the price by sku page we don't actually want to make the
            // ATP call, this was late requirement so isn't handled the most gracefully.
            if(isPriceBySku === true){
                return new Promise($A.getCallback(function (resolve, reject) {
                    product.isValidAtp = true;
                    product.isValidData = true;
                    cmp.set('v.store', self);
                    resolve();
                }));
            } // end if isPriceBySku page

            // set loading attribute
            product.isAtpLoading = true;
            product.showProductSupply = false;

            cmp.set('v.store', this);

            return new Promise($A.getCallback(function (resolve, reject) {

                // get the product
                var product = cart.products[cartId];

                // set the display parameter to false for now, if
                // the request is successful we will set it back to true
                product.showProductInfo = false;

                // get selected price record
                var selectedPriceRecord = getSelectedPriceRecordFromList(cartId) || {};

                // get selected unit of measure
                var selectedUnitOfMeasure = getSelectedUnitOfMeasureFromList(cartId) || {};

                // since we are going to round the quantity we need to store the original quantity requested
                product.originalQuantityRequested = product.quantity;

                // prepare product attributes needed to request ATP data
                var params = {
                    sku: product.sku,
                    quantity: product.quantity,
                    uom: selectedUnitOfMeasure.value,
                    reqShipDate: product.requestShipDate, //THIS FAILS IN IE11: $A.localizationService.formatDate(product.requestShipDate, 'YYYY-MM-DD'),
                    priceRecord: selectedPriceRecord.priceRecordCode
                };

                console.log('getAdditionalProductData:params:', params);

                // make the call to get ATP data
                var atpResults = helper.doCallout(cmp, 'c.getATPResults', params);

                atpResults.then(function(response){

                    // will return an array of SOS, if the preferred SOS can provide the
                    // whole supply of the product there will only be one SOS otherwise
                    // there will be multiple SOS.
                    if(response !== undefined && Array.isArray(response) && response.length > 0){
                        var sourceOfSupplies = [];

                        // used to determine if primary source of supply can full the order sku by the requested date
                        var canPrimarySosFulfill = false;

                        // iterate all the SOS, if we find a SOS number 1 that is the primary SOS
                        response.forEach(function(source){

                            // if SOS == 1, we have found the primary source of supply
                            if(source.SOS === '1') {
                                // in order to update the store with the source of supply we first have
                                // to create a source of supply object that the store will understand.
                                var primarySourceOfSupplyObject = createSourceOfSupply(source, true);

                                // update the store with primary source of supply information
                                updateToStoreFromSourceOfSupply(cartId, primarySourceOfSupplyObject);

                                // can the primary source of supply fulfill the order
                                canPrimarySosFulfill = (primarySourceOfSupplyObject.isQtyAvailable === 'Y' && primarySourceOfSupplyObject.onTimeFlag === 'Y');

                                // add the source of supply to the list
                                sourceOfSupplies.push(primarySourceOfSupplyObject);

                                // update the cumulative total and weight for the order
                                updateOrderTotals();
                            }

                            // non primary source of supply items, just add them to the source
                            // of supply list for display/use in the source of supply dropdown
                            else {
                                sourceOfSupplies.push(createSourceOfSupply(source, false));
                            }
                        });

                        // set the source of supply data
                        product.sourceOfSupply = sourceOfSupplies;
                        product.canPrimarySosFulfill = canPrimarySosFulfill;
                        var selectedSourceOfSupply = getSelectedSourceOfSupplyFromList(cartId) || {};
                        product.sourceOfSupplySelectedName = selectedSourceOfSupply.label;

                        // now we have product info set the ability to show it
                        product.showProductInfo = true;
                        product.productInfoError = false;
                        product.isAtpLoading = false;
                        product.isValidAtp = true;
                        product.isValidData = true;
                        cmp.set('v.store', self);
                        resolve();
                    } else {
                        product.productInfoError = true;
                        product.isAtpLoading = false;

                        if(((product.sku == null || typeof(product.sku) == undefined || product.sku == '') &&
                            (product.quantity == null || typeof(product.quantity) == undefined || product.quantity == ''))){

                            product.isValidAtp = true;
                        }else{
                            product.isValidAtp = false;
                        }

                        cmp.set('v.store', self);
                        reject();
                    }
                }, function(response){
                    console.log('getAdditionalProductData:error:', response);
                    product.productInfoError = true;
                    product.isAtpLoading = false;

                    if(((product.sku == null || typeof(product.sku) == undefined || product.sku == '') &&
                        (product.quantity == null || typeof(product.quantity) == undefined || product.quantity == ''))){

                        product.isValidAtp = true;
                    }else{
                        product.isValidAtp = false;
                    }

                    cmp.set('v.store', self);
                    reject(response);
                }); // end promise handler

            })); // end return promise

        }

        /**
         *  Get the supply time phase of the product
         * @param cartId
         */
        function getProductSupplyData(cartId){
            return new Promise($A.getCallback(function (resolve, reject) {
                // get the product
                var product = cart.products[cartId];

                // prepare product attributes needed to get time phase results
                var params = {
                    sku: product.sku,
                    codeSet: '',
                    uom: product.unitOfMeasureSelected,
                    supplyplantId: product.supplyPlantID,
                    supplyplantType: product.supplyPlantType
                };

                // make the call to get time phased data
                var productSupplyResults = helper.doCallout(cmp, 'c.getTimePhasedResults', params);

                productSupplyResults.then(function(response){
                    resolve(response);
                }, function(response){
                    reject(response);
                });

            })); // end return promise
        }

        /**
         * Get product shade data
         * @param cartId
         * @returns {Promise}
         */
        function getProductShadeData(cartId) {
            return new Promise($A.getCallback(function (resolve, reject) {
                // get the product
                var product = cart.products[cartId];

                // get selected price record
                var selectedPriceRecord = getSelectedPriceRecordFromList(cartId) || {};

                // prepare product attributes for get shade call
                var params = {
                    sku: product.sku,
                    qty: product.quantity,
                    uom: product.unitOfMeasureSelected,
                    reqShipdate: product.requestShipDate,
                    priceRecord: selectedPriceRecord.priceRecordCode,
                    supplyplantId: product.supplyPlantID,
                    supplyplantType: product.supplyPlantType
                };

                // make the call
                var getShadeDetails = helper.doCallout(cmp, 'c.getShadeDetails', params);

                getShadeDetails.then(function(response){
                    resolve(response);
                }, function(response){
                    reject(response);
                });

            }));
        }

        function getPriceBySkuByCartId(cartId) {
            var self = this;

            // get the product
            var product = cart.products[cartId];

            // set the loading state
            product.isPriceBySkuLoading = true;
            product.showPriceBySku = false;
            product.productInfoError = false;
            product.netPrice = 0;
            product.qtyPrice = 0;

            // get selected source of supply
            var selectedSourceOfSupply = getSelectedSourceOfSupplyFromList(cartId);

            // set action params
            var params = {
                material: product.sku,
                pricedQuantity: product.quantity,
                pricedQuantityUOM: product.unitOfMeasureSelected,
                supplyPlant: (selectedSourceOfSupply !== undefined && selectedSourceOfSupply.id !== undefined) ? selectedSourceOfSupply.id : '',
                pricerecord: (product.priceRecordSelected !== undefined && product.priceRecordSelected.priceRecordCode !== undefined ) ? product.priceRecordSelected.priceRecordCode : undefined
            };

            var promise = helper.doCallout(cmp, 'c.getPricingbySKU', params);

            // update view with loading state
            cmp.set('v.store', self);

            // make the call
            promise.then(function(response){
                // let make sure we have the needed data
                if(response !== undefined && Array.isArray(response) && response.length > 0
                    && response[0].priceperUnit !== undefined && response[0].totalPrice !== undefined){
                    product.isPriceBySkuLoading = false;
                    product.showPriceBySku  = true;
                    product.netPrice = response[0].priceperUnit;
                    product.qtyPrice = response[0].totalPrice;
                    product.pricedUom = response[0].uom;
                } else {
                    product.isPriceBySkuLoading = false;
                    product.productInfoError = true;
                    console.log('getPriceBySkuByCartId:Needed data not found', response);
                }

                cmp.set('v.store', self);
            }, function(response){
                product.isPriceBySkuLoading = false;
                product.productInfoError = true;
                console.log('getPriceBySkuByCartId:fail', response);
                cmp.set('v.store', self);
            });
        }

        /**
         * Will iterate all the skus in the order and update the
         * cumulative order total cost and total weight
         */
        function updateOrderTotals() {
            var totalPrice = 0;
            var totalWeight = 0;

            // iterate all products to generate total order price
            for(var x=0; x<cart.products.length; x++){

                if(cart.products[x].qtyPrice !== undefined){
                    totalPrice += parseFloat(cart.products[x].qtyPrice);
                }
                console.log('weight--'+cart.products[x].extendedWeight);
                if(cart.products[x].extendedWeight !== undefined){
                    totalWeight += parseFloat(cart.products[x].extendedWeight);
                }

            }

            // update the order info object with the totals
            orderInfo.orderSubTotal = totalPrice;
            orderInfo.orderTotalWeight = totalWeight;
        }

        /**
         * Checks the cart products to make sure we have at least one valid product in the cart
         * @returns {boolean}
         */
        function hasValidProducts(){
            var products = cart.products;
            var isValid = true;
            var isAtleastOneValid = false;

            // iterate cart product to and determine if valid
            for(var x=0; x < products.length; x++){
                if(products[x].isValidAtp !== true || products[x].isValidData !== true){
                    if(!((products[x].sku == null || typeof(products[x].sku) == undefined || products[x].sku == '') &&
                        (products[x].quantity == null || typeof(products[x].quantity) == undefined || products[x].quantity == ''))){

                        isValid = false;
                    }
                }else{
                    isAtleastOneValid = true;
                }
            }

            if(isAtleastOneValid == false){
                isValid = false;
            }
            console.log('isValid????>>' + isValid);
            return isValid;
        }

        /**
         * Given a data, will return valid price records for that data
         * @param requestedDate
         * @returns {Promise}
         */
        function getPriceRecordsByDate(requestedDate){
            return new Promise($A.getCallback(function (resolve, reject) {
                // need the users selected location in order to get price records
                var getUserSelectedLocation = helper.getUserSelectedLocation(cmp);

                // check response from getting the user selected location
                getUserSelectedLocation.then(function(response){
                    var getPriceRecords = helper.doCallout(cmp, 'c.getPriceRecordsByDate', {
                        customerId: response.DW_ID__c,
                        requestedDate: new Date(requestedDate)
                    });

                    // price records response
                    getPriceRecords.then(function(response){
                        var priceRecords = [];

                        // make sure we have a valid response, else reject
                        if(response !== undefined && Array.isArray(response)){
                            // create formatted price record list
                            priceRecords = createPriceRecordsList(response);

                            // return the price records
                            resolve(priceRecords);
                        } else {
                            reject(response);
                        }

                    }, function(response){
                        reject(response);
                    });

                }, function(response){
                    reject(response);
                });
            }));
        }

        /**
         * Iterate through all the products in the cart and
         * determine if the weight is over the weight allowed
         * for small package shipping
         */
        function canShipSmallPackage(){

            var maxWeightAllowed = 150;
            var products = cart.products;
            var productsBySos = {};

            // iterate cart product to, adding up extended weights
            for(var x=0; x < products.length; x++){

                // check if the products source of supply is already in the map, if not add it,
                // if it is, add the current weight with the new weight.
                if(productsBySos.hasOwnProperty(products[x].sourceOfSupplySelectedName)) {
                    productsBySos[products[x].sourceOfSupplySelectedName] =+productsBySos[products[x-1].sourceOfSupplySelectedName] +  +products[x].extendedWeight;
                } else {
                    productsBySos[products[x].sourceOfSupplySelectedName] = products[x].extendedWeight;
                }

                // check if the products for the current SOS are over maxWeightAllowed, if so, we can't ship small package
                if(productsBySos[products[x].sourceOfSupplySelectedName] > maxWeightAllowed) {
                    return false;
                }

            } // end for

            return true;
        }

        // -----------------------------------------------------
        // End Helper Functions
        // -----------------------------------------------------

        // -----------------------------------------------------
        // End Private Variables
        // -----------------------------------------------------

        // -----------------------------------------------------
        // Public Function/Variables
        // -----------------------------------------------------
        return {

            // current order process position
            currentPos: 1,

            // single attribute getter functions
            getHelper: function(){return helper;},
            getLoadingDefaultPriceRecords: function(){return loadingDefaultPriceRecords;},
            getOrderTotal: function(){return orderInfo.orderSubTotal;},
            getOrderWeight: function(){return orderInfo.orderTotalWeight;},

            // simple attribute getter functions where we return a copy, not reference, to prevent direct mutation
            getShippingInfo: function () {return JSON.parse(JSON.stringify(shippingInfo));},
            getOrderInfo: function () {return JSON.parse(JSON.stringify(orderInfo));},
            getCartProducts: function () {return JSON.parse(JSON.stringify(cart.products));},
            getDefaults: function () {return JSON.parse(JSON.stringify(defaults));},

            // single attribute setters
            setShowProductSupply: function(cartId, value){
                var product = cart.products[cartId];
                product.showProductSupply = (value === true);
                cmp.set('v.store', this);
            },

            setDefaultPriceRecords: function(priceRecordsList, defaultPriceRecordSelected){
                priceRecordsList = (priceRecordsList !== undefined && Array.isArray(priceRecordsList)) ? priceRecordsList : [];

                //  set the default price record if available
                if(defaultPriceRecordSelected !== undefined){
                    priceRecordsList.forEach(function(priceRecord){
                        if(priceRecord.priceRecordCode === defaultPriceRecordSelected){
                            priceRecord.selected = true;
                        }
                    })
                }

                defaults.priceRecord = priceRecordsList;
                cmp.set('v.store', this);
            },

            /**
             * Given a javascript date object, if valid, set it to the
             * default shipping date
             * @param date
             */
            setDefaultShippingDate: function (date) {
                // make sure the date is a valid Javascript date object
                var isValidDate = helper.isValidJavascriptDate(new Date(date));

                // if valid, set it
                if(isValidDate) {
                    defaults.shipDate = date;
                    cmp.set('v.store', this);
                }
            },

            /**
             * Given a selected value will set the 'selected'
             * attribute of the matching price record.
             * @param selectedValue
             */
            setDefaultPriceRecord: function (selectedValue) {
                defaults.priceRecord.forEach(function(item){
                    // check if selectedValue is equal to the items value
                    item.selected = (item.value === ((typeof item.value === 'number') ? parseInt(selectedValue, 10) : selectedValue));
                });

                cmp.set('v.store', this);
            },

            setAllCartProductsPriceRecord: function(selectedValue){
                // set the default selected price record to the store
                this.setDefaultPriceRecord(selectedValue);

                // iterate all the cart product and set their price record
                cart.products.forEach(function(product, index){
                    saveToStoreProductByCartId(index, {
                        priceRecord: defaults.priceRecord
                    })
                });

            },

            /**
             * Given a date, will set default price records available to the
             * user based on that date.
             *
             * @param date
             */
            setDefaultPriceRecordsByDate: function(date) {
                var self = this;

                // set the loading attribute
                loadingDefaultPriceRecords = true;
                cmp.set('v.store', self);

                // make request to get the price records  by date
                var promise = getPriceRecordsByDate(date);

                // get price records response
                promise.then(function(response){
                    defaults.priceRecord = response;
                    loadingDefaultPriceRecords = false;
                    cmp.set('v.store', self);
                }, function(response){
                    loadingDefaultPriceRecords = false;
                    defaults.priceRecord = [];
                    cmp.set('v.store', self);
                });
            },

            setPriceBySkuDefaultPriceRecordsByDate: function(date){
                // get the new price records by date
                this.setDefaultPriceRecordsByDate(date);

                // reset all the price records for the products
                cart.products.forEach(function(product, index){
                    saveToStoreProductByCartId(index, {
                        priceRecord: []
                    })
                });
            },

            /**
             * Given a date, will set price records available to the
             * user based on that date.
             * @param cartId
             * @param date
             * @returns {*}
             */
            setPriceRecordsByDate: function(cartId, date){
                var self = this;

                // get the product item
                var product = cart.products[cartId];

                // set loading state
                product.isPriceRecordsLoading = true;

                cmp.set('v.store', self);

                // get the price records
                var promise = getPriceRecordsByDate(date);

                // if the request was successful, set the priceRecords and update the store
                promise.then(function(response){
                    product.priceRecord = response;
                    product.isPriceRecordsLoading = false;
                    cmp.set('v.store', self);
                }, function(response){
                    product.isPriceRecordsLoading = false;
                    product.priceRecord = [];
                    cmp.set('v.store', self);
                });

                return promise;
            },

            /**
             * Set requested date attribute
             * @param date
             */
            setRequestedShipDate: function(cartId, date){
                var product = cart.products[cartId];
                product.requestShipDate = date;
                cmp.set('v.store', this);
            },

            /**
             * Return if all products items have valid data provided
             * @returns {boolean}
             */
            hasValidProducts: function(){
                return hasValidProducts();
            },

            /**
             * Add a default product to the cart of products
             * @param num
             */
            addProducts: function (num) {
                if(num !== undefined && !isNaN(num)){
                    for(var x=0; x < num; x++) {
                        cart.products.push(createProduct());
                    }
                    cmp.set('v.store', this);
                }
            },

            /**
             * Given some product data will create and add a product
             * to the cart
             */
            addProductFromSearchResult: function(productFromSearch){
                var formattedProductFromSearch = createProductFromSearchResult(productFromSearch);
                var product = createProduct(formattedProductFromSearch);

                cart.products.push(product);
                cmp.set('v.store', this);
            },

            addProductFromSearchResultByCartId: function(cartId, productFromSearch){
                if(cartId !== undefined && cart.products[cartId] !== undefined ){
                    var formattedProductFromSearch = createProductFromSearchResult(productFromSearch);
                    cart.products[cartId] = createProduct(formattedProductFromSearch);
                    cmp.set('v.store', this);
                } else {
                    this.addProductFromSearchResult(productFromSearch);
                }

            },

            /**
             * Given a cartId remove that product from the cart
             * @param cartId
             */
            removeProductByCartId: function(cartId){
                if(cartId !== undefined && cartId > -1 && cart.products[cartId] !== undefined){

                    // remove the product from the cart
                    cart.products.splice(cartId, 1);

                    // update order totals
                    updateOrderTotals();

                    cmp.set('v.store', this);
                }
            },

            /**
             * Make ATP call to get SKU data
             * @param cartId
             * @param sku
             * @param productName
             * @param quantity
             * @param unitOfMeasure
             * @param sourceOfSupply
             * @param requestShipDate
             * @param priceRecord
             * @param isPriceBySku
             * @returns {*}
             */
            getAdditionalProductData: function(cartId, sku, productName, quantity, unitOfMeasure, sourceOfSupply, requestShipDate, priceRecord, isPriceBySku, isValidData){

                var updatedProduct = {
                    sku: sku,
                    productName: productName,
                    quantity: quantity,
                    unitOfMeasure: unitOfMeasure,
                    sourceOfSupply: sourceOfSupply,
                    requestShipDate: requestShipDate,
                    priceRecord: priceRecord,
                    isValidData: isValidData
                };

                saveToStoreProductByCartId(cartId, updatedProduct);
                return getAdditionalProductData.call(this, cartId, isPriceBySku);
            },

            /**
             * Make service call to get product supply data
             * @param cartId
             * @returns {*}
             */
            getProductSupplyData: function(cartId){
                var self = this;
                var promise = getProductSupplyData(cartId);

                // get the product item
                var product = cart.products[cartId];

                // set loading state
                product.showProductSupply = true;
                product.isProductSupplyLoading = true;
                cmp.set('v.store', self);

                promise.then(function(response){
                    product.isProductSupplyLoading = false;
                    product.futureProductSupply = response;
                    cmp.set('v.store', self);
                }, function(response){
                    console.log('getProductSupplyData:error:', response);
                    product.isProductSupplyLoading = false;
                    product.futureProductSupply = [];
                    cmp.set('v.store', self);
                });

                return promise;
            },

            /**
             * Make service call to return product shade data
             * @param cartId
             * @returns {Promise}
             */
            getProductShadeData: function(cartId){
                return getProductShadeData.call(this, cartId);
            },

            /**
             * Create unit of measure list and return it
             * @param skuObject
             * @returns {Array}
             */
            createUnitOfMeasure: function(skuObject){
                return createUnitOfMeasureList(skuObject.UOM__c || [], skuObject.Base_UoM__c);
            },

            /**
             * Given list of DT_SYS_PriceRecord__x will return formatted price record list.
             */
            createPriceRecordsList: function(List_DT_SYS_PriceRecord__x){
                return createPriceRecordsList(List_DT_SYS_PriceRecord__x);
            },

            /**
             * User selected a new source of supply, so will update the new
             * selected source of supply as well as the ATP data from that
             * source of supply. We already have the ATP date from the initial
             * ATP call so no service call is needed.
             * @param cartId
             * @param supplyplantID
             */
            updateSourceOfSupply: function(cartId, supplyplantID){
                if(cart.products[cartId] !== undefined){
                    var product = cart.products[cartId];
                    var sourceOfSupply = product.sourceOfSupply;

                    // iterate the source of supply array
                    sourceOfSupply.forEach(function(source){
                        if(source.supplyPlantID === supplyplantID){
                            source.selected = true;
                            updateToStoreFromSourceOfSupply(cartId, source);
                        } else {
                            source.selected = false;
                        }
                    });

                    cmp.set('v.store', this);
                }
            },

            /**
             * Save an order to the store and server
             * @returns {*}
             */
            saveOrder: function(){
                var self = this;

                var shippingInfo = this.getShippingInfo();
                var orderInfo = this.getOrderInfo();
                var products = this.getCartProducts();
                console.log("Save order shippingInfo--->",shippingInfo);

                var tempProducts = [];

                for(var x=0; x<products.length; x++){
                    if((typeof(products[x].sku) != undefined && products[x].sku != null && products[x].sku != '') &&
                        (typeof(products[x].quantity) != undefined && products[x].quantity != null && products[x].quantity != '')){

                        tempProducts.push(products[x]);
                    }
                }

                var promise = saveOrderToServer(shippingInfo, orderInfo, tempProducts);

                promise.then(function(){
                    cmp.set('v.store', self);
                }, function(){
                    // handle error if needed
                });

                return promise;
            },

            /**
             * Save and continue from the sku page of the order (step 1 order process)
             */
            saveContinueSku: function(){
                var self = this;

                // need to get reference to the order process event, so next step can use it.
                // since call in inside of callback it loses context. Even setting context
                // using .call doesn't work.
                var orderProcessStepEvt = getOrderProcessStepEvent();

                return new Promise($A.getCallback(function (resolve, reject) {
                    var saveOrder = self.saveOrder();

                    saveOrder.then(function(){

                        // set the ability to ship as small package
                        shippingInfo.canShipSmallPackage = canShipSmallPackage();

                        // get the default ship to address used on the detail page.
                        var getUserSelectedLocation = helper.getUserSelectedLocation(cmp);

                        getUserSelectedLocation.then(function(response){
                            saveShipToFromSelectedLocation(response);
                            self.nextStep(orderProcessStepEvt);
                            resolve();
                        }, function(response){
                            console.log('Dal_Dist_OrderBase:saveContinueSku:failed:', response);
                            reject();
                        });

                    }, function(response){
                        console.log('Dal_Dist_OrderBase:saveContinueSku:failed:', response);
                        reject();
                    });
                }));
            },

            /**
             * Save and continue from the order detail page (step 2 order process)
             */
            saveContinueDetail: function(){
                var self = this;

                // need to get reference to the order process event, so next step can use it.
                // since call in inside of callback it loses context. Even setting context
                // using .call doesn't work.
                var orderProcessStepEvt = getOrderProcessStepEvent();

                return new Promise($A.getCallback(function (resolve, reject) {
                    var saveOrder = self.saveOrder();

                    saveOrder.then(function(){
                        self.nextStep(orderProcessStepEvt);
                        resolve();
                    }, function(response){
                        console.log('Dal_Dist_OrderBase:saveContinueSku:failed:', response);
                        reject();
                    });
                }));
            },

            submitOrder: function(){
                return new Promise($A.getCallback(function (resolve, reject) {
                    var submitOrderPromise = submitOrderToServer();
                    submitOrderPromise.then(function(response){
                        resolve(response);
                    }, function(response){
                        reject(response);
                    });
                }));
            },

            /**
             * Given a cartId and a product object, will update the store
             * with the product, but won't update the aura "store" attribute. We
             * do this because we don't always want the view to refresh because the
             * aura attribute updated.
             * @param cartId
             * @param product
             */
            backgroundUpdateStoreProduct: function(cartId, product){
                console.log('background update:', product);
                saveToStoreProductByCartId(cartId, product);
            },

            /**
             * Save products then move to the next
             * step in the order process
             */
            nextStep: function(refOrderProcessStepEvt) {

                // check if the order process step event is passed in, if not try to get it. Why would we do it this
                // way, why wouldn't we just get it here, well there are issues with context and using $A to get
                // aura application events, the issues usually occur in promise callbacks.
                var orderProcessStepEvt = (refOrderProcessStepEvt !== undefined) ? refOrderProcessStepEvt : getOrderProcessStepEvent();

                // update the current position
                this.currentPos += 1;

                // prepare the params for the the orderProcessStepEvt event
                orderProcessStepEvt.setParams({
                    'currentPos': this.currentPos
                });

                // fire the orderProcessStepEvt
                orderProcessStepEvt.fire();

                cmp.set('v.store', this);
            },

            /**
             * Save products then move to the next
             * step in the order process
             */
            previousStep: function(){
                var orderProcessStepEvt = getOrderProcessStepEvent();

                // update the current position
                this.currentPos -= 1;

                // prepare the params for the the orderProcessStepEvt event
                orderProcessStepEvt.setParams({
                    'currentPos': this.currentPos
                });

                // fire the orderProcessStepEvt
                orderProcessStepEvt.fire();

                cmp.set('v.store', this);
            },

            /**
             * Given a step number go to that step
             * @param stepNumber
             */
            goToStep: function(stepNumber){
                var orderProcessStepEvt = getOrderProcessStepEvent();

                // update the current position
                this.currentPos = stepNumber;

                // prepare the params for the the orderProcessStepEvt event
                orderProcessStepEvt.setParams({
                    'currentPos': this.currentPos
                });

                // fire the orderProcessStepEvt
                orderProcessStepEvt.fire();

                cmp.set('v.store', this);
            },

            /**
             * Given an orderWrapper from APEX service call will map that object
             * to the store model for products, shippingInfo and orderInfo. Used
             * primary for detail view pages.
             * @param orderWrapper
             */
            mapOrderWrapperToStore: function(orderWrapper){
                mapOrderWrapperToStore(orderWrapper);
            }, // end mapOrderWrapperToStore

            updateProductByCartIdToStore: function(cartId, product){
                saveToStoreProductByCartId(cartId, product);
                cmp.set('v.store', this);
            },

            updateShippingInfoToStore: function(shippingInfo){
                saveToStoreShippingInfo(shippingInfo);
                cmp.set('v.store', this);
            },

            updateOrderInfoToStore: function(orderInfo){
                saveToStoreOrderInfo(orderInfo);
                cmp.set('v.store', this);
            },

            initExistingProductRows: function(){
                var self = this;
                var products = this.getCartProducts();
                products.forEach(function(product, index){
                    initExistingProduct.call(self, product, index);
                });
            },

            getCartProductsPriceBySku: function(){
                var self = this;
                var products = cart.products;

                if(products.length > 0){
                    products.forEach(function(product, index){
                        getPriceBySkuByCartId.call(self, index);
                    });
                }
            }

        } // end public methods
        // -----------------------------------------------------
        // End Public Function/Variables
        // -----------------------------------------------------

    } // end create store

})