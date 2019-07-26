/**
 * Created by 7Summits on 4/4/18.
 */
({
    init: function(cmp, evt, helper){
        var today = $A.localizationService.formatDateTime(new Date(), 'yyyy-MM-dd');
        cmp.set('v.effectiveDate', today);
        helper.getPriceList(cmp);
    },

    searchPriceRecordList: function(cmp, event, helper){
        var parameters = event.getParam('arguments');

        if(parameters !== undefined && parameters.effectiveDate !== undefined){
            cmp.set('v.effectiveDate', parameters.effectiveDate);
            helper.getPriceList(cmp);
        }

    }
})