/**
 * Created by ranja on 13-11-2018.
 */
({
    getAllProductsOfSeries : function (cmp, _serId) {
    //    debugger;
        this.doCallout(cmp, 'c.getInventoryColorCodes', {SeriesId : _serId}, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                cmp.set('v.listOfColors', response.getReturnValue());
                console.log('Resp for color: ', response.getReturnValue());
            }
        });
    },

    getSearchedProductBySku : function(cmp,event,helper){
    //    debugger;

        cmp.set('v.isInventoryBaseLoading',true);
        cmp.set('v.isPageLoading', true);

        var listOfColors = cmp.get('v.listOfColors');
        var _selectedColor = cmp.get("v.selectedColor");
        var _params = [];

        if(_selectedColor === "All") {
            if(listOfColors.length > 0) {
                for(var i=0;i<listOfColors.length;i++)
                    _params.push(listOfColors[i].colorCode);
            }
        } else {
            _params.push(_selectedColor);
        }
        helper.getSearchedProductBySkuColl(cmp,event,helper,_params);
    },

    getExternalData : function(cmp,event,helper,paramValue){
    //   debugger;

         cmp.set('v.isInventoryBaseLoading',true);
         cmp.set('v.isPageLoading',true);

         //console.log('paramValue: ', paramValue);
         var par = JSON.stringify(paramValue);

         var _params = {
             data : par
         };

         console.log('_params: ', _params);

         this.doCallout(cmp, "c.getInventoryRecord", _params, function(response){
             var state = response.getState();
             if(state === "SUCCESS"){
                var _resp = response.getReturnValue();

                console.log("RES for 2nd page---> ",response.getReturnValue());
                cmp.set('v.finalResponseWrapper', response.getReturnValue());

                //Fire an event
                var appEvent = $A.get("e.c:Dal_SSC_InventorySearchCurrentPage");
                appEvent.setParams({ "currentPos" : 2 });
                appEvent.fire();

                //Navigate to next Page
                cmp.set('v.count',0);
                cmp.set('v.pos', 2);
                cmp.set('v.isInventoryBaseLoading',false);
                cmp.set('v.isPageLoading',false);
             } else {
                 cmp.set('v.count',0);
                 cmp.set('v.isInventoryBaseLoading',false);
                 cmp.set('v.isPageLoading',false);
             }
         });
    }

})