/**
 * Created by 7Summits on 5/14/18.
 */
({
    handleUpdate : function(cmp,event,helper) {
        console.log('#############event captured');
      helper.handleStoreUpdate(cmp);  
        
    },

    gotoSelectItems: function(cmp){
        var store = cmp.get('v.store');
        var currentOrderPos = store.getCurrentOrderPosition();
        store.setScheduleByItemActiveTab(currentOrderPos, 'selectItems');
    },

    handleSavePickup: function(cmp, evt, helper){
        helper.handleSavePickup(cmp);
    },

    handlePickDateChange: function(cmp, evt, helper){
        helper.handlePickupDateChange(cmp);
    },

    handlePickupTimeSelected: function(cmp, evt, helper){
        var selectedPickupTime = evt.currentTarget.dataset.value;
        cmp.set('v.pickupTimeSelected', selectedPickupTime);
    },
    
    handleShouldTextChange: function(cmp, evt, helper){
        var isChecked = cmp.find('shouldSendText').get('v.checked');
        cmp.set('v.pickupShouldSendTxt', isChecked);
        helper.updateStore(cmp);
    }

})