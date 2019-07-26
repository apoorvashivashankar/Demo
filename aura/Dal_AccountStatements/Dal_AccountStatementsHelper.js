/**
 * Created by 7Summits on 2/28/18.
 */
({

    getStatements: function(cmp){
        var self = this;

        // get the 'CommunityShared' custom settings
        var themeSettings = this.getThemeSettings(cmp, 'CommunityShared');

        var listLimit = cmp.get("v.listMaximum");
        // make call to controller to get open items
        var statementSummaryByCustomer = this.doListCallout(cmp, 'c.getStatementSummarybyCustomer', {'listLimit' : listLimit});

        Promise.all([themeSettings, statementSummaryByCustomer]).then(function(values) {
            self.handleInitStatementsSuccess(cmp, values[0].results, values[1]);
        }, function(response){
            console.log('Dal_AccountStatements:getStatements:Error:', response);
        });
    },

    handleInitStatementsSuccess: function(cmp, themeSettings, statementsWrapper){
        var settings = (themeSettings !== undefined && Array.isArray(themeSettings) && themeSettings.length > 0) ? themeSettings[0] : {};
        var visualForceBaseUrl = settings.visualForceUrl__c || '';

        // Set columns data
        cmp.set('v.columns', [
            {label: 'Customer', fieldName: 'customer', type: 'text'},
            {label: 'Statement Date', fieldName: 'statementDate', type: 'dateLink', urlName: 'url', sortable: true}
        ]);

        // Row Data: Note 'fieldName' from the column must have a matching
        // attribute in the row data. Example if the column has a 'orderNumber' fieldName
        // there must be a data attribute 'orderNumber' in this data set.
        var dataList = [];

        // check if there are statements to display
        if(statementsWrapper !== undefined && statementsWrapper.statements !== undefined && Array.isArray(statementsWrapper.statements)) {
            statementsWrapper.statements.forEach(function(result, index){

                // create a moment object using the YYYYMMDD format that the date is returned in
                var statementDate = window.moment(result.StatementDate__c, 'YYYYMMDD');
				var baseCommunityUrl = window.location.href.substring(0, window.location.href.lastIndexOf('/s/'));
                // create statement URL
                var statementUrl = baseCommunityUrl + '/Dal_StatementPDF?filename=' + result.FileName__c + '&sdate=' + result.StatementDate__c;

                dataList.push({
                    id: index,
                    statementDate: new Date(statementDate.toString()), // convert the moment to js Date
                    customer: statementsWrapper.accountName,
                    url: statementUrl
                });

            }); //  end statements for loop
        } // end if

        //  set the data of the list
        cmp.set('v.data', dataList);

        // create the list table
        this.initTable(cmp);
    },

    /**
     * Callback for the onSelected event of the action menu. The row
     * and actionName attributes will automatically be passed into  this
     * function from the Dal_ListBase which this component extends.
     * @param row - row in which the action was selected
     * @param actionName - name of action selected
     */
    handleActionOnSelect: function(row, actionName){

        switch (actionName) {
            case 'downloadPdf':
                console.log('Download PDF Details: ' + JSON.stringify(row));
                break;
        }

    }

})