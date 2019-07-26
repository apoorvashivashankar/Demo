({

    init: function(cmp, evt, helper){
        helper.handleStateInit(cmp);
        helper.handleCountryInit(cmp);
        helper.handleAccessInit(cmp);
        helper.handleNewRecordInit(cmp);      
    },

    handleNewAccount: function(cmp, evt, helper){
        helper.handleNewCustomerSetup(cmp, evt);
    },    
    
    handleAddressUpdate: function(cmp, evt, helper){
        helper.handleCountryUpdate(cmp, evt);
    },
    
    handleSubmit: function(cmp, evt, helper){
        helper.handleSubmit(cmp, evt);
    },
    
    handleClose: function(cmp, evt, helper){
        helper.navigateTo(cmp);
    }
    
})