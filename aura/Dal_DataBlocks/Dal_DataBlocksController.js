/**
 * Created by 7Summits on 2/28/18.
 */
({

     init: function(cmp, evt, helper){
            cmp.set("v.isSSC", ((window.location.href.indexOf('SSC') > -1) || (window.location.href.indexOf('tradeproexchange') > -1)));
            console.log('isSSC', cmp.get("v.isSSC"));
     },

    handleToggleDetail: function(cmp, evt, helper){
        helper.handleToggleDetail(cmp, evt);
    }

})