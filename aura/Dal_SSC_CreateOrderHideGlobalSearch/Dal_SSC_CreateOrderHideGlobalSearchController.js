/**
 * Created by ranja on 23-01-2019.
 */
({
    initialize : function(cmp,event,helper) {
        var appEvent = $A.get("e.c:Dal_SSC_CreateOrderHideGSearchEvent");
        appEvent.fire();

    },
})