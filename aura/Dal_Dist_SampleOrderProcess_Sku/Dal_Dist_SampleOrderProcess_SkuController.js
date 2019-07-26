/**
 * Created by ranja on 07-08-2018.
 */
({
    initData : function (cmp, event, helper) {

        //console.log('IN INIT DATA Process SKU');
         //helper.initLoadData(cmp);

        var _currentDate = new Date();
        var _month = _currentDate.getMonth() + 1;
        var _date = _currentDate.getDate();
        var _year = _currentDate.getFullYear().toString();
        //console.log('_year: ',_year);
        _year = _year.substr(2,2);
        //console.log('_year: ',_year);
        if(_month < 10)
            _month = '0' + _month;
        if(_date < 10)
            _date = '0' + _date;

        var _newDate =  _month  + '/' + _date + '/' + _year ;
        //console.log('NEW DATE: ' , _newDate);
        cmp.set('v.today', _newDate);

        //console.log('v.listOfSeries ' , cmp.get('v.listOfSeries'));

    },

    checkSeriesSelected : function (cmp, event, helper) {
          var selectedProduct = cmp.get('v.selectedProduct');
          var selectedSeries = cmp.get('v.selectedSeries');
          if(!selectedSeries) {
              cmp.set('v.isSeriesNotSelected',true);
          } else {
              cmp.set('v.isSeriesNotSelected',false);
          }
    },


    checkProductSelected : function (cmp, event, helper) {
        var selectedProduct = cmp.get('v.selectedProduct');
        var selectedSeries = cmp.get('v.selectedSeries');
        if(!selectedSeries) {
              cmp.set('v.isSeriesNotSelected',true);
          } else {
              cmp.set('v.isSeriesNotSelected',false);
          }
          if(!selectedProduct) {
            cmp.set('v.isProductNotSelected',true);
          } else {
            cmp.set('v.isProductNotSelected',false);
          }
    },

    getProducts : function (cmp, event, helper) {
        //console.log('IN GET PRODUCTS FUNCTION FIRST');

        var serId = cmp.find('series').get('v.value');
        //console.log('value : ' , serId);
        var empProd = [];
        if(serId!='') {
            helper.getAllProductsOfSeries(cmp,serId);
        } else {
            cmp.set('v.listOfProducts',empProd);
        }
        //console.log(cmp.get('v.listOfProducts').length);
    },

    openModalComponent : function (cmp, event, helper) {
        debugger;
        //console.log('OPEN MODAL METHOD CALLED');
        var selectedProduct = cmp.get('v.selectedProduct');
        var selectedSeries = cmp.get('v.selectedSeries');
        if(!selectedSeries) {
              cmp.set('v.isSeriesNotSelected',true);
          } else {
              cmp.set('v.isSeriesNotSelected',false);
          }
          if(!selectedProduct ) {
            cmp.set('v.isProductNotSelected',true);
          } else {
            cmp.set('v.isProductNotSelected',false);
          }


        var productList = cmp.get('v.listOfProducts');

        var searchValue = cmp.find('products').get('v.value');
        //console.log('searchValue : ' , searchValue);
        var searchValueList = [];

        if(searchValue == 'All Products') {
           if(productList.length > 0){
            for(var i=0;i<productList.length;i++){
                searchValueList.push(productList[i].colorCode);
            }
           }
        } else {
            searchValueList.push(searchValue);
        }
        //console.log('searchValueList: ', searchValueList);


         if(searchValueList.length > 0 && searchValueList[0]!='') {
                cmp.set('v.isSearching',true);
              var params = {
                            ColorCode : searchValueList
                            };
                //console.log(params);


         helper.doCalloutForSampleOrder(cmp,'c.getProduct',params,function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                //console.log('IN SUCCESS STATEMENT FOR SEARCHING PRODUCT FOR MODAL: ' , response.getReturnValue());

                var productResponse = response.getReturnValue();
                var listOfIdsOfOrderLine = cmp.get('v.listOfIdsOfOrderLine');
                //console.log('listOfIdsOfOrderLine: ' , listOfIdsOfOrderLine.length);
                console.log('Response: ' ,  productResponse);
                if(listOfIdsOfOrderLine.length > 0 && productResponse.length > 0) {
                    for(var j=0;j<listOfIdsOfOrderLine.length;j++) { 
                        for(var i=0;i<productResponse.length;i++) {
                            if(listOfIdsOfOrderLine[j] == productResponse[i].productId) {
                                productResponse[i].isAdded = true;

                            }
                        }
                    }
                }
                cmp.set('v.isSearching',false);
                cmp.set('v.productResponse', productResponse);
                helper.openModal(cmp,'c:Dal_Dist_SampleOrderProductSearch', {listOfSeries: cmp.getReference('v.listOfSeries'),listOfProducts : cmp.getReference('v.listOfProducts'),
                                    selectedProduct : cmp.getReference('v.selectedProduct'),selectedSeries : cmp.getReference('v.selectedSeries'),
                                    productResponse : cmp.getReference('v.productResponse'), productOrderLines : cmp.getReference('v.productOrderLines'),
                                    cumulativeOrderWeight : cmp.getReference('v.cumulativeOrderWeight'), listOfIdsOfOrderLine : cmp.getReference('v.listOfIdsOfOrderLine') },
                                    true,'slds-modal_medium');

            } else if (state === "ERROR") {
                  var errors = response.getError();
                  if (errors) {
                      if (errors[0] && errors[0].message) {
                          cmp.set('v.isSearching',false);
                          //console.log("Error message: " , errors[0].message);
                          helper.showtoast('This Product is presently not available at any Location.  Please select another Product.','error');
                      }
                  } else {
                      //console.log("Unknown error");
                      cmp.set('v.isSearching',false);
                      helper.showtoast('This Product is presently not available at any Location.  Please select another Product.','error');
                  }
            }
         });

         } else {
             //console.log('### PRODUCT WAS NOT SELECTED ###');
         }

    },

    closeModal : function (cmp, event, helper) {
        component.set('v.isOpenModal', false);
    },

    goToDetailPage : function(cmp,event,helper) {
        cmp.set('v.isSearching',true);
        var productOrderLines = cmp.get('v.productOrderLines');
        var weight = 0;
        var diffSourcesSOS = new Map();

        for(var i=0;i<productOrderLines.length;i++) {
            if(diffSourcesSOS.has(productOrderLines[i].sourceOfSupply)) {
                weight = diffSourcesSOS.get(productOrderLines[i].sourceOfSupply);
                weight = parseFloat(weight) + (parseFloat(productOrderLines[i].ExtendedWeight) * parseFloat(productOrderLines[i].selectedQuantity));
                weight = weight.toFixed(2);
                diffSourcesSOS.set(productOrderLines[i].sourceOfSupply,weight);
                if(weight > 150) {
                    cmp.set('v.isMore', true);
                    break;
                } else {
                     cmp.set('v.isMore', false);
                }

            } else {
                weight = diffSourcesSOS.get(productOrderLines[i].sourceOfSupply);
                if(!weight) {
                    weight = 0;
                    diffSourcesSOS.set(productOrderLines[i].sourceOfSupply, weight);
                }
                weight = diffSourcesSOS.get(productOrderLines[i].sourceOfSupply);
                weight = parseFloat(weight) + (parseFloat(productOrderLines[i].ExtendedWeight) * parseFloat(productOrderLines[i].selectedQuantity));
                weight = weight.toFixed(2);
                diffSourcesSOS.set(productOrderLines[i].sourceOfSupply, weight);
                if(weight > 150) {
                    cmp.set('v.isMore', true);
                    break;
                } else {
                     cmp.set('v.isMore', false);
                }
            }
        }

        var currentPosition = cmp.get('v.currentPosition');
        currentPosition ++;
        cmp.set('v.currentPosition',currentPosition);
        cmp.set('v.isSearching',false);
        helper.nextStep(cmp.get('v.currentPosition'));
    },


})