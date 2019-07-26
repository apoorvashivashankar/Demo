/**
 * Created by presh on 21-11-2018.
 */
({
    init: function(cmp, evt, helper){
        helper.getLeadList(cmp);
    },

    searchLeadList: function(cmp, event, helper){
            var parameters = event.getParam('arguments');
            if(parameters){

                var firstname = parameters.firstname;
                var lastname = parameters.lastname;
                var leadSource = parameters.leadSource;
                var leadScore = parameters.leadScore;
                var leadDateStart = parameters.leadDateStart;
                var leadDateEnd = parameters.leadDateEnd;
                var leadStatus = parameters.leadStatus;
                console.log('dates in list controller '+leadDateStart+'--'+leadDateEnd+'--'+leadStatus);
                helper.searchLeadList(cmp, firstname, lastname, leadSource,leadScore, leadDateStart, leadDateEnd, leadStatus);
            }

    },

    handleSelectAllLeads: function(cmp, evt, helper){
        var checked = evt.currentTarget.checked; // get checked state
        helper.setCheckedStateAllData(cmp, checked);
    },

    handleScheduleSelectedLeads: function(cmp, evt, helper){
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