/**
 * Created by 7Summits on 5/16/18.
 */
({

    init: function(cmp, evt, helper){
        helper.submit(cmp);

        var pageUrl = window.location.href;
        var hashIndex = pageUrl.lastIndexOf('#');
        var selectedProductType = pageUrl.substring(hashIndex+1,pageUrl.length);

        if(selectedProductType == 'reschedule') {
            cmp.set("v.isReschedule",true);
        } else {
            cmp.set("v.isReschedule",false);
        }
    },

    handleClose: function(cmp, evt, helper){
        var store = cmp.get('v.store');
        var isLastOrder = cmp.get('v.isLastOrder');
        var hasSavingError = cmp.get('v.hasSavingError');

        // If this is the last order to schedule, we want to redirect the
        // user to the my orders page if not just close the modal
        if(isLastOrder === true && hasSavingError === false){
            helper.doGotoURL('/my-orders');
        } else {
            cmp.find('overlayLib').notifyClose();
            store.scrollToTop();
        }
        
    }

})