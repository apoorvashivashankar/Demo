/* *
 * Created by ranja on 31-10-2018.
 */
({
    doInit : function(cmp,event,helper) {
        cmp.set('v.isInventoryBaseLoading',false);
        cmp.set('v.isPageLoading',false);
        debugger;

        var today = new Date();
        var tomorrow = new Date();
        tomorrow.setDate(today.getDate()+1);
        var _newDate = tomorrow.getFullYear() + '-' + (tomorrow.getMonth()+1) + '-' + tomorrow.getDate() ;
        var d=_newDate.split("-");
        var newDateByString = new Date(d[0],d[1]-1,d[2]);

        cmp.set('v.tomorrowsDate',newDateByString);
    },

    createNewInventory : function(cmp, event, helper) {
        var prodType = cmp.get('v.selectedProductType');
        var hashProd = '';
        if(prodType === 'Branded Product') {
            hashProd = 'bp';
        } else if(prodType === 'Installation Product') {
            hashProd = 'ip';
        }
        helper.goToURL('inventorysearch/#'+ hashProd);
    },

    openCalculator : function(cmp,event,helper) {
         debugger;

        var finalResponseWrapper = cmp.get('v.finalResponseWrapper');
        var indexOfCalc = event.currentTarget.name;


        helper.openModal(cmp,'c:Dal_SSC_Inventory_madalCalculator',{
             listOfUOM : finalResponseWrapper[indexOfCalc].uomList,
             materialId : finalResponseWrapper[indexOfCalc].sku
           },
             true,
            'dal-modal_small'
         );

    },

    clearSelectedValue : function(cmp,event,helper) {
         debugger;

        var indexSelected = event.currentTarget.value;
        var finalResponseWrapper = cmp.get('v.finalResponseWrapper');

        finalResponseWrapper.splice(indexSelected,1);
        cmp.set('v.finalResponseWrapper',finalResponseWrapper);
    },

    handleShowMore : function(cmp,event,helper) {
        debugger;

        var indexOfShowMore = event.getSource().get('v.value');
        var finalResponseWrapper = cmp.get('v.finalResponseWrapper');

        finalResponseWrapper[indexOfShowMore].ShowTill = finalResponseWrapper[indexOfShowMore].ShowTill + 5;

        cmp.set('v.finalResponseWrapper',finalResponseWrapper);
    },

    changeSelectedMiles : function(cmp,event,helper) {
        debugger;

        var skuIndex = event.getSource().get('v.name');
        var finalResponseWrapper = cmp.get('v.finalResponseWrapper');

        cmp.set('v.showSpinner',true);

        var action = cmp.get("c.getMiles");
        action.setParams({
            sku : finalResponseWrapper[skuIndex].sku,
            UOM : finalResponseWrapper[skuIndex].pricingUOM,
            milesRadius : finalResponseWrapper[skuIndex].selectedMile
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var _resp = response.getReturnValue();
                console.log('_resp: ',_resp);
                var finalResponseWrapper = cmp.get('v.finalResponseWrapper');
                /*
                var _listOfMiles = [];
                for(var i=0;i<5;i++) {
                    _listOfMiles.push(_resp[i]);
                } 
                */
                finalResponseWrapper[skuIndex].milesWrapperList = _resp;  
                //finalResponseWrapper[skuIndex].showTill = 5; 
                cmp.set('v.finalResponseWrapper',finalResponseWrapper);
                cmp.set('v.showSpinner',false);
                console.log('finalResponseWrapper: ',finalResponseWrapper);
                
            } else {
                cmp.set('v.showSpinner',false);
            }
        });
        $A.enqueueAction(action); 
        

    }

})