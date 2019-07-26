/**
 * Created by 7Summits on 5/17/18.
 */
({
    init: function(cmp, evt, helper){
       if(cmp.get("v.listType")!='Search Invoices') 
         helper.getInvoiceList(cmp);
       else
       {
         cmp.set('v.isLoading', false);
          cmp.set('v.showNoDataMsg', false);  
       }
    },
    searchInvoiceList: function(cmp, event, helper){
        console.log('inside list comp');
        var parameters = event.getParam('arguments');
        console.log('invoice is '+parameters.invoiceNumber);
 		console.log('invoice is '+parameters.jobName);
        if(parameters){
            var userType = parameters.userType;
            var invoiceNumber = parameters.invoiceNumber;
            var purchaseOrder = parameters.purchaseOrder;
            var divisionName = parameters.divisionName;
            var invoiceDateStart = parameters.invoiceDateStart;
            var invoiceDateEnd = parameters.invoiceDateEnd;
            var jobName= parameters.jobName;
            console.log('params in list comp '+userType+'--'+invoiceNumber+'--'+ purchaseOrder+'--'+ divisionName+'--'+ invoiceDateStart+'--'+ invoiceDateEnd+'--'+jobName);
            helper.searchInvoiceList(cmp, userType, invoiceNumber, purchaseOrder, divisionName, invoiceDateStart, invoiceDateEnd,jobName);
        }

    },
   /* handleScheduleSelectedOrders: function(cmp, evt, helper){
        var rows = cmp.get('v.data');
        var selectedRows = [];

        // get all the rows that are checked
        rows.forEach(function(row){
            if(row.checked === true){
                selectedRows.push(row);
            }
        });

        console.log('handleScheduleSelectedOrders: ', selectedRows);
    },
    */

    handleSelectAllInvoices: function(cmp, evt, helper){
        var checked = evt.currentTarget.checked; // get checked state
        helper.setCheckedStateAllData(cmp, checked);

    },
    
    handleDownloadAsExcel: function(cmp, evt, helper){

            var rows = cmp.get('v.fullData');
        
        var invoiceNumbers = [];
        
        rows.forEach(function(row){
           invoiceNumbers.push(row.invoiceNumber);
        });
        console.log('rows-',invoiceNumbers);
        if(invoiceNumbers.length > 0){
            helper.downloadSelectedInvoices(cmp, invoiceNumbers);
        }
    },

    handleSelectedInvoices: function(cmp, evt, helper){
        var rows = cmp.get('v.data');

        var selectedRows = [];

        // get all the rows that are checked
        var invoiceNumbers = [];
        rows.forEach(function(row){

            if(row.checked === true){
                invoiceNumbers.push(row.invoiceNumber);
            }
        });

        if(invoiceNumbers.length > 0){
            console.log('handleSelectedInvoices: ');
           helper.goToInvoicepdf(cmp,invoiceNumbers.join(','));
        }

    }
})