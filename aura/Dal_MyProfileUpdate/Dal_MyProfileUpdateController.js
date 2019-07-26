({
    loadDetails : function(component, event, helper) {
		var Id = component.get("v.recordId");
        helper.getDetailWithId(component,Id);
	},
    openModel: function(component, event, helper) {
      component.set("v.isOpen", true);
      var Id = component.get("v.recordId");
      helper.getDetailWithId(component,Id);  
    },
  	clickClose: function(component, event, helper) {
      component.set("v.isOpen", false);
   	},
    updateclick: function(component, event, helper) {
    	helper.updateclick(component, event, helper);
    }
})