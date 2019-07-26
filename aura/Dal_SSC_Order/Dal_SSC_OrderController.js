/**
 * Created by 7Summits on 4/13/18.
 */
({
    init: function(cmp, evt, helper){
        helper.init(cmp);
    },

    handleBack: function(cmp){
        var store = cmp.get('v.store');
        store.previousStep();
    },

    handleBackToSku: function(cmp){
        var store = cmp.get('v.store');
        store.goToStep(1);
    },

    handleRemoveProduct: function(cmp){
        var store = cmp.get('v.store');
        store.removeProductByCartId(0);
    },
    handleRescheduleClick: function(cmp,event,helper){
        debugger;
       // var _orderNumber = evt.getSource().get('v.value');
        var selectedSkuNumber = event.currentTarget.name;
        var _orderNumber = cmp.get("v.orderInfo").orderNumber;
        //console.log('selectedSkuNumber: ',selectedSkuNumber);

        var products = cmp.get("v.products");
        var _futureDate = products[selectedSkuNumber].fulfillmentScheduleTime;
        var _fulfillmentMethod = products[selectedSkuNumber].fulfillmentMethod;
        var _futureDateStamp = '';
        var _rescheduleType;
        if(products[selectedSkuNumber].lineItemStatus == 'Scheduled for Delivery'){
            _rescheduleType = 'deliverAll';
        }
        if(products[selectedSkuNumber].lineItemStatus == 'Scheduled for Pick Up'){
            _rescheduleType = 'pickupAll';
        }
        if(_fulfillmentMethod == 'SHP'){
            _futureDateStamp = _futureDate.split(" ")[0].split("/")[2]+_futureDate.split(" ")[0].split("/")[0]+_futureDate.split(" ")[0].split("/")[1];
        }else if(_fulfillmentMethod == 'PICK'){
            _futureDateStamp = _futureDate.split(" ")[0].split("-")[0]+_futureDate.split(" ")[0].split("-")[1]+_futureDate.split(" ")[0].split("-")[2];
        }
        
        //console.log('_futureDate: ',_futureDate);

        var _link = "/schedule-pickups-deliveries?orderIds="+_orderNumber + "&sku="+selectedSkuNumber+ "&futuredate=" + _futureDateStamp + "&scheduleType="+ _rescheduleType + "#reschedule" ;
        //console.log(_link);
        $A.get("e.force:navigateToURL").setParams({
            "url": _link
        }).fire();

    },
    handleCancelClick: function(cmp,event,helper){
        //debugger;

        var indexOfSelectedProduct = event.currentTarget.name;
        var orderInfo = cmp.get('v.orderInfo');
        var products = cmp.get("v.products");
        var selectedProduct = products[indexOfSelectedProduct];
        var _listOfAllSkus = [];
        var _orderSkus = {};

        //console.log('productInfo: ', JSON.stringify(products));
        _orderSkus.productName = selectedProduct.productName;
        _orderSkus.sku = selectedProduct.sku;
        _orderSkus.extendedPrice = selectedProduct.qtyPrice;
        _orderSkus.pickupTime = selectedProduct.fulfillmentScheduleTime;
        _orderSkus.unitPrice = selectedProduct.sscunitprice;
        _orderSkus.quantity = selectedProduct.sscqty;
        if(selectedProduct.lineItemStatus.includes('Delivery'))
            _orderSkus.isPickup = false;
        else
            _orderSkus.isPickup = true;
        _orderSkus.unitOfMeasure = selectedProduct.sscuom;
        _listOfAllSkus.push(_orderSkus);

        //console.log('indexOfSelectedProduct: ',indexOfSelectedProduct); 
        //console.log("orderNumber-->",orderInfo.orderNumber);

        helper.openModal(cmp, 'c:Dal_SSC_PickupCancellation', {listOfAllSkus : _listOfAllSkus, isPickup : _orderSkus.isPickup,
                        orderNumber : orderInfo.orderNumber, indexToCancel : indexOfSelectedProduct}, true, 'dal-modal_small');
//        helper.openModal(cmp, 'c:Dal_SSC_PickupCancellation', {productName:selectedProduct.productName, sku : selectedProduct.sku,
//                        extendedPrice : selectedProduct.qtyPrice, quantity:selectedProduct.sscqty, unitPrice:selectedProduct.sscunitprice,
//                        pickupTime:selectedProduct.fulfillmentScheduleTime, unitOfMeasure : selectedProduct.unitOfMeasureSelected},
//                        true, 'dal-modal_small');
    }

})