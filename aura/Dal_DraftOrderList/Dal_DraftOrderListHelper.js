/**
 * Created by 7Summits on 4/23/18.
 */
({

    getSavedOrders: function(cmp){
        var self = this;

        var actionName = 'c.getDraftOrders';
        var promise = this.doListCallout(cmp, actionName);

        // set callbacks for callout response
        promise.then(function(response){
            self.handleGetDraftOrders(cmp, response);
        }, function(response){
            console.log('Dal_DraftedOrderList:handleGetOrders:Error:', response);
        });

    },

    handleGetDraftOrders: function(cmp, response){
        console.log('handleGetOrders:', response);

        // Columns data
        cmp.set('v.columns', [
            {label: 'PO Number', fieldName: 'poNumber', type: 'text', sortable: true},
            {label: 'Job Name', fieldName: 'jobName', type: 'text', sortable: true},
            {label: 'Date Created', fieldName: 'draftCreatedDate', type: 'date', sortable: true},
            {label: '', fieldName: 'deleteOrder', type: 'singleAction', onClick: this.handleDelete},
            {label: '', fieldName: 'resumeOrder', type: 'textLink', urlName: 'resumeOrderLink'}
        ]);

        var rowData = [];

        // make sure we have valid response data
        if(response !== undefined && Array.isArray(response)){
            response.forEach(function(item, index){
                rowData.push({
                    id: index,
                    poNumber: item.Purchase_Order__c,
                    jobName: item.JobName__c,
                    draftCreatedDate: new Date(item.CreatedDate) || '',
                    deleteOrder: 'Delete',
                    resumeOrder: 'Resume Order',
                    resumeOrderLink: '/quick-order?draftId=' + item.Id,
                    draftId: item.Id
                });
            });
        }

        cmp.set('v.data', rowData);
        this.initTable(cmp);
    },

    handleDelete: function(cmp, dataRowClicked, parentHelper){
        var data = cmp.get('v.data'); // get all the data
		var _self = this;
        // get action and params
        var actionName = 'c.deleteDraftOrder';
        var params = {'draftOrderId': data[dataRowClicked].draftId};

        // make call to delete row
        var promise = parentHelper.doCallout(cmp, actionName, params);

        // delete the row from the view
        data.splice(dataRowClicked, 1);
        cmp.set('v.data', data);

        // set callbacks for callout response
        promise.then(function(response){
            // if unable to delete show message
            console.log(response);
            parentHelper.initTable(cmp);
            if(response === false){
                console.log('Dal_DraftedOrderList:handleDelete:Unable to delete draft:', response);
                parentHelper.showMessage('Error', 'Unable to delete order draft, refresh the page and try again.');
            }
        }, function(response){
            console.log('Dal_DraftedOrderList:handleDelete:Error:', response);
            parentHelper.showMessage('Error', 'Unable to delete order draft, refresh the page and try again.');
        });
    }

})