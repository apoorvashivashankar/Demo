/**
 * Created by 7Summits on 4/24/18.
 */
({

    init: function(cmp, evt, helper){
        debugger;
        helper.initStore(cmp);

        var store = cmp.get('v.store');

        var pageUrl = window.location.href;
        var hashIndex = pageUrl.lastIndexOf('#');
        if(hashIndex) {

        var selectedProductType = pageUrl.substring(hashIndex+1,pageUrl.length);
        var flag1 = true;
        if(selectedProductType === 'reschedule' ||   selectedProductType === 'Reschedule') {
            cmp.set("v.isReschedule",true);
            cmp.set("v.isMultiple",true);
            flag1 = false;
        } else {
            cmp.set("v.isReschedule",false);
            cmp.set("v.isMultiple",false);
        }

        if(selectedProductType == 'multiple' ) {
            cmp.set("v.isReschedule",true);
            cmp.set('v.isMultiple',true);
            cmp.set('v.isMultipleHeader',true);
        } else {
            if(flag1){
             cmp.set("v.isReschedule",false);
             cmp.set('v.isMultiple',false);
              cmp.set('v.isMultipleHeader',false);
            }
        }


        if(selectedProductType == 'multiple') {
            var listOfOrderNumber = cmp.get('v.listOfOrderNumber');
            var totalOrders = listOfOrderNumber.length;
            var _orderList = [];
            if(listOfOrderNumber && listOfOrderNumber.length>0) {
                for(var i=0;i<totalOrders;i++) {
                    _orderList.push(listOfOrderNumber[i]);
                }
            }
            if(_orderList){

            
            console.log('totalOrders: ',totalOrders);
            console.log('orderNumbers: ',_orderList);
            cmp.set('v.totalOrders',totalOrders);
            cmp.set('v.orderNumbers',_orderList);
            }
        }
        } else {
             cmp.set("v.isReschedule",false);
            cmp.set("v.isMultiple",false);
            cmp.set('v.isMultipleHeader',false);
        }


    },

    handleActive: function(cmp, evt){
        debugger;
        var store = cmp.get('v.store');
        var tab = evt.getSource();
        var activeTabId = tab.get('v.id');
        store.setActiveTab(activeTabId);

        var appEvent = $A.get("e.c:Dal_SSC_HandleTabChangeEvent");
        console.log('event: ',appEvent);
        appEvent.fire();

    }

})