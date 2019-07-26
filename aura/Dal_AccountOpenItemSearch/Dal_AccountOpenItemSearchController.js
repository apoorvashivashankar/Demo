/**
 * Created by Preshit on 17-01-2019.
 */
({
    init: function(cmp, evt, helper){
        debugger;
       // var userType = cmp.get("v.communityType");
        helper.getBrandOptions(cmp);
        var today = new Date();
        var startDate = new Date(new Date().setDate(new Date().getDate() - 30));

        cmp.set('v.invoiceDateStart', startDate.getFullYear() + "-" + (startDate.getMonth() + 1) + "-" + startDate.getDate());
        cmp.set('v.invoiceDateEnd', today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate());

        helper.handleSearch(cmp, evt, helper);
    },
    onLineStatusChange : function(component, event, helper){
        var lineStatus = component.find("divisionName").get("v.value");
        component.set("v.divisionName", lineStatus);
    },
    searchInvoices : function(component, event, helper) {
        helper.handleSearch(component, event, helper);
    }
})