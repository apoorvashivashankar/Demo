/**
 * Created by 7Summits on 3/9/18.
 */
({
    
    init: function(cmp){

        // ---------------------------------
        // set selected unitOfMeasure record
        // ---------------------------------
        var unitOfMeasure = cmp.get('v.unitOfMeasure');
        if(unitOfMeasure !== undefined && Array.isArray(unitOfMeasure) && unitOfMeasure.length > 0){
            this.helpers.setToViewSelectBoxSelected(cmp, 'v.inputValueUnitOfMeasureSelected', 'v.unitOfMeasure');
        }

        // ---------------------------------
        // set selected source of supply record
        // ---------------------------------
        var sourceOfSupply = cmp.get('v.sourceOfSupply');
        if(sourceOfSupply !== undefined && Array.isArray(sourceOfSupply) && sourceOfSupply.length > 0){
            this.helpers.setToViewSelectBoxSelected(cmp, 'v.inputValueSourceOfSupplySelected', 'v.sourceOfSupply');
        }

        // ---------------------------------
        // set selected price record
        // ---------------------------------
        var priceRecord = cmp.get('v.priceRecord');
        if(priceRecord !== undefined && Array.isArray(priceRecord) && priceRecord.length > 0){
            this.helpers.setToViewSelectBoxSelected(cmp, 'v.inputValuePriceRecordSelected', 'v.priceRecord');
        }

        // ---------------------------------
        // set sites with inventory based on source of supply
        // ---------------------------------
        this.helpers.setSitesWithInventory(cmp);

        // validate form on init
        this.validateForm(cmp, true, true);
    },

    handleChange: function(cmp){
        var isFormValid = this.validateForm(cmp);
        var _prodName = cmp.get("v.productName");
        var _quantity = cmp.get("v.quantity");

        // check if we should make a request to update the product date, but there is a one off
        // case were we don't want to update the product data that is if we are in a price by sku flow
        if(_prodName){
            if(isFormValid === true || _quantity){
                cmp.set('v.isValidData', true);
                this.helpers.updateProduct(cmp);
            } else {
                cmp.set('v.isValidData', false);
                this.helpers.updateProductToStore(cmp);
            }
        }else{
            cmp.set('v.isValidData', false);
            this.helpers.updateProductToStore(cmp);
        }
    },

    handleSourceOfSupplyChange: function(cmp){
        var isFormValid = this.validateForm(cmp);

        console.log('handleSourceOfSupplyChange:isFormValid:', isFormValid);

        // check if we should make a request to update the product date
        if(isFormValid === true){
            var store = cmp.get('v.store');
            var cartId = cmp.get('v.cartId');
            var selectedValue = cmp.get('v.inputValueSourceOfSupplySelected');
            store.updateSourceOfSupply(cartId, selectedValue);
            store.setShowProductSupply(cartId, false);
        }
    },

    handleShipDateChange: function(cmp){
        var store = cmp.get('v.store');
        var cartId = cmp.get('v.cartId');
        var shippingDate = cmp.get('v.requestShipDate');

        // check if shipping date is valid
        var isValidShippingDate = this.isValidShippingDate(cmp, shippingDate);

        // now we know the changed shipping date is valid, but since the shipping
        // date changed we need to make a request to get the new price records.
        if(isValidShippingDate === true){
            var priceRecord = cmp.get('v.priceRecord');

            // we want to clear the selected price record since updating shipping date
            // will results in new price records. Also updating the shipping date will
            // require a product update, so to speed up the process and not have to wait
            // unt the new price  records are returned to call the product update we are
            // doing both at the same time and in order to get valid data we need
            // price records cleared.
            priceRecord.forEach(function(priceRecord){
                priceRecord.selected = false;
            });

            store.setPriceRecordsByDate(cartId, shippingDate);
            store.setRequestedShipDate(cartId, shippingDate);
            this.handleChange(cmp);
        } else {
            cmp.set('v.isValidData', false);
            this.helpers.updateProductToStore(cmp);
        }
    },

    handleSkuInputChange: function(cmp, sku){
        cmp.set('v.loadingSkuSearch', true);
        var store = cmp.get('v.store');
        var baseHelper = store.getHelper();

        // make autocomplete call
        var promise = baseHelper.doCallout(cmp, 'c.searchProductSKUs', {sku: sku.trim()});

        promise.then(function(response){
            if(response !== undefined && Array.isArray(response)){
                console.log('HG: >>> ', response);
                cmp.set('v.skuSearchResults', response);
                cmp.set('v.showSkuSearchResults', true);
            //    cmp.set('v.isCallAtp', true);  
            }

            cmp.set('v.loadingSkuSearch', false);
        }, function(response){
            cmp.set('v.loadingSkuSearch', false);
            console.log('handleSkuInputChange:error:', response);
        });

    },

    setSelectedSku: function(cmp, cartId, skuId){
        var skuList = cmp.get('v.skuSearchResults');
		var _this = this;
        // make sure we have a skuList
        if(skuList !== undefined && Array.isArray(skuList)){
            // iterate the list to find the selected
            for(var x=0; x < skuList.length; x++){
                // look for id match
                if(skuList[x].Id === skuId){
                    var store = cmp.get('v.store');

                    console.log('skuSelected:', skuList[x]);

                    // get the sku attributes needed
                    var sku = skuList[x].DW_ID__c || '';
                    var productName = skuList[x].Description || '';

                    // create unitOfMeasure list
                    var uom = store.createUnitOfMeasure(skuList[x]);

                    // set view attributes
                    cmp.set('v.sku', sku);
                    cmp.set('v.productName', productName);
                    cmp.set('v.unitOfMeasure', uom);

                    // store some SKU information to the store behind the scenes
                    store.backgroundUpdateStoreProduct(cartId, {
                        sku: sku,
                        productName: productName,
                        unitOfMeasure: uom,
                        size: skuList[x].Size__c || undefined,
                        color: skuList[x].Color__c || undefined,
                        trim: skuList[x].Tile_Type__c || undefined
                    });

                    // input changed so run handle checks
                    _this.handleChange(cmp);

                    break;
                }
            } // end for loop

            // clear search results
            _this.clearSkuSearch(cmp);
        } // end outer if

    },

    validateForm: function(cmp, showErrors, hideRequiredFieldErrors){
        var store = cmp.get('v.store');
        var baseHelper = store.getHelper();

        // aura:ids of the lightning inputs (Note we are using one ui:inputDate not listed here)
        var lightningFormInputIds = ['productSku', 'quantity', 'unitOfMeasure'];

        // if we are on the price by sku page we don't want to validate SOS
        var isPriceBySku = cmp.get('v.priceBySku');
        if(isPriceBySku === false){
            lightningFormInputIds.push('sourceOfSupply');
        }

        //  Since we are using lightning:input for all input except for the date fields
        // we are using ui:inputDate for IE. Because of this we have to validate two different ways.
        var lightningInputValid = baseHelper.validateForm(cmp, null, lightningFormInputIds, showErrors === true, (hideRequiredFieldErrors === undefined ? false : hideRequiredFieldErrors));

        // valid requested shipping date
        var requestedShippingDate = cmp.get('v.requestShipDate');
        var validateShippingDate = this.isValidShippingDate(cmp, requestedShippingDate);

        return lightningInputValid && validateShippingDate;
    },

    setSelectBox: function(value, list) {
        list.forEach(function(item){
            // check if selectedValue is equal to the items value
            item.selected = (item.value === ((typeof item.value === 'number') ? parseInt(value, 10) : value));
        });
    },

    getProductSupply: function(cmp){
        var store = cmp.get('v.store');
        var cartId = cmp.get('v.cartId');

        // no need currently to handle returned promise because this call updates the store which in turn updates this component
        var promise = store.getProductSupplyData(cartId);
    },

    clearSkuSearch: function(cmp){
        cmp.set('v.showSkuSearchResults', false);
        cmp.set('v.skuSearchResults', []);
    },

    resetPriceBySku: function(cmp){
        var store = cmp.get('v.store');
        var cartId = cmp.get('v.cartId');

        store.backgroundUpdateStoreProduct(cartId, {
            showPriceBySku: false
        });

        cmp.set('v.showPriceBySku', false);
    },

    /**
     * Internal helper to this file
     */
    helpers: {

        updateProduct: function(cmp){
            var store = cmp.get('v.store');
            var cartId = cmp.get('v.cartId');
            var sku = cmp.get('v.sku');
            var productName = cmp.get('v.productName');
            var quantity = cmp.get('v.quantity');
            var unitOfMeasure = cmp.get('v.unitOfMeasure');
            var sourceOfSupply = cmp.get('v.sourceOfSupply');
            var requestShipDate = cmp.get('v.requestShipDate');
            var priceRecord = cmp.get('v.priceRecord');
            var isPriceBySku = cmp.get('v.priceBySku');
            var isValidData = cmp.get('v.isValidData');

            // no need currently to handle returned promise because this call updates the store which in turn updates this component
           var getAdditionalProductData = store.getAdditionalProductData(cartId, sku, productName, quantity, unitOfMeasure, sourceOfSupply, requestShipDate, priceRecord, isPriceBySku, isValidData);
            getAdditionalProductData.then(function(){
               // handle if needed
            }, function(){
                // handle if needed
            });
        },

        updateProductToStore: function(cmp){
            var store = cmp.get('v.store');
            var cartId = cmp.get('v.cartId');
                
            store.updateProductByCartIdToStore(cartId, {
                sku: cmp.get('v.sku'),
                productName: cmp.get('v.productName'),
                quantity: cmp.get('v.quantity'),
                unitOfMeasure: cmp.get('v.unitOfMeasure'),
                sourceOfSupply: cmp.get('v.sourceOfSupply'),
                requestShipDate: cmp.get('v.requestShipDate'),
                priceRecord: cmp.get('v.priceRecord'),
                isValidData: cmp.get('v.isValidData')
            });
        },

        setSitesWithInventory: function(cmp){
            var sourceOfSupply = cmp.get('v.sourceOfSupply');
            if(sourceOfSupply !== undefined && Array.isArray(sourceOfSupply) && sourceOfSupply.length > 0){
                var sitesWithInventory = [];
                sourceOfSupply.forEach(function(source){
                    // we only want sites that are not currently selected and have the available quantity,
                    // requested and can be delivered at the requested date.
                    if(source.selected !== true && source.isQtyAvailable === 'Y' && source.onTimeFlag === 'Y'){
                        sitesWithInventory.push(source);
                    }
                });
                cmp.set('v.sitesWithInventory', sitesWithInventory);
            }
        },

        setViewUnitOfMeasureSelected: function(cmp){
            var unitOfMeasure = cmp.get('v.unitOfMeasure');
            if(unitOfMeasure !== undefined && Array.isArray(unitOfMeasure) && unitOfMeasure.length > 0){
                console.log('setViewUnitOfMeasureSelected:', cmp.get('v.unitOfMeasure'));
                this.setToViewSelectBoxSelected(cmp, 'v.unitOfMeasureSelected', 'v.unitOfMeasure');
            }
        },

        setToViewSelectBoxSelected: function(cmp, attrName, attrList){
            var list = cmp.get(attrList);

            for(var x=0; x < list.length; x++){
                if(list[x].selected === true){
                    cmp.set(attrName, list[x].id);
                    break;
                }
            }

        }

    } // end helpers

})