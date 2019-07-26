/**
 * Created by brianpoulsen on 11/8/17.
 */
({
    handleClick: function (component, event) {

        // closest() polyfill for IE11
        if (!Element.prototype.matches)
            Element.prototype.matches = Element.prototype.msMatchesSelector ||
                Element.prototype.webkitMatchesSelector;


        if (!Element.prototype.closest)
            Element.prototype.closest = function (s) {
                var el = this;
                if (!document.documentElement.contains(el)) return null;
                do {
                    if (el.matches(s)) return el;
                    el = el.parentElement;
                } while (el !== null);
                return null;
            };

        var accordionId = event.currentTarget.id;
        var acc = component.find(accordionId);

        for (var cmp in acc) {
            $A.util.toggleClass(acc[cmp], 'slds-show');
            $A.util.toggleClass(acc[cmp], 'slds-hide');
        }

        var parentContainer = event.currentTarget.closest("section");
        $A.util.toggleClass(parentContainer, 'slds-is-open');
    }
})