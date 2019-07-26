/**
 * Created by ranja on 21-08-2018.
 */
({
    showtoast : function(_msg, _type){
            var _toastEvent = $A.get("e.force:showToast");
            _toastEvent.setParams({
                message: _msg,
                type : _type,
            });
            _toastEvent.fire();
        },

    nextStep: function(currentPosition) {
            //console.log('IN NExt Step');

            var orderProcessStepEvt = $A.get('e.c:Dal_Dist_OrderProcessStepEvt');
            orderProcessStepEvt.setParams({
                'currentPos': currentPosition
            });

            // fire the orderProcessStepEvt
            orderProcessStepEvt.fire();
        },
})