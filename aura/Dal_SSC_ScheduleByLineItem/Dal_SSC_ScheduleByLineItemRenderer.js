/**
 * Created by 7Summits on 5/10/18.
 */
({
    /*render : function(cmp, helper) {
        var ret = this.superRender();
        helper.handleStoreUpdate(cmp);
        return ret;
    },*/

    rerender : function(cmp, helper){
        this.superRerender();
        helper.handleStoreUpdate(cmp);
    },

    afterRender: function (cmp, helper) {
        this.superAfterRender();
        helper.handleStoreUpdate(cmp);
    }

})