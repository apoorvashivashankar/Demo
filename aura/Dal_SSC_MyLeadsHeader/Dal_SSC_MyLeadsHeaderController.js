/**
 * Created by ranja on 20-11-2018.
 */
({
    createNewLead : function(cmp,event,helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": '/createnewlead'
        });
        urlEvent.fire();
    }
})