({
	getVisibilities : function(component) {
        var _this = this;
		var _action = component.get("c.fetchNavMenuVisibilty");
        _action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                _this.setVisibilties(component, response.getReturnValue());
            }
        });
        $A.enqueueAction(_action);
	},
    
    setVisibilties :function(component, _mapOfVisibilty){
        var _menuItems = component.get("v.menuItems");
        var _activeMenuItems = [];
        var _activeSubMenuItems = [];
        var _localMenuItem;
        var i=0;
        var j=0;
        for(i=0; i<_menuItems.length; i++){
            _activeSubMenuItems = [];
            if(_mapOfVisibilty[_menuItems[i].label] == true){
                if(_menuItems[i].subMenu){
                    for(j=0; j<_menuItems[i].subMenu.length; j++){
                        if(_mapOfVisibilty[_menuItems[i].subMenu[j].label])
                            _activeSubMenuItems.push(_menuItems[i].subMenu[j]);
                    }
                    _menuItems[i].subMenu = _activeSubMenuItems;
                }
                _activeMenuItems.push(_menuItems[i]);
            }
        }
        component.set("v.menuItems", _activeMenuItems);
    }
})