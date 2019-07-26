({
	getCopyrightYear: function(component, event, helper) {
	    var d = new Date();
		var year = d.getFullYear();
	    component.set("v.CopyrightYear", year);
	}
})