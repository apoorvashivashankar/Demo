/**
 * Created by ranja on 25-11-2018.
 */
({
    doInit : function(cmp,event,helper) {
        var objectType = cmp.get('v.objectType');
        console.log('INIT: ',objectType);
        if(objectType === 'User'){
            var pillTarget = cmp.find("lookup-pill");
            var lookUpTarget = cmp.find("lookupField");

            var forclose = cmp.find("lookup-pill");
            $A.util.addClass(forclose, 'slds-show');
            $A.util.removeClass(forclose, 'slds-hide');

            var forclose = cmp.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');

            var lookUpTarget = cmp.find("lookupField");
            $A.util.addClass(lookUpTarget, 'slds-hide');
            $A.util.removeClass(lookUpTarget, 'slds-show');
        }
    },

    onblur : function(cmp,event,helper) {
        cmp.set("v.listOfSearchRecords", null );
        var forclose = cmp.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },

    clear :function(cmp,event,heplper){
         var pillTarget = cmp.find("lookup-pill");
         var lookUpTarget = cmp.find("lookupField");

         $A.util.addClass(pillTarget, 'slds-hide');
         $A.util.removeClass(pillTarget, 'slds-show');

         $A.util.addClass(lookUpTarget, 'slds-show');
         $A.util.removeClass(lookUpTarget, 'slds-hide');

         cmp.set("v.searchKeyWord",'');
         cmp.set("v.listOfSearchRecords", null );
         //cmp.set("v.selectedRecord", '' );
         var _refObj = cmp.get('v.objectType');

         if(_refObj === 'User')
            cmp.set('v.selectedOwner','');
         else if(_refObj === 'Account')
            cmp.set('v.selectedAccount','');
         else if(_refObj === 'Contact')
            cmp.set('v.selectedContact','');
    },

    onfocus : function(cmp,event,helper){
       $A.util.addClass(cmp.find("mySpinner"), "slds-show");
       var forOpen = cmp.find("searchRes");
       $A.util.addClass(forOpen, 'slds-is-open');
       $A.util.removeClass(forOpen, 'slds-is-close');

       // Get Default 5 Records order by createdDate DESC
       var getInputkeyWord = '';
       helper.fetchObjectList(cmp,event,helper);

    },

    doDropdownClose : function(component, event, helper){
        var mainBox = component.find('searchRes');
        component.set("v.showDropdown", false);
        $A.util.removeClass(mainBox, 'slds-is-open');
    },

    handleComponentEvent : function(cmp, event, helper) {
        // get the selected Account record from the COMPONENT event
    //    debugger;

       var selectedValue = event.getParam("selectedValue");
       var selectedName = event.getParam("selectedName");
       var _refObj = cmp.get('v.objectType');

       if(_refObj === 'User') {
           cmp.set('v.selectedOwner',selectedValue);
           cmp.set('v.selectedOwnerName',selectedName);
       } else if(_refObj === 'Account') {
           cmp.set('v.selectedAccount',selectedValue);
           cmp.set('v.selectedAccountName',selectedName);
       } else if(_refObj === 'Contact') {
           cmp.set('v.selectedContact',selectedValue);
           cmp.set('v.selectedContactName',selectedName);
       }

        var forclose = cmp.find("lookup-pill");
           $A.util.addClass(forclose, 'slds-show');
           $A.util.removeClass(forclose, 'slds-hide');

        var forclose = cmp.find("searchRes");
           $A.util.addClass(forclose, 'slds-is-close');
           $A.util.removeClass(forclose, 'slds-is-open');

        var lookUpTarget = cmp.find("lookupField");
            $A.util.addClass(lookUpTarget, 'slds-hide');
            $A.util.removeClass(lookUpTarget, 'slds-show');

    },
})