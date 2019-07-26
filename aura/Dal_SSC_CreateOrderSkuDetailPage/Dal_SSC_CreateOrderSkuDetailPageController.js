/**
 * Created by ranja on 01-01-2019.
 */
({
    openCalculator : function(cmp,event,helper) {
        //debugger;
        var finalResponseWrapper = cmp.get('v.finalResponseWrapper');
        var indexOfCalc = event.currentTarget.name;
        var createOrderWrapper = cmp.get('v.createOrderWrapper');
        var selQty = finalResponseWrapper[indexOfCalc].updatedQuantity;

        helper.openModal(cmp,'c:Dal_SSC_Inventory_madalCalculator',{
             listOfUOM : finalResponseWrapper[indexOfCalc].uomList,
             materialId : finalResponseWrapper[indexOfCalc].sku,
             selectedUOM : finalResponseWrapper[indexOfCalc].updatedBaseUOM,
             selectedQuantity : selQty.toString()
           },
           true,
           'dal-modal_small'
        );

    },

    changeMilesAddress : function(cmp,event,helper) {
        var finalResponseWrapper = cmp.get('v.finalResponseWrapper');

        var isStoreChanged1 = finalResponseWrapper[0].isStoreChanged;
        if(!isStoreChanged1) {
            var object2 = Object.assign({}, finalResponseWrapper[0]);
            cmp.set('v.primaryStoreData', object2);
        }
        var _params = {
             milesWrapperList : finalResponseWrapper[0].milesWrapperList,
             indexOfDist : 0,
             selectedAddressMile : finalResponseWrapper[0].supplyPlant,
             finalResponseWrapper : cmp.getReference('v.finalResponseWrapper'),
             UOM : finalResponseWrapper[0].BaseUOM,
             prevSupplyPlantId : finalResponseWrapper[0].supplyPlantId,
             isStoreChanged : finalResponseWrapper[0].isStoreChanged,
             availableQty : finalResponseWrapper[0].availableQty,
             totalCartons : finalResponseWrapper[0].totalCartons,
        };
        console.log('Params for miles modal: ', _params);
        helper.openModal(cmp,'c:Dal_Dist_Inventory_SkuAvailTable',_params,false,'dal-modal_small');

    },

    handleBackToPSL : function(cmp,event,helper) {
       debugger;
        try{
            var finalResponseWrapper = cmp.get('v.finalResponseWrapper');
            var primaryStoreData = cmp.get('v.primaryStoreData');

            if(primaryStoreData) {
                finalResponseWrapper[0] = primaryStoreData;
                cmp.set('v.finalResponseWrapper',finalResponseWrapper);
            }

        } catch(ex) {

        }
    },

    handleAddToCart : function(cmp,event,helper) {
        debugger;
        var createOrderWrapper = cmp.get('v.createOrderWrapper');
        var isAccountOnHold = false;
        var finalResponseWrapper = cmp.get('v.finalResponseWrapper');
        var viewCartWrapper = [];
        var productsNotEntered = [];

        if(finalResponseWrapper && finalResponseWrapper.length > 0) {
            if(finalResponseWrapper[0].accountCreditRiskCategory === 'D80') {
                isAccountOnHold = true;
            }
        }

        if(isAccountOnHold) {
            helper.openModal(cmp,'c:Dal_SSC_CreateOrderProductSearchCancelModal',{},
               false,
               'dal-modal_small'
            );
        }
        if(finalResponseWrapper && finalResponseWrapper.length > 0) {
            if(finalResponseWrapper[0].cartProducts.length > 0){

                var cartProductList = finalResponseWrapper[0].cartProducts;
                for(var i=0;i<cartProductList.length;i++){

                    if(cartProductList[i].Product__r.DW_ID__c == finalResponseWrapper[0].sku && cartProductList[i].SSC__r.SAP_Plant__c == finalResponseWrapper[0].supplyPlantId){
                            productsNotEntered.push(finalResponseWrapper[0].supplyPlant);
                            helper.openModal(cmp,'c:Dal_SSC_CreateOrderProductCheck',{productNotEntered : productsNotEntered , isSingle : true},
                                                  false,
                                                  'dal-modal_small'
                            );
                    }

                }

            }
        }

         if(!isAccountOnHold && productsNotEntered.length == 0) {
 
           if(finalResponseWrapper && finalResponseWrapper.length > 0) {

             for(var i=0;i<finalResponseWrapper.length;i++) {
                 finalResponseWrapper[i].PiecesPerCarton = finalResponseWrapper[i].PiecesPerCarton__c;
                 finalResponseWrapper[i].SquarefeetPerCarton = finalResponseWrapper[i].SquarefeetPerCarton__c;
             }

             helper.startSpinner(cmp);
             console.log('finalResponseWrapper: ',finalResponseWrapper);
             cmp.set('v.finalResponseWrapper',finalResponseWrapper);
             helper.doCallout(cmp, "c.addToCart", {cartValue : JSON.stringify(finalResponseWrapper)}, function(response){
                 var state = response.getState();
                 if(state === "SUCCESS"){
                     var _resp = response.getReturnValue();
                     console.log('Resp for View Cart: ', _resp);
                     //var finalResponseWrapperResp = cmp.get('v.finalResponseWrapper');
                     var finalResponseWrapperResp = _resp.cartproductLst;

                     var appEvent = $A.get("e.c:Dal_SSC_MyCartQuantityUpdateEvent");
                     appEvent.setParams({ "cartTotal" : finalResponseWrapperResp.length, 'action' : 'ADD' });
                     appEvent.fire();

                     var appEvent = $A.get("e.c:Dal_SSC_CreateOrderProdListCaptureEvt");
                     appEvent.setParams({ "quantity" : 0 });
                     appEvent.fire();
                     helper.stopSpinner(cmp);

                     if(finalResponseWrapperResp.length > 0){

                          helper.openModal(cmp,'c:Dal_SSC_CreateOrderDetailAddToCart',{
                             finalResponseWrapper : finalResponseWrapper,
                             createOrderWrapper : cmp.get('v.createOrderWrapper')
                             },
                             false,
                             'dal-modal_small'
                          );
                      }else{
                           helper.openModal(cmp,'c:Dal_SSC_CreateOrderProductCheck',{productNotEntered : _resp.notEntered[0] , isAddingCart : true},
                                                false,
                                                'dal-modal_small'
                          );
                      }
                 }
             });
           }
        }
    },
    handleQuantityChange : function(cmp,event,helper) {
        debugger;
        try {
            helper.startSpinner(cmp);

            var finalResponseWrapper = cmp.get('v.finalResponseWrapper');
            let oldArray = finalResponseWrapper;
            let newArray;

            var _params = {
                   material : finalResponseWrapper[0].sku ,
                   pricedQuantityUOM : finalResponseWrapper[0].updatedBaseUOM ,
                   pricedQuantity : Math.abs(finalResponseWrapper[0].updatedQuantity),
                   supplyPlant : finalResponseWrapper[0].supplyPlantId
            };
            cmp.set('v.isPageLoad',false);
            helper.doCallout(cmp, 'c.getMyCartPriceData', _params,function(response){
                 var state = response.getState();
                 if(state === "SUCCESS"){
                    console.log('Resp from Calc: ', response.getReturnValue());
                    var _resp = response.getReturnValue();
                    if(oldArray[0].updatedQuantity == _resp[0].quantity){
                        finalResponseWrapper[0].isChanged =  false;
                    }else{
                        finalResponseWrapper[0].isChanged =  true;
                    }
                    for(var i=0; i<finalResponseWrapper.length; i++ ){
                        finalResponseWrapper[i].updatedQuantity = _resp[i].quantity;
                    }
                    cmp.set('v.finalResponseWrapper',finalResponseWrapper);

                 }
            });
            helper.stopSpinner(cmp);
        }
        catch(err) {
               helper.stopSpinner(cmp);
               console.log('error-----');
        }

    },
    handleBackToProduct : function (cmp,event,helper){
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": "/products"
        });
        urlEvent.fire();
    }
})