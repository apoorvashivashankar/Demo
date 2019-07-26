/**
 * Created by 7Summits on 3/7/18.
 */
({

    rerender : function(cmp, helper){
        this.superRerender();
        helper.handleStoreUpdate(cmp);
        helper.setStickyFooter(cmp);
    },

    afterRender: function (cmp, helper) {
        this.superAfterRender();
        helper.initStickyFooter();
        helper.setStickyFooter(cmp);
    }

})