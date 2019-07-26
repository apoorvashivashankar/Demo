/**
 * Created by 7Summits on 3/7/18.
 */
({

    handleActive: function(cmp, evt){
        var tab = evt.getSource();
        var activeTabId = tab.get('v.id');
        cmp.set('v.activeTab', activeTabId);
    }

})