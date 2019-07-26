/**
 * Created by 7Summits on 5/9/18.
 */
({
    
    handleComponentEvent : function(cmp,event,helper) {
        
        var activeTab = cmp.get('v.activeTab');
        if(activeTab === 'selectItems')
            cmp.set('v.showFirst',true);
        
    },


    handleActive: function(cmp, evt){
        debugger;
        console.log('ACtive Tab 3');
        var tab = evt.getSource();
        var activeTabId = tab.get('v.id');
        cmp.set('v.activeTab', activeTabId);
        
        if(cmp.get('v.activeTab') === 'schedule') {
            var urlEvent = $A.get("e.c:Dal_SSC_OrderScheduleHandlerEvent");
            urlEvent.fire();
        	console.log('even fired#######',urlEvent);
        }
            
        
    }

})