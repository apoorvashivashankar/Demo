/**
 * Created by presh on 05-12-2018.
 */
({
    getLineStatusOptions: function(cmp){
    //    debugger;
        var self = this;
        
       /* var today = new Date();
        var startDate = new Date(new Date().setDate(new Date().getDate() - 30));
        
        cmp.set('v.orderDateStart', startDate.getFullYear() + "-" + (startDate.getMonth() + 1) + "-" + startDate.getDate());
        cmp.set('v.orderDateEnd', today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate());
        console.log('---recordId---: ',cmp.get('v.recordId'));*/
        // set the controller action type
        var actionName = 'c.searchOpportunityRelatedOrder';
        
        var params = {opportunityId : cmp.get('v.recordId')};
        // make call to controller to get open items
        var promise = self.doCallout(cmp, actionName, params);
        
        // set callbacks for callout response
        promise.then(function(response){
            console.log('response: ',response);
            //self.handleGetStatusOptions(cmp, response);
            /* cmp.set('v.lineStatuses', response.Status);
                cmp.set('v.leadSources', response.leadSource);*/
            });
    },
    searchOrders : function(component, event, helper) {
    //    debugger;
        console.log('In SearchOrders');
        var listComponent = component.find("orderListComponent");
        var userType = component.get("v.communityType");
        var orderListType = component.get("v.listType");
        var orderNumber = component.get("v.orderNumber");
        var poNumber = component.get("v.poNumber");
        var jobName = component.get("v.jobName");
        console.log('dates in search controller before '+component.get("v.orderDateEnd")+'--'+component.get("v.orderDateStart"));
        
        var orderDateStart = component.get("v.orderDateStart");
        var orderDateEnd = component.get("v.orderDateEnd");
        var orderStatus = component.get("v.orderStatus");
        
        console.log('dates in search controller after '+orderDateStart+'--'+orderDateEnd);
        console.log('orderStatus:'+orderStatus);
        
        listComponent.searchOrderList(userType, orderListType, orderNumber, poNumber, jobName, orderDateStart, orderDateEnd, orderStatus);
    }
})