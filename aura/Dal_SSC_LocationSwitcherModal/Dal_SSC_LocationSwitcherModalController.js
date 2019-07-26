/**
 * Created by Yadav on 2/8/2019.
 */
({
     closeModal : function(cmp,event,helper) {
            cmp.find('overlayLib').notifyClose();
     },

    changeAccount : function (cmp,event,helper) {
        	//helper.changeSelectedAcc(cmp,event,helper);
            helper.changeSelectedAccount(cmp,event,helper);
    },
})