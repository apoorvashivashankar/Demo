/**
 * Created by 7Summits on 4/12/18.
 */
({
    init: function(cmp, evt, helper){
        helper.getOrders(cmp);
    },

    handleSelectAllOrders: function(cmp, evt, helper){
        var checked = evt.currentTarget.checked; // get checked state
        helper.setCheckedStateAllData(cmp, checked);
    },

    handleScheduleSelectedOrders: function(cmp, evt, helper){
        var rows = cmp.get('v.data');
        var selectedRows = [];

        // get all the rows that are checked
        rows.forEach(function(row){
            if(row.checked === true){
                selectedRows.push(row);
            }
        });

        console.log('handleScheduleSelectedOrders: ', selectedRows);
    }
})