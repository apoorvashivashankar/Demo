/**
 * Created by 7Summits on 5/2/18.
 */
({

    init: function(cmp, evt, helper){
        helper.init(cmp);
    },

    handlePrintClick: function(){
        window.print();
    },
     handleLinkClick : function(cmp, evt, helper){
        var _link = evt.getSource().get('v.value');
        console.log(_link);
        $A.get("e.force:navigateToURL").setParams({
            "url": _link
        }).fire();
    },
    
    handlePickupScheduleClick: function(cmp, evt, helper){
		helper.handleschedule(cmp);
    },

    handlePickupScheduleCancelClick: function(cmp, evt, helper){
        debugger;

        var _listOfAllSkus = cmp.get('v.listOfAllSkus');
        //console.log('OrderNumber: ' , cmp.get('v.orderNumber'));
        helper.openModal(cmp, 'c:Dal_SSC_PickupCancellation', {listOfAllSkus : _listOfAllSkus, isPickup : _listOfAllSkus[0].isPickup,
                        orderNumber : cmp.get('v.orderNumber'), indexToCancel : 'ALL'}, true, 'dal-modal_small');
    }, 

    handlePickupScheduleRescheduleClick : function(cmp, evt, helper){
        debugger;
        var skus = cmp.get('v.skus');
        var _skus = '';
        for(var i=0;i<skus.length;i++) {
            if((i+1)!= (skus.length)) {
                _skus = _skus + '' +  skus[i] + '%2C';
            }else
                _skus = _skus + '' + skus[i];
            //console.log('_skus: ',_skus);
        }
        var _orderNumber = evt.getSource().get('v.value');
        
        
        //DATE PASS IN URL
        var selectedSkuNumber = 0;
        var products = cmp.get("v.listOfAllSkus");
        var _futureDate = products[selectedSkuNumber].fulfillmentScheduleTime;
        var _fulfillmentMethod = products[selectedSkuNumber].fulfillmentMethod;
        var _futureDateStamp = '';
        if(_fulfillmentMethod == 'SHP'){ 
             _futureDateStamp = _futureDate.split(" ")[0].split("-")[0]+_futureDate.split(" ")[0].split("-")[1]+_futureDate.split(" ")[0].split("-")[2];
        }else if(_fulfillmentMethod == 'PICK'){
            _futureDateStamp = _futureDate.split(" ")[0].split("-")[0]+_futureDate.split(" ")[0].split("-")[1]+_futureDate.split(" ")[0].split("-")[2];
        }
        
        //console.log('_futureDate: ',_futureDate);
        
        var _link = "/schedule-pickups-deliveries?orderIds="+_orderNumber + "&sku="+_skus+ "&futuredate=" + _futureDateStamp  + "#reschedule" ;
        
        
        
        //var _link = "/schedule-pickups-deliveries?orderIds="+ _orderNumber + "&sku="+ _skus + "#reschedule" ;
        //console.log(_link);
        $A.get("e.force:navigateToURL").setParams({
            "url": _link
       }).fire();
    }


})