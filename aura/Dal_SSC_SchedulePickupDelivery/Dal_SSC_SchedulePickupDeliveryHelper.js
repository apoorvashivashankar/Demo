/**
 * Created by 7Summits on 4/26/18.
 */
({

    handleStoreUpdate: function(cmp){
        // get the store
        debugger; 
        var store = cmp.get('v.store');

      /*  //----------------- to get Schedule or Reschedule from URL ----------
         var pageUrl = window.location.href;
            var hashIndex = pageUrl.lastIndexOf('#');
            var selectedProductType = pageUrl.substring(hashIndex+1,pageUrl.length);

            if(selectedProductType == 'reschedule') {
                cmp.set('v.isReschedule',true);
            } else {
                cmp.set('v.isReschedule',false);
            }

            if(selectedProductType == 'multiple'){
                cmp.set('v.isMultiple',true);
            }
*/
        // get the order info from the store and set to view
        var orders = store.getOrders();
        var currentOrderPosition = store.getCurrentOrderPosition();
        var isLoading = store.getIsLoading();
        var activeTab = store.getActiveTab();

        console.log('handleStoreUpdate:currentOrder:', JSON.parse(JSON.stringify(orders[currentOrderPosition])), JSON.parse(JSON.stringify(orders)));

        // set the current order position
        cmp.set('v.currentOrderScheduling', currentOrderPosition + 1);
        cmp.set('v.totalOrdersToSchedule', orders.length);
        cmp.set('v.currentOrder', orders[currentOrderPosition]);
        cmp.set('v.isLoading', isLoading);
        cmp.set('v.activeTab', activeTab);
    }

})