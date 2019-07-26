/**
 * Created by 7Summits on 5/2/18.
 */
({

    ACCEPTED_INVENTORY_ASSIGNED: 'In Stock',

    init: function(cmp) {
        var self = this;
        debugger;


        // get url param order number
        var orderNumber = this.getUrlParamByName('ordernumber');
		console.log('orderNumber is -----'+orderNumber);
        if (orderNumber !== undefined) {
            cmp.set('v.orderNumber', orderNumber);
			//console.log('calling order details ####');
            var getSubmittedOrder = this.doCallout(cmp, 'c.getSubmittedOrder', {orderNumber: orderNumber});

            getSubmittedOrder.then(function (response) {
                if(response.orderLineList.length > 0){
                    cmp.set('v.showHeader', true);
                }
                var flag = true;
                if(response.BDC.includes('BDC')){
                      cmp.set('v.forBDC', true);
                }
                if(response.profileName != ''){
                       cmp.set('v.profile', response.profileName);
                }
                var _items = [];
                var count = 0;
                var _listOfAllSkus = [];
                var flagOfDate = true;
				var dt = new Date();
               
                
                response.orderLineList.forEach(function(item){
						//console.log('item ####'+JSON.stringify(item));
                        var BDC = cmp.get('v.forBDC');
                        var profile = cmp.get('v.profile');
                        if(item.lineitemstatus !== undefined && item.lineitemstatus === self.ACCEPTED_INVENTORY_ASSIGNED && flag){
                             cmp.set('v.canSchedulePickupDelivery', true);
                        }
                        if(item.lineitemstatus !== undefined && item.lineitemstatus === "Scheduled for Pick Up"){
                            cmp.set('v.canSchedulePickupDelivery', false);
                            cmp.set('v.canReSchedulePickupDelivery', true);
                            flag = false;
                        } 
                        if(item.lineitemstatus !== undefined && item.lineitemstatus === "Scheduled for Delivery"){
                            cmp.set('v.canSchedulePickupDelivery', false);
                            cmp.set('v.canReSchedulePickupDelivery', true);
                            flag = false;
                        }
                        if(BDC){
                            cmp.set('v.canSchedulePickupDelivery', false);
                            cmp.set('v.canReSchedulePickupDelivery', false);
                        }
						if(profile === "SSC Purchaser II" || profile === "SSC Statement Dealer Sales Rep"
						        || profile === "SSC Accounting" || profile === "SSC Sales Rep"){
						    cmp.set('v.canSchedulePickupDelivery', false);
                            cmp.set('v.canReSchedulePickupDelivery', false); 
                        }
                        if(item.lineitemstatus === 'Scheduled for Delivery' || item.lineitemstatus === 'Scheduled for Pick Up') {
                            _items.push(count);

                            var _orderSkus = {};
                            _orderSkus.productName = item.productdesc;
                            _orderSkus.sku = item.skuNumber;
                            _orderSkus.extendedPrice = item.extendedPrice;
                            _orderSkus.pickupTime = item.Fulfilment_ScheduleTime;
                            _orderSkus.unitPrice = item.sscunitprice;
                            _orderSkus.quantity = item.sscqty;
							_orderSkus.fulfillmentScheduleTime = item.Fulfilment_ScheduleTime;
                            _orderSkus.fulfillmentMethod = item.fulfillmentMethod;  
                            //console.log('item.Fulfilment_ScheduleTime: ', item.Fulfilment_ScheduleTime);                                                        
                            if(item.lineitemstatus.includes('Delivery'))
                                _orderSkus.isPickup = false;
                            else
                                _orderSkus.isPickup = true;

                            _orderSkus.unitOfMeasure = item.sscuom;
                            _listOfAllSkus.push(_orderSkus);
                        }

                    count++;
          
                });
                cmp.set('v.skus',_items);
                cmp.set('v.listOfAllSkus',_listOfAllSkus);
                /*if(response !== undefined && response.status === self.ACCEPTED_INVENTORY_ASSIGNED){
                    
                    cmp.set('v.canSchedulePickupDelivery', true);
                }*/
            }, function(){
                // handle error if needed
            });
        }

    },
    
    handleschedule: function(cmp){
        // get url param order number
        var orderNumber = this.getUrlParamByName('ordernumber');
        this.goToSchedulePickupsDeliveries(orderNumber);
    }
 

})