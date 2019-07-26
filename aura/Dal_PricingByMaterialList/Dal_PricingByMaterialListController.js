/**
 * Created by 7Summits on 4/4/18.
 */
({
    init: function(cmp, evt, helper){
        helper.init(cmp);
    },

    searchPromotionList: function(component, event, helper) {
        var effectiveDate = component.get("v.effectiveDateValue");
        var appliedPromotion = component.get("v.appliedPromotion");
        var skuNumber = component.get("v.skuNumber");
        var description = component.get("v.description");
        helper.searchPromotionList(component, effectiveDate, appliedPromotion, skuNumber, description);
    },

    handleDatePromoChange: function(cmp, evt, helper){
        var isLoading = evt.getParam('isLoading');
        var effectiveDate = evt.getParam('effectiveDate');
        var appliedPromotionCode = evt.getParam('appliedPromotionCode');

        if(isLoading === false && appliedPromotionCode !== undefined && effectiveDate !== undefined){
            cmp.set('v.appliedPromotion', appliedPromotionCode);
            cmp.set('v.effectiveDateValue', effectiveDate);
            helper.getMaterialRecords(cmp);
        } else {
            cmp.set('v.isLoading', isLoading);
        }
    }


})