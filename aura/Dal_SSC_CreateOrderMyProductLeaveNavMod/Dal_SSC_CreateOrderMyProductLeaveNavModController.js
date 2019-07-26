/**
 * Created by ranja on 25-01-2019.
 */
({
    closeModal : function(cmp,event,helper) {
        cmp.set('v.showModal',false);
    },

    handleLeavePage : function(cmp,event,helper) {
        let _id = cmp.get('v.idToNavigate');

        let appEvent = $A.get("e.c:Dal_SSC_CreateOrderHideGSearchEvent");
        appEvent.fire();

        cmp.getSuper().navigate(_id);
        cmp.set('v.showModal',false);
    },
})