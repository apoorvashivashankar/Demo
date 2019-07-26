({
	doinit  : function(component, event, helper) {	
        var action = component.get("c.getDivision");
        action.setCallback(this, function(response) {
 				var state = response.getState();
                if(state === "SUCCESS"){
                    component.set('v.divisionCode',response.getReturnValue());
                    if(response.getReturnValue()=='40')
                         component.set('v.selectedBrand',"Daltile");
                    else if(response.getReturnValue()=='41')
                         component.set('v.selectedBrand',"American Olean");
                }               
        });
        $A.enqueueAction(action);
    },
    downloadPDF : function(component, event, helper) {
        helper.downloadDB(component, event, helper) ;  
    },
})