/**
 * Created by ranja on 27-12-2018.
 */
({
    getColors : function (cmp, event, helper) {
        debugger;

        var createOrderWrapper = cmp.get('v.createOrderWrapper');
        var serId = createOrderWrapper.selectedSeries;
         var selBrand = helper.getBrandName(cmp);

        if(serId && serId!='select') {
            helper.getAllProductsOfSeries(cmp,helper,serId,selBrand);
        } else {
           var createOrderWrapper = cmp.get('v.createOrderWrapper');
           createOrderWrapper.selectedSeries = 'select';
           createOrderWrapper.selectedColor = 'all';
           createOrderWrapper.selectedSize = 'all';
           createOrderWrapper.selectedVendor= 'all';
           createOrderWrapper.listOfProducts = [];
           createOrderWrapper.listOfSizes = [];
           cmp.set('v.createOrderWrapper',createOrderWrapper);
           cmp.set('v.displayProdList',[]);
           cmp.set('v.responseFromSearchResult',[]);
        }
    },

    handleProductSearch : function(cmp,event,helper) {
        var selBrand = helper.getBrandName(cmp);

        helper.getSearchedProductBySku(cmp,event,helper);
    },

    handleCategoryChange : function(cmp,event,helper) {
        debugger;
        var createOrderWrapper = cmp.get('v.createOrderWrapper');
        createOrderWrapper.selectedSeries = 'select';
        createOrderWrapper.selectedColor = 'all';
        createOrderWrapper.selectedSize = 'all';
        createOrderWrapper.selectedVendor= 'all';
        createOrderWrapper.listOfProducts = [];
        createOrderWrapper.listOfSizes = [];
        cmp.set('v.createOrderWrapper',createOrderWrapper);
        cmp.set('v.displayProdList',[]);
        cmp.set('v.responseFromSearchResult',[]);

        if(createOrderWrapper.selectedCategory === 'Installation Product') {
            helper.getVendorsResultHelper(cmp,event,helper);
        }

    },

    handleBrandChange : function(cmp,event,helper) {
        var createOrderWrapper = cmp.get('v.createOrderWrapper');
        createOrderWrapper.selectedSeries = 'select';
        createOrderWrapper.selectedColor = 'all';
        createOrderWrapper.selectedSize = 'all';
        createOrderWrapper.skuKeyword = '';
        createOrderWrapper.selectedVendor= 'all';
        createOrderWrapper.listOfProducts = [];
        createOrderWrapper.listOfSizes = [];
        cmp.set('v.createOrderWrapper',createOrderWrapper);
        cmp.set('v.displayProdList',[]);
        cmp.set('v.responseFromSearchResult',[]);
        helper.getSeries(cmp,event,helper);
    },

     getResultBySizeFilter : function(cmp,event,helper) {
        debugger;

        var createOrderWrapper = cmp.get('v.createOrderWrapper');
        var skuKeyword = createOrderWrapper.skuKeyword;
        var selectedSize = createOrderWrapper.selectedSize;
        var listOfColors = createOrderWrapper.listOfProducts;
        var selectedColor = createOrderWrapper.selectedColor;
        var listOfSizes = createOrderWrapper.listOfSizes;
        var colorParams = [];
        var sizeParams = [];
        var selBrand = helper.getBrandName(cmp);

        if(selectedSize && listOfSizes) {
            if(selectedSize.toUpperCase() === 'ALL') {
                for(var i=0;i<listOfSizes.length;i++)
                    sizeParams.push(listOfSizes[i]);
            } else {
                sizeParams.push(selectedSize);
            }
        }

        if(selectedColor === "All" || selectedColor == 'all' || selectedColor === 'ALL') {
            if(listOfColors.length > 0) {
                for(var i=0;i<listOfColors.length;i++)
                    colorParams.push(listOfColors[i].colorCode);
            }
        } else {
            colorParams.push(selectedColor);
        }

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

    getVendorsResult : function(cmp,event,helper) {
        helper.getVendorsResultHelper(cmp,event,helper);
    },

    clearAllFields : function(cmp,event,helper) {
        var createOrderWrapper = cmp.get('v.createOrderWrapper');
        createOrderWrapper.selectedSeries = 'select';
        createOrderWrapper.selectedColor = 'All';
        createOrderWrapper.selectedSize = 'All';
        createOrderWrapper.skuKeyword = '';
        createOrderWrapper.selectedVendor= 'All';
        createOrderWrapper.listOfColors = [];
        createOrderWrapper.listOfSizes = [];
        cmp.set('v.createOrderWrapper',createOrderWrapper);
        cmp.set('v.displayProdList',[]);
        cmp.set('v.responseFromSearchResult',[]);
    }

})