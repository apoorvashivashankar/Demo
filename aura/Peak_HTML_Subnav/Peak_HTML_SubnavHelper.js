/**
 * Created by brianpoulsen on 3/20/17.
 * Edited by Joe Callin on 8/12/2017.
 */
({
    buildNav : function(component) {
        var object = [];
        for(var i = 1; i <= 10; i++){
            var navItem = component.get('v.navItem' + i);
            var navItemLabel = component.get('v.navItemLabel' + i);

            if (navItem && navItemLabel) {
                object.push({
                    link : navItem,
                    label : navItemLabel
                })
            }
        }
        component.set('v.itemList', object);
    },

    navigate : function(component, event) {
        var path = event.target.dataset.link;
        var scrollToAnchors = component.get("v.ScrollToAnchors");
        var navigateEvent = $A.get("e.force:navigateToURL");

        // check if link is an in-page anchor; use scrollIntoView() method
        if(path.charAt(0) === '#') {
            var anchor = path.substring(1);
            var x = document.getElementById(anchor);

            // check if we are using smooth scrolling to anchor (IE not supported)
            if(scrollToAnchors) {
                x.scrollIntoView({behavior: "smooth", block: "start"});
            } else {
                x.scrollIntoView({block: "start"});
            }
        } else {
            // this is a regular url; use force:navigateToURL
            navigateEvent.setParams({
                "url": path,
            });
            navigateEvent.fire();
        }
    }

})