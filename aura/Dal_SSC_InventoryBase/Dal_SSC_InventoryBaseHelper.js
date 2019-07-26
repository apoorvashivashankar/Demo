/**
 * Created by Yadav on 10/31/2018.
 */
({
    
    getSearchedProduct : function(cmp,event,helper,searchvalue){
    //    debugger;
        
        try {
            
            this.doCallout(cmp, "c.getProduct", 'test', function(response){
                var state = response.getState();
                if(state === "SUCCESS"){
                    cmp.set('v.isInventoryBaseLoading',false);
                    cmp.set('v.isPageLoading', false);
                    helper.resetSelectedSkus(cmp,event,helper);
                    //console.log("Response : " , response.getReturnValue());
                    //cmp.set("v.productBaseList", response.getReturnValue());
                } else {
                    helper.resetSelectedSkus(cmp,event,helper);
                    cmp.set('v.isPageLoading', false);
                    cmp.set('v.isInventoryBaseLoading',false);
                }
            });
            
        } catch(ex) {
            cmp.set('v.isPageLoading', false);
            cmp.set('v.isInventoryBaseLoading',false);
        }
    },
    
    doCallout : function(cmp, methodName, params, callBackFunc){
        //console.log('IN CALLBACK METHOD');
        var action = cmp.get(methodName);
        action.setParams(params);
        action.setCallback(this, callBackFunc);
        $A.enqueueAction(action);
        //console.log('OUT CALLBACK METHOD');
    },
    
    getSeries : function(cmp,event,helper){
    //    debugger;
        
        try{
            var brand = cmp.get('v.selectedBrand');
            var divisionCode = cmp.get('v.divisionCode');
            if(!brand){
                if(divisionCode == 41) {
                    brand = 'AO';
                } else {
                    brand = 'DB';
                }
            }
            
            this.doCallout(cmp, "c.getInventorySeries", {brand : brand} , function(response){
                var state = response.getState();
                if(state === "SUCCESS"){
                    console.log("Series",response.getReturnValue());
                    cmp.set('v.isInventoryBaseLoading',false);
                    cmp.set('v.isPageLoading', false);
                    cmp.set('v.listOfSeries',response.getReturnValue());
                    helper.resetSelectedSkus(cmp,event,helper);
                } else {
                    cmp.set('v.isInventoryBaseLoading',false);
                    cmp.set('v.isPageLoading', false);
                    helper.resetSelectedSkus(cmp,event,helper);
                }
            });
            
        } catch(ex) {
            cmp.set('v.isInventoryBaseLoading',false);
            cmp.set('v.isPageLoading', false);
        }
    },
    
    fetchVendors : function(cmp,event,helper){
    //    debugger;
        
        try{
            
            this.doCallout(cmp, "c.getVendors", {}, function(response){
                var state = response.getState();
                if(state === "SUCCESS"){
                    cmp.set('v.isPageLoading', false);
                    cmp.set('v.isInventoryBaseLoading',false);
                    cmp.set('v.listOfVendors',response.getReturnValue());
                    helper.resetSelectedSkus(cmp,event,helper);
                } else {
                    cmp.set('v.isPageLoading', false);
                    cmp.set('v.isInventoryBaseLoading',false);
                    helper.resetSelectedSkus(cmp,event,helper);
                }
            });
        } catch(ex) {
            cmp.set('v.isPageLoading', false);
            cmp.set('v.isInventoryBaseLoading',false);
        }
    },
    
    getFilterFromVender : function(cmp,event,helper,params) {
    //    debugger;
        
        cmp.set('v.isInventoryBaseLoading',true);
        cmp.set('v.isPageLoading',true);
        
        try {
            
            this.doCallout(cmp, "c.vendorProducts", params, function(response){
                var state = response.getState();
                if(state === "SUCCESS"){
                                       
                    var custResp = {};
                    var skuList = [];
                    var sizeList = [];
                    custResp = response.getReturnValue();
                    console.log('Resp from vendors: ', custResp);
                    if(custResp ) {
                        for(var i=0;i<custResp.length;i++) {
                            custResp[i].isChecked = false;
                            if(i<30){
                                skuList.push(custResp[i]);
                            }
                        }
                        
                        var pgNb = Math.ceil((custResp.length) / 30) ;
                        var totalPages = (custResp.length > 30) ? pgNb :  1 ;
                        cmp.set('v.listOfSizes',sizeList);
                        cmp.set('v.responseWrapperData', custResp);
                        cmp.set('v.totalPages', totalPages);
                        cmp.set('v.displayProdList',skuList);
                        cmp.set('v.pageNumber',1);
                        helper.resetSelectedSkus(cmp,event,helper);
                        //helper.setSelectedList(cmp,event,helper);
                    } else {
                        cmp.set('v.listOfSizes',[]);
                        cmp.set('v.responseWrapperData', []);
                        cmp.set('v.totalPages', 0);
                        cmp.set('v.displayProdList',[]);
                        cmp.set('v.pageNumber',1);
                        helper.resetSelectedSkus(cmp,event,helper);
                        //helper.setSelectedList(cmp,event,helper);
                    }
                    cmp.set('v.isInventoryBaseLoading',false);
                    cmp.set('v.isPageLoading', false);
                } else {
                    cmp.set('v.isPageLoading', false);
                    cmp.set('v.isInventoryBaseLoading',false);
                }
            });
            
        } catch(ex) {
            cmp.set('v.isPageLoading', false);
            cmp.set('v.isInventoryBaseLoading',false);
        }
        
    },
    
    getDivisionCode : function(cmp,event,helper) {
        cmp.set('v.isPageLoading', true);
        cmp.set('v.isInventoryBaseLoading',true);
        
        try {
            
            helper.doCallout(cmp, "c.getDivision", {}, function(response){
                var state = response.getState();
                if(state === "SUCCESS"){
                    cmp.set('v.isInventoryBaseLoading',false);
                    cmp.set('v.isPageLoading', false);
                    
                    var _resp = response.getReturnValue();
                    cmp.set('v.divisionCode',_resp);
                    helper.getSeries(cmp,event,helper);
                    console.log('divisionCode: ', _resp);
                    
                } else {
                    cmp.set('v.isInventoryBaseLoading',false);
                    cmp.set('v.isPageLoading', false);
                }
            });
            
        } catch(ex){
            cmp.set('v.isPageLoading', false);
            cmp.set('v.isInventoryBaseLoading',false);
        }
        
    },
    
    getSearchResultFromSizes : function(cmp,event,helper,params) {
        
        cmp.set('v.isInventoryBaseLoading',true);
        cmp.set('v.isPageLoading',true);
        
        try {
            
            this.doCallout(cmp, "c.sizedProducts", params, function(response){
                var state = response.getState();
                if(state === "SUCCESS"){
                    cmp.set('v.isInventoryBaseLoading',false);
                    cmp.set('v.isPageLoading', false);
                    
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
                    cmp.set('v.displayProdList',skuList);
                    cmp.set('v.responseWrapperData', custResp);
                    cmp.set('v.totalPages', totalPages);
                    cmp.set('v.displayProdList',skuList);
                    cmp.set('v.pageNumber',1);
                    helper.resetSelectedSkus(cmp,event,helper);
                    //helper.setSelectedList(cmp,event,helper); 
                } else {
                    cmp.set('v.isPageLoading', false);
                    cmp.set('v.isInventoryBaseLoading',false);
                    helper.resetSelectedSkus(cmp,event,helper);
                    //helper.setSelectedList(cmp,event,helper);
                }
            });
            
        } catch(ex) {
            cmp.set('v.isPageLoading', false);
            cmp.set('v.isInventoryBaseLoading',false);
        }
        
    },
    
    getSearchedProductBySkuColl : function(cmp,event,helper,_params){
    //    debugger;
        
        var _params = {
            ColorCode : _params[0],
            brand : _params[1],
            quickSearch : _params[2]
        };
        console.log('param: ',_params);
        
        try{
            
            this.doCallout(cmp, "c.getProductList", _params, function(response){
                var state = response.getState();
                if(state === "SUCCESS"){
                    cmp.set('v.isInventoryBaseLoading',false);
                    cmp.set('v.isPageLoading', false);
                    
                    var custResp = {};
                    var skuList = [];
                    var sizeList = [];
                    custResp = response.getReturnValue();
                    
                    if(custResp) {
                        for(var i=0;i<custResp.length;i++) {
                            custResp[i].isChecked = false;
                            if(sizeList.indexOf(custResp[i].Size__c) == -1)
                                sizeList.push(custResp[i].Size__c);
                            if(i<30){
                                skuList.push(custResp[i]);
                            }
                        }
                        var pgNb = Math.ceil((custResp.length) / 30) ;
                        var totalPages = (custResp.length > 30) ? pgNb :  1 ;
                    }
                    cmp.set('v.listOfSizes',sizeList);
                    cmp.set('v.responseWrapperData', custResp);
                    cmp.set('v.totalPages', totalPages);
                    cmp.set('v.displayProdList',skuList);
                    cmp.set('v.pageNumber',1);
                    helper.resetSelectedSkus(cmp,event,helper);
                    //helper.setSelectedList(cmp,event,helper);
                } else {
                    cmp.set('v.isPageLoading', false);
                    cmp.set('v.isInventoryBaseLoading',false);
                    helper.resetSelectedSkus(cmp,event,helper);
                    //helper.setSelectedList(cmp,event,helper);
                }
            });
        } catch(ex) {
            cmp.set('v.isPageLoading', false);
            cmp.set('v.isInventoryBaseLoading',false);
        }
    },
    
    setSelectedList : function(cmp,event,helper) {
    //    debugger;
        
        var listOfSelectedProducts = cmp.get('v.listOfSelectedProducts');
        var displayProdList = cmp.get('v.displayProdList');
        
        for(var i=0;i<listOfSelectedProducts.length;i++) {
            for(var j=0;j<displayProdList.length;j++) {
                if(displayProdList[j].Id === listOfSelectedProducts[i].Id) {
                    displayProdList[j] = listOfSelectedProducts[i];
                } 
            }
        }
        cmp.set('v.displayProdList',displayProdList);  
    },
    
    resetSelectedSkus : function(cmp,event,helper) {
        cmp.set('v.listOfSelectedProducts',[]);
        cmp.set('v.count',0);  
    },
    
    goToURL: function (pageName) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/'+pageName
        });
        urlEvent.fire();
    },
    
    setProductTypeByURL : function(cmp,event,helper) {
        var pageUrl = window.location.href;
        var hashIndex = pageUrl.lastIndexOf('#');
        var selectedProductType = pageUrl.substring(hashIndex+1,pageUrl.length);
        
        if(selectedProductType === 'bp') {
            cmp.set('v.isBranded',true);
            cmp.set('v.selectedProductType','Branded Product');
        } else if(selectedProductType === 'ip') {
            cmp.set('v.isBranded',false);
            cmp.set('v.selectedProductType','Installation Product');
        } else {
            cmp.set('v.isBranded',true);
            cmp.set('v.selectedProductType','Branded Product');
        }
    }
})