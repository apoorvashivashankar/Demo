/**
 * Created by ranja on 07-08-2018.
 */
({
    initLoadData : function (cmp) {

        //console.log('IN INIT LOAD SERIES');

        var promise = this.doCallout(cmp, 'c.getOrderSampleSeries', {});

                promise.then(function(response){

                    //console.log('Response from getOrderSampleSeries: ', response);

                    // make sure we have a valid response
                    if(response != undefined  || response!=null){
                        cmp.set('v.listOfSeries', response);
                    }

                    //set loading to false
                    cmp.set('v.isSampleOrderBaseLoading' , false);
                    //cmp.set('v.isLoadedInit',true);

            }, function(response){
                // handle error state
                //console.log('searchProducts:fail:', response);
                    });

    },


    getAllProductsOfSeries : function (cmp, _serId) {
            //console.log('IN NEW BASE CLASS GET PRODUCTS FUNCTION');

            cmp.set('v.isSearching' , true);
            var promise = this.doCallout(cmp, 'c.getOrderSampleSeriesProduct', {SeriesId : _serId});

                promise.then(function(response){

                //console.log('Response from getOrderSampleSeriesProduct: ', response);

                // make sure we have a valid response
                if(response != undefined  || response!=null){
                    cmp.set('v.listOfProducts', response);
                    //console.log('ProductList:- ', response);
                    cmp.set('v.selectedProduct','');
                }
                cmp.set('v.isSearching' , false);
            }, function(response){
                // handle error state
                cmp.set('v.isSearching' , false);
                //console.log('searchProducts:fail:', response);
            });
    },


    doCalloutForSampleOrder : function(cmp, methodName, params, callBackFunc){
        //console.log('IN CALLBACK METHOD');
        var action = cmp.get(methodName);
        action.setParams(params);
        action.setCallback(this, callBackFunc);
        $A.enqueueAction(action);
        //console.log('OUT CALLBACK METHOD');
    },

     navigateToSampleOrderDetailPage : function(cmp,event,helper) {
        //console.log('IN NAVIGATE TO SAMPLE ORDER DETAIL PAGE');


     },

     getAddressForAccount : function (cmp,event,helper) {
        cmp.set('v.isSampleOrderBaseLoading' , false);
     },

     showtoast : function(_msg, _type){
           var _toastEvent = $A.get("e.force:showToast");
           _toastEvent.setParams({
               message: _msg,
               type : _type,
           });
           _toastEvent.fire();
       },

})