/**
 * Created by ranja on 24-01-2019.
 */
({
    closeModal : function(cmp,event,helper) {
        cmp.find('overlayLib').notifyClose();
    },

    handleLeavePage : function(cmp,event,helper) {
         var urlEvent = $A.get('e.force:navigateToURL');
         var url = cmp.get('v.url');;
         var target = cmp.get('v.target');

         if(target === '_blank') {
            window.open(url, '_blank');
         } else {
            urlEvent.setParams({
                'url': url
            });
            urlEvent.fire();
         }
    },



})