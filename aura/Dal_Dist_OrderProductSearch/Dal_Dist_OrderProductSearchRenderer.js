/**
 * Created by 7Summits on 5/2/18.
 */
({

    rerender : function(cmp, helper){
        this.superRerender();
        helper.checkForResultsAlreadyInCart(cmp);
    }

})