/**
 * Created by 7Summits on 3/5/18.
 */
({

    /**
     * Available filter types
     */
    filterTypes: {
        'Total Due': 'totalDue',
        'Past Due': 'pastDue',
        'Current Due': 'currentDue',
        'Credits':  'credits'
    },

   getOpenItems: function(cmp){
        var self = this;

        // get the filter parameter set in the component
        var filterType = cmp.get('v.filterType');
        console.log('filterType',filterType);
        var today = new Date();
        var startDate = new Date(new Date().setDate(new Date().getDate() - 30));
        cmp.set('v.invoiceDateStarts', startDate.getFullYear() + "-" + (startDate.getMonth() + 1) + "-" + startDate.getDate());
        cmp.set('v.invoiceDateEnds', today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate());
        // make sure there a valid filter type was selected
       if(this.filterTypes[filterType] !== undefined){
        var userType;
        var invoiceNumber;
        var purchaseOrder;
        var divisionName;
        var invoiceDateStart = cmp.get("v.invoiceDateStarts");
        var invoiceDateEnd = cmp.get("v.invoiceDateEnds");
        var filterTabType = cmp.get('v.filterType');
           // set the controller action type
           var actionName = 'c.searchOpenAccount';
            var params = {
                           'userType': userType,
                           'invoiceNumber': invoiceNumber,
                           'purchaseOrder': purchaseOrder,
                           'divisionName': divisionName,
                           'invoiceFrom': invoiceDateStart,
                           'invoiceTo': invoiceDateEnd,
                           'filterType': filterTabType,
                           'listLimit' : listLimit
                       };
           /*switch(this.filterTypes[filterType]) {
               case 'totalDue':
                   actionName = 'c.getAllOpenItems';
                   cmp.set('v.noDataMsg', 'No Open Items');
                   console.log('totalDue');

                   break;
               case 'pastDue':
                   actionName = 'c.getPastOpenItems';
                   cmp.set('v.noDataMsg', 'No Past Due Items');
                   console.log('pastDue');
                   break;
               case 'currentDue':
                   actionName = 'c.getCurrentOpenItems';
                   cmp.set('v.noDataMsg', 'No Current Due Items');
                   console.log('currentDue');
                   break;
               case 'credits':
                   actionName = 'c.getReturnsAndCreditsOpenItems';
                   cmp.set('v.noDataMsg', 'No Returns or Credits');
                   console.log('credits');
                   break;
           }*/
           var listLimit = cmp.get("v.listMaximum");

           // make call to controller to get open items
           var promise = this.doListCallout(cmp, actionName, params);

           // set callbacks for callout response
           promise.then(function(response){
               self.handleGetOpenItemsSuccess(cmp, response);
           });

       } else {
           console.log('Dal_AccountOpenItemsHelper:getOpenItems:Invalid Filter Type');
       }

   }, // end initOpenItems


   searchInvoiceList: function(cmp, userType, invoiceNumber, purchaseOrder, divisionName, invoiceDateStart, invoiceDateEnd, filterTabType){
       var self = this;
           console.log('params in helper comp '+userType+'--'+ invoiceNumber+'--'+ purchaseOrder+'--'+ divisionName+'--'+ invoiceDateStart+'--'+ invoiceDateEnd);

         // get the filter parameter set in the component
        var filterType = cmp.get('v.filterType');
        console.log('filterType',filterType);

           // set the controller action type
           var actionName = 'c.searchOpenAccount';

           var listLimit = cmp.get("v.listMaximum");
           var params = {
               'userType': userType,
               'invoiceNumber': invoiceNumber,
               'purchaseOrder': purchaseOrder,
               'divisionName': divisionName,
               'invoiceFrom': invoiceDateStart,
               'invoiceTo': invoiceDateEnd,
               'filterType': filterTabType,
               'listLimit' : listLimit
           };
           console.log('params '+params.invoiceNumber+'--'+params.purchaseOrder);
           console.log(invoiceDateStart);
           console.log(invoiceDateEnd);
           // make call to controller to get open items
           var promise = this.doListCallout(cmp, actionName, params);

           // set callbacks for callout response
           promise.then(function(response){
               console.log('response  data is:' + JSON.stringify(response));
               console.log('success response ');
               self.handleGetOpenItemsSuccess(cmp, response);
               self.handleDataOverage(cmp, response.length, listLimit);
           });


   }, // end initOpenItems

    handleDataOverage: function(cmp, recordCount, totalCount){
        var _overageLabel = '';
        if(recordCount >= totalCount){
            _overageLabel = 'There are more results than can be displayed. Please try more specific search criteria.';
        }
        cmp.set('v.pageMessage', _overageLabel);

    },

    handleGetOpenItemsSuccess: function(cmp, response) { 

        // Columns data
        cmp.set('v.columns', [
            {type: 'checkbox'},
            {label: 'Transaction type', fieldName: 'transactionType', type: 'text', sortable: true},
            {label: 'Reason code', fieldName: 'reasonCode', type: 'text', sortable: true },
            {label: 'Invoice/Payment No', fieldName: 'referenceNumber', type: 'text', sortable: true},
            {label: 'Transaction Date', fieldName: 'transactionDate', type: 'date', sortable: true},
            {label: 'Due Date', fieldName: 'dueDate', type: 'date', detailViewOnly: true},
            {label: 'Shipping From', fieldName: 'shippingFrom', type: 'text', sortable: true , detailViewOnly: true},
            {label: 'Amount', fieldName: 'amount', type: 'currency' , sortable: true},
            {label: 'Aging', fieldName: 'aging', type: 'text' , sortable: true, detailViewOnly: true},
            {label: 'Past Due Days', fieldName: 'pastDueDays', type: 'text' , sortable: true, detailViewOnly: true},
            {label: 'Brand', fieldName: 'division', type: 'text', sortable: true},
            {label: 'PO Number', fieldName: 'customerPONo', type: 'text', sortable: true},
            {label: 'Job Name', fieldName: 'jobName', type: 'text', sortable: true , detailViewOnly: true },
            {label: 'Sales Receipt Number', fieldName: 'salesReceiptNo', type: 'text', sortable: true},
            {label: 'Bol Number', fieldName: 'bolNumber', type: 'text', detailViewOnly: true},
            {label: 'View Details', type: 'modal', component: 'c:Dal_AccountOpenItemsDetail'}
        ]);

        var rowData = [];

        // make sure we have valid response data
        if(response !== undefined && Array.isArray(response)){

            response.forEach(function(item, index){

                console.log(item);

                rowData.push({
                    transactionType: item.TransactionType || '',
                    reasonCode: item.ReasonCode || '',
                    referenceNumber: item.ReferenceNo || '',
                    transactionDate: item.ReferenceDate || '',
                    dueDate: new Date(item.DueDate) || '',
                    shippingFrom:  item.ShipFrom || '',
                    amount: item.GrossAmount || '',
                    aging: item.AgingCode || '',
                    pastDueDays: item.PastDueDays || '',
                    customerPONo: item.CustomerPONo || '',
                    jobName: item.JobName || '',
                    salesReceiptNo: item.SalesReceiptNo || '',
                    division: item.Division || '',
                    bolNumber: item.BolNumber || ''
                });

            });
        }

        // Row Data: Note 'fieldName' from the column must have a matching
        // attribute in the row data.
        cmp.set('v.data', rowData);
        console.log('rowData--',rowData.length);
        cmp.set('v.fullData', rowData);
        this.initTable(cmp);
    },

    downloadSelectedInvoices: function(cmp,invoiceNumbers){
       debugger;
        var self = this;

        // get the 'CommunityShared' custom settings
        var themeSettings = this.getThemeSettings(cmp, 'CommunityShared');

        Promise.all([themeSettings]).then(function(values) {
            self.handleInitStatementsSuccess(cmp, values[0].results, invoiceNumbers);
        }, function(response){
            console.log('DownloadAsExcel:Error:', response);
        });
    },

    handleInitStatementsSuccess: function(cmp, themeSettings,invoiceNumbers) {
        debugger;
        var settings = (themeSettings !== undefined && Array.isArray(themeSettings) && themeSettings.length > 0) ? themeSettings[0] : {};
        var visualForceBaseUrl = settings.visualForceUrl__c || '';
        var baseCommunityUrl = window.location.href.substring(0, window.location.href.lastIndexOf('/s/'));
        //var invoiceExcelUrl = visualForceBaseUrl + '/apex/Dal_AllInvoiceRecord';
        var invoiceExcelUrl = baseCommunityUrl + '/Dal_AllInvoiceRecord?InvoiceIds=' + invoiceNumbers;
        this.doGotoURL(invoiceExcelUrl);
    },

    goToInvoicepdf: function(cmp,invoiceNumbers){
        debugger;
        console.log('invoiceNumbers -----'+invoiceNumbers);
        var themeSettings = this.getThemeSettings(cmp, 'CommunityShared');
        var settings = (themeSettings !== undefined && Array.isArray(themeSettings) && themeSettings.length > 0) ? themeSettings[0] : {};
        console.log('settings ---- '+settings);
        var visualForceBaseUrl = settings.visualForceUrl__c || '';

        var baseCommunityUrl = window.location.href.substring(0, window.location.href.lastIndexOf('/s/'));
        var invoicepdfUrl = baseCommunityUrl + '/Dal_CustomerInvoice?InvoiceIds=' + invoiceNumbers;
        console.log('invoicepdfUrl ----- '+invoicepdfUrl);
        window.open(invoicepdfUrl, '_blank');

    },


})