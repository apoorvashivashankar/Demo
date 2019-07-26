/**
 * Created by ranja on 13-11-2018.
 */
({
    doInit : function(cmp,event,helper) {
        cmp.set('v.isProductSelected',true);
        
        /*
        var pageUrl = window.location.href;
        var hashIndex = pageUrl.lastIndexOf('#');
        var selectedProductType = pageUrl.substring(hashIndex+1,pageUrl.length);

        if(selectedProductType == 'bp') {
            cmp.set('v.isBranded',true);
            cmp.set('v.selectedProductType','Branded Product');
        } else {
            cmp.set('v.isBranded',false);
            cmp.set('v.selectedProductType','Installation Product');
        } */
        
        helper.getDivisionCode(cmp,event,helper);
        helper.setProductTypeByURL(cmp,event,helper);
        //helper.getSeries(cmp,event,helper);
        helper.fetchVendors(cmp,event,helper);
        cmp.set('v.selectedSeries','ALL');
    },
    
    setProductType : function(cmp,event,helper) {
        debugger;
        
        cmp.set('v.isProductSelected',true);
        cmp.set('v.skuKeyword','');
        cmp.set('v.responseWrapperData',[]);
        cmp.set('v.selectedVendor','');
        cmp.set('v.selectedSeries','All');
        cmp.set('v.selectedColor','All');
        cmp.set('v.selectedSize','All');
        cmp.set('v.count',0);
        cmp.set('v.listOfSelectedProducts',[]);
        var selectedProductType = cmp.get('v.selectedProductType');
        if(selectedProductType == 'Branded Product') {
            cmp.set('v.isBranded',true);
        } else {
            cmp.set('v.isBranded',false);
        }
        
    },
    
    handleSearchClick : function(cmp,event,helper) {
        debugger;
        
        var paramValue = cmp.get('v.skuKeyword');
        var flag = true;
        //console.log('skuKeyword: ',paramValue);
        //if(paramValue) {
        
        
        try {
            var selectedProductType = cmp.get('v.selectedProductType');
            //if(paramValue) {
            cmp.set('v.isInventoryBaseLoading',true);
            cmp.set('v.isPageLoading', true);
            cmp.set('v.isFilterOpen',true);
            
            var brand = cmp.get('v.selectedBrand');
            var divisionCode = cmp.get('v.divisionCode');
            if(!brand){
                if(divisionCode == 41) {
                    brand = 'AO';
                } else {
                    brand = 'DB';
                }
            }
            
            var selectedVendor = cmp.get('v.selectedVendor');
            var methodName = "c.sizedProducts";
            
            if(selectedProductType == 'Installation Product') {
                methodName = "c.vendorProducts";
                
                
                if(selectedVendor) {
                    if(!paramValue)
                        paramValue = '';
                    if(selectedVendor.localeCompare('Select Vendor') === 0) {
                   		selectedVendor = '';
                    }
                    
                    var params = {
                        searchParameter : paramValue,
                        vendor : selectedVendor
                    };
                } else {
                    if(paramValue) {
                        var params = { 
                            searchParameter : paramValue,
                            vendor : ''
                        };
                    } else {
                        cmp.set('v.responseWrapperData',[]);
                        cmp.set('v.displayProdList',[]);
                        flag = false;
                    }
                }
            } else {
                var listOfColors = cmp.get('v.listOfColors');
                var _selectedColor = cmp.get('v.selectedColor');
                var selectedSize = cmp.get('v.selectedSize');
                var listOfSizes = cmp.get('v.listOfSizes');
                var _params = [];
                var _params1 = [];
                
                var methodName = "c.sizedProducts";
                
                if(listOfColors!= null && listOfColors.length > 0){
                    if(!selectedSize)
                        selectedSize = 'All';
                }
                
                if(_selectedColor) {
                    if(_selectedColor === 'ALL' || _selectedColor === 'All' || _selectedColor == 'All') {
                        if(listOfColors!= null && listOfColors.length > 0) {
                            for(var i=0;i<listOfColors.length;i++)
                                _params.push(listOfColors[i].colorCode);
                        } else {
                            
                        }
                    } else {
                        _params.push(_selectedColor);
                    }
                }
                
                if(selectedSize) {
                    if(selectedSize === 'ALL' || selectedSize === 'All' || selectedSize == 'All') {
                        if(listOfSizes!=null && listOfSizes.length > 0) {
                            for(var i=0;i<listOfSizes.length;i++)
                                _params1.push(listOfSizes[i]);
                        } else {
                            
                        }
                    } else {                        
                        _params1.push(selectedSize);
                    }
                } 
                
                if(_params.length >0 || _params1.length>0) {
                    
                    if(cmp.get('v.selectedSeries') === 'All' || cmp.get('v.selectedSeries') === 'ALL' || cmp.get('v.selectedSeries') === 'all') {
                        if(paramValue) {
                            
                        var var1 = {};
                        
                        var params = { 
                            searchParameter : var1,
                            size : var1,
                            quickSearch : paramValue,
                            brand : brand
                        };
                        
                        } else {
                            flag = false;
                            cmp.set('v.listOfSizes',[]);
                            cmp.set('v.listOfColors',[]);  
                            cmp.set('v.responseWrapperData', []);
                            cmp.set('v.displayProdList',[]);
                            cmp.set('v.isInventoryBaseLoading',false);
                            cmp.set('v.isPageLoading', false);
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
                        cmp.set('v.listOfSizes',[]);
                        cmp.set('v.listOfColors',[]);  
                        cmp.set('v.responseWrapperData', []);
                        cmp.set('v.displayProdList',[]);
                        cmp.set('v.isInventoryBaseLoading',false);
                        cmp.set('v.isPageLoading', false);
                        flag = false;
                    }
                }
                
            }           
            console.log('params for tab : ',params);
            
            if(flag) {
                
                helper.doCallout(cmp, methodName, params, function(response){
                    var state = response.getState();
                    if(state === "SUCCESS"){
                        cmp.set('v.isInventoryBaseLoading',false);
                        cmp.set('v.isPageLoading', false);
                        var _resp = response.getReturnValue();
                        console.log('Search Result by search: ', _resp);
                        
                        
                        var custResp = {};
                        var skuList = [];
                        
                        custResp = response.getReturnValue();
                        if(custResp) {
                            
                            for(var i=0;i<custResp.length;i++) {
                                custResp[i].isChecked = false;
                                
                                if(i<30){
                                    skuList.push(custResp[i]);
                                }
                            }
                            
                            var pgNb = Math.ceil((custResp.length) / 30) ;
                            var totalPages = (custResp.length > 30) ? pgNb :  1 ;
                        }
                        cmp.set('v.responseWrapperData', custResp);
                        cmp.set('v.totalPages', totalPages);
                        cmp.set('v.displayProdList',skuList);
                        cmp.set('v.pageNumber',1);
                        helper.resetSelectedSkus(cmp,event,helper);
                        //helper.setSelectedList(cmp,event,helper);
                    } else { 
                        cmp.set('v.isInventoryBaseLoading',false);
                        cmp.set('v.isPageLoading', false);
                        helper.resetSelectedSkus(cmp,event,helper);
                        //helper.setSelectedList(cmp,event,helper);
                    }
                });
            } else {
                cmp.set('v.isInventoryBaseLoading',false);
                cmp.set('v.isPageLoading', false);
            }
            
        } catch(ex) {
            cmp.set('v.isInventoryBaseLoading',false);
            cmp.set('v.isPageLoading', false);
        }
        
    },
    
})