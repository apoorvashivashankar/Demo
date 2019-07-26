({
      // Fetch the accounts from the Apex controller
      getAccountList: function(component) {
          
        var rid = component.get("v.recordId");  
        var action = component.get('c.getAccounts');
        action.setParams({recordID : rid});
  
        // Set up the callback
        var self = this;
        action.setCallback(this, function(actionResult) {
         component.set('v.accounts', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
      }
    })