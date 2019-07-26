/**
 * Created by ranja on 31-12-2018.
 */
({
    handleCreateOrderMyProductList : function(cmp,event,helper) {
        var newHeading = event.getParam('pageName');
        cmp.set('v.productSkuName',event.getParam('skuName'));
        cmp.set('v.isCreateOrderHeader',true);
        cmp.set('v.labelProductSearch',newHeading);
    },

    handleMyCart : function(cmp,event,helper) {
        var newHeading = event.getParam('headerText');
        cmp.set('v.isCreateOrderHeader',false);
        cmp.set('v.labelProductSearch',newHeading);
    },

})