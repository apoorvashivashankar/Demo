/**
 * Created by 7Summits on 5/17/18.
 */
({
    getInvoiceList: function(cmp){
        var self = this;
        debugger;
         var today = new Date();
         var startDate = new Date(new Date().setDate(new Date().getDate() - 30));
         var dd = (startDate.getDate() < 10 ? '0' : '') + startDate.getDate();
         var MM = ((startDate.getMonth() + 1) < 10 ? '0' : '') + (startDate.getMonth() + 1);
         var tdd = (today.getDate() < 10 ? '0' : '') + today.getDate();
         var tMM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
        //cmp.set('v.orderDateStarts', startDate.getFullYear() + "-" + (startDate.getMonth() + 1) + "-" + startDate.getDate());
        //cmp.set('v.orderDateStarts', startDate.getFullYear() + "-" + (startDate.getMonth() + 1) + "-" + startDate.getDate());
            cmp.set('v.invoiceDateStarts', startDate.getFullYear() + "-" + (MM) + "-" + dd);
            console.log('after setting '+cmp.get('v.invoiceDateStarts'));
            //cmp.set('v.orderDateEnds', today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + (today.getDate() +1));
            cmp.set('v.invoiceDateEnds', today.getFullYear() + "-" + (tMM) + "-" + (tdd));
            console.log('after setting '+cmp.get('v.invoiceDateEnds'));

        // set the controller action type
        var actionName = 'c.getInvoiceList';
        var listLimit = cmp.get("v.listMaximum");

        var userType = cmp.get("v.userType");
        var invoiceDateStart = new Date(cmp.get("v.invoiceDateStarts"));
        var invoiceDateEnd = new Date(cmp.get("v.invoiceDateEnds"));
        var params = {
            'userType': userType,
            'invoiceNumber': undefined,
            'purchaseOrder': undefined,
            'divisionName': undefined,
            'invoiceDateStart': invoiceDateStart,
            'invoiceDateEnd': invoiceDateEnd,
            'listLimit' : listLimit
        };

        // make call to controller to get open items
        var promise = this.doListCallout(cmp, actionName, params);
          var _brandList = [];
        // set callbacks for callout response
        promise.then(function(response){
            var _resp = response[0];
            _resp.forEach(function(invoice){
                if(!_brandList.includes(invoice.Division_Name))
                  _brandList.push(invoice.Division_Name);
            });
            cmp.set('v.brandlist',_brandList);
            self.handleGetOrderListSuccess(cmp, response[0]);
            self.handleDataOverage(cmp, response[0].length, listLimit);
        });

    },
    searchInvoiceList: function(cmp, userType, invoiceNumber, purchaseOrder, divisionName, invoiceDateStart, invoiceDateEnd, jobName){
        var self = this;
            console.log('params in helper comp '+userType+'--'+ invoiceNumber+'--'+ purchaseOrder+'--'+ divisionName+'--'+ invoiceDateStart+'--'+ invoiceDateEnd+'--'+jobName);

        // set the controller action type
        var actionName = 'c.searchInvoice';

        var listLimit = cmp.get("v.listMaximum");
        var params = {
            'userType': userType,
            'invoiceNumber': invoiceNumber,
            'purchaseOrder': purchaseOrder,
            'divisionName': divisionName,
            'invoiceFrom': invoiceDateStart,
            'invoiceTo': invoiceDateEnd,
            'listLimit' : listLimit,
            'jobName' : jobName
        };
        console.log('params '+params.invoiceNumber+'--'+params.purchaseOrder+'---'+params.purchaseOrder);
        console.log(invoiceDateStart);
        console.log(invoiceDateEnd);
        // make call to controller to get open items
        var promise = this.doListCallout(cmp, actionName, params);


        // set callbacks for callout response
        promise.then(function(response){

            console.log('response  data is:' + JSON.stringify(response));
            console.log('success response ');
            self.handleGetOrderListSuccess(cmp, response);
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

    handleGetOrderListSuccess: function(cmp, response) {

        var userType = cmp.get("v.userType");
        console.log(' handling response '+userType);
        // Columns data
        if(userType == 'SSC'){
            cmp.set('v.columns', [
                {type: 'checkbox'},
                {label: 'Invoice Date', fieldName: 'invoiceDate', type: 'date', sortable: true},
                {label: 'Transaction Type', fieldName: 'transactionType', type: 'text', sortable: true},
                {label: 'Total Header Amount ($)', fieldName: 'headerAmount', type: 'text', sortable: true},
                {label: 'Invoice Number', fieldName: 'invoiceNumber', type: 'text', sortable: true},
                {label: 'Purchase Order', fieldName: 'purchaseOrder', type: 'text', sortable: true},
                {label: 'Brand', fieldName: 'divisionName', type: 'text', sortable: true},
                {label: 'Sales Receipt', fieldName: 'salesReceipt', type: 'text', sortable: true}
            ]);
        } else {
            cmp.set('v.columns', [
                {type: 'checkbox'},
                {label: 'Invoice Date', fieldName: 'invoiceDate', type: 'date', sortable: true},
                {label: 'Transaction Type', fieldName: 'transactionType', type: 'text', sortable: true},
                {label: 'Total Header Amount ($)', fieldName: 'headerAmount', type: 'text', sortable: true},
                {label: 'Invoice Number', fieldName: 'invoiceNumber', type: 'text', sortable: true},
                {label: 'Purchase Order', fieldName: 'purchaseOrder', type: 'text', sortable: true},
                {label: 'Brand', fieldName: 'divisionName', type: 'text', sortable: true}
            ]);
        }

        var rowData = [];

        // make sure we have valid response data
         console.log(' actual response '+response.results+'--'+Array.isArray(response.results));
        if(response !== undefined ){

            response.forEach(function(item,index){

                console.log('response data '+item);

                rowData.push({


                  //  invoiceLink: '/order-detail?ordernumber='+item.SalesOrder,
                    invoiceDate: new Date(item.Billing_Date) || '',
                    transactionType: item.TransactionType,
                    headerAmount: item.Total_Header_Amount,
                    invoiceNumber: item.Invoice_Number,
                    purchaseOrder: item.Purchase_Order,
                    divisionName: item.Division_Name,
                    salesReceipt: item.SalesSlip
                });

            });
        }

        // Row Data: Note 'fieldName' from the column must have a matching
        // attribute in the row data.
        cmp.set('v.data', rowData);
        console.log('rowData--',rowData.length);
        cmp.set('v.fullData', rowData);
		if(rowData.length==0)
            cmp.set('v.showNoDataMsg', true);
        this.initTable(cmp);
    },

    downloadSelectedInvoices: function(cmp,invoiceNumbers){
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
        var settings = (themeSettings !== undefined && Array.isArray(themeSettings) && themeSettings.length > 0) ? themeSettings[0] : {};
        var visualForceBaseUrl = settings.visualForceUrl__c || '';
        var baseCommunityUrl = window.location.href.substring(0, window.location.href.lastIndexOf('/s/'));
        //var invoiceExcelUrl = visualForceBaseUrl + '/apex/Dal_AllInvoiceRecord';
        var invoiceExcelUrl = baseCommunityUrl + '/Dal_AllInvoiceRecord?InvoiceIds=' + invoiceNumbers;
        this.doGotoURL(invoiceExcelUrl);
    },

    goToInvoicepdf: function(cmp,invoiceNumbers){
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