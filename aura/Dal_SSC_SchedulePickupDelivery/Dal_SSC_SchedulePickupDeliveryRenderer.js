/**
 * Created by 7Summits on 4/26/18.
 */
({

    rerender : function(cmp, helper){
        this.superRerender();
        helper.handleStoreUpdate(cmp);
    }

})