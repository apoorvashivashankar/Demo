/**
 * Created by 7Summits on 4/24/18.
 */
({
    init: function(cmp, evt, helper){
        helper.getMaterialList(cmp);
    },
    searchPriceRecordList: function(cmp, event, helper){
        console.log("Search!");
        var parameters = event.getParam('arguments');
        if(parameters){
            var sku = parameters.skuValue;
            var description = parameters.descriptionValue;
            helper.searchPriceList(cmp, sku, description);
        }

    }
})