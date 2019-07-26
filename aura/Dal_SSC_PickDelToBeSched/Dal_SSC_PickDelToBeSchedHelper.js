/**
 * Created by 7Summits on 3/1/18.
 */
({

    getOrdersToBeScheduled: function(cmp){
        var self = this;
        var listLimit = cmp.get("v.listMaximum");

        // make call to controller to get open items
        var promise = this.doListCallout(cmp, 'c.getOrdersToBeScheduled', {'listLimit' : listLimit});

        // set callbacks for callout response
        promise.then(function(response){
            self.handleGetOrders(cmp, response);
        }, function(response){
            console.log('Dal_SSC_PickDelToBeSched:handleGetOrders:Error:', response);
        });

    },

    handleGetOrders: function(cmp, response){
        console.log('handleGetOrders:', response);

        // Columns data
        cmp.set('v.columns', [
            {type: 'checkbox'},
            {label: 'Order Number', fieldName: 'orderNumber', type: 'textLink', urlName: 'orderLink'},
            {label: 'Job Name', fieldName: 'jobName', type: 'text'},
            {label: 'PO Number', fieldName: 'poNumber', type: 'text'},
            {label: 'Status', fieldName: 'status', type: 'text'},
            {label: 'Order Date', fieldName: 'orderDate', type: 'date'},
            {label: 'SSC Location', fieldName: 'sscLocation', type: 'text'},
            {label: 'Fulfillment Method', fieldName: 'fulfillmentMethod', type: 'text'}
        ]);

        var rowData = [];

        // make sure we have valid response data
        if(response !== undefined && Array.isArray(response)){
            response.forEach(function(item, index){
                rowData.push({
                    id: index,
                    orderNumber: item.SalesOrder,
                    orderLink: '/order-detail?ordernumber=' + item.SalesOrder,
                    jobName: item.JobName,
                    poNumber: item.CustomerPONo,
                    status: item.Status,
                    orderDate: new Date(item.CreatedTime) || '',
                    sscLocation: item.SSCLocation,
                    fulfillmentMethod: item.FulfillmentMethod
                });
            });
        }

        cmp.set('v.data', rowData);
        this.initTable(cmp);
    },

    //TODO Build out handleSelectAllOrders
    handleScheduleOrders: function(rows){
        console.log('handleScheduleOrders:', rows);
    }

})