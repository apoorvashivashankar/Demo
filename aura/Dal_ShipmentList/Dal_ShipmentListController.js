/**
 * Created by 7Summits on 5/14/18.
 */
({
    init: function(cmp, evt, helper){
        console.log('list start');
       
        helper.getShipmentList(cmp);
    },
    searchShipmentList: function(cmp, event, helper){
        var parameters = event.getParam('arguments');
        if(parameters){

            var shipmentNumber = parameters.shipmentNumber;
            var shipFromLoc = parameters.shipFromLoc;
            var shipFrom = parameters.shipFrom;
            var shipTo = parameters.shipTo;
            helper.searchShipmentList(cmp, shipmentNumber, shipFromLoc, shipFrom, shipTo);
        }

    }
})