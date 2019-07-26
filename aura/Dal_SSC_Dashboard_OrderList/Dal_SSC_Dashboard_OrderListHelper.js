/**
 * Created by 7Summits on 4/12/18.
 */
({
    getOrders: function(cmp){
        var self = this;

        // set the controller action type
        var actionName = 'c.getOrdersToBeScheduled';

        var params = {};
        // make call to controller to get open items
        var promise = this.doListCallout(cmp, actionName, params);

        // set callbacks for callout response
        promise.then(function(response){
            cmp.set('v.isLoading', false);
            self.handleGetOrders(cmp, response);
        });

    },

    handleScheduleOrders: function(rows){
        console.log('handleScheduleOrders:::', rows);
    },

    handleGetOrders: function(cmp, response){

        // Columns data
        cmp.set('v.columns', [
            {type: 'checkbox'},
            {label: 'Order Number', fieldName: 'orderNumber', type: 'textLink', urlName: 'orderLink'},
            {label: 'Job Name', fieldName: 'jobName', type: 'text'},
            {label: 'PO Number', fieldName: 'poNumber', type: 'text'},
            {label: 'Status', fieldName: 'status', type: 'text'},
            {label: 'Order Date', fieldName: 'orderDate', type: 'date'},
            {label: 'SSC Location', fieldName: 'sscLocation', type: 'text'}
        ]);

        var rowData = [];
        // Row Data: Note 'fieldName' from the column must have a matching
        // attribute in the row data. Example if the column has a 'orderNumber' fieldName
        // there must be a data attribute 'orderNumber' in this data set.

        // make sure we have valid response data
        if(response !== undefined && Array.isArray(response)){

            response.forEach(function(item, index){

                console.log(item);

                rowData.push({
                    id: index,
                    orderNumber: item.SalesOrder__c,
                    orderLink: '/order-detail?ordernumber='+item.SalesOrder__c,
                    jobName: item.JobName__c,
                    poNumber: item.CustomerPONo__c,
                    status: item.Status__c,
                    orderDate: new Date(item.CreatedTime__c) || '',
                    sscLocation: item.OrderPlant__c
                });

            });
        }

        // Row Data: Note 'fieldName' from the column must have a matching
        // attribute in the row data.
        cmp.set('v.data', rowData);

        this.initTable(cmp);
    }
})