({
    initPopover: function(component, event, helper) {
        var popover = component.find(helper.returnPopoverId());
        $A.util.addClass(popover,'slds-nubbin_'+component.get('v.nubbinLocation'));
    },
    handleMouseEnter : function(component, event, helper) {
    	var popover = component.find(helper.returnPopoverId());
        $A.util.removeClass(popover,'slds-hide');
    },
    handleMouseLeave  : function(component, event, helper) {
        var popover = component.find(helper.returnPopoverId());
        $A.util.addClass(popover,'slds-hide');
    }
})