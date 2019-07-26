/**
 * Created by 7Summits on 3/1/18.
 */
({

    init: function(cmp, evt, helper){
        helper.getOrdersToBeScheduled(cmp);
    },

    handleSelectAllOrders: function(cmp, evt, helper){
        var checked = evt.currentTarget.checked; // get checked state
        helper.setCheckedStateAllData(cmp, checked);
    },

    handleScheduleSelectedOrders: function(cmp, evt, helper){
        var rows = cmp.get('v.data');
        var selectedRows = [];

        // get all the rows that are checked
        var orderNumbers = [];
        rows.forEach(function(row){
            if(row.checked === true){
                orderNumbers.push(row.orderNumber);
            }
        });

        if(orderNumbers.length > 0){
            helper.goToSchedulePickupsDeliveriesWithMultiple(orderNumbers.join(','));
        }
    },

    handleScheduleSelectedOrdersForMultiple: function(cmp, evt, helper){
            var rows = cmp.get('v.data');
            var selectedRows = [];

            // get all the rows that are checked
            var orderNumbers = [];
            rows.forEach(function(row){
                if(row.checked === true){
                    orderNumbers.push(row.orderNumber);
                }
            });


            if(orderNumbers.length > 0){
                helper.goToSchedulePickupsDeliveries(orderNumbers.join(','));
            }

        }

 
})