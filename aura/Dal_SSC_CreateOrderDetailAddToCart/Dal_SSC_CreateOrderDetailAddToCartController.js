/**
 * Created by ranja on 02-01-2019.
 */
({

    navigateToBrowseProducts : function (cmp,event,helper) {
        /*
        var appEvent = $A.get("e.c:Dal_SSC_CreateOrderProdListCaptureEvt");
        appEvent.setParams({ "quantity" : 0 });
        appEvent.fire();

        var appEvent1 = $A.get("e.c:Dal_SSC_MyCartQuantityUpdateEvent");
        appEvent1.setParams({ "cartTotal" : finalResponseWrapperResp.length, 'action' : 'ADD' });
        appEvent1.fire();

        let appEvent2 = $A.get("e.c:Dal_SSC_CreateOrderHideGSearchEvent");
        appEvent2.fire(); 
        */

        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/products'
        });
        urlEvent.fire();
    },

    handleViewCart : function(cmp,event,helper) {
        debugger;


/*
        var finalResponseWrapper = cmp.get('v.finalResponseWrapper');
        for(var i=0;i<finalResponseWrapper.length;i++) {
            finalResponseWrapper[i].PiecesPerCarton = finalResponseWrapper[i].PiecesPerCarton__c;
            finalResponseWrapper[i].SquarefeetPerCarton = finalResponseWrapper[i].SquarefeetPerCarton__c;
        }
 
        console.log('finalResponseWrapper: ',finalResponseWrapper);
        cmp.set('v.finalResponseWrapper',finalResponseWrapper);
        helper.doCallout(cmp, "c.addToCart", {cartValue : JSON.stringify(finalResponseWrapper)}, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var _resp = response.getReturnValue();
                console.log('Resp for View Cart: ', _resp);
                var finalResponseWrapperResp = cmp.get('v.finalResponseWrapper');

                var appEvent = $A.get("e.c:Dal_SSC_MyCartQuantityUpdateEvent");
                appEvent.setParams({ "cartTotal" : finalResponseWrapperResp.length, 'action' : 'ADD' });
                appEvent.fire();

                var appEvent = $A.get("e.c:Dal_SSC_CreateOrderProdListCaptureEvt");
                appEvent.setParams({ "quantity" : 0 }); 
                appEvent.fire();

                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": '/mycart'
                });
                urlEvent.fire();

            }
        });
*/
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/mycart'
        });
        urlEvent.fire();
    },

    showMoreSku : function(cmp,event,helper) {
        var addMore = cmp.get('v.addMore');
        var showTill = cmp.get('v.showTill');

        showTill = showTill + addMore;
        cmp.set('v.showTill',showTill);
    },

})