/**
 * Created by presh on 21-11-2018.
 */
({
    getLeadList : function (cmp){
          var self = this;
          var today = new Date();
          var startDate = new Date(new Date().setDate(new Date().getDate() - 30));
          var dd = (startDate.getDate() < 10 ? '0' : '') + startDate.getDate();
          var MM = ((startDate.getMonth() + 1) < 10 ? '0' : '') + (startDate.getMonth() + 1);
          var tdd = (today.getDate() < 10 ? '0' : '') + today.getDate();
          var tMM = ((today.getMonth() + 1) < 10 ? '0' : '') + (today.getMonth() + 1);
          //cmp.set('v.orderDateStarts', startDate.getFullYear() + "-" + (startDate.getMonth() + 1) + "-" + startDate.getDate());
          cmp.set('v.leadDateStarts', startDate.getFullYear() + "-" + (MM) + "-" + dd);
          console.log('after setting '+cmp.get('v.leadDateStarts'));
          //cmp.set('v.orderDateEnds', today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + (today.getDate() +1));
          cmp.set('v.leadDateEnds', today.getFullYear() + "-" + (tMM) + "-" + (tdd));
          console.log('after setting '+cmp.get('v.leadDateEnds'));

         // set the controller action type
          var actionName = 'c.searchOpenLead';

          var listLimit = cmp.get("v.listMaximum");

          var leadDateStart = new Date(cmp.get("v.leadDateStarts"));
          var leadDateEnd = new Date(cmp.get("v.leadDateEnds"));

          var params = {
            'leadDateToui' : leadDateEnd,
            'leadDateFromui' : leadDateStart
          };

          // make call to controller to get open items
          var promise = this.doListCallout(cmp, actionName, params);

          // set callbacks for callout response
          promise.then(function(response){
              console.log('RESPONSE: ', response);
              self.handleLeadList(cmp, response);
              //self.handleDataOverage(cmp, response[0].length, listLimit);
          });
        },

    searchLeadList: function(cmp, firstname,lastname, leadSource, leadScore, leadDateStart, leadDateEnd, leadStatus){
          //      debugger;
               var self = this;

               // set the controller action type
               var actionName = 'c.searchAllLeads';

                var listLimit = cmp.get("v.listMaximum");

               var params = {
                   'firstname': firstname,
                   'lastname': lastname,
                   'leadSource': leadSource,
                   'leadScore' : leadScore,
                   'leadDateFrom': leadDateStart,
                   'leadDateTo': leadDateEnd,
                   'lineStatus': leadStatus,
                    /*'listLimit' : 20*/
               };

               // make call to controller to get open items
               var promise = this.doListCallout(cmp, actionName, params);

               // set callbacks for callout response
               promise.then(function(response){
                   self.handleLeadList(cmp, response);
                  // self.handleDataOverage(cmp, response[0].length, listLimit);
               });

    }, // end initOpenItems

    handleLeadList : function (cmp, response){
    //    debugger;
         cmp.set('v.columns', [
            {label: 'FIRST NAME', fieldName: 'FirstName', type: 'textLink', urlName: 'leadLink', sortable: true},
            {label: 'LAST NAME', fieldName: 'LastName', type: 'text', sortable: true},
             {label: 'LEAD SOURCE', fieldName: 'LeadSource', type: 'text', sortable: true},
             {label: 'LEAD SCORE', fieldName: 'LeadScore', type: 'text', sortable: true},
             /*{label: 'PRODUCT', fieldName: 'Product_Type__c', type: 'text', sortable: true},*/
             {label: 'STATUS', fieldName: 'Status', type: 'text', sortable: true},
             {label: 'CREATED', fieldName: 'CreatedDate', type: 'date', sortable: true}
         ]);

         var rowData = [];

                 // make sure we have valid response data
                 if(response !== undefined && Array.isArray(response)){

                     response.forEach(function(item, index){

                         rowData.push({
                             id: index,
                             
                             leadLink: '/lead/'+item.Id,
                             FirstName: item.FirstName,
                             LastName: item.LastName,
                             LeadSource: item.LeadSource,
                             LeadScore: item.Lead_Score__c,
                             Status: item.Status,
                             CreatedDate: (item.CreatedDate) || ''

                         });

                     });
                 }

                 // Row Data: Note 'fieldName' from the column must have a matching
                 // attribute in the row data.
                 cmp.set('v.data', rowData);

                 this.initTable(cmp);
    },
    handleDataOverage: function(cmp, recordCount, totalCount){
         var _overageLabel = '';
         if(recordCount >= totalCount){
             _overageLabel = 'There are more results than can be displayed. Please try more specific search criteria.';
         }
         cmp.set('v.pageMessage', _overageLabel);

    }

})