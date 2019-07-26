/**
 * Created by 7Summits on 2/27/18.
 */
({
    init: function(cmp, evt, helper){
        // Action dropdown items
        // var actionItems = [
        //     {label: 'Default', name: 'active'}
        //  ];

        // Columns data
        cmp.set('v.columns', [
            {label: 'isActive', fieldName: 'isActive', type: 'text'},
            {label: 'Name', fieldName: 'name', type: 'text' , sortable: true},
            {label: 'Account ID', fieldName: 'accountID', type: 'text' , sortable: true},
            {label: 'Customer Name', fieldName: 'customerName', type: 'text', sortable: true},
            {label: 'Address Line 1', fieldName: 'addressOne', type: 'text'},
            {label: 'Address Line 2', fieldName: 'addressTwo', type: 'text'},
            {label: 'Address Line 3', fieldName: 'addressThree', type: 'text'},
            {label: 'Address Line 4', fieldName: 'addressFour', type: 'text'},
            {label: 'City', fieldName: 'city', type: 'text'},
            {label: 'State', fieldName: 'state', type: 'text'},
            {label: 'Country', fieldName: 'country', type: 'text'}
           // {label: 'Actions', type: 'action', actions: actionItems, menuAlignment: 'right', onSelect: helper.handleActionOnSelect}
        ]);

        // Row Data: Note 'fieldName' from the column must have a matching
        // attribute in the row data.
        cmp.set('v.data', [
            {
                isActive: '',
                id: '00001',
                name: 'Account Name',
                accountID: '00021343455',
                customerName: 'Mike Ross',
                addressOne: ' 123 W Main St.',
                addressTwo: ' Suite 500',
                addressThree: ' ',
                addressFour: ' ',
                city: 'Milwaukee',
                state: 'WI',
                postalCode: '53202',
                country: 'US'
            },
            {
                isActive: '',
                id: '00002',
                name: 'Account Name',
                accountID: '012212345',
                customerName: 'Louise Litt',
                addressOne: ' 123 Spring Valley Rd.',
                addressTwo: ' Suite 100',
                addressThree: ' ',
                addressFour: ' ',
                city: 'Dallas',
                state: 'TX',
                postalCode: '74055',
                country: 'US'
            },
            {
                isActive: '',
                id: '00003',
                name: 'Account Name',
                accountID: '012300851',
                customerName: 'Harvey Spector',
                addressOne: ' E Pike Place.',
                addressTwo: ' Unit 12',
                addressThree: ' ',
                addressFour: ' ',
                city: 'Seattle',
                state: 'WA',
                postalCode: '00001',
                country: 'US'
            },
            {
                isActive: '',
                id: '00004',
                name: 'Account Name',
                accountID: '0784357791',
                customerName: 'Jessica Pearson',
                addressOne: ' 100 Congress Ave.',
                addressTwo: ' Suite 2',
                addressThree: ' ',
                addressFour: ' ',
                city: 'madison',
                state: 'WI',
                postalCode: '53718',
                country: 'US'
            }
        ]);

            helper.initTable(cmp);
    }
})