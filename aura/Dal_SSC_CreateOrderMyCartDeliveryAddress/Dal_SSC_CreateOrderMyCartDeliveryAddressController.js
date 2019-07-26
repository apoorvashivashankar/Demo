/**
 * Created by ranja on 08-01-2019.
 */
({
    handleCancel : function(cmp) {
        cmp.find('overlayLib').notifyClose();
    },

    handleChangeAddress : function(cmp,event,helper) {
        helper.handleSaveAddress(cmp);
        cmp.find('overlayLib').notifyClose();

    },

})