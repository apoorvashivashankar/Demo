({
    doInit : function(component, event, helper) {
        helper.doInit(component, event, helper) ;
    },
    statReturned: function(component, event, helper) {
        //console.log("statReturned");
        var params = event.getParam('arguments');
        component.set("v.actualProgress", params.result1);
        component.set("v.totalProgress", params.result2);
        //console.log("v.actualProgress SR = ", params.result1);
        //console.log("v.totalProgress SR = ", params.result2);
        helper.computeProgress(component, event, helper);
    }
})