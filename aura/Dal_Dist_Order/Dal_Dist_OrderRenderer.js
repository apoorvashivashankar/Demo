/**
 * Created by 7Summits on 4/12/18.
 */
({
    rerender : function(cmp, helper){
        this.superRerender();
        helper.init(cmp);
    }
})