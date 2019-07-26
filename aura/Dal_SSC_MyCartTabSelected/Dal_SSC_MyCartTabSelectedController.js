/**
 * Created by ranja on 07-01-2019.
 */
({
    navigateToProductSearch : function(cmp,event,helper) {

        //Navigate to Browse Products
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": '/products'
        });
        urlEvent.fire();
    },

})