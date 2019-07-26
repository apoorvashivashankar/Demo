/**
 * Created by 7Summits on 4/30/18.
 */
({
    
    rerender : function(cmp, helper){
        this.superRerender();
        // rerender only is on desktop due to iOS bug with datepicker
        // TODO: update if datepicker issue is resolved
        if($A.get("$Browser.formFactor") === "DESKTOP") {
            helper.handleStoreUpdate(cmp);
        }
    },

    afterRender: function (cmp, helper) {
        this.superAfterRender();
        
        helper.handleStoreUpdate(cmp);
    }
})