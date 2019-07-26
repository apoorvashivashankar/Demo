/**
 * Created by 7Summits on 5/24/18.
 */
({

    init: function(cmp, evt, helper){
        debugger;
        var orderNumbers = helper.getUrlParamByName('orderIds');
        var orderNumbersList = (orderNumbers !== null) ? orderNumbers.split(',') : [];

        //console.log('ORDER TYPE: ',helper.getUrlParamByName('orderType'));
        var pageUrl = window.location.href;
        var hashIndex = pageUrl.lastIndexOf('#');
        var selectedProductType = pageUrl.substring(hashIndex+1,pageUrl.length);

        if(selectedProductType == 'reschedule') {
            cmp.set('v.title',"Reschedule Appointment");
        } else {
            cmp.set('v.title',"Schedule Pick Ups &amp; Deliveries"); 
        }

        if(orderNumbersList.length > 0){
            var maxOrderNumbersToShow = cmp.get('v.maxOrderNumbersToShow');

            // set the total number of orders
            cmp.set('v.totalOrderNumbers', orderNumbersList.length);

            // create list of order numbers
            var orderNumbersToDisplay = [];
            var orderNumbersToDisplayLength = (orderNumbersList.length <= maxOrderNumbersToShow) ? orderNumbersList.length : maxOrderNumbersToShow;

            for(var x=0; x < orderNumbersToDisplayLength; x++){
                orderNumbersToDisplay.push(orderNumbersList[x]);
            }

            cmp.set('v.totalOrderNumbers', orderNumbersList.length);
            cmp.set('v.orderNumbersToDisplay', orderNumbersToDisplay.join(','));
            cmp.set('v.hasMoreOrders', (orderNumbersList.length > maxOrderNumbersToShow));
            cmp.set('v.moreOrdersTotal', (orderNumbersList.length - maxOrderNumbersToShow));
        }

    }

})