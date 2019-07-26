/**
 * Created by ranja on 13-11-2018.
 */
({
    setProductType : function(cmp,event,helper) {
        cmp.set('v.isProductSelected',true);
        cmp.set('v.isInventoryBaseLoading',true);
        cmp.set('v.isPageLoading', true);

        var selectedProductType = cmp.get('v.selectedProductType');
        if(selectedProductType == 'Branded Product') {
            console.log('true');

            cmp.set('v.isBranded',true);
        } else {
            console.log('false ');
            cmp.set('v.isBranded',false);
        }

        helper.doCallout(cmp, "c.getDivision", {}, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var _resp = response.getReturnValue();

                cmp.set('v.divisionCode',_resp);
                console.log('divisionCode: ', _resp);
                cmp.set('v.isInventoryBaseLoading',false);
                cmp.set('v.isPageLoading', false);
            } else {
                 cmp.set('v.isInventoryBaseLoading',false);
                 cmp.set('v.isPageLoading', false);
            }
        });

    },

    handleSearchClick : function(cmp,event,helper) {
    //    debugger;
         cmp.set('v.isInventoryBaseLoading',true);
         cmp.set('v.isPageLoading', true);
        cmp.set('v.skuKeyword','');
         cmp.set('v.isFilterOpen',true);
        var paramValue = cmp.get('v.skuKeyword');

        if(paramValue) {
        var _params = {
            searchParameter : paramValue
        };
        helper.doCallout(cmp, "c.getProduct", _params, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var _resp = response.getReturnValue();
                console.log('Key: ', _resp);

                var custResp = {};
                var skuList = [];
                custResp = response.getReturnValue();

                for(var i=0;i<custResp.length;i++) {
                    custResp[i].isChecked = false;
                    if(i<30){
                        skuList.push(custResp[i]);
                    }
                }
                var pgNb = Math.ceil((custResp.length) / 30) ;
                var totalPages = (custResp.length > 30) ? pgNb :  1 ;

                cmp.set('v.responseWrapperData', custResp);
                cmp.set('v.totalPages', totalPages);
                cmp.set('v.displayProdList',skuList);
                cmp.set('v.pageNumber',1);
                cmp.set('v.isInventoryBaseLoading',false);
                 cmp.set('v.isPageLoading', false);
            } else {
                 cmp.set('v.isInventoryBaseLoading',false);
                 cmp.set('v.isPageLoading', false);
            }
        });
        }
    }

})