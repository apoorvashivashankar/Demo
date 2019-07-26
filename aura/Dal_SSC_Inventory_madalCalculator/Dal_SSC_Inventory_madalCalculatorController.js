({
    doInit : function(cmp,event,helper) {
      helper.setToBlank(cmp,event,helper);
      helper.handleCalculateHelper(cmp,event,helper);

    },

    handleCloseModal: function(cmp, evt, helper){
       cmp.find('overlayLib').notifyClose();
    },

    handleCalculate : function(cmp,event,helper){
        helper.setToBlank(cmp,event,helper);
        helper.handleCalculateHelper(cmp,event,helper);
    },
})