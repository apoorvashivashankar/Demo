/**
 * Created by ranja on 12-11-2018.
 */
({
    handlePositionEvent : function(cmp,event,helper) {

        cmp.set('v.link2URL','/inventorysearch');
        cmp.set('v.link2Label','Inventory Search')
        cmp.set('v.link2IsLink',true);

        cmp.set('v.link3Label','Inventory List');
    },

    handlePageChange : function(cmp,event,helper) {
        var newLabel = JSON.parse(event.getParam('pageName'));

        cmp.set('v.link3Label',(newLabel.FirstName + ' ' + newLabel.LastName));
    },

    handleOppPageChange : function(cmp,event,helper) {
        var newLabel = event.getParam('pageName');
        //console.log('newLabel: ',newLabel);
        cmp.set('v.link3Label',newLabel);
    },

    handleCreateOrderMyProductList : function(cmp,event,helper) {
        var newLabel = event.getParam('pageName');
        cmp.set('v.link3Label',newLabel);

        cmp.set('v.link2URL','/products');
        cmp.set('v.link2Label','Products');
        cmp.set('v.link2IsLink',true);
    },

    updateProductList : function(cmp,event,helper) {
        var quantity = event.getParam('quantity');
        var profileName = event.getParam('profile');
        cmp.set('v.sizeOfSelectedProducts', parseInt(quantity));
        cmp.set('v.profileName', profileName);
    },

    gotoURL: function(cmp, evt, helper) {
        debugger;
        var url = evt.currentTarget.dataset.url;
        var target = evt.currentTarget.target;
        var profile = cmp.get('v.profileName');
        var baseCommunityUrl = window.location.href;
        var isBrowseProducts = baseCommunityUrl.indexOf('products');
        let flag = true;
        if(isBrowseProducts != -1) {
            if(profile == 'SSC Accounting' || profile == 'SSC Customer Service' || profile == 'SSC Sales Rep' ||
                profile == 'SSC Statement Dealer Sales Rep' ){
               console.log('profile--');
            }else{
                var sizeOfSelectedProducts = cmp.get('v.sizeOfSelectedProducts');
               if(sizeOfSelectedProducts > 0) {
                   helper.openModal(cmp,'c:Dal_SSC_CreateOrderLeavePageModal',
                    {url : url, target : target},
                    false,
                    'dal-modal_small'
                 );
                 flag = false;
               }
            }

        }
        if(flag)
            helper.doGotoURL(url, target);
    },
})