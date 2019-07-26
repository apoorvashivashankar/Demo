/**
 * Created by 7Summits on 2/22/18.
 */
({

    /**
     * Callback for the onSelected event of the action menu. The row
     * and actionName attributes will automatically be passed into  this
     * function from the Dal_ListBase which this component extends.
     * @param row - row in which the action was selected
     * @param actionName - name of action selected
     */
    handleActionOnSelect: function(row, actionName){

        switch (actionName) {
            case 'showDetails':
                console.log('Showing Details: ' + JSON.stringify(row));
                break;
        }

    }

})