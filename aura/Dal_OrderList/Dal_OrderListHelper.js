/**
 * Created by 7Summits on 4/9/18.
 */
({
    getOrderList: function(cmp){
         var self = this;
            var today = new Date();
            var startDate = new Date(new Date().setDate(new Date().getDate() - 30));
    		 var dd = (startDate.getDate() < 10 ? '0' : '') + startDate.getDate();
        		var MM = ((startDate.getMonth() + 1) < 10 ? '0' : '') + (startDate.getMonth() + 1);
            var tdd = (today.getDate() < 10 ? '0' : '') + today.getDate();
            var tMM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
            //cmp.set('v.orderDateStarts', startDate.getFullYear() + "-" + (startDate.getMonth() + 1) + "-" + startDate.getDate());
            cmp.set('v.orderDateStarts', startDate.getFullYear() + "-" + (MM) + "-" + dd);
            console.log('after setting '+cmp.get('v.orderDateStarts'));
            //cmp.set('v.orderDateEnds', today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + (today.getDate() +1));
            cmp.set('v.orderDateEnds', today.getFullYear() + "-" + (tMM) + "-" + (tdd));
         	console.log('after setting '+cmp.get('v.orderDateEnds'));

           // set the controller action type
            var actionName = 'c.searchOpenOrders';

            var orderListType = cmp.get("v.orderListType");
            if(orderListType == 'Orders List'){
              actionName = 'c.searchOpenOrders';
            } else if(orderListType == 'History List'){
              actionName = 'c.searchOrderHistory';
            } else if(orderListType == 'Completed Orders List'){
              actionName = 'c.searchCompletedOrders';
            } else if(orderListType == 'Pickup Orders List'){
              actionName = 'c.searchOrdersForPickup';
            } else if(orderListType == 'All Orders List'){
              actionName = 'c.searchAllOrders';
            }

            var listLimit = cmp.get("v.listMaximum");

            var userType = cmp.get("v.userType");
            var orderDateStart = new Date(cmp.get("v.orderDateStarts"));
            var orderDateEnd = new Date(cmp.get("v.orderDateEnds"));

            var params = {
                'userType': userType,
               'orderNumber': undefined,
               'purchaseOrder': undefined,
               'jobName': undefined,
               'orderDateFrom': orderDateStart,
               'orderDateTo': orderDateEnd,
               'lineStatus': undefined,
               'listLimit' : listLimit
            };

            // make call to controller to get open items
            var promise = this.doListCallout(cmp, actionName, params);

            // set callbacks for callout response
            promise.then(function(response){
                //debugger;
                console.log('RESPONSE: ', response);
                self.handleGetOrderListSuccess(cmp, response[0]);
                self.handleDataOverage(cmp, response[0].length, listLimit);
            });

    },
    searchOrderList: function(cmp, userType, orderListType, orderNumber, poNumber, jobName, orderDateStart, orderDateEnd, orderStatus){
       // debugger;
       var self = this;

       // set the controller action type
       var actionName = 'c.searchOpenOrders';
       if(orderListType == 'Orders List'){
           actionName = 'c.searchOpenOrders';
       } else if(orderListType == 'History List'){
           actionName = 'c.searchOrderHistory';
       } else if(orderListType == 'Completed Orders List'){
           actionName = 'c.searchCompletedOrders';
       } else if(orderListType == 'Pickup Orders List'){
           actionName = 'c.searchOrdersForPickup';
       } else if(orderListType == 'All Orders List'){
           actionName = 'c.searchAllOrders';
       }
        var listLimit = cmp.get("v.listMaximum");

       var params = {
           'userType': userType,
           'orderNumber': orderNumber,
           'purchaseOrder': poNumber,
           'jobName': jobName,
           'orderDateFrom': orderDateStart,
           'orderDateTo': orderDateEnd,
           'lineStatus': orderStatus,
           'listLimit' : listLimit
       };

       // make call to controller to get open items
       var promise = this.doListCallout(cmp, actionName, params);

       // set callbacks for callout response
       promise.then(function(response){
          // debugger;
           self.handleGetOrderListSuccess(cmp, response[0]);
           self.handleDataOverage(cmp, response[0].length, listLimit);
       });

    }, // end initOpenItems

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
            if(cmp.get('v.listOfOppTORelate').length){
                cmp.set('v.columns', [
                    {type: 'checkbox'},
                    {label: 'Order Number', fieldName: 'orderNumber', type: 'textLink', urlName: 'orderLink', sortable: true},
                    {label: 'Purchase Order', fieldName: 'poNumber', type: 'text', sortable: true},
                    {label: 'Job Name', fieldName: 'jobNumber', type: 'text', sortable: true},
                    {label: 'Order Date', fieldName: 'orderDate', type: 'date', sortable: true},
                    {label: 'SSC Location', fieldName: 'sscLocation', type: 'text', sortable: true},
                    {label: 'Fulfillment Method', fieldName: 'fulfillmentMethod', type: 'text', sortable: true}
                ]);
            } else {
                cmp.set('v.columns', [
                    {label: 'Order Number', fieldName: 'orderNumber', type: 'textLink', urlName: 'orderLink', sortable: true},
                    {label: 'Purchase Order', fieldName: 'poNumber', type: 'text', sortable: true},
                    {label: 'Job Name', fieldName: 'jobNumber', type: 'text', sortable: true},
                    {label: 'Order Date', fieldName: 'orderDate', type: 'date', sortable: true},
                    {label: 'SSC Location', fieldName: 'sscLocation', type: 'text', sortable: true},
                    {label: 'Fulfillment Method', fieldName: 'fulfillmentMethod', type: 'text', sortable: true}
                ]);
            }

            var orderListType = cmp.get("v.orderListType");
            if(orderListType == 'Pickup Orders List'){
                cmp.set('v.columns', [
                    {type: 'checkbox'},
                    {label: 'Order Number', fieldName: 'orderNumber', type: 'textLink', urlName: 'orderLink', sortable: true},
                    {label: 'Purchase Order', fieldName: 'poNumber', type: 'text', sortable: true},
                    {label: 'Job Name', fieldName: 'jobNumber', type: 'text', sortable: true},
                    {label: 'Order Date', fieldName: 'orderDate', type: 'date', sortable: true},
                    {label: 'SSC Location', fieldName: 'sscLocation', type: 'text', sortable: true},
                    {label: 'Fulfillment Method', fieldName: 'fulfillmentMethod', type: 'text', sortable: true}
                ]);
            }
        } else {
            var orderListType = cmp.get("v.orderListType");
            if (orderListType == 'Orders List' || orderListType == 'History List') {
                cmp.set('v.columns', [
                   {label: 'Order Number', fieldName: 'orderNumber', type: 'textLink', urlName: 'orderLink', sortable: true},
                    {label: 'Purchase Order', fieldName: 'poNumber', type: 'text', sortable: true},
                    {label: 'Job Name', fieldName: 'jobNumber', type: 'text', sortable: true},
                    {label: 'Order Date', fieldName: 'orderDate', type: 'date', sortable: true},
                    {label: 'Order Type', fieldName: 'orderType', type: 'text', sortable: true}
                ]);
            } else {
                cmp.set('v.columns', [
                    {label: 'Order Number', fieldName: 'orderNumber', type: 'textLink', urlName: 'orderLink', sortable: true},
                    {label: 'Purchase Order', fieldName: 'poNumber', type: 'text', sortable: true},
                    {label: 'Job Name', fieldName: 'jobNumber', type: 'text', sortable: true},
                    {label: 'Order Date', fieldName: 'orderDate', type: 'date', sortable: true}
                ]);
            }

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