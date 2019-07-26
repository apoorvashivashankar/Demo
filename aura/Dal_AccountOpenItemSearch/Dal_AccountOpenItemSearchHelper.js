/**
 * Created by Preshit on 17-01-2019.
 */
({
    getBrandOptions: function(cmp){
        var self = this;

         // get the filter parameter set in the component
        var filterType = cmp.get('v.filterType');
        console.log('filterType',filterType);
        // set the controller action type
        var actionName = 'c.getBrandlist';

        //var params = {'userType': userType, 'orderType': orderType};
        // make call to controller to get open items
        var promise = self.doCallout(cmp, actionName);

        // set callbacks for callout response
        promise.then(function(response){
            console.log('Brand ',response);
           self.handleGetBrandOptions(cmp, response);
        });
    },
    handleGetBrandOptions: function(cmp, response){
        console.log(response);
        cmp.set('v.brandlist', response);
    },
    handleSearch : function(component, event, helper) {
        debugger;
        var listComponent = component.find("invoiceListComponent");
        var userType = component.get("v.communityType");
        var invoiceNumber = component.get("v.invoiceNumber");
        var purchaseOrder = component.get("v.purchaseOrder");
        var divisionName = component.get("v.divisionName");
        var invoiceDateStart = component.get("v.invoiceDateStart");
        var invoiceDateEnd = component.get("v.invoiceDateEnd");
        var filterTabType = component.get("v.filterTabType");

        console.log('Calling list comp method#####'+userType+'--'+ invoiceNumber+'--'+purchaseOrder+'--'+divisionName+'--'+invoiceDateStart+'--'+invoiceDateEnd);
        listComponent.searchInvoiceList(userType, invoiceNumber, purchaseOrder, divisionName, invoiceDateStart, invoiceDateEnd,filterTabType);
    }
})