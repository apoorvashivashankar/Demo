({
 doInit : function(component, event, helper) {
    var urlEvent = $A.get("e.force:navigateToURL");
    urlEvent.setParams({
        "url":"http://www.cnn.com"
    });
    urlEvent.fire(); 
 }
})