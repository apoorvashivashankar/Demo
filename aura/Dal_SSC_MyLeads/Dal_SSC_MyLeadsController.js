/**
 * Created by presh on 20-11-2018.
 */
({
     init: function(cmp, evt, helper){
            helper.getLineStatusOptions(cmp);
            //helper.getPicklistValues(cmp);
     },

    /* handleDropdownClick : function(component, event, helper) {
            var mainDiv = component.find('dropdownDiv');
            $A.util.toggleClass(mainDiv, 'slds-is-open');
            component.set("v.showDropdown", true);
     },

     doDropdownClose : function(component, event, helper){
            var mainBox = component.find('dropdownDiv');
            component.set("v.showDropdown", false);
            $A.util.removeClass(mainBox, 'slds-is-open');
     },*/

     onLineStatusChange : function(component, event, helper){
            var lineStatus = component.find("leadStatus").get("v.value");
            console.log('lineStatus is '+lineStatus);
            component.set("v.leadStatus", lineStatus);
     },

     onLineSourceChange : function(component, event, helper){
             var lineStage = component.find("leadStage").get("v.value");
             console.log('leadStage is '+leadStage);
             component.set("v.leadStage", leadStage);
     },

     searchLeads : function(component, event, helper) {
            helper.searchLeads(component, event, helper);
     },

     /*onLineStatusSelect : function(component, event, helper){
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
            component.set("v.leadStatus", multilpeLineStatus.toString());
            console.log("UI Val---",val);
     }*/
})