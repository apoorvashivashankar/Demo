/**
 * Created by 7summits on 5/14/18.
 */
({

    init: function(cmp, evt, helper){
        var self = this;
        cmp.set('v.isLoading', true);

        // get the order number and make request to get the order data
        var bolNumber = helper.getUrlParamByName('bolnumber');

        var promise = this.doCallout(cmp, 'c.getShipmentDetail', {
            'ShipmentId': bolNumber
        });

        // set callbacks for callout response
        promise.then(function(response){
            console.log('Shipment Details: ',response);
            self.handleGetShipmentDetailSuccess(cmp, response);
            cmp.set('v.isLoading', false);
        }, function(response){
            console.log('Dal_ShipmentDetail:getShippedOrder:failed: ', response);
        });
    },
    handleGetShipmentDetailSuccess: function (cmp, response) {
        cmp.set('v.shipmentHeader', response);
    }
    
})