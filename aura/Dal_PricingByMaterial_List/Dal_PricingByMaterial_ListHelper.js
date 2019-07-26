/**
 * Created by 7Summits on 4/24/18.
 */
({
    getMaterialList: function(cmp, sku, description){
        var self = this;

        // set the controller action type
        var actionName = 'c.getAllPriceRecord';
        var sku = sku;
        var description = description;
        if(sku != null && sku != undefined && sku != ''){
            actionName = 'c.getPriceRecordsForCustomerByDate';
        }

        //var params = {'customer': undefined, 'dateVal': searchDate};
        // make call to controller to get open items
        var promise = this.doListCallout(cmp, actionName, params);

        // set callbacks for callout response
        promise.then(function(response){
            self.handleGetPriceRecordsSuccess(cmp, response);
        });

    }, // end initOpenItems

    handleGetPriceRecordsSuccess: function(cmp, response) {

        cmp.set('v.columns', [
            {label: 'SKU #', fieldName: 'sku', type: 'text', sortable: true},
            {label: 'DESCRIPTION', fieldName: 'description', type: 'text', sortable: true},
            {label: 'PRICE', fieldName: 'price', type: 'currency',typeAttributes: { currencyCode: 'USD'}, sortable: true},
            {label: 'SOURCE OF SUPPLY', fieldName: 'sourceOfSupply', type: 'text', sortable: true},
            {label: 'Start Date', fieldName: 'ValidFrom__c', type: 'date', sortable: true},
            {label: 'End Date', fieldName: 'ValidTo__c', type: 'date', sortable: true},
        ]);

        var rowData = [];

        // make sure we have valid response data
        if(response !== undefined && Array.isArray(response)){

            response.forEach(function(item, index){

                console.log(item);

                rowData.push({
                    id: index,
                    sku: item.sku,
                    description: item.PriceRecordDescription__c,
                    price: item.price + ' /SF',
                    sourceOfSupply: item.supplyplant,
                    ValidFrom__c: new Date(item.ValidFrom__c) || '',
                    ValidTo__c: new Date(item.ValidTo__c) || ''
                });

            });
        }

        // Row Data: Note 'fieldName' from the column must have a matching
        // attribute in the row data.
        cmp.set('v.data', rowData);

        this.initTable(cmp);
    }
})