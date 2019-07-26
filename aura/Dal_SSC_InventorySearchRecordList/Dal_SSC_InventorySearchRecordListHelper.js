/**
 * Created by Yadav on 10/31/2018.
 */
({

    getExternalData : function(cmp,event,helper,paramValue){
    //    debugger;

         cmp.set('v.isInventoryBaseLoading',true);
         cmp.set('v.isPageLoading',true);

         //console.log('paramValue: ', paramValue);

         try {



         var par = JSON.stringify(paramValue);

         var _params = {
             data : par
         };

         this.doCallout(cmp, "c.getInventoryRecord", _params, function(response){
             var state = response.getState();
             if(state === "SUCCESS"){
                cmp.set('v.isInventoryBaseLoading',false);
                cmp.set('v.isPageLoading',false);

                var _resp = response.getReturnValue();
                var listOfSelectedProducts = cmp.get('v.listOfSelectedProducts');

                console.log("RES for 2nd page---> ",_resp);

                var updatedRespList = [];
                 if(_resp){

                     console.log('IN If: ',JSON.stringify(listOfSelectedProducts[0]));
                for(var i=0;i<_resp.length;i++) {

                    var respWrapper = {};
                    respWrapper = _resp[i];
					
                    if(!respWrapper.totalCartons)
                        respWrapper.totalCartons = '0'; 
                    
                    if(!respWrapper.availableQty)
                        respWrapper.availableQty = '0';
                    
                    if(listOfSelectedProducts[i].Size__c)
                   		respWrapper.Size = listOfSelectedProducts[i].Size__c;

                    if(listOfSelectedProducts[i].Description)
                    	respWrapper.Description = listOfSelectedProducts[i].Description;

                    if(listOfSelectedProducts[i].Product_Color__r)
                    	respWrapper.Color = listOfSelectedProducts[i].Product_Color__r.Name;

                    if(listOfSelectedProducts[i].Base_UoM__c)
                        respWrapper.BaseUOM = listOfSelectedProducts[i].Base_UoM__c;

                    respWrapper.ShowTill = 5;

                    console.log('respWrapper: ',respWrapper);
                    var uomList = [];
                    var uoms = listOfSelectedProducts[i].UOM__c;
                    uomList =  uoms.split(';');
					
                    if(respWrapper.dateAtSupplyPlant) {
                        let to = respWrapper.dateAtSupplyPlant;
                        let _tos = to.split('-');
                        if(parseInt(_tos[1]) < 10)
                            _tos[1] = '0' + _tos[1];
                        if(parseInt(_tos[2]) < 10)
                            _tos[2] = '0' + _tos[2];

                        let _newTo = _tos[1] + '-' + _tos[2];
                        if(respWrapper.dateAtSupplyPlantFinal) {
                            var forD = respWrapper.dateAtSupplyPlantFinal;
                            var _forDs = forD.split('-');
                            if(parseInt(_forDs[1]) < 10)
                                _forDs[1] = '0' + _forDs[1];
                            if(parseInt(_forDs[2]) < 10)
                                _forDs[2] = '0' + _forDs[2];

                            var _newforD = _forDs[1] + '-' + _forDs[2];
                        }
                        respWrapper.dateAtSupplyPlant = _newTo;
                        respWrapper.dateAtSupplyPlantFinal = _newforD;
                    }
                    
                    respWrapper.uomList = uomList;
                    if(listOfSelectedProducts[i].PiecesPerCarton__c)
                        respWrapper.PiecesPerCarton__c = listOfSelectedProducts[i].PiecesPerCarton__c;
                    if(listOfSelectedProducts[i].SquarefeetPerCarton__c)
                        respWrapper.SquarefeetPerCarton__c = listOfSelectedProducts[i].SquarefeetPerCarton__c;

                    updatedRespList.push(respWrapper);
                }

                cmp.set('v.finalResponseWrapper', updatedRespList);

                //Fire an event
                var appEvent = $A.get("e.c:Dal_SSC_InventorySearchCurrentPage");
                appEvent.setParams({ "currentPos" : 2 });
                appEvent.fire();

                //Navigate to next Page
                cmp.set('v.count',0);
                cmp.set('v.pos', 2);
                }
             } else {
                 cmp.set('v.isInventoryBaseLoading',false);
                 cmp.set('v.isPageLoading',false);
             }
         });

         } catch(ex) {
              cmp.set('v.isInventoryBaseLoading',false);
             cmp.set('v.isPageLoading',false);
         }
    }

})