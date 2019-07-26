/**
 * Created by 7Summits on 3/2/18.
 */
({

    getAccountMetrics: function(cmp){
        var self = this;

        // make request to get account data
        var accountSummary = this.doCallout(cmp, 'c.getAccountSummary');

        // setup promise callbacks
        accountSummary.then(function(response){
            cmp.set('v.isLoading', false);
            // response is a peak response check to see if success
            if(response.success === true){
                self.helpers.handleGetAccountMetricsSuccess(cmp, response);
            } else {
                self.helpers.handleGetAccountMetricsError(cmp);
            }

        }, function(){
            cmp.set('v.isLoading', false);
            self.helpers.handleGetAccountMetricsError(cmp);
        });

    }, // end getAccountMetrics

    // shared helpers
    helpers: {

        /**
         * Success handles for getAccountSummary
         * @param cmp
         * @param response
         */
        handleGetAccountMetricsSuccess: function(cmp, response){
            // create data blocks with response data
            var dataBlocks = this.createDataBlocks(cmp, response.results[0] || {});
            cmp.set('v.dataBlock', dataBlocks);
        },
        
        /**
         * Error callback for getAccount Summary
         * @param cmp
         */
        handleGetAccountMetricsError:function(cmp){
            cmp.set('v.dataBlockError', true); // set view error
        },

        /**
         * Given a response object from the getAccountSummary request
         * will create dataBlocks view attribute
         * @param cmp
         * @param data
         * @returns {Array}
         */
        createDataBlocks: function(cmp, data) {

            // get view attributes
            var totalDueLabel = cmp.get('v.totalDueLabel');
            var totalDueCtaLabel = cmp.get('v.totalDueCtaLabel');
            var totalDueCtaUrl = cmp.get('v.totalDueCtaUrl');
            var pastDueLabel = cmp.get('v.pastDueLabel');
            var pastDueCtaLabel = cmp.get('v.pastDueCtaLabel');
            var pastDueCtaUrl = cmp.get('v.pastDueCtaUrl');
            var currentDueLabel = cmp.get('v.currentDueLabel');
            var currentDueCtaLabel = cmp.get('v.currentDueCtaLabel');
            var currentDueCtaUrl = cmp.get('v.currentDueCtaUrl');

            var creditsLabel = cmp.get('v.creditsLabel');
            var creditsCtaLabel = cmp.get('v.creditsCtaLabel');
            var creditsCtaUrl = cmp.get('v.creditsCtaUrl');

            var lastPaymentLabel = cmp.get('v.lastPaymentLabel');
            var lastPaymentCtaLabel = cmp.get('v.lastPaymentCtaLabel');
            var lastPaymentCtaUrl = cmp.get('v.lastPaymentCtaUrl');

            // get data from response data passed in
            var totalDueValue = data.AccountBalance__c || 0;
            var pastDueValue = data.PastDue__c || 0;
            var currentDueValue = data.CurrentAndFutureDue__c || 0;
            var creditsValue = data.OpenCreditAndReturns__c || 0;
            var lastPaymentValue = data.LastDepositAmount__c || 0;
            var lastPaymentDate = data.LastDepositDate__c || '';
            var lastPaymentReferenceNo = data.ReferenceNo__c || '';

            // format lastPaymentReferenceNo
            var formattedLastPaymentReferenceNo = (lastPaymentReferenceNo !== '') ? 'Ref: ' + lastPaymentReferenceNo : '';

            // format date
            var formattedLastPaymentDate = (lastPaymentDate !== '') ? $A.localizationService.formatDate(lastPaymentDate, 'MM/DD/YYYY') : '';
            
            // create results array
            var results = [];
            results.push(this.createDataBlock(totalDueLabel, totalDueValue, 'currency', totalDueCtaLabel, totalDueCtaUrl));
            results.push(this.createDataBlock(pastDueLabel, pastDueValue, 'currency', pastDueCtaLabel, pastDueCtaUrl));
            results.push(this.createDataBlock(currentDueLabel, currentDueValue, 'currency', currentDueCtaLabel, currentDueCtaUrl));
            results.push(this.createDataBlock(creditsLabel, creditsValue, 'currency', creditsCtaLabel, creditsCtaUrl));
            results.push(this.createDataBlock(lastPaymentLabel, lastPaymentValue, 'currency', lastPaymentCtaLabel, lastPaymentCtaUrl, formattedLastPaymentDate, formattedLastPaymentReferenceNo));

            return results
        }, // end createDataBlocks

        /**
         * Create a data block object
         * @param label
         * @param value
         * @param valueType
         * @param ctaLabel
         * @param ctaUrl
         * @returns {{label: *, value: *, ctaLabel: *, ctaUrl: *}}
         */
        createDataBlock: function(label, value, valueType, ctaLabel, ctaUrl, labelTopLeft, labelTopRight){
            return {
                label: label,
                value: value,
                valueType: valueType,
                ctaLabel: ctaLabel,
                ctaUrl: ctaUrl,
                labelTopLeft: labelTopLeft,
                labelTopRight: labelTopRight
            }
        } // end createDataBlock

    } // end helpers

})