/**
 * Created by 7Summits on 4/26/18.
 */
({
    init: function(cmp, evt, helper) {
        helper.init(cmp);
    },

    handleDateChange : function(cmp, evt, helper) {
        helper.handleDateChange(cmp);
    },

    handleAppliedPromotionChange: function(cmp, evt, helper){
        var promotions = cmp.get('v.promotions');
        helper.setPriceRecords(cmp, promotions);
        helper.handlePromoChange(cmp);
    }

})