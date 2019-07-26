/**
 * Created by ranja on 26-12-2018.
 */
({
    doInit : function(cmp,event,helper) {
        helper.getDivisionCode(cmp,event,helper);
    },

    goToCreateOrderDetailPage : function(cmp,event,helper) {
        debugger;
        var createOrderWrapper = cmp.get('v.createOrderWrapper');

        if(createOrderWrapper.pageOrderCreate === '1' || createOrderWrapper.pageOrderCreate === 1)
            helper.goToCreateOrderDetailPageHelper(cmp,event,helper);
        else if(createOrderWrapper.pageOrderCreate === '2' || createOrderWrapper.pageOrderCreate === 2)
            helper.navigateToMyCartsDetailPage(cmp,event,helper);

    },

    searchSkuWithKeyword : function(cmp,event,helper) {
        debugger;

        var createOrderWrapper = cmp.get('v.createOrderWrapper');
        var searchSku = createOrderWrapper.skuKeyword;
        var selectedSeries = createOrderWrapper.selectedSeries;
        var selectedProduct = createOrderWrapper.selectedColor;
        var divisionCode = cmp.get('v.divisionCode');
        var listOfSizes = createOrderWrapper.listOfSizes;
        var selectedSize = createOrderWrapper.selectedSize;
        var selectedCategory = createOrderWrapper.selectedCategory;
        var selVendor = createOrderWrapper.selectedVendor;
        var methodName = '';
        var selectedVendor = '';
        var selectedBrand = helper.getBrandName(cmp);
        var brand = helper.getBrandName(cmp);
        var flag = true;
        var _selectedProduct = [];
        var _size = [];
        var skuKeyword = createOrderWrapper.skuKeyword;
        var paramValue = createOrderWrapper.skuKeyword;

        if(selectedCategory === 'Branded Product') {
            var listOfColors = createOrderWrapper.listOfProducts;
            var _selectedColor =  createOrderWrapper.selectedColor;

            var _params = [];
            var _params1 = [];

            var methodName = "c.sizedProducts";

            if(listOfColors!= null && listOfColors.length > 0){
                if(!selectedSize)
                    selectedSize = 'All';
            }

            if(_selectedColor) {
                if(_selectedColor.toUpperCase() === 'ALL' || _selectedColor === 'All' || _selectedColor == 'All') {
                    if(listOfColors != null && listOfColors.length > 0) {
                        for(var i=0;i<listOfColors.length;i++)
                            _params.push(listOfColors[i].colorCode);
                    } else {

                    }
                } else {
                    _params.push(_selectedColor);
                }
            }

            if(selectedSize) {
                if(selectedSize.toUpperCase() === 'ALL') {
                    if(listOfSizes!=null && listOfSizes.length > 0) {
                        for(var i=0;i<listOfSizes.length;i++)
                            _params1.push(listOfSizes[i]);
                    }
                } else {
                    _params1.push(selectedSize);
                }
            }

            if(_params.length >0 || _params1.length>0) {

                if(selectedSeries === 'select') {
                    if(paramValue) {

                    var var1 = [];

                    var params = {
                        searchParameter : var1,
                        size : var1,
                        quickSearch : paramValue,
                        brand : brand
                    };

                    } else {
                        flag = false;
                        createOrderWrapper.listOfProducts = [];
                        createOrderWrapper.listOfSizes = [];
                        cmp.set('v.createOrderWrapper',createOrderWrapper);
                        cmp.set('v.responseWrapperData', []);
                        cmp.set('v.displayProdList',[]);
                        this.stopSpinner(cmp);
                    }

                } else {

                    if(!paramValue)
                        paramValue = '';

                    var params = {
                        searchParameter : _params,
                        size : _params1,
                        quickSearch : paramValue,
                        brand : brand
                    };

                }
            } else {
                if(paramValue) {
                    if(cmp.get('v.selectedSeries') === 'All' || cmp.get('v.selectedSeries') === 'ALL' || cmp.get('v.selectedSeries') === 'all') {
                        var var1 = {};
                        var params = {
                            searchParameter : var1,
                            size : var1,
                            quickSearch : paramValue,
                            brand : brand
                        };

                    } else {
                        var params = {
                            searchParameter : _params,
                            size : _params1,
                            quickSearch : paramValue,
                            brand : brand
                        };

                    }
                } else {
                    createOrderWrapper.listOfProducts = [];
                    createOrderWrapper.listOfSizes = [];
                    cmp.set('v.createOrderWrapper',createOrderWrapper);
                    cmp.set('v.responseWrapperData', []);
                    cmp.set('v.displayProdList',[]);
                    flag = false;
                }
            }

            console.log('params for tab : ',params);

            methodName = "c.sizedProducts";

        } else {

            methodName = "c.vendorProducts";
            if(selVendor) {
                if(selVendor.toUpperCase() === 'ALL') {
                    selectedVendor = '';
                } else {
                    selectedVendor = selVendor;
                }

                if(!skuKeyword)
                    skuKeyword = '';

                var params = {
                    searchParameter : skuKeyword,
                    vendor : selectedVendor
                };

            } else if (skuKeyword) {
                var params = {
                   searchParameter : skuKeyword,
                   vendor : ''
                };
            } else {
                flag = false;
            }

        }
        console.log('Params for Top Search: ', params);

        if(flag) {
            helper.startSpinner(cmp);
            helper.doCallout(cmp, methodName, params, function(response){
                var state = response.getState();
                if(state === "SUCCESS"){
                    var _resp = response.getReturnValue();

                    if(_resp && _resp.length>0) {
                        _resp = helper.addCheckboxToSizeResponse(cmp,event,helper,_resp);
                    }
                    console.log('Response for Searched Products: ',_resp );
                    cmp.set('v.responseFromSearchResult',_resp);
                    helper.stopSpinner(cmp);

                } else {
                    helper.stopSpinner(cmp);
                }
            });

        } else {
            cmp.set('v.listOfSelectedProducts',[]);
            cmp.set('v.responseFromSearchResult',[]);
            helper.stopSpinner(cmp);
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