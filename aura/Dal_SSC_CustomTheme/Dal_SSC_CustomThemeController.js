/**
 * Created by ranja on 14-01-2019.
 */
({
    doInit : function(cmp,event,helper) {
        debugger;
        var baseCommunityUrl = window.location.href;
        var isBrowseProducts = baseCommunityUrl.indexOf('products');
        if(isBrowseProducts === -1) {
            cmp.set('v.isBrowseProducts', false);
        } else {
            cmp.set('v.isBrowseProducts', true);
        }

        try{

        var action = cmp.get("c.getMyCartProductsCount");
        action.setCallback(this, function(actionResult) {
            var state = actionResult.getState();

            if (state === 'SUCCESS') {
                var _resp = actionResult.getReturnValue();
                console.log('------profile---Count'+JSON.stringify(_resp));
                cmp.set('v.countInMyCart',_resp.cartCount);
                cmp.set('v.profile',_resp.profileName);
                if(_resp.profileName != 'SSC Accounting' && _resp.profileName != 'SSC Statement Dealer Sales Rep' &&
                   _resp.profileName != 'SSC Sales Rep' &&  _resp.profileName != 'SSC Customer Service'){
                          cmp.set('v.isCartVisible',true);
                }

            }
        });
         $A.enqueueAction(action);

        } catch(ex) {
            console.log('Dal_SSC_CustomTheme:Exception');
        }
    },

    gotoMyCartPage : function(cmp,event,helper) {
		
         var urlEvent = $A.get("e.force:navigateToURL");
         urlEvent.setParams({
           "url": '/mycart' 
         });
         urlEvent.fire();
        cmp.set('v.isBrowseProducts', false);
    },

    updateCartProducts : function(cmp,event,helper) {
        var countInMyCart = cmp.get('v.countInMyCart');
        var count = event.getParam('cartTotal');
        var action = event.getParam('action');
        if(count) {
            if(action.toUpperCase() === 'ADD')
               countInMyCart = parseInt(countInMyCart) + count;
            else
               countInMyCart = parseInt(countInMyCart) - count;
        } 
        
        if(countInMyCart < 0)
            countInMyCart = 0;
            
        cmp.set('v.countInMyCart', countInMyCart);
    },

    handleGlobalSearchVisibility : function(cmp,event,helper) {
        //console.log('GLOBAL SEARCH HIDE EVENT FIRED');
        var baseCommunityUrl = window.location.href;
        var isBrowseProducts = baseCommunityUrl.indexOf('products');
        if(isBrowseProducts === -1) {
            cmp.set('v.isBrowseProducts', false);
        } else {
            cmp.set('v.isBrowseProducts', true);
        }
        //console.log('GLOBAL SEARCH HIDE EVENT FIRED',isBrowseProducts);
    },

    makeGlobalSearchVisible : function(cmp,event,helper) {
        //console.log('Make it visible event!!!');
        cmp.set('v.isBrowseProducts', false);
    },

})