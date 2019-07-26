/**
 * Created by 7Summits on 2/28/18.
 */
({
    getPayments: function(cmp){
        var self = this;

        var listLimit = cmp.get("v.listMaximum");

        // make call to controller to get open items
        var promise = this.doListCallout(cmp, 'c.getPaymentSummary', {'listLimit' : listLimit});

        // set callbacks for callout response
        promise.then(function(response){
            self.handleGetPaymentsSuccess(cmp, response);
        }, function(response){
            console.log('Dal_AccountPayments:getPayments:Error', response);
        });
        
    },

    handleGetPaymentsSuccess: function(cmp, response){

        cmp.set('v.columns', [
            {label: 'Amount', fieldName: 'amountDue', type: 'currency', sortable: true},
            {label: 'Payment Date', fieldName: 'paymentDate', type: 'date', sortable: true},
            {label: 'Payment No', fieldName: 'paymentNumber', type: 'text'}
        ]);

        // Row Data
        var dataList = [];

        if(response.results !== undefined && Array.isArray(response.results)) {
            response.results.forEach(function(result, index){

                // create a moment object using the YYYYMMDD format that the date is returned in
                dataList.push({
                    id: index,
                    amountDue: result.GrossAmount__c,
                    paymentDate: result.DueDate__c,
                    paymentNumber: result.ReferenceNo__c
                });
            }); // end for each
        } // end if

        //  set the data of the list
        cmp.set('v.data', dataList);

        this.initTable(cmp);
    }

})