/**
 * Created by Yadav on 2/11/2019.
 */
({
    closeModal : function(cmp,event,helper) {
           cmp.find('overlayLib').notifyClose();
    },
    changeAccount : function (cmp,event,helper) {
            /*//helper.changeSelectedAcc(cmp,event,helper);
            helper.changeSelectedAccount(cmp,event,helper);*/
    },
    navigateToBrowseProducts : function (cmp,event,helper) {

            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": '/products'
            });
            urlEvent.fire();
    },
})