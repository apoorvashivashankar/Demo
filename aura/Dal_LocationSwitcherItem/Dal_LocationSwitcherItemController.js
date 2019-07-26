/**
 * Created by 7Summits on 2/16/18.
 */
({
    handleClick: function(cmp){
        debugger;
        var id = cmp.get('v.id');
        var selected = cmp.get('v.selected');
        var compEvent = cmp.getEvent('locationSelectedEvt');
        compEvent.setParams({'id': id , 'isSelected': selected});
        compEvent.fire();
    }

})