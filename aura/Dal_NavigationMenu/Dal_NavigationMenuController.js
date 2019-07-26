({
    doInit: function(component, event, helper){
        helper.getVisibilities(component);
        window.onclick = function(event) {
            var _target = event.target;
            var _matches;
            try{
                _matches =  _target.matches('.dal-sub-menu-trigger');
            }catch(ex){
                _matches =  _target.msMatchesSelector('.dal-sub-menu-trigger');
            }
            if (!_matches) {
                try{
                    _matches =  _target.matches('.dal-mobile-nav-btn');
                }catch(ex){
                    _matches =  _target.msMatchesSelector('.dal-mobile-nav-btn');
                }
                if (!_matches) {
                    component.set("v.mobileNavShown", false);
                    var _subMenuTriggers = document.getElementsByClassName("dal-sub-menu-trigger");
                    var i;
                    for (i = 0; i < _subMenuTriggers.length; i++) {
                        var _subMenuTrigger = _subMenuTriggers[i];
                        _subMenuTrigger.setAttribute('aria-expanded', 'false');
                        if(_subMenuTrigger.nextSibling.classList.contains("slds-is-open")) {
                            _subMenuTrigger.nextSibling.classList.remove("slds-is-open");
                        }
                    }
                }
            }
            
            var toggleLocationList = document.getElementById('locationListId');
            _matches = false;
            
            try{
                _matches =  _target.matches('.selectButton')? true: (_target.matches('.selectButton .icon') ? true : _target.matches('.selectButton .text')) ;
            }catch(ex){
                _matches =  _target.msMatchesSelector('.selectButton')? true: (_target.msMatchesSelector('.selectButton .icon') ? true : _target.msMatchesSelector('.selectButton .text'));
            }
            
            if (!_matches) {
                if(!toggleLocationList.classList.contains("slds-hide")) {
                     toggleLocationList.classList.add("slds-hide");    
                }
            }

        }
    },
    
    onClick: function(component, event, helper) {
        debugger;
        var _menuItem = event.target || event.src;
        var id = event.target.dataset.menuItemId;
        var _label = event.target.dataset.menuLabel;
        var _menuLabel = _menuItem.name;
        let flag = true;

        if(_menuLabel && _menuLabel.toUpperCase() === 'PRODUCTS') {
        var baseCommunityUrl = window.location.href;
        var isBrowseProducts = baseCommunityUrl.indexOf('products');
        var profile = component.get('v.profileName');
        if(isBrowseProducts != -1) {
            if(profile == 'SSC Accounting' || profile == 'SSC Customer Service' || profile == 'SSC Sales Rep' ||
                            profile == 'SSC Statement Dealer Sales Rep' ){
                           console.log('profile--');

            }
            else{
                var sizeOfSelectedProducts = component.get('v.sizeOfSelectedProducts');
                if(sizeOfSelectedProducts > 0) {
                    component.set('v.idToNavigate', id);
                    component.set('v.showLeaveModal',true);
                    flag = false;
                }
            }

        }

        }
        if(flag) {

        if(_label && _label == 'Branded Product'){
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": "/SSC/s/inventorysearch#bp",
                "isredirect" : true
            });
            urlEvent.fire();
        } else if(_label && _label == 'Installation Product'){
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": "/SSC/s/inventorysearch#ip",
                "isredirect" : true
            });
            urlEvent.fire();
        }else if (id) {
            component.getSuper().navigate(id);
        }

            var appEvent = $A.get("e.c:Dal_SSC_CreateOrderHideGSearchEvent");
            appEvent.fire();
        }

    },
    
    toggleMobileMenu: function(component, event, helper){
        component.set("v.mobileNavShown", !component.get("v.mobileNavShown"));
    },
    
    toggleSubmenu: function(component, event, helper) {
        var _toggleButton = event.currentTarget;
        var _subMenuTriggers = document.getElementsByClassName("dal-sub-menu-trigger");
        var i;
        for (i = 0; i < _subMenuTriggers.length; i++) {
            var _subMenuTrigger = _subMenuTriggers[i];
            if(_subMenuTrigger != _toggleButton){
                _subMenuTrigger.setAttribute('aria-expanded', 'false');
                if(_subMenuTrigger.nextSibling.classList.contains("slds-is-open")) {
                    _subMenuTrigger.nextSibling.classList.remove("slds-is-open");
                }
            }
        }
        
        var _expanded = _toggleButton.getAttribute('aria-expanded');
        if(_expanded =='false'){
            _toggleButton.setAttribute('aria-expanded', 'true');
            _toggleButton.nextSibling.classList.add("slds-is-open");
        }else{
            _toggleButton.setAttribute('aria-expanded', 'false');
            _toggleButton.nextSibling.classList.remove("slds-is-open");
        }
    },

     updateProductList : function(cmp,event,helper) {
        var quantity = event.getParam('quantity');
        cmp.set('v.sizeOfSelectedProducts', parseInt(quantity));
        var profileName = event.getParam('profile');
        cmp.set('v.profileName', profileName);
     },

})