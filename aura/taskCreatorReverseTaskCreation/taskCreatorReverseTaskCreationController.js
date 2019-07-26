({
 doInit : function(component, event, helper) {
        var taskCreationId = component.get("v.recordId");
        var action = component.get("c.reverseTaskCreation");
        action.setParams({
            taskCreationId : taskCreationId
        });
        action.setCallback(this, function(response) {
            if(response.getState() === "SUCCESS") {
                console.log("Updated");
             	var rec = response.getReturnValue();

            }
        });
        $A.enqueueAction(action);
        $A.get('e.force:refreshView').fire();
     	$A.get("e.force:closeQuickAction").fire();
     
 }
})