/**
 * Created by 7Summits on 3/23/18.
 */
({
    /**
     * Available List types
     */
    listTypes: {
        'Orders List': 'ordersList',
        'History List': 'historyList'
    },

    getOrderList: function(cmp){
        var self = this;

        // get the List parameter set in the component
        var listType = cmp.get('v.listType');

        var communityTypeParam = cmp.get('v.communityType');
        var param = {'userType': communityTypeParam};
        // make sure a valid list type was selected
        if(this.listTypes[listType] !== undefined){

            // set the controller action type
            var actionName = '';
            switch(this.listTypes[listType]) {
                case 'ordersList':
                    actionName = 'c.getOpenOrder';
                    cmp.set('v.noDataMsg', 'No open orders');
                    break;
                case 'historyList':
                    actionName = 'c.getOrderHistory';
                    cmp.set('v.noDataMsg', 'No order history');
                    break;
            }
            // make call to controller to get order list
            var promise = this.doCallout(cmp, actionName, param);

            // set callbacks for callout response
            promise.then(function(response){
                console.log(response);
                self.handleGetOrdersSuccess(cmp, response);
            });

        } else {
            console.log('invalid');
        }

    },
    handleGetOrdersSuccess: function (cmp, response, helper) {

        cmp.set('v.columns', [
            {label: 'Order Number', fieldName: 'orderNumber', type: 'text'},
            {label: 'Purchase Order', fieldName: 'purchaseOrder', type: 'text'},
            {label: 'Job Name', fieldName: 'jobName', type: 'text'},
            {label: 'Order Date', fieldName: 'orderDate', type: 'date'}
        ]);

        var rowData = [];

        // make sure we have valid response data
        if(response !== undefined && Array.isArray(response)){

            response.forEach(function(item, index){

                console.log(item);

                rowData.push({
                    orderNumber: item.SalesOrder__c || '',
                    purchaseOrder: item.CustomerPONo__c || '',
                    jobName: item.JobName__c || '',
                   orderDate: new Date(item.CreatedTime__c) || ''
                });

            });
        }
        cmp.set('v.data', rowData);
        this.initTable(cmp);
    },
    initTable: function(cmp){
        var self = this;

        // prepare the column to data mapping
        //var filteredRows = cmp.get('v.filteredRows');
        var columns = cmp.get('v.columns');
        var data = cmp.get('v.data');

        // iterate all the data rows
        data.forEach(function(row){
            row.columns = [];

            // iterate all the columns looking for data point matches
            columns.forEach(function(column){

                row.columns.push(self.helpers.createViewRow(row[column.fieldName], column.fieldName,  column.label, column.type, column.actions, column.menuAlignment, row[column.urlName]));
            });

            //viewDataRows.push(row);
        });

        cmp.set('v.data', data);
    },
    helpers : {

        createViewRow: function(value, fieldName, label, type, actions, menuAlignment, url){
            var data = {
                value: value || '',
                fieldName: fieldName || '',
                label: label || '',
                type: type || '',
                url: url || ''
            };

            if(type === 'action'){
                data.actions = actions || [];
                data.menuAlignment = menuAlignment || '';
            }

            return data;
        } // end createViewRow
    }
})