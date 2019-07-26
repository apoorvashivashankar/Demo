/**
 * Created by 7Summits on 4/17/18.
 */
({
    init: function(cmp, evt, helper) {
        helper.getOrderInfo(cmp, evt, helper);
    },
    print: function (cmp, evt, helper) {
        window.print();
    },
    handleClone: function (cmp, evt, helper){
        helper.cloneOrder(cmp, evt, helper);
    },

    handleLinkClick : function(cmp, evt, helper){
        var _link = evt.getSource().get('v.value');
        console.log(_link);
        $A.get("e.force:navigateToURL").setParams({
            "url": _link
        }).fire();
    }
})