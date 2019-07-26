/**
 * Created by abdoundure on 3/1/18.
 */
/**
 * Created by 7Summits on 2/27/18.
 */
({
    init: function(cmp, evt, helper){
        //helper.getOpenItems(cmp);
    },
    searchInvoiceList: function(cmp, event, helper){
        console.log('inside list comp');
        var parameters = event.getParam('arguments');

        console.log('invoice is '+parameters.filterTabType);

        if(parameters){
            var userType = parameters.userType;
            var invoiceNumber = parameters.invoiceNumber;
            var purchaseOrder = parameters.purchaseOrder;
            var divisionName = parameters.divisionName;
            var invoiceDateStart = parameters.invoiceDateStart;
            var invoiceDateEnd = parameters.invoiceDateEnd;
            var filterTabType = parameters.filterTabType;
            console.log('params in list comp '+userType+'--'+invoiceNumber+'--'+ purchaseOrder+'--'+ divisionName+'--'+ invoiceDateStart+'--'+ invoiceDateEnd + '---'+filterTabType);
            helper.searchInvoiceList(cmp, userType, invoiceNumber, purchaseOrder, divisionName, invoiceDateStart, invoiceDateEnd,filterTabType);
        }

    },
    handleSelectAllInvoices: function(cmp, evt, helper){
        var checked = evt.currentTarget.checked; // get checked state
        helper.setCheckedStateAllData(cmp, checked);

    },

    handleDownloadAsExcel: function(cmp, evt, helper){
        debugger;
        var rows = cmp.get('v.fullData');

        var invoiceNumbers = [];

        rows.forEach(function(row){
           invoiceNumbers.push(row.referenceNumber);
        });
        console.log('rows-',invoiceNumbers);
        if(invoiceNumbers.length > 0){
            helper.downloadSelectedInvoices(cmp, invoiceNumbers);
        }
    },

    handleSelectedInvoices: function(cmp, evt, helper){
        debugger;
        var rows = cmp.get('v.data');
        var selectedRows = [];

        // get all the rows that are checked
        var invoiceNumbers = [];
        rows.forEach(function(row){

            if(row.checked === true){
                invoiceNumbers.push(row.referenceNumber);
            }
        });

        if(invoiceNumbers.length > 0){
            console.log('handleSelectedInvoices: ');
           helper.goToInvoicepdf(cmp,invoiceNumbers.join(','));
        }

    }
})