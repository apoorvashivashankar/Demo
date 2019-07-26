/**
 * Created by presh on 22-11-2018.
 */
({
    init: function(cmp, evt, helper){
                helper.getLineStatusOptions(cmp);
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
         },
*/
         onLineStageChange : function(component, event, helper){
                var oppStage = component.find("oppStage").get("v.value");
                console.log('oppStage is '+oppStage);
                component.set("v.oppStage", oppStage);
         },

         searchOpportunity : function(component, event, helper) {
                helper.searchOpportunity(component, event, helper);
         },
         hideErrors : function(component, event, helper) {
        //     debugger;
             var el = component.find("opportunityStage");
             $A.util.removeClass(el, "slds-has-error"); // remove red border
             $A.util.addClass(el, "hide-error-message"); // hide error message
         }

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