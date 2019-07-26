/**
 * Created by ranja on 23-01-2019.
 */
({
    handleCloseModal : function(cmp,event,helper) {
         helper.goToUrl('my-orders');
    },

    navigateToOrderDetailPage : function(cmp,event,helper) {
        let orderNumber = event.currentTarget.name;
        if(orderNumber)
            helper.goToUrl('order-detail?ordernumber=' + orderNumber);
    }, 

})