/**
 * Created by 7Summits on 4/9/18.
 */
({
    init: function(cmp, evt, helper){
        helper.getOrderList(cmp);
        //debugger;
        var pageUrl = window.location.href;
        var hashIndex = pageUrl.lastIndexOf('#');
        if(hashIndex != (-1)) {
            var selectedProductType = pageUrl.substring(hashIndex+1,pageUrl.length);
            var oppNumbersList = [];
            if(selectedProductType === 'relateOpportunity') {
                var oppNumbers = helper.getUrlParamByName('oppIds');
                var oppNumbersList =  oppNumbers.split(',') || [];
                
                console.log('oppNumbersList: ',oppNumbersList);
                cmp.set('v.listOfOppTORelate',oppNumbersList);
            } 
        }
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
    
    handleSelectAllOrders: function(cmp, evt, helper){
        var checked = evt.currentTarget.checked; // get checked state
        helper.setCheckedStateAllData(cmp, checked);
    },
    
    /*
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
            helper.goToSchedulePickupsDeliveries(orderNumbers.join(','));
        }
        
    },
    */
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

    },

    
    handleRelateToOrderSubmit : function(cmp, evt, helper){
        var rows = cmp.get('v.data');
        var selectedRows = [];

        // get all the rows that are checked
        var orderNumbers = [];
        rows.forEach(function(row){
            if(row.checked === true){
                orderNumbers.push(row.orderNumber);
                console.log('row: ',row);
            }
        });

        console.log('orderNumbers Submit: ',orderNumbers);
        
        var listOfOppTORelate = cmp.get('v.listOfOppTORelate');
        if(listOfOppTORelate!= null  && listOfOppTORelate.length > 0 && orderNumbers!=null && orderNumbers.length > 0) {
            
            var action = cmp.get("c.mapOppToOrders");
            action.setParams({listOfOppIds : listOfOppTORelate, lstOforderIds : orderNumbers });
            
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") { 
                    
                    
                    helper.openModal(cmp,'c:Dal_SSC_LM_RelateToOrderModal', {}, true,'dal-modal_small');
                    
                } else {
                    console.log('Error while relating to order.');  
                }
            }); 
            $A.enqueueAction(action);
        }
    }
})