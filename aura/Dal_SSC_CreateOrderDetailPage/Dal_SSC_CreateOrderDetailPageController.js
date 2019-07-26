/**
 * Created by ranja on 28-12-2018.
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

    clearSelectedValue : function(cmp,event,helper) {

        var indexSelected = event.currentTarget.name;
        var finalResponseWrapper = cmp.get('v.finalResponseWrapper');

        finalResponseWrapper.splice(indexSelected,1);
        cmp.set('v.finalResponseWrapper',finalResponseWrapper);
    },

    openSkuDetailPage : function(cmp,event,helper) {

        var indexOfSelectedSku = event.currentTarget.name;
        var finalResponseWrapper = cmp.get('v.finalResponseWrapper');
        var _selectedSkuResponseWrapper = {};
        var _sel = [];

        _selectedSkuResponseWrapper = finalResponseWrapper[indexOfSelectedSku];

        _sel.push(_selectedSkuResponseWrapper);
        cmp.set('v.finalResponseWrapper',_sel);
        console.log('SELECTED SKU FOR SEARCH: ', _sel);

        //Event Fire
        var appEvent = $A.get("e.c:Dal_SSC_CreateOrderProductPageChange");
        appEvent.setParams({ "pageName" : _selectedSkuResponseWrapper.Description, "skuName" : _selectedSkuResponseWrapper.sku });
        appEvent.fire();

        helper.navigateToNewPage(cmp,event,helper,'productList',1,'next');
    },

    changeMilesAddress : function(cmp,event,helper) {
        debugger;
        var primaryStoreData = cmp.get('v.primaryStoreData');

        if(!primaryStoreData) {
            primaryStoreData = new Map();
        }

        var finalResponseWrapper = cmp.get('v.finalResponseWrapper');
        var selectedIndex = event.currentTarget.name;
        var listofPrimaryWrapper = [];
        var isStoreChanged1 = finalResponseWrapper[selectedIndex].isStoreChanged;
        if(!isStoreChanged1) {
            primaryStoreData.set(selectedIndex, JSON.parse(JSON.stringify(finalResponseWrapper[selectedIndex])));
            cmp.set('v.primaryStoreData', primaryStoreData);
        }

        var _params = {
            milesWrapperList : finalResponseWrapper[selectedIndex].milesWrapperList,
             indexOfDist : selectedIndex,
             selectedAddressMile : finalResponseWrapper[selectedIndex].supplyPlant,
             finalResponseWrapper : cmp.getReference('v.finalResponseWrapper'),
             UOM : finalResponseWrapper[selectedIndex].BaseUOM,
             prevSupplyPlantId : finalResponseWrapper[selectedIndex].supplyPlantId,
             isStoreChanged : finalResponseWrapper[selectedIndex].isStoreChanged,
             availableQty : finalResponseWrapper[selectedIndex].availableQty,
             totalCartons : finalResponseWrapper[selectedIndex].totalCartons
        };

        console.log('Params for miles modal: ', _params);
        helper.openModal(cmp,'c:Dal_Dist_Inventory_SkuAvailTable',_params,false,'dal-modal_small');

     },

    handleBackToPSL : function(cmp,event,helper) {
		debugger;
         try{

             var selectedIndex = event.currentTarget.name;
             var finalResponseWrapper = cmp.get('v.finalResponseWrapper');
             var primaryStoreData = cmp.get('v.primaryStoreData');

             if(primaryStoreData) {
                 if(primaryStoreData.has(selectedIndex)) {
                     console.log('data found');
                     finalResponseWrapper[selectedIndex] = primaryStoreData.get(selectedIndex);
                     cmp.set('v.finalResponseWrapper',finalResponseWrapper);
                 } else {
                     console.error('data not found');
                 }
             }


         } catch(ex) {

         }
    },

    handleQuantityChange : function(cmp,event,helper) {
         debugger;
         try {
             helper.startSpinner(cmp);

             var finalResponseWrapper = cmp.get('v.finalResponseWrapper');
             var index = event.getSource().get('v.name');

             let oldArray = finalResponseWrapper;
             let newArray;

             cmp.set('v.isOldQuantity',finalResponseWrapper[index].updatedQuantity);
             cmp.set('v.isPageLoad',false);
             console.log('isOldQuantity: ', finalResponseWrapper[index].updatedQuantity);
             var _params = {
                    material : finalResponseWrapper[index].sku ,
                    pricedQuantityUOM : finalResponseWrapper[index].updatedBaseUOM ,
                    pricedQuantity : Math.abs(finalResponseWrapper[index].updatedQuantity),
                    supplyPlant : finalResponseWrapper[index].supplyPlantId
             };

             helper.doCallout(cmp, 'c.getMyCartPriceData', _params,function(response){
                  var state = response.getState();
                  if(state === "SUCCESS"){
                     console.log('Resp from Calc: ', response.getReturnValue());
                     var _resp = response.getReturnValue();
                      if(oldArray[index].updatedQuantity == _resp[0].quantity){
                            finalResponseWrapper[index].isChanged =  false;
                        }else{
                            finalResponseWrapper[index].isChanged =  true;
                        }
                     finalResponseWrapper[index].updatedQuantity = _resp[0].quantity;
                     
                     cmp.set('v.finalResponseWrapper',finalResponseWrapper);
                     cmp.set('v.isQuantityChanged',true);





                  }
             });
             helper.stopSpinner(cmp);
         }
         catch(err) {
                helper.stopSpinner(cmp);
                console.log('error-----');
         }

    }

})