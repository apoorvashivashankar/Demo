/**
 * Created by 7Summits on 5/9/18.
 */
({
    doInit:function(cmp, evt, helper){
        helper.handleStoreUpdate(cmp);


    },

    gotoSelectItems: function(cmp){
        var store = cmp.get('v.store');
        var currentOrderPos = store.getCurrentOrderPosition();
        store.setScheduleByItemActiveTab(currentOrderPos, 'selectItems');
    },

    handleSaveNext: function(cmp, evt, helper){
        helper.handleSaveNext(cmp);
    },

    handleCancel: function(cmp){
        var store = cmp.get('v.store');
        var baseHelper = store.getHelper();
        baseHelper.doGotoURL($A.get("$Label.c.Dal_SSC_ScheduleByLineItem_GotoUrl_Label"));
    }

})