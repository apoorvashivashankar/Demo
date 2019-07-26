/**
 * Created by 7Summits on 2/22/18.
 */
({

    init: function(cmp, evt, helper){
        // Action dropdown items
        var actionItems = [
            { label: 'Show details', name: 'showDetails' },
            { label: 'Test', name: 'test' },
            { label: 'Test 2', name: 'test2' }
        ];

        // Columns data
        cmp.set('v.columns', [
            {label: 'Order Number', fieldName: 'orderNumber', type: 'text'},
            {label: 'Shipping Location', fieldName: 'shippingLocation', type: 'text'},
            {label: 'Status', fieldName: 'status', type: 'text', sortable: true},
            {label: 'Order Date', fieldName: 'orderDate', type: 'date', sortable: true},
            {label: 'PO #', fieldName: 'poNumber', type: 'text'},
            {label: 'Job #', fieldName: 'jobNumber', type: 'text'},
            {label: 'Actions', type: 'action', actions: actionItems, menuAlignment: 'right', onSelect: helper.handleActionOnSelect}
        ]);

        // Row Data: Note 'fieldName' from the column must have a matching
        // attribute in the row data. Example if the column has a 'orderNumber' fieldName
        // there must be a data attribute 'orderNumber' in this data set.
        cmp.set('v.data', [
            {
                orderNumber: '00021343455',
                shippingLocation: 'Dallas',
                status: 'Shipped',
                orderDate: new Date('2018-01-12T08:24:00'),
                poNumber: '4012353',
                jobNumber: '3015473'
            },
            {
                orderNumber: '00023543455',
                shippingLocation: 'Dallas',
                status: 'Shipped',
                orderDate: new Date('2018-01-19T08:24:00'),
                poNumber: '7652353',
                jobNumber: '83215473'
            },
            {
                orderNumber: '00023546702',
                shippingLocation: 'Austin',
                status: 'Open',
                orderDate: new Date('2018-01-30T08:24:00'),
                poNumber: '8695353',
                jobNumber: '23115473'
            },
            { 
                orderNumber: '00077686702',
                shippingLocation: 'Houston',
                status: 'Transferred',
                orderDate: new Date('2018-01-17T08:24:00'),
                poNumber: '6545312',
                jobNumber: '53115213'
            }
        ]);

        helper.initTable(cmp);
    }

})