/**
 * Created by presh on 05-12-2018.
 */
({
    init: function(cmp, evt, helper){
          helper.getRelatedOrderList(cmp);
    },
    searchOrderList: function(cmp, event, helper){
            var parameters = event.getParam('arguments');
            if(parameters){
                var userType = parameters.userType;
                var orderNumber = parameters.orderNumber;
                var orderListType = parameters.orderListType;
                var poNumber = parameters.poNumber;
                var jobName = parameters.jobName;
                var orderDateStart = parameters.orderDateStart;
                var orderDateEnd = parameters.orderDateEnd;
                var orderStatus = parameters.orderStatus; 
                console.log('dates in list controller '+orderDateStart+'--'+orderDateEnd+'--'+orderStatus);
                helper.searchOrderList(cmp, userType, orderListType, orderNumber, poNumber, jobName, orderDateStart, orderDateEnd, orderStatus);
            }

    },

})