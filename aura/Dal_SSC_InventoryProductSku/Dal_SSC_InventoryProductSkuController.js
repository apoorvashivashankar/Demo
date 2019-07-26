/**
 * Created by Yadav on 10/30/2018.
 */
({
   /* doInit: function(cmp,event,helper) {
        debugger;

        cmp.set('v.selectedSeries','ALL');


    }, */

    handleBrandChange : function(cmp,event,helper) {

        cmp.set('v.selectedSeries','ALL');
        cmp.set('v.selectedSize','All');
        cmp.set('v.displayProdList',[]);
        cmp.set('v.responseWrapperData',[]);
        cmp.set('v.count',0);
        cmp.set('v.listOfColors',[]);
        cmp.set('v.listOfSizes',[]);
        cmp.set('v.listOfSelectedProducts',[]);  
        helper.getSeries(cmp,event,helper);

    },

    getVendorsResult : function(cmp,event,helper){
      //  debugger;

        var skuKeyword = cmp.get('v.skuKeyword');
        var selectedVendor = cmp.get('v.selectedVendor');
        var selBrand = cmp.get('v.selectedBrand');
        var divCode = cmp.get('v.divisionCode');
        if(!selBrand) {
            if(divCode === '40' ) {
                selBrand = 'DB';
            } else {
                selBrand = 'AO';
            }
        }

        if(selectedVendor) {

            if(selectedVendor === 'All' || selectedVendor === 'ALL')
                selectedVendor = '';

            if(!skuKeyword)
                skuKeyword = '';

            var params = {
                searchParameter : skuKeyword,
                vendor : selectedVendor
            };
            helper.getFilterFromVender(cmp,event,helper,params);

        } else if(skuKeyword) {

           var params = {
               searchParameter : skuKeyword,
               vendor : selectedVendor
           };
            helper.getFilterFromVender(cmp,event,helper,params);

        } else {
             cmp.set('v.responseWrapperData',[]);
            cmp.set('v.displayProdList',[]);
        }

        //helper.getFilterFromVender(cmp,event,helper,params);
    },

    getResultBySizeFilter : function(cmp,event,helper) {
    //    debugger;

        var skuKeyword = cmp.get('v.skuKeyword');
        var selectedSize = cmp.get('v.selectedSize');
        var listOfColors = cmp.get('v.listOfColors');
        var selectedColor = cmp.get("v.selectedColor");
        var listOfSizes = cmp.get('v.listOfSizes');
        var divCode = cmp.get('v.divisionCode');
        var selBrand = cmp.get('v.selectedBrand');

        if(!selBrand) {
            if(divCode === '40' ) {
                selBrand = 'DB';
            } else {
                selBrand = 'AO';
            }
        }

        var colorParams = [];
        var sizeParams = [];

        if(selectedSize && listOfSizes) {
            if(selectedSize === 'All') {
                for(var i=0;i<listOfSizes.length;i++)
                    sizeParams.push(listOfSizes[i]);
            } else {
                sizeParams.push(selectedSize);
            }
        }

        if(selectedColor === "All" || selectedColor == 'All' || selectedColor === 'ALL') {
            if(listOfColors.length > 0) {
                for(var i=0;i<listOfColors.length;i++)
                    colorParams.push(listOfColors[i].colorCode);
            }
        } else {
            colorParams.push(selectedColor);
        }

        var skuKeyword = cmp.get('v.skuKeyword');
        if(!skuKeyword){
            skuKeyword = '';
        }
        var params = {
            searchParameter : colorParams,
            size : sizeParams,
            quickSearch : skuKeyword,
            brand : selBrand
        };
        console.log('Params for size: ',params );
        helper.getSearchResultFromSizes(cmp,event,helper,params);

    },

    handleSearchClick : function(cmp,event,helper){
    //    debugger;

        cmp.set('v.searchPressed',true);
        var paramValue = cmp.get('v.skuValue');
        var _params = {
            searchParameter : paramValue
        };

        this.doCallout(cmp, "c.getProduct", _params, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var _resp = response.getReturnValue();
                cmp.set("v.responseWrapperData",response.getReturnValue());
            }
        });
    },

    handleCollectionSearchClick : function (cmp,event, helper) {
    //    debugger;

        helper.getSearchedProductBySku(cmp,event,helper);
    },


    getColors : function (cmp, event, helper) {
    //    debugger;

        var serId = cmp.get('v.selectedSeries');
        cmp.set('v.selectedColor','All');
		
        var selBrand = cmp.get('v.selectedBrand');
        var divCode = cmp.get('v.divisionCode');
        if(!selBrand) {
            if(divCode === '40' ) {
                selBrand = 'DB';
            } else {
                selBrand = 'AO';
            }
        }
        
        var flag = true;
        if(serId) {
            if(serId != 'ALL')
                helper.getAllProductsOfSeries(cmp,helper,serId,selBrand);
            else {
                helper.handleSearchClickAll(cmp,event,helper);
                flag = false;
            }
        } else {
            cmp.set('v.listOfColors',[]);
            cmp.set('v.listOfSizes',[]);
        }
        if(serId && flag)
            helper.getSearchedProductBySku(cmp,event,helper);
    },
    
    clearAllFields : function(cmp, event, helper) {
        cmp.set('v.selectedSeries',null);
        cmp.set("v.selectedColor",null);
        cmp.set("v.selectedSize",null);
        cmp.set("v.productList", '');
        cmp.set('v.responseWrapperData',[]);
        cmp.set('v.count',0);
        cmp.set('v.searchPressed',false);
        cmp.set('v.listOfSelectedProducts',[]);
        cmp.set('v.isProductSelected',true);
        cmp.set('v.totalPages',0);
        cmp.set('v.pageNumber',1);
        cmp.set('v.disableNext',false);
        cmp.set('v.listOfColors',[]);
        cmp.set('v.skuKeyword','');
        cmp.set('v.isFilterOpen',false);
        cmp.set('v.listOfSizes',[]);
        //cmp.set('v.selectedProductType',null);
        //helper.setProductTypeByURL(cmp,event,helper);
    },

    clearAllFieldsForVendors : function(cmp,event,helper) {
        cmp.set("v.productList", '');
        cmp.set('v.selectedSeries',null);
        cmp.set("v.selectedColor",null); 
        cmp.set("v.selectedSize",null);
        cmp.set("v.selectedVendor",'Select Vendor');
        cmp.set('v.responseWrapperData',[]);
        cmp.set('v.count',0);
        cmp.set('v.listOfSelectedProducts',[]);
        cmp.set('v.isProductSelected',true);
        cmp.set('v.totalPages',0);
        cmp.set('v.pageNumber',1);
        cmp.set('v.disableNext',false);
        cmp.set('v.listOfColors',[]);
        cmp.set('v.skuKeyword','');
        cmp.set('v.isFilterOpen',false);
        //cmp.set('v.selectedProductType',null);
        //helper.setProductTypeByURL(cmp,event,helper);
    }
    
})