/**
 * Created by ranja on 25-11-2018.
 */
({
    fetchObjectList : function(cmp,event,helper) {
    //    debugger;

        var searchKeyWord = cmp.get('v.searchKeyWord');
        var _params = {
            inputKeyword : searchKeyWord
        }

        var _refObj = cmp.get('v.objectType');
        var methodName = '';

        if(_refObj === 'User')
            methodName = 'c.fetchUsers';
        else if(_refObj === 'Account')
            methodName = 'c.fetchAccounts';
        else if(_refObj === 'Contact')
            methodName = 'c.fetchContacts';

        this.doCallout(cmp,methodName,_params,function(response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                var _resp = response.getReturnValue();
                cmp.set('v.listOfSearchRecords',_resp);
                console.log('resp frm select obje: ', _resp);
            }
        });
    },

    doCallout : function(cmp, methodName, params, callBackFunc){
        //console.log('IN CALLBACK METHOD');
        var action = cmp.get(methodName);
        action.setParams(params);
        action.setCallback(this, callBackFunc);
        $A.enqueueAction(action);
        //console.log('OUT CALLBACK METHOD');
    },
})