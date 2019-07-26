/**
 * Created by presh on 22-11-2018.
 */
({
     init: function(cmp, evt, helper){
        helper.getLeadList(cmp);
    },

    searchOpportunityList: function(cmp, event, helper){
            var parameters = event.getParam('arguments');
            if(parameters){

                var name = parameters.name;
                var account = parameters.account;
                var oppDateStart = parameters.oppDateStart;
                var oppDateEnd = parameters.oppDateEnd;
                var oppStage = parameters.oppStage;
                console.log('dates in list controller '+oppDateStart+'--'+oppDateStart+'--'+oppDateEnd);
                helper.searchOpportunityList(cmp, name, account, oppDateStart, oppDateEnd, oppStage);
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
    },

    handleRelateToOrder : function(cmp, evt, helper){
        var rows = cmp.get('v.data');
        var selectedRows = [];
        console.log('Row Size: ', rows);
        // get all the rows that are checked
        var oppNumbers = [];
        rows.forEach(function(row){
            if(row.checked === true){
                var oppLink = row.oppLink;
                var lastIndex = oppLink.lastIndexOf('/');
                var selectedProductType = oppLink.substring(lastIndex+1,oppLink.length);
                oppNumbers.push(selectedProductType);
            }
        });

        console.log('oppNumbers: ', oppNumbers);
        if(oppNumbers.length > 0){
            helper.goToAllOrderPage(oppNumbers.join(','));
        }

    }

})