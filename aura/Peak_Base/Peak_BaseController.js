/**
 * Edited by Joe Callin on 8/12/2017.
 */
({
    initPeakBase: function(component, event, helper) {
        helper.getSitePrefix(component);
        helper.getIsGuest(component);
        helper.setLabel(component);
    },

    handleLabelUtilEvent: function (component, event, helper) {
        var text = event.getParam('labelText');
        var attribute = event.getParam('attribute');
        helper.setLabelEvent(component, text, attribute);
    },

    gotoURL: function(cmp, evt, helper) {
        var url = evt.currentTarget.dataset.url;
        var target = evt.currentTarget.target;
        helper.doGotoURL(url, target);
    }
})