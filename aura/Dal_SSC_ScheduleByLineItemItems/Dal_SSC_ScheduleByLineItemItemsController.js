/**
 * Created by 7Summits on 5/14/18.
 */
({

    handleSkuClicked: function(cmp, evt){
        var store = cmp.get('v.store');
        var currentOrderPos = store.getCurrentOrderPosition();
        var currentTarget = evt.currentTarget;
        var skuIndex = currentTarget.dataset.index;
        store.toggleSkuSelected(currentOrderPos, skuIndex);

        // now that we clicked an individual item we know that the select all buttons shouldn't be checked
        cmp.set('v.selectAllItemsValue', false);
    },

    handleSelectAllSkusClicked: function(cmp){
        var store = cmp.get('v.store');
        var currentOrderPos = store.getCurrentOrderPosition();
        var selectAllItemsValue = cmp.get('v.selectAllItemsValue');
        store.setAllSkusSelected(currentOrderPos, selectAllItemsValue);
    },

    
    handleGoToScheduleClick: function(cmp){
        console.log('handleGoToScheduleClick:');
        cmp.set('v.showFirst',false);
        var store = cmp.get('v.store');
        var currentOrderPos = store.getCurrentOrderPosition();

        // reset the select all button
        cmp.set('v.selectAllItemsValue', false);

        store.setScheduleByItemActiveTab(currentOrderPos, 'schedule');
    },

    handleScheduleTypeChange: function(cmp){
        var store = cmp.get('v.store');
        var currentOrderPos = store.getCurrentOrderPosition();
        store.setScheduleByItemType(currentOrderPos, cmp.get('v.scheduleTypeValue'));
    },
    


})