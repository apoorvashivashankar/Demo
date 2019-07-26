({
	init: function(cmp, evt, helper){
        console.log("init...");
        helper.handleInit(cmp, evt); 
        helper.helperLoadData(cmp);
    },
 	
    showSpinner: function(cmp, evt, helper) {
       // make Spinner attribute true for display loading spinner 
        cmp.set("v.Spinner", true); 
   },
    
    hideSpinner : function(cmp, evt, helper){
     // make Spinner attribute to false for hide loading spinner    
       cmp.set("v.Spinner", false);
    },
    
    handleSave: function(cmp, evt, helper){
        console.log("handleSave...");
        helper.createCase(cmp, evt); 
    }
})