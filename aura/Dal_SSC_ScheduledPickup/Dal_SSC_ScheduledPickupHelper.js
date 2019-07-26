/**
 * Created by 7Summits on 4/12/18.
 */
({

    getOrdersScheduledForPickup: function(cmp){
        var self = this;
        var listLimit = cmp.get("v.listMaximum");

        // make call to controller to get open items
        var promise = this.doListCallout(cmp, 'c.getScheduledPickups', {'listLimit' : listLimit});

        // set callbacks for callout response
        promise.then(function(response){
            self.handleGetOrdersScheduledForPickup(cmp, response);
        }, function(response){
            console.log('Dal_SSC_ScheduledPickup:getOrdersScheduledForPickup:Error:', response);
        });
    },

    handleGetOrdersScheduledForPickup: function(cmp, response){
        console.log('handleGetOrdersScheduledForPickup:', response);

        // Columns data
        cmp.set('v.columns', [
            {label: 'Order Number', fieldName: 'orderNumber', type: 'textLink', urlName: 'orderLink'},
            {label: 'Job Name', fieldName: 'jobName', type: 'text'},
            {label: 'PO Number', fieldName: 'poNumber', type: 'text'},
            {label: 'Status', fieldName: 'status', type: 'text'},
            {label: 'Order Date', fieldName: 'orderDate', type: 'date'},
            {label: 'SSC Location', fieldName: 'sscLocation', type: 'text'}
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
                    sscLocation: item.OrderPlant
                });
            });
        }

        cmp.set('v.data', rowData);
        this.initTable(cmp);
    }

})