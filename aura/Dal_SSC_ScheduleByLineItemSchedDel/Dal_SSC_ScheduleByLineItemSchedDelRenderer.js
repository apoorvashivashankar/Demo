/**
 * Created by 7Summits on 5/14/18.
 */
({

    rerender : function(cmp, helper){
        this.superRerender();
        helper.handleStoreUpdate(cmp);
    },

    afterRender: function (cmp, helper) {
        this.superAfterRender();
        helper.handleStoreUpdate(cmp);
    }

})