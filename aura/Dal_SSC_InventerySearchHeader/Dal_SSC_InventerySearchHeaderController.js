/**
 * Created by ranja on 12-11-2018.
 */
({
    handlePositionEvent : function(cmp,event,helper) {

        var pos = cmp.get('v.pos');
        var curPos = event.getParam('currentPos');
        console.log('Event param currentPos: ', curPos);
        cmp.set('v.pos',curPos);

    }
})