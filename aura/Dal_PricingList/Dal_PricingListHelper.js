/**
 * Created by 7Summits on 4/4/18.
 */
({

    getPriceList: function(cmp){
        var self = this;
        var effectiveDate = cmp.get('v.effectiveDate');

        var params = {'customer': null, 'dateVal': effectiveDate};

        var promise = this.doListCallout(cmp, 'c.getPriceRecordsForCustomerByDate', params);

        promise.then(function(response){
            self.handleGetPriceRecordsSuccess(cmp, response);
        });
    }, // end initOpenItems

    handleGetPriceRecordsSuccess: function(cmp, response) {
        var effectiveDate = cmp.get('v.effectiveDate');

        cmp.set('v.columns', [
            {label: 'Special Pricing', fieldName: 'PriceRecordCode__c', type: 'textLink', urlName: 'promotionLink', sortable: true},
            {label: 'Special Pricing Name', fieldName: 'PriceRecordDescription__c', type: 'text', sortable: true},
            {label: 'Start Date', fieldName: 'ValidFrom__c', type: 'date', sortable: true},
            {label: 'End Date', fieldName: 'ValidTo__c', type: 'date', sortable: true},
            {label: '', fieldName: 'promotionDetailLink', type: 'textLink', urlName: 'promotionLink'}
        ]);

        var rowData = [];

        // make sure we have valid response data
        if(response !== undefined && Array.isArray(response)){

            response.forEach(function(item, index){
                rowData.push({
                    id: index,
                    PriceRecordCode__c: item.PriceRecordCode__c,
                    PriceRecordDescription__c: item.PriceRecordDescription__c,
                    ValidFrom__c: new Date(item.ValidFrom__c) || '',
                    ValidTo__c: new Date(item.ValidTo__c) || '',
                    promotionDetailLink: 'View Details',
                    promotionLink: '/pricing-detail?PriceRecordCode__c=' + encodeURIComponent(item.PriceRecordCode__c) + '&effectiveDate=' + encodeURIComponent(effectiveDate)
                });
            });
        }

        // Row Data: Note 'fieldName' from the column must have a matching
        // attribute in the row data.
        cmp.set('v.data', rowData);

        //cmp.set('v.estimatedShipDate', effectiveDate);
        this.initTable(cmp);
    }
})