/**
 * Created by 7Summits on 2/22/18.
 */
({
    
    handleSort: function (cmp, event, helper) {
        var fieldName = event.currentTarget.getAttribute('data-fieldName');
        var sortDirection = event.currentTarget.getAttribute('data-sortDirection');
        var hasPagination = cmp.get('v.hasPagination');

        // get current fieldName and sortDirection
        var currentFieldName = cmp.get('v.sortedBy');
        var currentSortedDirection = cmp.get('v.sortedDirection');

        // check if we are toggling back and forth the same fieldName if so we have to modify the sort direction
        var newSortDirection = (currentFieldName === fieldName) ? ((currentSortedDirection === 'asc') ? 'desc' : 'asc' ) : sortDirection;

        // assign the latest attribute with the sorted column fieldName and sorted direction
        cmp.set('v.sortedBy', fieldName);
        cmp.set('v.sortedDirection', newSortDirection);

        // is pagination is on we need to sort slightly different
        if(hasPagination === true){
            helper.sortPaginatedData(cmp, fieldName, newSortDirection);
        } else {
            helper.sortData(cmp, fieldName, newSortDirection);
        }

    },

    handleOnSelect: function(cmp, evt){
        // get the selected action value
        var selectedMenuItemValue = evt.getParam('value');

        // parse the selected action value
        var selectedMenuItemSplit = selectedMenuItemValue.split(':');

        // make sure we parsed correctly
        if(selectedMenuItemSplit[0] !== undefined && selectedMenuItemSplit[1]){
            // get the row that the action is called on
            var data = cmp.get('v.data');
            var selectedDataRow = data[selectedMenuItemSplit[0]];

            // make sure we have a valid callback
            if(selectedDataRow.onSelect !== undefined && typeof selectedDataRow.onSelect === 'function'){
                selectedDataRow.onSelect(selectedDataRow, selectedMenuItemSplit[1]);
            } else {
                console.log('Error:Dal_ListBase:handleOnSelect:No Callback');
            }

        } // end parse check

    },

    handleSingleActionClick: function(cmp, evt, helper){
        var selectedRow = parseInt(evt.currentTarget.dataset.row); // get the row selected
        var data = cmp.get('v.data'); // get all the data

        // check to make sure we have row data
        if(data !== undefined && data[selectedRow] !== undefined) {
            data[selectedRow].onClick(cmp, selectedRow, helper);
        }
    },

    handleOnCheckboxClick: function(cmp, evt, helper){
        var checked = evt.currentTarget.checked; // get checked state
        var row = parseInt(evt.currentTarget.dataset.row); // get the row
        var data = cmp.get('v.data'); // get all the data

        // iterate the data rows looking for which row was selected
        for(var x=0; x < data.length; x++){
            // if we found a match, set checked state
            if(row === x){
                data[x].checked = checked;
                break;
            }
        }

        // if the checked state is false we know that the all checked state should be false as well
        if(checked === false){
            cmp.set('v.allDataChecked', false)
        }

        // set the data back to the view
        cmp.set('v.data', data);
    },

    handleShowModal: function(cmp, evt, helper){
        var data = cmp.get('v.data'); // get all the data
        var componentName = evt.currentTarget.dataset.component; // get the component name
        var selectedRow = parseInt(evt.currentTarget.dataset.row); // get the row selected
        var rowData = {};

        // check to make sure we have row data to  provide to the modal
        if(data !== undefined && data[selectedRow] !== undefined) {
            rowData = data[selectedRow];
        }

        helper.openModal(cmp, componentName, {data: rowData}, true, '');

        // check to make sure we have a onclick provided by the extending component
        // if(data !== undefined && data[selectedRow] !== undefined) {
        //
        //     console.log('showModal:' + componentName + ' passing in this:', data[selectedRow]);
        // }

    },

    pagerNext: function pagerNext(cmp, evt, helper) {
        helper.pagerNext(cmp);
    },

    pagerPrev: function pagerPrev(cmp, evt, helper) {
        helper.pagerPrev(cmp);
    }

})