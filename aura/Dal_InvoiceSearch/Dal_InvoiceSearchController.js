/**
 * Created by 7Summits on 5/17/18.
 */
({
    init: function(cmp, evt, helper){
       // var userType = cmp.get("v.communityType");
        //helper.getBrandOptions(cmp);
        var today = new Date();
        var startDate = new Date(new Date().setDate(new Date().getDate() - 30));

        cmp.set('v.invoiceDateStart', startDate.getFullYear() + "-" + (startDate.getMonth() + 1) + "-" + startDate.getDate());
        cmp.set('v.invoiceDateEnd', today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate());
    },

    onLineStatusChange : function(component, event, helper){

        var lineStatus = component.find("divisionName").get("v.value");
        component.set("v.divisionName", lineStatus);
    },
    searchInvoices : function(component, event, helper) {

        var listComponent = component.find("invoiceListComponent");
        var userType = component.get("v.communityType");
        var invoiceNumber = component.get("v.invoiceNumber");
        var purchaseOrder = component.get("v.purchaseOrder");
        var divisionName = component.get("v.divisionName");
        var invoiceDateStart = component.get("v.invoiceDateStart");
        var invoiceDateEnd = component.get("v.invoiceDateEnd");	
        var listType=  component.get("v.listType");
        var jobName = component.get("v.jobName");
        if(listType=='Search Invoices')
        {
            invoiceDateStart='';
            invoiceDateEnd='';
            divisionName='';
        }
        console.log('Calling list comp method#####'+userType+'--'+ invoiceNumber+'--'+purchaseOrder+'--'+divisionName+'--'+invoiceDateStart+'--'+invoiceDateEnd+'--'+jobName);
        listComponent.searchInvoiceList(userType, invoiceNumber, purchaseOrder, divisionName, invoiceDateStart, invoiceDateEnd,  jobName);
    }
})