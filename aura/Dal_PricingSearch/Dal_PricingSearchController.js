/**
 * Created by 7Summits on 4/9/18.
 */
({
    init: function(cmp, evt, helper){
        var today = $A.localizationService.formatDateTime(new Date(), 'yyyy-MM-dd');
        cmp.set('v.effectiveDate', today);
    },

    handleDateChange : function(cmp, evt, helper) {
        var effectiveDate = cmp.get('v.effectiveDate');

        var isDateValid = helper.isDateValid(cmp, effectiveDate);

        if(isDateValid === true){
            var listComponent = cmp.find('pricingListComponent');
            listComponent.searchPriceRecordList(effectiveDate);
        }
    }

})