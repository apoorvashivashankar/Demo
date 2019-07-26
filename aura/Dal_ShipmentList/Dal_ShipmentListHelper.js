/**
 * Created by 7Summits on 5/14/18.
 */
({
    getShipmentList: function(cmp){
        var self = this;

        debugger;
                 var today = new Date();
                 var startDate = new Date(new Date().setDate(new Date().getDate() - 30));
                 var dd = (startDate.getDate() < 10 ? '0' : '') + startDate.getDate();
                 var MM = ((startDate.getMonth() + 1) < 10 ? '0' : '') + (startDate.getMonth() + 1);
                 var tdd = (today.getDate() < 10 ? '0' : '') + today.getDate();
                 var tMM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
                //cmp.set('v.orderDateStarts', startDate.getFullYear() + "-" + (startDate.getMonth() + 1) + "-" + startDate.getDate());
                //cmp.set('v.orderDateStarts', startDate.getFullYear() + "-" + (startDate.getMonth() + 1) + "-" + startDate.getDate());
                    cmp.set('v.shipmentDateStarts', startDate.getFullYear() + "-" + (MM) + "-" + dd);
                    console.log('after setting '+cmp.get('v.invoiceDateStarts'));
                    //cmp.set('v.orderDateEnds', today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + (today.getDate() +1));
                    cmp.set('v.shipmentDateEnds', today.getFullYear() + "-" + (tMM) + "-" + (tdd));
                    console.log('after setting '+cmp.get('v.invoiceDateEnds'));

        // set the controller action type
        var actionName = 'c.getShipmentList';

        var listLimit = cmp.get("v.listMaximum");

        var shipmentDateStart = new Date(cmp.get("v.shipmentDateStarts"));
        var shipmentDateEnd = new Date(cmp.get("v.shipmentDateEnds"));
        var params = {
            'shipFrom': shipmentDateStart,
            'shipTo': shipmentDateEnd,
            'shipLocation': undefined,
            'listLimit': listLimit
        };


        // make call to controller to get open items
        var promise = this.doListCallout(cmp, actionName, params);
        // set callbacks for callout response
        promise.then(function(response){
            console.log('Shipment List: ',response);
            self.handleGetOrderListSuccess(cmp, response);
            self.handleDataOverage(cmp, response.length, listLimit);
        });

    },
    searchShipmentList: function(cmp, shipmentNumber, shipFromLoc, shipFrom, shipTo){
        var self = this;

        // set the controller action type
        var actionName = 'c.searchShipments';

        var listLimit = cmp.get("v.listMaximum");
        var params = {
            'shipmentNumber': shipmentNumber,
            'shipFrom': shipFrom,
            'shipTo': shipTo,
            'shipFromLoc': shipFromLoc,
            'listLimit' : listLimit
        };
        console.log(params);
        console.log(shipFrom);
        console.log(shipTo);
        // make call to controller to get open items
        var promise = this.doListCallout(cmp, actionName, params);

        // set callbacks for callout response
        promise.then(function(response){
            console.log('SEARCH!');
            self.handleGetOrderListSuccess(cmp, response);
            self.handleDataOverage(cmp, response.length, listLimit);
        });

    }, // end initOpenItems

    handleDataOverage: function(cmp, recordCount, totalCount){
        var _overageLabel = '';
        if(recordCount >= totalCount){
            _overageLabel = 'There are more results than can be displayed. Please try more specific search criteria.';
        }
        cmp.set('v.pageMessage', _overageLabel);

    },
    
    handleGetOrderListSuccess: function(cmp, response) {

        cmp.set('v.columns', [
            {label: 'BOL Number', fieldName: 'bolNumber', type: 'textLink', urlName: 'shipmentLink', sortable: true},
            {label: 'Shipment Date', fieldName: 'shipmentDate', type: 'date', sortable: true},
            {label: 'Carrier Name', fieldName: 'carrierName', type: 'text', sortable: true},
            {label: 'Ship From', fieldName: 'shipLocation', type: 'text', sortable: true},
            {label: 'Status', fieldName: 'status', type: 'text', sortable: true},
            {label: 'Tracking #', fieldName: 'trackingNumber', type: 'text', sortable: true}
        ]);


        var rowData = [];

        // make sure we have valid response data
        if(response !== undefined && Array.isArray(response)){

            response.forEach(function(item, index){

                //console.log(item);

                rowData.push({
                    id: index,
                    bolNumber: item.BolNumber,
                    shipmentLink: '/shipment-detail?bolnumber='+item.BolNumber,
                    shipmentDate: new Date(item.ShipmentCreationDate) || '',
                    shipLocation: item.ShipFromLocDesc,
                    carrierName: item.CarrierName,
                    status: item.StatusDesc,
                    trackingNumber: item.TrackingNbr
                });

            });
        }

        // Row Data: Note 'fieldName' from the column must have a matching
        // attribute in the row data.
        cmp.set('v.data', rowData);

        this.initTable(cmp);
    }

})