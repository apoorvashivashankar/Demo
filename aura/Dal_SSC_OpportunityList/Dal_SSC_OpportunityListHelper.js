/**
 * Created by presh on 22-11-2018.
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
              cmp.set('v.oppDateStarts', startDate.getFullYear() + "-" + (MM) + "-" + dd);
              console.log('after setting '+cmp.get('v.oppDateStarts'));
              //cmp.set('v.orderDateEnds', today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + (today.getDate() +1));
              cmp.set('v.oppDateEnds', today.getFullYear() + "-" + (tMM) + "-" + (tdd));
              console.log('after setting '+cmp.get('v.oppDateEnds'));

             // set the controller action type
              var actionName = 'c.searchOpenOpportunity';

              var listLimit = cmp.get("v.listMaximum");

              var oppDateStart = new Date(cmp.get("v.oppDateStarts"));
              var oppDateEnd = new Date(cmp.get("v.oppDateEnds"));

              var params = {
                'oppDateToui' : oppDateEnd,
                 'oppDateFromui' : oppDateStart
              };

              // make call to controller to get open items
              var promise = this.doListCallout(cmp, actionName, params);

              // set callbacks for callout response
              promise.then(function(response){
                  console.log('RESPONSE: ', response);

                  if(response.length > 0){
                      cmp.set("v.isButton",true);
                      cmp.set("v.responseList");
                  }
                  self.handleLeadList(cmp, response);
                  //self.handleDataOverage(cmp, response[0].length, listLimit);
              });
            },

        searchOpportunityList: function(cmp, name, account, oppDateStart, oppDateEnd, oppStage){
        //            debugger;
                   var self = this;

                   // set the controller action type
                   var actionName = 'c.searchAllOpportunity';

                    var listLimit = cmp.get("v.listMaximum");

                   var params = {

                       'name': name,
                       'account': account,
                       'oppDateStart': oppDateStart,
                       'oppDateEnd': oppDateEnd,
                       'oppStage': oppStage,
                       /*'listLimit' : 20*/
                   };

                   // make call to controller to get open items
                   var promise = this.doListCallout(cmp, actionName, params);

                   // set callbacks for callout response
                   promise.then(function(response){

                       if(response.length > 0){
                      	cmp.set("v.isButton",true);
                        cmp.set("v.responseList");
                  		}
                       self.handleLeadList(cmp, response);
                      // self.handleDataOverage(cmp, response[0].length, listLimit);
                   });

        }, // end initOpenItems

        handleLeadList : function (cmp, response){
        //    debugger;
             cmp.set('v.columns', [
                 {type: 'checkbox'},
                 {label: 'OPPORTUNITY NAME', fieldName: 'Name', type: 'textLink',urlName: 'oppLink', sortable: true},
                 {label: 'ACCOUNT', fieldName: 'AccountName', type: 'text', sortable: true},
                 {label: 'RATING', fieldName: 'Rating', type: 'text', sortable: true},
                 /*{label: 'PRODUCT', fieldName: 'Product_Type__c', type: 'text', sortable: true},*/
                 {label: 'STAGE', fieldName: 'StageName', type: 'text', sortable: true},
                 {label: 'CLOSE DATE', fieldName: 'CloseDate', type: 'date', sortable: true}
             ]);

             var rowData = [];

                     // make sure we have valid response data
                     if(response !== undefined && Array.isArray(response)){

                         response.forEach(function(item, index){

                             rowData.push({
                                 id: index,
                                 oppLink: '/opportunity/'+item.Id,
                                 Name: item.Name,
                                 AccountName: item.Account.Name,
                                 Rating: item.Rating__c,
                                 StageName: item.StageName,
                                 CloseDate: (item.CloseDate) || ''

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