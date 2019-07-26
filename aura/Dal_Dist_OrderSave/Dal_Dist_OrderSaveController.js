/**
 * Created by 7Summits on 5/7/18.
 */
({

    handleSave: function(cmp, evt, helper){
        helper.save(cmp);
    },

    handleClose: function(cmp){
        cmp.find('overlayLib').notifyClose();
    },

    handleGoToSavedOrders: function(cmp, evt, helper){
        helper.goToSavedOrderPage();
    }

})