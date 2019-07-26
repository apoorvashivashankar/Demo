/**
 * Created by 7Summits on 5/14/18.
 */
({
    getShipLocationOptions: function(cmp){
        var self = this;

        var today = new Date();
        var startDate = new Date(new Date().setDate(new Date().getDate() - 30));

       cmp.set('v.shipmentDateStart', startDate.getFullYear() + "-" + (startDate.getMonth() + 1) + "-" + startDate.getDate());
       cmp.set('v.shipmentDateEnd', today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate());

        // set the controller action type
        var actionName = 'c.getShipfromLoc';
        // make call to controller to get open items
        var promise = self.doCallout(cmp, actionName);

        // set callbacks for callout response
        promise.then(function(response){
            console.log('Shipment Locations: ',response);
            self.handleGetLocationOptions(cmp, response);
        });
    },
    handleGetLocationOptions: function(cmp, response){
        console.log(response);
        cmp.set('v.shipLocations', response);
    }
})