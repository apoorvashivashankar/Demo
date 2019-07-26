/**
 * Created by ranja on 21-08-2018.
 */
({
    getAllProductsOfSeries : function (cmp, _serId) {
                //console.log('IN HELPER CLASS');
         cmp.set('v.isSearching',true);

                var promise = this.doCallout(cmp, 'c.getOrderSampleSeriesProduct', {SeriesId : _serId});

                                promise.then(function(response){

                                //console.log('Response from getOrderSampleSeriesProduct Helper: ', response);

                                // make sure we have a valid response
                                if(response != undefined  || response!=null){
                                    cmp.set('v.listOfProducts', response);
                                    //console.log('SET');
                                    cmp.set('v.isSearching',false);
                                    cmp.set('v.selectedProduct','');
                                }

                            }, function(response){
                                    // handle error state
                                    helper.showtoast('This Product is presently not available at any Location.  Please select another Product.','error');
                                    cmp.set('v.isSearching',false);
                                    //console.log('searchProducts:fail:', response);
                              });
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