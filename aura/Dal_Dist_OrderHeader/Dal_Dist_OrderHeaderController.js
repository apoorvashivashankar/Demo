/**
 * Created by 7Summits on 3/14/18.
 */
({

    handleChangeStepEvent: function(cmp, evt){
        var currentPos = evt.getParam('currentPos');
        cmp.set('v.currentPos', currentPos);
    }


})