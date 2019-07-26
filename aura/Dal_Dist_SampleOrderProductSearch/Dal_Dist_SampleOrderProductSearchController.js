/**
 * Created by ranja on 09-08-2018.
 */
({
    updateTheValues : function (cmp, event, helper) {

        var productList = cmp.get('v.listOfProducts');
        //console.log('productList: ', productList.length);
        var searchValue = cmp.find('products').get('v.value');
        //console.log('searchValue : ' , searchValue);
        var searchValueList = [];
        if(searchValue == 'All Products') {
           if(productList){
            for(var i=0;i<productList.length;i++){
                searchValueList.push(productList[i].colorCode);
            }
           }
        } else {
            searchValueList.push(searchValue);
        }
        //console.log('searchValueList: ', searchValueList);
          if(searchValueList.length > 0) {
           var params = {
                           ColorCode : searchValueList
                        };
          }

        //console.log('%%%%%%%%%%%%% CALLING %%%%%%%%%%%%%%')


         if(searchValueList.length > 0 && searchValueList[0]!='') {
         var promise = helper.doCallout(cmp, 'c.getProduct', params);
         cmp.set('v.isSearching',true);
         promise.then(function(response){

                //console.log('searchResultsResponse FROM MODAL', response);
                var listOfIdsOfOrderLine = cmp.get('v.listOfIdsOfOrderLine');
                 var productResponse = response;

                 if(listOfIdsOfOrderLine.length > 0 && productResponse.length > 0) {
                    for(var j=0;j<listOfIdsOfOrderLine.length;j++) {
                         for(var i=0;i<productResponse.length;i++) {
                             if(listOfIdsOfOrderLine[j] == productResponse[i].productId) {
                                     productResponse[i].isAdded = true;
                                     //console.log('HANDLED TRUE IN UPDATE SEARCH CLICK');
                             }
                         }
                    }
                    }

                // make sure we have a valid response
                if(response !== undefined && Array.isArray(response)){
                    cmp.set('v.productResponse', productResponse);

                }

             cmp.set('v.isSearching',false);

            }, function(response){
                // handle error state
                helper.showtoast('This Product is presently not available at any Location.  Please select another Product.','error');
                //console.log('searchProducts:fail:', response);
                cmp.set('v.isSearching',false);
            });
         }
    },

    handleAddAll : function (cmp, event, helper) {
        //cmp.set('v.isSearching',true);
        var productResponse = cmp.get('v.productResponse');
        var productOrderLines = cmp.get('v.productOrderLines');
        var listOfIdsOfOrderLine = cmp.get('v.listOfIdsOfOrderLine');
        var cumulativeOrderWeight = cmp.get('v.cumulativeOrderWeight');

        if(cumulativeOrderWeight==null)
            cumulativeOrderWeight = 0.00;

        if(productOrderLines==null)
            productOrderLines = [];

        if(listOfIdsOfOrderLine==null)
            listOfIdsOfOrderLine = [];

        var listOfIdsOfOrderLine = cmp.get('v.listOfIdsOfOrderLine');
        if(listOfIdsOfOrderLine.length > 0 && productResponse.length > 0) {
               for(var j=0;j<listOfIdsOfOrderLine.length;j++) {
                    for(var i=0;i<productResponse.length;i++) {
                        if(listOfIdsOfOrderLine[j] == productResponse[i].productId) {
                            productResponse[i].isAdded = true;
                            //console.log('HANDLED TRUE IN ADD ALL');
                        }
                    }
               }
        //cmp.set('v.productResponse', productResponse);
        }

        //console.log('HANDLED ALL');
         if(productResponse.length > 0) {

                    for(var i=0;i<productResponse.length;i++) {
                         if(!productResponse[i].isAdded && productResponse[i].availableQty >= 1) {
                             var productResponseItem = productResponse[i] || {};
                            productResponseItem.variableQuantity =
                                    (productResponse[i].ExtendedWeight  * productResponse[i].selectedQuantity);
                            productOrderLines.push(productResponseItem);
                            productResponseItem.isAdded = true;
                            listOfIdsOfOrderLine.push(productResponseItem.productId);
                            cumulativeOrderWeight = (parseFloat(cumulativeOrderWeight) + parseFloat(productResponseItem.ExtendedWeight));
                         }
                    }
                }

        cmp.set('v.cumulativeOrderWeight',cumulativeOrderWeight.toFixed(2));
        cmp.set('v.productResponse', productResponse);
        cmp.set('v.productOrderLines',productOrderLines);
        //cmp.set('v.isSearching',false);
    },

    handleClose : function (cmp, event, helper) {
        cmp.find('overlayLib').notifyClose();
    },

    addToProductList : function (cmp, event, helper) {
        //console.log('Added to order list called');
        debugger;
        var productResponse = cmp.get('v.productResponse');
        var selectedRowNumber = event.getSource().get("v.value");
        var cumulativeOrderWeight = cmp.get('v.cumulativeOrderWeight');

        if(cumulativeOrderWeight)
            cumulativeOrderWeight = 0.00;

        //console.log('selectedRowNumber: ', selectedRowNumber);

        var listOfIdsOfOrderLine = cmp.get('v.listOfIdsOfOrderLine');
        if(listOfIdsOfOrderLine==null)
            listOfIdsOfOrderLine = [];

        var productOrderLines = cmp.get('v.productOrderLines');
        if(productOrderLines==null)
            productOrderLines = [];


        if(selectedRowNumber + 1) {
            //console.log('productResponse[selectedRowNumber]: ' , productResponse[selectedRowNumber]);
            var productResponseItem = productResponse[selectedRowNumber] || {};
            if(productResponseItem && productResponse[selectedRowNumber].ExtendedWeight) {
                productResponseItem.variableQuantity =
                        (productResponse[selectedRowNumber].ExtendedWeight  * productResponse[selectedRowNumber].selectedQuantity);
             }
            //console.log('^^^^^^^^^^^^ ,', productResponseItem.variableQuantity);
            productOrderLines.push(productResponseItem);
            //console.log('productOrderLines: ',productOrderLines);
            listOfIdsOfOrderLine.push(productResponseItem.productId);
            //console.log('listOfIdsOfOrderLine: ' ,listOfIdsOfOrderLine)
            productResponseItem.isAdded = true;

            if(productResponseItem && productResponseItem.ExtendedWeight) { 
                cumulativeOrderWeight = (parseFloat(cumulativeOrderWeight) + parseFloat(productResponseItem.ExtendedWeight) );
            //console.log('cumulativeOrderWeight: ' , cumulativeOrderWeight.toFixed(2));
           }
        }

        cmp.set('v.cumulativeOrderWeight',cumulativeOrderWeight.toFixed(2));
        cmp.set('v.productResponse',productResponse);
        cmp.set('v.productOrderLines',productOrderLines);
        cmp.set('v.listOfIdsOfOrderLine',listOfIdsOfOrderLine);
        //console.log('PRODUCT ORDER LINE: ', productOrderLines);
    },

     getProducts : function (cmp, event, helper) {
            //console.log('IN GET PRODUCTS FUNCTION FIRST');

             var empProd = [];
            var productResponse = cmp.get('v.productResponse');
            var serId = cmp.find('series').get('v.value');
            //console.log('value : ' , serId);

            if(serId) {
                //console.log('in IF statement');
                helper.getAllProductsOfSeries(cmp,serId);
            } else {
                cmp.set('v.listOfProducts',empProd);
            }

        },

     changedSelectedProduct : function (cmp, event, helper) {

        var productResponse = cmp.get('v.productResponse');

        var listOfIdsOfOrderLine = cmp.get('v.listOfIdsOfOrderLine');
                if(listOfIdsOfOrderLine.length > 0 && productResponse.length > 0) {
                       for(var j=0;j<listOfIdsOfOrderLine.length;j++) {
                            for(var i=0;i<productResponse.length;i++) {
                                if(listOfIdsOfOrderLine[j] == productResponse[i].productId) {
                                        productResponse[i].isAdded = true;
                                        //console.log('HANDLED TRUE IN ADD ALL');
                                }
                            }
                       }
         cmp.set('v.productResponse', productResponse);
     }
    }
})