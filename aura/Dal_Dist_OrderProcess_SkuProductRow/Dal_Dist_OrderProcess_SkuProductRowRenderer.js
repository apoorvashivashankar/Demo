/**
 * Created by 7Summits on 4/5/18.
 */
({

    rerender : function(cmp, helper){
        this.superRerender();
        helper.init(cmp);
    },

    afterRender: function (cmp, helper) {
        this.superAfterRender();
        helper.init(cmp);
    }

})