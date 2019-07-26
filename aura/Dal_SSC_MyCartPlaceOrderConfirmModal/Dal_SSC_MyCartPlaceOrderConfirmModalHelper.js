/**
 * Created by ranja on 29-01-2019.
 */
({
    goToUrl : function(_pageName) {
        var urlEvent = $A.get("e.force:navigateToURL");
         urlEvent.setParams({
           "url": '/' + _pageName
         });
         urlEvent.fire();
    }
})