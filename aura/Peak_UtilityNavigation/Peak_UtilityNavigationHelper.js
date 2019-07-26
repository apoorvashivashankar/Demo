({
    toggleMobileNav : function(component) {
        var nav = component.find('utilNavWrapper');
        $A.util.toggleClass(nav, 'showNav');
    }
})