/**
 * Created by presh on 05-12-2018.
 */
({
    getRelatedOrderList : function (cmp){
    //    debugger;
        var self = this;
        var today = new Date();
        /* var startDate = new Date(new Date().setDate(new Date().getDate() - 30));
             var dd = (startDate.getDate() < 10 ? '0' : '') + startDate.getDate();
             var MM = ((startDate.getMonth() + 1) < 10 ? '0' : '') + (startDate.getMonth() + 1);
            var tdd = (today.getDate() < 10 ? '0' : '') + today.getDate();
            var tMM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
            //cmp.set('v.orderDateStarts', startDate.getFullYear() + "-" + (startDate.getMonth() + 1) + "-" + startDate.getDate());
            cmp.set('v.orderDateStarts', startDate.getFullYear() + "-" + (MM) + "-" + dd);
            console.log('after setting '+cmp.get('v.orderDateStarts'));
            //cmp.set('v.orderDateEnds', today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + (today.getDate() +1));
            cmp.set('v.orderDateEnds', today.getFullYear() + "-" + (tMM) + "-" + (tdd));
            console.log('after setting '+cmp.get('v.orderDateEnds'));*/
        
        // set the controller action type
        var actionName = 'c.searchOpportunityRelatedOrder';
        //var listLimit = cmp.get("v.listMaximum");
        //var userType = cmp.get("v.userType");
        /*var orderDateStart = new Date(cmp.get("v.orderDateStarts"));
            var orderDateEnd = new Date(cmp.get("v.orderDateEnds"));*/
        
        var params = {opportunityId : cmp.get('v.recordId')};
        console.log('---par,m--',params);
        
        // make call to controller to get open items
        var promise = this.doListCallout(cmp, actionName, params);
        
        // set callbacks for callout response
        promise.then(function(response){
            console.log('RESPONSE: ', response);
            self.handleGetOrderListSuccess(cmp, response);
            //self.handleDataOverage(cmp, response[0].length, listLimit);
        });
        
    },
    searchOrderList: function(cmp, userType,orderListType, orderNumber, poNumber, jobName, orderDateStart, orderDateEnd, orderStatus){
    //    debugger;
        var self = this;
        
        // set the controller action type
        var actionName = 'c.geAllOrderList';
        var listLimit = cmp.get("v.listMaximum");
        
        var params = {
            
            'orderNumber': orderNumber,
            'purchaseOrder': poNumber,
            'jobName': jobName,
            'orderDateFrom': orderDateStart,
            'orderDateTo': orderDateEnd,
            'lineStatus': orderStatus,
            'opportunityId': cmp.get('v.recordId'),
            'listLimit' : listLimit
        };
        
        // make call to controller to get open items
        var promise = this.doListCallout(cmp, actionName, params);
        
        // set callbacks for callout response
        promise.then(function(response){
        //    debugger;
            console.log('-response- Order--',response);
            self.handleGetOrderListSuccess(cmp, response);
            // self.handleDataOverage(cmp, response[0].length, listLimit);
        });
        
    }, // end initOpenItems.
    
    handleDataOverage: function(cmp, recordCount, totalCount){
        var _overageLabel = '';
        if(recordCount >= totalCount){
            _overageLabel = 'There are more results than can be displayed. Please try more specific search criteria.';
        }
        cmp.set('v.pageMessage', _overageLabel);
        
    },
    handleGetOrderListSuccess: function(cmp, response) {
        
        var userType = cmp.get("v.userType");
        // Columns data
        
        if(userType == 'SSC'){
            cmp.set('v.columns', [
                {label: 'Order Number', fieldName: 'orderNumber', type: 'textLink', urlName: 'orderLink', sortable: true},
                {label: 'Purchase Order', fieldName: 'poNumber', type: 'text', sortable: true},
                {label: 'Job Name', fieldName: 'jobNumber', type: 'text', sortable: true},
                {label: 'Order Date', fieldName: 'orderDate', type: 'date', sortable: true},
                {label: 'SSC Location', fieldName: 'sscLocation', type: 'text', sortable: true},
                {label: 'Fulfillment Method', fieldName: 'fulfillmentMethod', type: 'text', sortable: true}
            ]);
        }
        var rowData = [];
        
        // make sure we have valid response data
        if(response !== undefined && Array.isArray(response)){
            
            response.forEach(function(item, index){
                
                rowData.push({
                    id: index,
                    orderNumber: item.SalesOrder,
                    orderLink: '/order-detail?ordernumber='+item.SalesOrder,
                    orderDate: new Date(item.CreatedTime) || '',
                    poNumber: item.CustomerPONo,
                    jobNumber: item.JobName,
                    sscLocation: item.SSCLocation,
                    fulfillmentMethod: item.FulfillmentMethod,
                    orderType: item.OrderType
                });
                
            });
        }
        
        // Row Data: Note 'fieldName' from the column must have a matching
        // attribute in the row data.
        cmp.set('v.data', rowData);
        
        this.initTable(cmp);
    }
    
})