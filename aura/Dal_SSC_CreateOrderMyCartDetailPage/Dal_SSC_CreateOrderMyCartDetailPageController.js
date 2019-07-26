/**
 * Created by ranja on 07-01-2019.
 */
({
    doInit : function(cmp,event,helper) {
        helper.getCartProducts(cmp,event,helper);
    },

    handleLiftGateChange : function(cmp,event,helper) {
        //debugger;
        var orderNumber = event.currentTarget.value;
        var myCartOrderOne = cmp.get('v.myCartOrderOne');
        var myCartOrderTwo = cmp.get('v.myCartOrderTwo');

        if(orderNumber === 'order1') {
            if(myCartOrderOne[0].liftGate)
                myCartOrderOne[0].liftGate = false;
            else
                myCartOrderOne[0].liftGate = true;

            cmp.set('v.myCartOrderOne', myCartOrderOne);
        } else {
            if(myCartOrderTwo[0].liftGate)
                myCartOrderTwo[0].liftGate = false;
            else
                myCartOrderTwo[0].liftGate = true;

            cmp.set('v.myCartOrderTwo', myCartOrderTwo);
        }

    },

/*
    handleChangeDeliveryAddress : function(cmp,event,helper) {

        helper.openModal(cmp,'c:Dal_SSC_CreateOrderMyCartDeliveryAddress',{

        },
        true,
        'dal-modal_x-small'
        );
    },
*/


    handleDeliveryAddressChange : function(cmp,event,helper) {
        debugger;
        var paramsForAddress = {};
        var myCartOrderOne = cmp.get('v.myCartOrderOne');
        var myCartOrderTwo = cmp.get('v.myCartOrderTwo');

        try {
            var orderNumber = event.getSource().get('v.name');

            paramsForAddress = {orderNumber : orderNumber};

            helper.openModal(cmp,'c:Dal_SSC_CreateOrderChooseDeliveryAddress', paramsForAddress ,
              true,'slds-modal_small');
        } catch(err) {

        }
    },

    handleQuantityChange : function(cmp,event,helper) {
        try {
            debugger;

            helper.startSpinner(cmp);
            var index = event.getSource().get('v.name');


            var arr = index.split(' ');
            var indexOfCalc = index.split(' ')[0];
            //var indexOfCalc = event.getSource().get('v.id');
            var orderNumber = index.split(' ')[1];
            //var orderNumber = event.getSource().get('v.name');
            var myCartOrderOne = cmp.get('v.myCartOrderOne');
            var myCartOrderTwo = cmp.get('v.myCartOrderTwo');
            var _energySurchargeTotal = 0.0;
            var _orderSubTotalTotal = 0.0;
            var _estimatedTotal = 0.0;
            var flag = false;


            if(orderNumber.toUpperCase() === 'ORDER1'){
                var quantityChange = myCartOrderOne[indexOfCalc].updatedQuantity;
            }
            else{
                var quantityChange = myCartOrderTwo[indexOfCalc].updatedQuantity;
            }
            /*var re = /^[+]?[0-9]*\.?[0-9]+$/;
            if(quantityChange.match(re)){*/


           if(myCartOrderOne   &&   myCartOrderOne.length > 0   &&  orderNumber.toUpperCase() === 'ORDER1') {


               /*for(var i=0;i<myCartOrderOne.length;i++) {
                   var sku = myCartOrderOne[i];
                   _energySurchargeTotal = _energySurchargeTotal + parseFloat(sku.energySurcharge);
                   _orderSubTotalTotal = _orderSubTotalTotal + (parseFloat(sku.unit) * parseFloat(sku.updatedQuantity));
                   flag = true;
               }*/
                    var _oldEnergySurcharge = myCartOrderOne[indexOfCalc].energySurcharge;
                    var _oldSubTotal = myCartOrderOne[indexOfCalc].totalSingleLineQuantity;

                     var materialId = myCartOrderOne[indexOfCalc].productSKU;
                     var supplyPlant = myCartOrderOne[indexOfCalc].supplyPlantId;
                     var selectedUOM = myCartOrderOne[indexOfCalc].UOM;
                     var selQty = Math.abs(myCartOrderOne[indexOfCalc].updatedQuantity);
                     var selectedQuantity = selQty.toString();

           }

           if(myCartOrderTwo   &&   myCartOrderTwo.length > 0   &&   orderNumber.toUpperCase() === 'ORDER2') {
              /*for(var i=0;i<myCartOrderTwo.length;i++) {
                   var sku = myCartOrderTwo[i];
                   _energySurchargeTotal = _energySurchargeTotal + parseFloat(sku.energySurcharge);
                   _orderSubTotalTotal = _orderSubTotalTotal + (parseFloat(sku.unit) * parseFloat(sku.updatedQuantity));
                   flag = true;
              }*/

                  var _oldEnergySurcharge = myCartOrderTwo[indexOfCalc].energySurcharge;
                  var _oldSubTotal = myCartOrderTwo[indexOfCalc].totalSingleLineQuantity;
                                
                  var materialId = myCartOrderTwo[indexOfCalc].productSKU;
                  var supplyPlant = myCartOrderTwo[indexOfCalc].supplyPlantId;
                  var selectedUOM = myCartOrderTwo[indexOfCalc].UOM;
                  var selQty = Math.abs(myCartOrderTwo[indexOfCalc].updatedQuantity);
                  var selectedQuantity = selQty.toString();

           }

           var params = {
               material : materialId ,
               pricedQuantityUOM : selectedUOM ,
               pricedQuantity : selectedQuantity,
               supplyPlant : supplyPlant

           };
            let oldMycartOneArray = myCartOrderOne;
            let oldMycartTwoArray = myCartOrderTwo;
            cmp.set('v.isPageLoad',false);
            helper.doCallout(cmp, 'c.getMyCartPriceData', params,function(response){
                 var state = response.getState();
                 if(state === "SUCCESS"){
                // make sure we have a valid response
                     _orderSubTotalTotal = cmp.get('v.orderSubTotalTotal');
                     _energySurchargeTotal = cmp.get('v.energySurchargeTotal');

                   console.log('Resp from Calc: ', response.getReturnValue());

                        _orderSubTotalTotal = _orderSubTotalTotal - _oldSubTotal;
                        _orderSubTotalTotal = _orderSubTotalTotal + response.getReturnValue()[0].extendedNetPrice;

                        _energySurchargeTotal = _energySurchargeTotal - _oldEnergySurcharge;
                        _energySurchargeTotal = _energySurchargeTotal + response.getReturnValue()[0].ExtendedEnergySurCharge;

                   if(myCartOrderOne   &&   myCartOrderOne.length > 0   &&  orderNumber.toUpperCase() === 'ORDER1') {
                       if(oldMycartOneArray[indexOfCalc].updatedQuantity == response.getReturnValue()[0].quantity){
                           myCartOrderOne[indexOfCalc].isChanged =  false;
                       }else{
                           myCartOrderOne[indexOfCalc].isChanged =  true;
                       }
                        myCartOrderOne[indexOfCalc].totalSingleLineQuantity = response.getReturnValue()[0].extendedNetPrice;
                        myCartOrderOne[indexOfCalc].updatedQuantity = response.getReturnValue()[0].quantity;
                        myCartOrderOne[indexOfCalc].energySurcharge = response.getReturnValue()[0].ExtendedEnergySurCharge;

                        cmp.set('v.myCartOrderOne', myCartOrderOne);
                   }

                   if(myCartOrderTwo   &&   myCartOrderTwo.length > 0   &&   orderNumber.toUpperCase() === 'ORDER2') {
                       if(oldMycartTwoArray[indexOfCalc].updatedQuantity == response.getReturnValue()[0].quantity){
                          myCartOrderTwo[indexOfCalc].isChanged =  false;
                      }else{
                          myCartOrderTwo[indexOfCalc].isChanged =  true;
                      }
                       myCartOrderTwo[indexOfCalc].totalSingleLineQuantity = response.getReturnValue()[0].extendedNetPrice;
                       myCartOrderTwo[indexOfCalc].updatedQuantity = response.getReturnValue()[0].quantity;
                       myCartOrderTwo[indexOfCalc].energySurcharge = response.getReturnValue()[0].ExtendedEnergySurCharge;

                       cmp.set('v.myCartOrderTwo', myCartOrderTwo);
                   }
                    var _myCartOne = cmp.get('v.myCartOrderOne');
                    var _myCartTwo = cmp.get('v.myCartOrderTwo');
                    if(_myCartOne.length > 0){
                          for(var i=0;i<_myCartOne.length;i++){
                             if(_myCartOne[i].totalSingleLineQuantity == 0){
                                 cmp.set('v.isPriceError',true);
                                 console.log('true');
                             }
                          }
                    }
                    if(_myCartTwo.length > 0){
                          for(var i=0;i<_myCartTwo.length;i++){
                             if(_myCartTwo[i].totalSingleLineQuantity == 0){
                                 cmp.set('v.isPriceError',true);
                                 console.log('true');
                             }
                          }
                    }

                   cmp.set('v.energySurchargeTotal', _energySurchargeTotal.toFixed(2));
                   cmp.set('v.orderSubTotalTotal', _orderSubTotalTotal.toFixed(2));
                   cmp.set('v.estimatedTotal', (_energySurchargeTotal + _orderSubTotalTotal).toFixed(2));
                    helper.stopSpinner(cmp);
               }

            });
            /*}else{
                cmp.set('v.isShowError', true);
                helper.stopSpinner(cmp);
            }*/
        } catch(err) {
           helper.stopSpinner(cmp);
           console.log('error-----')
        }

    },

    handleRemove :  function(cmp,event,helper) {
        var indexToProd = event.currentTarget.name;
        var orderId = event.currentTarget.id;

        var appEvent = $A.get("e.c:Dal_SSC_MyCartQuantityUpdateEvent");
        appEvent.setParams({ "cartTotal" : 1, 'action' : 'DELETE' });
        appEvent.fire();

        helper.deleteProduct(cmp,event,helper,orderId,indexToProd);
    },

    changeModeOrderOne : function(cmp,event,helper) {
        //debugger;
        var myCartResponse = cmp.get('v.myCartResponse');
        var selectedMode = event.getSource().get("v.text");
        var myCartOrderOne = cmp.get('v.myCartOrderOne');

        if(selectedMode === 'Delivery') {
            myCartOrderOne[0].fulfillmentType = 'Delivery';
            myCartOrderOne[0].isDelivery = true;
            myCartOrderOne[0].isPickUp = false;
            //cmp.set('v.isPickUpOne', false);
            //cmp.set('v.isDeliveryOne', true);
        } else {
            myCartOrderOne[0].fulfillmentType = 'PickUp';
            myCartOrderOne[0].isDelivery = false;
            myCartOrderOne[0].isPickUp = true;
            //cmp.set('v.isPickUpOne', true);
            //cmp.set('v.isDeliveryOne', false);
        }
        cmp.set('v.myCartOrderOne',myCartOrderOne);
    },

    changeModeOrderTwo : function(cmp,event,helper) {
        var myCartResponse = cmp.get('v.myCartResponse');
        var selectedMode = event.getSource().get("v.text");
        var myCartOrderTwo = cmp.get('v.myCartOrderTwo');

        if(selectedMode === 'Delivery') {
            myCartOrderTwo[0].fulfillmentType = 'Delivery';
            myCartOrderTwo[0].isDelivery = true;
            myCartOrderTwo[0].isPickUp = false;
        } else {
            myCartOrderTwo[0].fulfillmentType = 'PickUp';
            myCartOrderTwo[0].isDelivery = false;
            myCartOrderTwo[0].isPickUp = true;
        }
        cmp.set('v.myCartOrderTwo',myCartOrderTwo);
    },

    handleDeliveryAddressChangeEvent : function(cmp,event,helper) {

        console.log('### HANDLE EVENT ADDRESS CHANGE ###');
        var myCartOrderOne = cmp.get('v.myCartOrderOne');
        var myCartOrderTwo = cmp.get('v.myCartOrderTwo');

        var orderNumber = event.getParam('orderNumber');
        if(orderNumber === 'order1') {
            myCartOrderOne[0].shippingName = event.getParam('companyName'); 
            myCartOrderOne[0].shippingStreet = event.getParam('streetAddress');
            myCartOrderOne[0].shippingCity = event.getParam('city');
            myCartOrderOne[0].shippingState = event.getParam('state');
            myCartOrderOne[0].shippingCountry = event.getParam('country');
            myCartOrderOne[0].shippingZIPCode = event.getParam('zipCode');
            //console.log('myCartOrderOne[0]: ',myCartOrderOne[0]);
        } else {
            myCartOrderTwo[0].shippingName = event.getParam('companyName');
            myCartOrderTwo[0].shippingStreet = event.getParam('streetAddress');
            myCartOrderTwo[0].shippingCity = event.getParam('city');
            myCartOrderTwo[0].shippingState = event.getParam('state');
            myCartOrderTwo[0].shippingCountry = event.getParam('country');;
            myCartOrderTwo[0].shippingZIPCode = event.getParam('zipCode');
        }
        cmp.set('v.myCartOrderOne',myCartOrderOne);
        cmp.set('v.myCartOrderTwo',myCartOrderTwo);
    },

    openCalculator : function(cmp,event,helper) {
        debugger;
        var index = event.currentTarget.id;

        if(index == 'order1'){
            var finalResponseWrapper = cmp.get('v.myCartOrderOne');
        }else if(index == 'order2'){
            var finalResponseWrapper = cmp.get('v.myCartOrderTwo');
        }

        var indexOfCalc = event.currentTarget.name;
        //var createOrderWrapper = cmp.get('v.createOrderWrapper');
        var selQty = finalResponseWrapper[indexOfCalc].updatedQuantity;

        helper.openModal(cmp,'c:Dal_SSC_Inventory_madalCalculator',{
             listOfUOM : finalResponseWrapper[indexOfCalc].listOfUOM,
             materialId : finalResponseWrapper[indexOfCalc].productSKU,
             selectedUOM : finalResponseWrapper[indexOfCalc].updatedUOM,
             selectedQuantity : selQty.toString()
           },
             true,
            'dal-modal_small'
         );

    },


})