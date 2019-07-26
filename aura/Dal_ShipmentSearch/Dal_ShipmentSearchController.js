/**
 * Created by 7Summits on 5/14/18.
 */
({
    init: function(cmp, evt, helper){
        helper.getShipLocationOptions(cmp);
    },

    searchOrders : function(component, event, helper) {

        var listComponent = component.find("shipmentListComponent");
        var shipmentNumber = component.get("v.shipmentNumber");
        var shipmentDateStart = component.get("v.shipmentDateStart");
        var shipmentDateEnd = component.get("v.shipmentDateEnd");
        var shipFromLocation = component.get("v.shipLocation");

        listComponent.searchShipmentList(shipmentNumber, shipFromLocation, shipmentDateStart, shipmentDateEnd);
    }
})