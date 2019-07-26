/**
 * Created by ranja on 06-12-2018.
 */
({
    doInit : function(cmp, event, helper) {
        debugger;

        var  _listOfOrders = cmp.get('v.listOfOrders');
        var successedSkus = cmp.get('v.successedSkus');
        var failedSkus = cmp.get('v.failedSkus');

        console.log('in modal');
        console.log('successedSkus: ',successedSkus);
        console.log('failedSkus: ',failedSkus);
        cmp.set('v.showSpinner',true);

        if(successedSkus.length > 0) {
        var action = cmp.get("c.getSkusSingleData");

        action.setParams({
            orderNumber : successedSkus
        });

        action.setCallback(this, function(response){

            var state = response.getState();
            if(state === "SUCCESS"){
                var rtnValue = response.getReturnValue();
                var _orderWrapperList = rtnValue;
                 cmp.set('v.showSpinner',false);
                for(var j=0;j<failedSkus.length;j++) {
                     var _orderWrapper = {};
                    _orderWrapper.countOfSkus = 'Failed';
                    _orderWrapper.orderNumber = failedSkus[j];
                    _orderWrapperList.push(_orderWrapper);
                }
                console.log('_orderWrapperList2: ',_orderWrapperList);
                cmp.set('v.orderWrapper',_orderWrapperList);

                cmp.set('v.showSpinner',false);
            } else {

                cmp.set('v.showSpinner',false);
                console.log('Failed to retrieve.');
            }
        });
        $A.enqueueAction(action);
        } else {
            var _orderWrapperList = [];

            for(var j=0;j<failedSkus.length;j++) {
                 var _orderWrapper = {};
                _orderWrapper.countOfSkus = 'Failed';
                _orderWrapper.orderNumber = failedSkus[j];
                _orderWrapperList.push(_orderWrapper);
            }
            cmp.set('v.isSuccess',false);
            console.log('_orderWrapperList5: ',_orderWrapperList);
            cmp.set('v.orderWrapper',_orderWrapperList);

            cmp.set('v.showSpinner',false);
        }
    },

    handleCloseModal : function(cmp, event, helper) {
        debugger;
       var isDashboard = cmp.get('v.isDashboard');

       if(cmp.get('v.isSuccess')) {
           var urlEvent = $A.get("e.force:navigateToURL");
           if(isDashboard) {
               urlEvent.setParams({
                   "url": '/'
               });
           } else {
               urlEvent.setParams({
                   "url": '/my-orders'
               });
           }
           urlEvent.fire();
       } else {
           var urlEvent = $A.get("e.force:navigateToURL");
           urlEvent.setParams({
               "url": '/my-orders'
           });

           urlEvent.fire();
       }

  	}
})