/**
 * Created by ajith on 16/08/18.
 */
({
    doInit : function(component, event, helper){
        var _caseId = component.get("v.caseId");
        console.log('In Component Init',_caseId)
        var _action = component.get("c.getSalesOrder");
        _action.setParams({'caseId' : _caseId});
        _action.setCallback(this, function(response){
            var _state = response.getState();
            if(_state === "SUCCESS"){
                var _res = response.getReturnValue();
                console.log('_res',_res);
                component.set("v.orderInfo", _res[0]);
            }
        });
        $A.enqueueAction(_action);
    }
})