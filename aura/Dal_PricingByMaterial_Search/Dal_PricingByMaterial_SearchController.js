/**
 * Created by 7Summits on 4/9/18.
 */
({
    init: function(cmp, evt, helper){
        // get the url params
        var effectiveDate = helper.getUrlParamByName('effectiveDate');
        var appliedPromotion =  helper.getUrlParamByName('PriceRecordCode__c');

        // check if we have an effective date, if not set it to today
        var today = new Date();
        effectiveDate = (effectiveDate !== undefined && effectiveDate !== null) ? effectiveDate : (today.getFullYear() + '-' + (today.getMonth()+1) + '-' + today.getDate());

        // check if we have an appliedPromotion passed in
        appliedPromotion = (appliedPromotion !== undefined && appliedPromotion !== null) ? appliedPromotion : 'none';

        // set to the view
        cmp.set('v.effectiveDate', effectiveDate);
        cmp.set('v.appliedPromotion', appliedPromotion);
        cmp.set('v.isInitPricingByMaterialSearch', true);
    },

    searchPromotions: function(component, event, helper) {
        var header = component.find('pricingHeaderComponent');
        var headerDate = header.get('v.effectiveDate');
        var headerPromotion = header.get('v.appliedPromotion');

        component.set('v.effectiveDate', headerDate);
        component.set('v.appliedPromotion', headerPromotion);

        var listComponent = component.find('pricingListComponent');
        var effectiveDate = component.get('v.effectiveDate');
        var promotionrecord = component.get('v.appliedPromotion');
        var skuNumber = component.get('v.skuNumber');
        var description = component.get('v.description');

        listComponent.searchPromotionList();
    },

    handleDatePromoChange: function(cmp){
        // just reset the search inputs
        cmp.set('v.skuNumber', '');
        cmp.set('v.description', '');
    }

})