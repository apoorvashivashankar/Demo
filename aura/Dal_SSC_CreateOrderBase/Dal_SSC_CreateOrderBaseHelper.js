/**
 * Created by ranja on 26-12-2018.
 */
({
    doCallout : function(cmp, methodName, params, callBackFunc){
        //console.log('IN CALLBACK METHOD');
        var action = cmp.get(methodName);
        action.setParams(params);
        action.setCallback(this, callBackFunc);
        $A.enqueueAction(action);
        //console.log('OUT CALLBACK METHOD');
    },

    getDivisionCode : function(cmp,event,helper) {
        debugger;
        try {
            this.startSpinner(cmp);

            helper.doCallout(cmp, "c.getDivision", {}, function(response){
                var state = response.getState();
                if(state === "SUCCESS"){

                    var _resp = response.getReturnValue();
                    cmp.set('v.divisionCode',_resp.division);
                    cmp.set('v.profileName',_resp.profileName);
                    console.log('Resp for DivisionCode: ', _resp);
                    this.stopSpinner(cmp);

                    //Hide Global Search Event
                    var appEvent = $A.get("e.c:Dal_SSC_CreateOrderHideGSearchEvent");
                    appEvent.fire();
 
                    helper.getSeries(cmp,event,helper);
                    helper.getVendors(cmp,event,helper);
                } else {
                    this.stopSpinner(cmp);
                }
            });

        } catch(ex){
            this.stopSpinner(cmp);
        }

    },

    getSeries : function(cmp,event,helper) {

        try{
            this.startSpinner(cmp);
            var brand = helper.getBrandName(cmp);

            helper.doCallout(cmp, "c.getInventorySeriesCreate", {brand : brand} , function(response){
                var state = response.getState();
                if(state === "SUCCESS"){
                     var _resp = response.getReturnValue();
                    console.log("Resp from Series",_resp);
                    var newBrand = helper.getBrandName(cmp);
                    _resp.selectedBrand = newBrand;
                    cmp.set('v.createOrderWrapper',_resp);
                    this.stopSpinner(cmp);
                } else {
                    this.stopSpinner(cmp);
                }
            });

        } catch(ex) {
            this.stopSpinner(cmp);
        }

    },

    getVendors : function(cmp,event,helper){

        try{
            this.doCallout(cmp, "c.getVendors", {}, function(response){
                var state = response.getState();
                if(state === "SUCCESS"){
                    var _resp = response.getReturnValue();
                    console.log('Resp from Vendors: ', _resp);
                    var createOrderWrapper = cmp.get('v.createOrderWrapper');
                    createOrderWrapper.listOfVendors = _resp;
                    cmp.set('v.createOrderWrapper', createOrderWrapper);
                    this.stopSpinner(cmp);
                } else {
                    this.stopSpinner(cmp);
                }
            });
        } catch(ex) {
            this.stopSpinner(cmp);
        }
    },


    getAllProductsOfSeries : function (cmp,helper, _serId,selBrand) {

        try {
        this.startSpinner(cmp);
        helper.doCallout(cmp, 'c.getInventoryColorCodes', {SeriesId : _serId, brand : selBrand}, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var _resp = response.getReturnValue();
                console.log('Response from Colors: ',_resp);

                if(_resp){
                    var createOrderWrapper = cmp.get('v.createOrderWrapper');
                    createOrderWrapper.listOfProducts = _resp;
                    cmp.set('v.createOrderWrapper', createOrderWrapper);
                    helper.getSearchedProductBySku(cmp,event,helper);
                }
                this.stopSpinner(cmp);
            } else {
                this.stopSpinner(cmp);
            }
        });

        } catch(ex) {
            this.stopSpinner(cmp);
        }
    },

    getListOfSearchedProducts : function(cmp,event,helper,_params){
		//debugger;
        var _params = {
            ColorCode : _params[0],
            brand : _params[1],
            quickSearch : _params[2]
        };
        console.log('param for search product: ',_params);

        try{
            this.startSpinner(cmp);

            this.doCallout(cmp, "c.getProductList", _params, function(response){
                var state = response.getState();
                if(state === "SUCCESS"){
                   var _resp = response.getReturnValue();

                   if(_resp && _resp.length>0) {
                        _resp = helper.addCheckboxToResponse(cmp,event,helper,_resp);
                   }
                   console.log('Response for Searched Products: ',_resp );
                   cmp.set('v.responseFromSearchResult',_resp);
                   this.stopSpinner(cmp);
                } else {
                   this.stopSpinner(cmp);
                }
            });
        } catch(ex) {
            this.stopSpinner(cmp);
        }
    },

    getSearchedProductBySku : function(cmp,event,helper){
        //debugger;

        var createOrderWrapper = cmp.get('v.createOrderWrapper');
        var listOfColors = createOrderWrapper.listOfProducts;
        var _selectedColor = createOrderWrapper.selectedColor;
        var _params = [];
        var param = [];
        var divCode = cmp.get('v.divisionCode');

        createOrderWrapper.selectedSize = 'all';
        cmp.set('v.createOrderWrapper',createOrderWrapper);

        this.startSpinner(cmp);
        if(_selectedColor && divCode && listOfColors){
            console.log('_selectedColor: ',_selectedColor);
        if(_selectedColor.toUpperCase() === 'ALL' || _selectedColor === 'All' || _selectedColor == 'All') {
            if(listOfColors.length > 0) {
                for(var i=0;i<listOfColors.length;i++)
                    _params.push(listOfColors[i].colorCode);
            }
        } else {
            _params.push(_selectedColor);
        }
        param.push(_params);

         var selectedBrand = helper.getBrandName(cmp);
        param.push(selectedBrand);
        var skuKeyword = createOrderWrapper.skuKeyword;

        if(!skuKeyword){
            skuKeyword = '';
        }
        param.push(skuKeyword);

        console.log('param for Product Color: ',param);
        helper.getListOfSearchedProducts(cmp,event,helper,param);
        } else {
            this.stopSpinner(cmp);
        }
    },

    getListOfVendorProducts : function(cmp,event,helper,params) {
        try{
            this.startSpinner(cmp);
            this.doCallout(cmp, "c.vendorProducts", params, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
               var _resp = response.getReturnValue();

               if(_resp && _resp.length>0) {
                    _resp = helper.addCheckboxToResponse(cmp,event,helper,_resp);
               }
               console.log('Response for Searched Products: ',_resp );
               cmp.set('v.responseFromSearchResult',_resp);
               this.stopSpinner(cmp);
            } else {
               this.stopSpinner(cmp);
            }
        });
        } catch(ex) {
            this.stopSpinner(cmp);
        }
    },

    goToCreateOrderDetailPageHelper : function(cmp,event,helper) {

        helper.navigateToCreateOrderDetailPage(cmp,event,helper);
        var listOfSelectedProducts = cmp.get('v.listOfSelectedProducts');
        var profileName = cmp.get('v.profileName');

        var appEvent = $A.get("e.c:Dal_SSC_CreateOrderProdListCaptureEvt");
        appEvent.setParams({ "quantity" : listOfSelectedProducts.length ,
                              "profile" : profileName});
        appEvent.fire();

        if(listOfSelectedProducts.length === 1) {

            //Event Fire
            var appEvent = $A.get("e.c:Dal_SSC_CreateOrderProductPageChange");
            appEvent.setParams({ "pageName" : listOfSelectedProducts[0].Description, "skuName" : listOfSelectedProducts[0].DW_ID__c });
            appEvent.fire();
        } else {

            var createOrderWrapper = cmp.get('v.createOrderWrapper');
            createOrderWrapper.updatedBaseUOM = createOrderWrapper.BaseUOM;
            cmp.set('v.createOrderWrapper',createOrderWrapper);

            //Event Fire
            var appEvent = $A.get("e.c:Dal_SSC_CreateOrderProductPageChange");
            appEvent.setParams({ "pageName" : 'My Product List' });
            appEvent.fire();
        }

        var appEvent = $A.get("e.c:Dal_SSC_CreateOrderGlobalSearchDoVisible");
        appEvent.fire();
    },

    navigateToCreateOrderDetailPage : function(cmp,event,helper) {

        var listOfSelectedProducts = cmp.get('v.listOfSelectedProducts');
        var listOfWrapperData = [];


        var today = new Date();
        var tomorrow = new Date();
        tomorrow.setDate(today.getDate()+1);
        var _newDate = tomorrow.getFullYear() + '-' + (tomorrow.getMonth()+1) + '-' + tomorrow.getDate() ;

        if(listOfSelectedProducts && listOfSelectedProducts.length > 0) {
            for(var i=0;i<listOfSelectedProducts.length;i++) {
                var wrapperData = {};
                wrapperData.sku = listOfSelectedProducts[i].DW_ID__c;
                wrapperData.quantity = '1';
                wrapperData.uom = listOfSelectedProducts[i].Base_UoM__c;
                wrapperData.CodeSet = 'Legacy';
                wrapperData.SupplyplantId = '4101';
                wrapperData.SupplyplantType = 'SAP_Plant';
                wrapperData.reqShipdate = _newDate;
                listOfWrapperData.push(wrapperData);
            }
            console.log('Navigation Params for 1st Page: ', listOfWrapperData);
            helper.getExternalData(cmp,event,helper,listOfWrapperData);
        }

    },

    getExternalData : function(cmp,event,helper,paramValue){
         debugger;
         try {
         this.startSpinner(cmp);
         var par = JSON.stringify(paramValue);
         var _params = {
             data : par
         };

         this.doCallout(cmp, "c.getInventoryRecord", _params, function(response){
             var state = response.getState();
             if(state === "SUCCESS"){
                var _resp = response.getReturnValue();
                var listOfSelectedProducts = cmp.get('v.listOfSelectedProducts');
                var updatedRespList = [];

                 if(_resp){

                for(var i=0;i<_resp.length;i++) {

                    var respWrapper = {};
                    respWrapper = _resp[i];

                    if(!respWrapper.totalCartons)
                        respWrapper.totalCartons = '0';

                    if(!respWrapper.availableQty)
                        respWrapper.availableQty = '0';

                    if(listOfSelectedProducts[i].Size__c)
                        respWrapper.Size = listOfSelectedProducts[i].Size__c;

                    if(listOfSelectedProducts[i].Description)
                        respWrapper.Description = listOfSelectedProducts[i].Description;

                    if(listOfSelectedProducts[i].Product_Color__r)
                        respWrapper.Color = listOfSelectedProducts[i].Product_Color__r.Name;

                    if(listOfSelectedProducts[i].Base_UoM__c)
                        respWrapper.BaseUOM = listOfSelectedProducts[i].Base_UoM__c;

                    respWrapper.ShowTill = 5;

                    //console.log('Response for 2nd Page: ',respWrapper);
                    var uomList = [];
                    var uoms = listOfSelectedProducts[i].UOM__c;
                    uomList =  uoms.split(';');

                    if(respWrapper.dateAtSupplyPlant) {
                        var to = respWrapper.dateAtSupplyPlant;
                        var _tos = to.split('-');
                        if(parseInt(_tos[1]) < 10)
                            _tos[1] = '0' + _tos[1];
                        if(parseInt(_tos[2]) < 10)
                            _tos[2] = '0' + _tos[2];

                        var _newTo = _tos[1] + '-' + _tos[2];
                        if(respWrapper.dateAtSupplyPlantFinal) {
                            var forD = respWrapper.dateAtSupplyPlantFinal;
                            var _forDs = forD.split('-');
                            if(parseInt(_forDs[1]) < 10)
                                _forDs[1] = '0' + _forDs[1];
                            if(parseInt(_forDs[2]) < 10)
                                _forDs[2] = '0' + _forDs[2];

                            var _newforD = _forDs[1] + '-' + _forDs[2];
                        }
                        respWrapper.dateAtSupplyPlant = _newTo;
                        respWrapper.dateAtSupplyPlantFinal = _newforD;
                    }
                    
                    
                    respWrapper.uomList = uomList;
                    if(listOfSelectedProducts[i].PiecesPerCarton__c)
                        respWrapper.PiecesPerCarton__c = listOfSelectedProducts[i].PiecesPerCarton__c;
                    if(listOfSelectedProducts[i].SquarefeetPerCarton__c)
                        respWrapper.SquarefeetPerCarton__c = listOfSelectedProducts[i].SquarefeetPerCarton__c;

                    respWrapper.updatedQuantity = respWrapper.pricingQuantity;

                    if(listOfSelectedProducts[i].Base_UoM__c)
                        respWrapper.updatedBaseUOM = listOfSelectedProducts[i].Base_UoM__c;
                    else
                        respWrapper.updatedBaseUOM = uomList[0];

                    updatedRespList.push(respWrapper);
                }
                for(var i=0;i<updatedRespList.length;i++){
                        updatedRespList[i].isChanged = false;
                }
                console.log('RESPONSE for 2nd Page: ', updatedRespList );

                if(updatedRespList.length === 1)
                    helper.navigateToNewPage(cmp,event,helper,'productList',2,'next');
                else
                    helper.navigateToNewPage(cmp,event,helper,'productList',1,'next');

                cmp.set('v.finalResponseWrapper', updatedRespList);

                this.stopSpinner(cmp);
                }
             } else {
                 this.stopSpinner(cmp);
             }
         });

         } catch(ex) {
             console.log('Failed TRY CATCH');
              this.stopSpinner(cmp);
         }
    },

    navigateToMyCartsDetailPage : function(cmp,event,helper) {
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
            var supplyPlant = new Set();
            var wrapperSuppluPlant = new Set();
            var isNoList = false;
            for(var i=0;i<finalResponseWrapper[0].cartProducts.length;i++){
                supplyPlant.add(finalResponseWrapper[0].cartProducts[i].SSC__r.SAP_Plant__c);
            }
            if(supplyPlant.size == 2){
                for(var i=0;i<finalResponseWrapper.length;i++){
                    if(!supplyPlant.has(finalResponseWrapper[i].supplyPlantId)){
                        productsNotEntered.push(finalResponseWrapper[i].supplyPlant);
                    }
                }
            }else{
                for(var i=0;i<finalResponseWrapper.length;i++){
                    if(!supplyPlant.has(finalResponseWrapper[i].supplyPlantId)){
                        supplyPlant.add(finalResponseWrapper[i].supplyPlantId);
                        if(supplyPlant.size > 2){
                            isNoList = true;
                            productsNotEntered.push(finalResponseWrapper[i].supplyPlant);
                        }
                    }
                }
            }
            if(productsNotEntered.length > 0){
                if(isNoList){
                    helper.openModal(cmp,'c:Dal_SSC_CreateOrderProductCheck',
                                     {isAddingCart:true , isNoCartItem:true},
                                 false,
                                 'dal-modal_small'
                                );
                }else{
                    helper.openModal(cmp,'c:Dal_SSC_CreateOrderProductCheck',
                                 {productNotEntered : productsNotEntered, isAddingCart:true},
                                 false,
                                 'dal-modal_small'
                                );
                }
                

            }
            if(productsNotEntered.length == 0){
            
            if(finalResponseWrapper[0].cartProducts.length > 0 ){

                    var cartProductList = finalResponseWrapper[0].cartProducts;
                    for(var i=0;i<cartProductList.length;i++){
                        for(var j=0;j<finalResponseWrapper.length;j++){
                              if(cartProductList[i].Product__r.DW_ID__c == finalResponseWrapper[j].sku && cartProductList[i].SSC__r.SAP_Plant__c == finalResponseWrapper[j].supplyPlantId){
                                    productsNotEntered.push(finalResponseWrapper[j].supplyPlant);
                              }
                        }

                    }
                    if(productsNotEntered.length > 0){
                         helper.openModal(cmp,'c:Dal_SSC_CreateOrderProductCheck',
                                            {productNotEntered : productsNotEntered, isMultple:true},
                                              false,
                                              'dal-modal_small'
                         );

                    }
                    

                }else{
                    var tempSupplyplantSet = new Set();
                    
                    for(var i=0 ; i<= finalResponseWrapper.length ;i++){
                        if(tempSupplyplantSet.size > 2){
                            productsNotEntered.push(1);
                             helper.openModal(cmp,'c:Dal_SSC_CreateOrderProductCheck',
                                    {isAddingCart:true},
                                      false,
                                      'dal-modal_small'
                             );
                            return;
                        }else{
                            if(i < finalResponseWrapper.length){
                                 if(!tempSupplyplantSet.has(finalResponseWrapper[i].supplyPlantId)){
                                    tempSupplyplantSet.add(finalResponseWrapper[i].supplyPlantId);
                                }
                        	}
                        }

                    }
                }
            }
         }
          if(!isAccountOnHold && productsNotEntered.length == 0) {
            if(finalResponseWrapper && finalResponseWrapper.length > 0) {
            //var finalResponseWrapper = cmp.get('v.finalResponseWrapper');
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

                    if(_resp.notEntered.length > 0){
                        helper.openModal(cmp,'c:Dal_SSC_CreateOrderProductCheck', 
                                        {productNotEntered : _resp.notEntered, isMultipleCart:true},
                                          false,
                                          'dal-modal_small'
                         );
                    }else{
                        helper.openModal(cmp,'c:Dal_SSC_CreateOrderDetailAddToCart',{
                                        finalResponseWrapper : finalResponseWrapper,
                                        createOrderWrapper : cmp.get('v.createOrderWrapper')
                                        },
                                        false,
                                        'dal-modal_small'
                         );
                    }


                }
            });

            }
        }
    },

    getSearchResultFromSizes : function(cmp,event,helper,params) {

        try {
            this.startSpinner(cmp);
            this.doCallout(cmp, "c.sizedProducts", params, function(response){
                var state = response.getState();
                if(state === "SUCCESS"){
                    var _resp = response.getReturnValue();

                    if(_resp && _resp.length>0) {
                       _resp = helper.addCheckboxToSizeResponse(cmp,event,helper,_resp);
                    }
                    console.log('Response for Sized Product Search: ',_resp );
                    cmp.set('v.responseFromSearchResult',_resp);

                    this.stopSpinner(cmp);
                } else {
                     this.stopSpinner(cmp);
                }
            });

        } catch(ex) {
             this.stopSpinner(cmp);
        }

    },


    //@@@@@@@@@@@@@@@ MY CART METHODS @@@@@@@@@@@@@@@@
    getCartProducts : function(cmp,event,helper) {
        debugger;

        try{
            this.startSpinner(cmp);
            this.doCallout(cmp, "c.getCartProducts", {}, function(response){
                var state = response.getState();
                if(state === "SUCCESS"){
                    var _resp = response.getReturnValue();
                    console.log('Resp from INIT CART: ', _resp);
                    cmp.set('v.myCartResponse', _resp);

                    var _deliveryResp = new Map();
                    var _energySurchargeTotal = 0.0;
                    var _orderSubTotalTotal = 0.0;
                    var _estimatedTotal = 0.0;
                    var _l1 = [];
                    var _l2 = [];

                    var _cartproductLst = _resp.cartReviewWrapperlist;
                    if(_cartproductLst && _cartproductLst.length > 0) {

                        for(var i=0;i<_cartproductLst.length;i++) {
                           if(!_deliveryResp.has(_cartproductLst[i].supplyPlantId)) {
                                var _delResp = [];
                                _delResp.push(_cartproductLst[i]);
                                _deliveryResp.set(_cartproductLst[i].supplyPlantId,_delResp);
                           } else {
                                var _delResp = [];
                                _delResp = _deliveryResp.get(_cartproductLst[i].supplyPlantId);
                                _delResp.push(_cartproductLst[i]);
                                _deliveryResp.set(_cartproductLst[i].supplyPlantId,_delResp);
                           }
                           _orderSubTotalTotal = _orderSubTotalTotal + _cartproductLst[i].totalSingleLineQuantity;
                           _energySurchargeTotal = _energySurchargeTotal + _cartproductLst[i].energySurcharge;
                        }

                        var _count=0;
                        var _keys = [];

                        for (var key of _deliveryResp.keys()) {
                            _keys.push(key);
                        }

                        for(var i=0;i<_keys.length;i++) {
                            for(var j=0;j<_deliveryResp.get(_keys[i]).length;j++) {
                                var sku = _deliveryResp.get(_keys[i])[j];
                                sku.updatedQuantity = sku.quantity;
                                sku.updatedUOM = sku.baseUOM;

                                var _uoms = sku.availableUOM;
                                if(_uoms) {
                                    sku.listOfUOM = _uoms.split(',');
                                    if(sku.listOfUOM[0].includes('null'))
                                        sku.listOfUOM[0] = sku.listOfUOM[0].substr(4,5);
                                    _deliveryResp.get(_keys[i])[j] = sku;
                                }

                                if(_count === 0) {
                                    _l1.push(_deliveryResp.get(_keys[i])[j]);
                                } else {
                                    _l2.push(_deliveryResp.get(_keys[i])[j]);
                                }

                                if(sku.energySurcharge) {
                                    //_energySurchargeTotal = _energySurchargeTotal + parseFloat(sku.energySurcharge);
                                    //_orderSubTotalTotal = _orderSubTotalTotal + _cartproductLst[i].totalSingleLineQuantity;
                                    //_orderSubTotalTotal = _orderSubTotalTotal +
                                       // (parseFloat(sku.unit) * parseFloat(sku.updatedQuantity));
                                }
                            }
                            _count++;
                        }

                        _estimatedTotal = parseFloat(_energySurchargeTotal) + parseFloat(_orderSubTotalTotal);
                        _energySurchargeTotal.toFixed(2);
                        _orderSubTotalTotal.toFixed(2);
                        _estimatedTotal.toFixed(2);

                    }
                    if(_resp)
                        cmp.set('v.myCartResponse', _resp);
                        cmp.set('v.myCartOrderOne', _l1);
                        cmp.set('v.myCartOrderTwo', _l2);
                        if(_l1.length > 0){
                           for(var i=0;i<_l1.length;i++){
                               if(_l1[i].totalSingleLineQuantity == 0){
                                   cmp.set('v.isPriceError',true);
                                   console.log('true');
                               }
                           }
                        }
                        if(_l2.length > 0){
                           for(var i=0;i<_l2.length;i++){
                               if(_l2[i].totalSingleLineQuantity == 0){
                                   cmp.set('v.isPriceError',true);
                                   console.log('true');
                               }
                           }
                        }
                    cmp.set('v.energySurchargeTotal', _energySurchargeTotal);
                    cmp.set('v.orderSubTotalTotal', _orderSubTotalTotal);
                    cmp.set('v.estimatedTotal', _estimatedTotal);
                    console.log('Resp for Delivery Skus One: ', _l1);
                    console.log('Resp for Delivery Skus Two: ', _l2);
                  
                    this.stopSpinner(cmp);
                } else {
                    this.stopSpinner(cmp);
                }
            });
        } catch(ex) {
            console.log('Dal_SSC_CreateOrderBase:Exception');
            this.stopSpinner(cmp);
        }
    },

    goToCheckoutPage : function(cmp,event,helper) {
        debugger;
        var _listOfCartProducts = helper.getListOfCartProducts(cmp,event,helper);

        try{
            this.startSpinner(cmp);
            this.doCallout(cmp, "c.getCheckoutCart", {updateCartDetail : JSON.stringify(_listOfCartProducts)}, function(response){
                var state = response.getState();
                if(state === "SUCCESS") {
                    var _resp = response.getReturnValue();
                    console.log('RESP from GoToCheckoutPage: ', _resp);
                    //cmp.set('v.recordTypeIdForNational', _resp);
                    if(_resp) {

                    cmp.set('v.myCartResponsePageTwo', _resp);
                    cmp.set('v.isPoRequired', _resp.isPoRequired);
                    cmp.set('v.isJobNameRequired', _resp.isJobNameRequired);

                    console.log('isPoRequired---'+cmp.get('v.isPoRequired'));
                    console.log('isJobNameRequired---'+cmp.get('v.isJobNameRequired'));

                    if(_resp.isPoRequired) {
                        if(_resp.po) {
                            cmp.set('v.isPOEmpty', false);
                        } else {
                            cmp.set('v.isPOEmpty', true);
                        }
                    }
                    if(_resp.isJobNameRequired){
                        if(_resp.jobName){
                            cmp.set('v.isJobNameEmpty', false);
                        } else {
                            cmp.set('v.isJobNameEmpty', true);
                        }
                    }
                     } else {
                         cmp.set('v.myCartResponsePageTwo', {});
                     }
                    this.stopSpinner(cmp);
                } else {
                    this.stopSpinner(cmp);
                }
            });
        } catch(ex) {
            console.log('Dal_SSC_CreateOrderBase:goToCheckoutPage:Exception');
            this.stopSpinner(cmp);
        }
    },

    deleteProduct : function(cmp,event,helper,orderId,indexToProd) {
        debugger;
        try{
            this.startSpinner(cmp);
            var myCartOrderOne = cmp.get('v.myCartOrderOne');
            var myCartOrderTwo = cmp.get('v.myCartOrderTwo');
            var productId = '';
            var orderSubTotal = 0.0;

            if(orderId.toUpperCase() === 'ORDER1' || orderId === 'Order1') {
                productId = myCartOrderOne[indexToProd].productId;
                orderSubTotal = myCartOrderOne[indexToProd].totalSingleLineQuantity;
            } else {
                productId = myCartOrderTwo[indexToProd].productId;
                orderSubTotal = myCartOrderTwo[indexToProd].totalSingleLineQuantity;
            }

            this.doCallout(cmp, "c.deleteProduct", {productId : productId}, function(response){
                var state = response.getState();
                if(state === "SUCCESS"){
                    var _resp = response.getReturnValue();
                    console.log('RESP SUCCESS from Delete Cart Product');

                    var _energySurchargeTotal = cmp.get('v.energySurchargeTotal');
                    var _orderSubTotalTotal = cmp.get('v.orderSubTotalTotal');
                    var _estimatedTotal = cmp.get('v.estimatedTotal');

                    if(orderId.toUpperCase() === 'ORDER1' || orderId === 'Order1') {
                        _orderSubTotalTotal = _orderSubTotalTotal - orderSubTotal;
                        _energySurchargeTotal = _energySurchargeTotal - parseFloat(myCartOrderOne[indexToProd].energySurcharge);
                        _estimatedTotal = _orderSubTotalTotal + _energySurchargeTotal;

                        _energySurchargeTotal.toFixed(2);
                        _orderSubTotalTotal.toFixed(2);
                        _estimatedTotal.toFixed(2);
                        cmp.set('v.energySurchargeTotal', _energySurchargeTotal);
                        cmp.set('v.orderSubTotalTotal', _orderSubTotalTotal);
                        cmp.set('v.estimatedTotal', _estimatedTotal);
                        myCartOrderOne.splice(indexToProd, 1);
                        cmp.set('v.myCartOrderOne',myCartOrderOne);
                    } else {
                        //_orderSubTotalTotal = _orderSubTotalTotal - (myCartOrderTwo[indexToProd].updatedQuantity * parseFloat(myCartOrderTwo[indexToProd].unit));
                        _orderSubTotalTotal = _orderSubTotalTotal - orderSubTotal;
                        _energySurchargeTotal = _energySurchargeTotal - parseFloat(myCartOrderTwo[indexToProd].energySurcharge);
                        _estimatedTotal = _orderSubTotalTotal + _energySurchargeTotal;

                        _energySurchargeTotal.toFixed(2);
                        _orderSubTotalTotal.toFixed(2);
                        _estimatedTotal.toFixed(2);
                        cmp.set('v.energySurchargeTotal', _energySurchargeTotal);
                        cmp.set('v.orderSubTotalTotal', _orderSubTotalTotal);
                        cmp.set('v.estimatedTotal', _estimatedTotal);
                        myCartOrderTwo.splice(indexToProd, 1);
                        cmp.set('v.myCartOrderTwo',myCartOrderTwo);
                    }

                    var myCartResponseAll = [];
                    myCartResponseAll.push(myCartOrderOne);
                    myCartResponseAll.push(myCartOrderTwo);
                    cmp.set('v.myCartResponseAll', myCartResponseAll);

                    this.stopSpinner(cmp);
                } else {
                    this.stopSpinner(cmp);
                }
            });
        } catch(ex) {
            console.log('Dal_SSC_CreateOrderBase:deleteProduct:Exception');
            this.stopSpinner(cmp);
        }

    },

    goToReviewDetailPage : function(cmp,event,helper,_myCartResponsePageTwo) {
        debugger;
        try {
//            _myCartResponsePageTwo.Tax_Exempt = _myCartResponsePageTwo.taxExempt;
//            _myCartResponsePageTwo.Status = _myCartResponsePageTwo.status;
//            _myCartResponsePageTwo.Special_Instructions = _myCartResponsePageTwo.specialInstruction;
//            _myCartResponsePageTwo.Job_Name = _myCartResponsePageTwo.jobName;
//            _myCartResponsePageTwo.National_Account_Field = _myCartResponsePageTwo.nationalAccountName;
//            _myCartResponsePageTwo.Contact_Name = _myCartResponsePageTwo.contactName;
//            _myCartResponsePageTwo.Contact_Number = _myCartResponsePageTwo.contactNumber;
//            //_myCartResponsePageTwo.User = _myCartResponsePageTwo.user;
//            _myCartResponsePageTwo.po = _myCartResponsePageTwo.po;

            //cmp.set('v.myCartResponsePageTwo', _myCartResponsePageTwo);
            this.startSpinner(cmp);
            this.doCallout(cmp, "c.saveCheckoutDetail", {checkoutDetail : JSON.stringify(_myCartResponsePageTwo)}, function(response){
                var state = response.getState();
                if(state === "SUCCESS"){
                    console.log('RESP SUCCESS from Go To Review Detail Page::'+ response.getReturnValue());
                    this.stopSpinner(cmp);
                } else {
                    this.stopSpinner(cmp);
                }
           });
        } catch(ex) {
            this.stopSpinner(cmp);
        }

    },

    handlePlaceOrder : function(cmp,event,helper) {
		debugger;
        try{
            this.startSpinner(cmp);
            this.doCallout(cmp, "c.placeOrder", {}, function(response){
                var state = response.getState();
                if(state === "SUCCESS"){ 
                    var _resp = response.getReturnValue();
                    console.log('ORDER SUCCESSFUL', response.getReturnValue());
                    var _orderStatus = [];
                    //var _msgs = [];
                    
                    //let isSuccess = response.getReturnValue()[0].success;
                    //let messg = response.getReturnValue()[0].messages[0];
                    
                    var myCartOrderTwo = cmp.get('v.myCartOrderTwo');
                    var myCartOrderOne = cmp.get('v.myCartOrderOne');
					var flag = false;
                    if(_resp) {
                     
                    _resp.forEach(function(row) {
                        var _ord = {};
                        if(row.success) {
                            flag = true;
                            _ord.isSuccess = true;
                            _ord.messg = row.messages[0];
                        } else {
                            _ord.isSuccess = false;
                            _ord.messg = 'Failed to place order.';
                        }
                        _orderStatus.push(_ord);
                    });
					
                    if(flag) {
                        var appEvent = $A.get("e.c:Dal_SSC_MyCartQuantityUpdateEvent");
                        appEvent.setParams({ "cartTotal" : (myCartOrderTwo.length + myCartOrderOne.length ), 'action' : 'SUB' });
                        appEvent.fire();
                    }

                    helper.openModal(cmp,'c:Dal_SSC_MyCartPlaceOrderConfirmModal',
                                     { listOfOrders : _orderStatus, isSuccess : flag},
                                     false,
                                     'dal-modal_small'
                                    );
                           
                    }
                    this.stopSpinner(cmp);
                } else {
                    this.stopSpinner(cmp);
                }
            });

        } catch(ex) {
            this.stopSpinner(cmp);
        }

    },


    //@@@@@@@@@@@@@ Reusable @@@@@@@@@@@@@@
    getBrandName : function(cmp) {

        var brand = '';
        var createOrderWrapper = cmp.get('v.createOrderWrapper');
        var divisionCode = cmp.get('v.divisionCode');
        if(createOrderWrapper) {
            brand = createOrderWrapper.selectedBrand;
        }
        if(!brand){
            if(divisionCode == 41) {
                brand = 'AO';
            } else {
                brand = 'DB';
            }
        }

        return  brand;
    },

    //Reusable
    addCheckboxToSizeResponse : function(cmp,event,helper,_resp) {

        var skuList = [];
        var perPageCount = cmp.get('v.perPageCount');
        var sizeList = [];
        var flag = false;
        var createOrderWrapper = cmp.get('v.createOrderWrapper');

        if(_resp && _resp.length > 0) {
            for(var i=0;i<_resp.length;i++) {
              _resp[i].isChecked = false;

              if(i<perPageCount){
                  skuList.push(_resp[i]);
              }
            }
        }

        var pgNb = Math.ceil((_resp.length) / perPageCount) ;
        var totalPages = (_resp.length > perPageCount) ? pgNb :  1 ;
        cmp.set('v.displayProdList',skuList);
        cmp.set('v.totalPages', totalPages);
        cmp.set('v.pageNumber',1);
        if( totalPages === 1 )
            cmp.set('v.disableNext', true);
        else
            cmp.set('v.disableNext', false);

        return _resp;
    },

    addCheckboxToResponse : function(cmp,event,helper,_resp) {
        var skuList = [];
        var perPageCount = cmp.get('v.perPageCount');
        var sizeList = [];
        var flag = false;
        var createOrderWrapper = cmp.get('v.createOrderWrapper');

        if(_resp && _resp.length > 0) {
            for(var i=0;i<_resp.length;i++) {
              _resp[i].isChecked = false;
              if(_resp[i].Size__c) {
                  if(sizeList.indexOf(_resp[i].Size__c) == -1) {
                      sizeList.push(_resp[i].Size__c);
                      flag = true;
                  }
              }
              if(i<perPageCount){
                  skuList.push(_resp[i]);
              }
            }
        }
        if(flag) {
            createOrderWrapper.listOfSizes = sizeList;
            cmp.set('v.createOrderWrapper',createOrderWrapper);
        }

        var pgNb = Math.ceil((_resp.length) / perPageCount) ;
        var totalPages = (_resp.length > perPageCount) ? pgNb :  1 ;
        cmp.set('v.displayProdList',skuList);
        cmp.set('v.totalPages', totalPages);
        cmp.set('v.pageNumber',1);
        if( totalPages === 1 )
            cmp.set('v.disableNext', true);
        else
            cmp.set('v.disableNext', false);

        return _resp;
    },

    getListOfCartProducts : function(cmp,event,helper) {
        debugger;
        var myCartOrderOne = cmp.get('v.myCartOrderOne');
        var myCartOrderTwo = cmp.get('v.myCartOrderTwo');
        var _listOfCartProducts = [];

        if(myCartOrderOne  &&  myCartOrderOne.length > 0) {
            var _companyName = myCartOrderOne[0].shippingName;
            var _shippingStreet = myCartOrderOne[0].shippingStreet;
            var _shippingCity = myCartOrderOne[0].shippingCity;
            var _shippingState = myCartOrderOne[0].shippingState;
            var _shippingZIPCode = myCartOrderOne[0].shippingZIPCode;
            var _shippingCountry = myCartOrderOne[0].shippingCountry;
            var _liftGate = myCartOrderOne[0].liftGate;
            var _fulfillmentType = myCartOrderOne[0].fulfillmentType;
            var _isDelivery = myCartOrderOne[0].isDelivery;
            var _isPickUp = myCartOrderOne[0].isPickUp;

            myCartOrderOne.forEach(function(cart){
                var cartLst = cart.cartLst;
                cart.shippingName = _companyName;
                cart.shippingStreet = _shippingStreet;
                cart.shippingCity = _shippingCity;
                cart.shippingState = _shippingState;
                cart.shippingZIPCode = _shippingZIPCode;
                cart.shippingCountry = _shippingCountry;
                cart.liftGate = _liftGate;
                cart.fulfillmentType = _fulfillmentType;
                cart.isDelivery = _isDelivery;
                cart.isPickUp = _isPickUp;

                cartLst.forEach(function(ct){
                    if(ct.Tax_Exempt__c)
                        ct.Tax_Exempt = ct.Tax_Exempt__c;
                    else
                        ct.Tax_Exempt = false;

                    ct.Status = ct.Status__c;
                    ct.Special_Instructions = ct.Special_Instructions__c;
                    ct.Job_Name = ct.Job_Name__c;
                    ct.National_Account_Field = ct.National_Account__c;
                    ct.Contact_Name = ct.Contact_Name__c;
                    ct.Contact_Number = ct.Contact_Number__c;
                    ct.User = ct.User__c;
                    ct.po = ct.PO__c;
                });
                cart.cartLst = cartLst;
                _listOfCartProducts.push(cart);
            });
            cmp.set('v.myCartOrderOne',myCartOrderOne);
        }

        if(myCartOrderTwo  &&  myCartOrderTwo.length > 0) {
            var _companyNameTwo = myCartOrderTwo[0].shippingName;
            var _shippingStreetTwo = myCartOrderTwo[0].shippingStreet;
            var _shippingCityTwo = myCartOrderTwo[0].shippingCity;
            var _shippingStateTwo = myCartOrderTwo[0].shippingState;
            var _shippingZIPCodeTwo = myCartOrderTwo[0].shippingZIPCode;
            var _shippingCountryTwo = myCartOrderTwo[0].shippingCountry;
            var _liftGate = myCartOrderTwo[0].liftGate;
            var _fulfillmentType = myCartOrderTwo[0].fulfillmentType;
            var _isDelivery = myCartOrderTwo[0].isDelivery;
            var _isPickUp = myCartOrderTwo[0].isPickUp;

             myCartOrderTwo.forEach(function(cart){
                var cartLst = cart.cartLst;
                cart.shippingName = _companyNameTwo;
                cart.shippingStreet = _shippingStreetTwo;
                cart.shippingCity = _shippingCityTwo;
                cart.shippingState = _shippingStateTwo;
                cart.shippingZIPCode = _shippingZIPCodeTwo;
                cart.shippingCountry = _shippingCountryTwo;
                cart.liftGate = _liftGate;
                cart.fulfillmentType = _fulfillmentType;
                cart.isDelivery = _isDelivery;
                cart.isPickUp = _isPickUp;

                cartLst.forEach(function(ct){
                   if(ct.Tax_Exempt__c)
                       ct.Tax_Exempt = ct.Tax_Exempt__c;
                   else
                       ct.Tax_Exempt = false;
                   ct.Status = ct.Status__c;
                   ct.Special_Instructions = ct.Special_Instructions__c;
                   ct.Job_Name = ct.Job_Name__c;
                   ct.National_Account_Field = ct.National_Account__c;
                   ct.Contact_Name = ct.Contact_Name__c;
                   ct.Contact_Number = ct.Contact_Number__c;
                   ct.User = ct.User__c;
                   ct.po = ct.PO__c;
                });
                cart.cartLst = cartLst;
               _listOfCartProducts.push(cart);
             });
             cmp.set('v.myCartOrderTwo', myCartOrderTwo);
        }

        return _listOfCartProducts;
    },


    // Changing the Page Number
    // _type = productList/cardList  -> Defining the type of the page to change
    // _by = how much number you want to navigate
    // _direction = 'next/prev' to navigate to forward or backward
    navigateToNewPage : function(cmp,event,helper,_type,_by,_direction) {
        var createOrderWrapper = cmp.get('v.createOrderWrapper');
        var _pageOrder = '';

        if(_type === 'productList') {
            _pageOrder = createOrderWrapper.pageOrderCreate;
        } else if (_type === 'cartList') {
            _pageOrder = createOrderWrapper.pageOrderCart;
        }

        if(_by) {
            if(_direction === 'next'){
               _pageOrder = _pageOrder + _by;
            } else if (_direction === 'prev') {
                _pageOrder = _pageOrder - _by;
            }
        }

        if(_type === 'productList') {
            createOrderWrapper.pageOrderCreate = _pageOrder;
        } else if (_type === 'cartList') {
            createOrderWrapper.pageOrderCart = _pageOrder;
        }

        cmp.set('v.createOrderWrapper',createOrderWrapper);
    },

    //Reusable
    startSpinner : function(cmp) {
        cmp.set('v.isCreateOrderBaseLoading',true);
        cmp.set('v.isPageLoading',true);
    },

    //Reusable
    stopSpinner : function(cmp) {
        cmp.set('v.isCreateOrderBaseLoading',false);
        cmp.set('v.isPageLoading',false);
    },

    //Reusable
    goToURL: function (pageName) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/'+pageName
        });
        urlEvent.fire();
    },

    //Reusable
    showtoast : function(_msg, _type){
        var _toastEvent = $A.get("e.force:showToast");
        _toastEvent.setParams({
            message: _msg,
            type : _type,
        });
        _toastEvent.fire();
    },

    moveToTop : function(_till) {
        window.scrollTo(0, _till);
    },

})