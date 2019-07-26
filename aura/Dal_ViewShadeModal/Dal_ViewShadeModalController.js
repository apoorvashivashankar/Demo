/**
 * Created by 7Summits on 4/11/18.
 */
({
    init:function(component, event, helper) {
       helper.getShadeDetails(component);
    },
    handleClose: function(cmp){
        cmp.find('overlayLib').notifyClose();
    }
})