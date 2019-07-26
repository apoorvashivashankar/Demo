/**
 * Created by 7Summits on 4/9/18.
 */
({
    init: function(cmp, evt, helper){
        debugger;
        var orderListType = cmp.get("v.listType");
        var userType = cmp.get("v.communityType");
        helper.getLineStatusOptions(cmp, userType, orderListType);

    },
    
    handleDropdownClick : function(component, event, helper) {
        var mainDiv = component.find('dropdownDiv');
        $A.util.toggleClass(mainDiv, 'slds-is-open');
        component.set("v.showDropdown", true);
    },
    
    doDropdownClose : function(component, event, helper){
        var mainBox = component.find('dropdownDiv');
        component.set("v.showDropdown", false);
        $A.util.removeClass(mainBox, 'slds-is-open');
    },
    
    handelOnFocus : function(component, event, helper) {
        var mainDiv = component.find('dropdownDiv');
        $A.util.toggleClass(mainDiv, 'slds-has-focus');
    },
    
    handleRemoveClick : function(component, event, helper) {
        var mainBox = component.find('dropdownDiv');
        $A.util.removeClass(mainBox, 'slds-is-open');
    },
    
    onLineStatusChange : function(component, event, helper){
        var lineStatus = component.find("orderStatus").get("v.value");
        console.log('lineStatus is '+lineStatus);
        component.set("v.orderStatus", lineStatus);
    },
    searchOrders : function(component, event, helper) {
        helper.searchOrders(component, event, helper);
    },
    onLineStatusSelect : function(component, event, helper){
        debugger;
        var val =  event.currentTarget.name;
        var index =  event.currentTarget.dataset.rowIndex;
        var multilpeLineStatus = component.get("v.multilpeLineStatus") || {};
        var lineStatuses = component.get("v.lineStatuses");
        if(!multilpeLineStatus.includes(val)){
            multilpeLineStatus.push(val);
            lineStatuses[index].isChecked = true;
        }else{
            lineStatuses[index].isChecked = false;
            multilpeLineStatus.splice(multilpeLineStatus.indexOf(val), 1);
        }
        
        // component.set("v.isChecked",true);
        component.set("v.lineStatuses",lineStatuses);
        component.set("v.multilpeLineStatus",multilpeLineStatus);
        component.set("v.orderStatus", multilpeLineStatus.toString());
        console.log("UI Val---",val);
    }
})