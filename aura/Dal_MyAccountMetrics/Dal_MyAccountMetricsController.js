/**
 * Created by 7Summits on 2/19/18.
 */
({

    init: function(cmp, evt, helper){
        helper.getAccountMetrics(cmp);
    },

    ctaClicked: function(cmp, evt, helper){
        var url = cmp.get('v.ctaUrl');
        helper.doGotoURL(url);
    }

})