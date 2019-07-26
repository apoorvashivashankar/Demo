/**
 * Created by ranja on 03-01-2019.
 */
({
    doCallout : function(cmp, methodName, params, callBackFunc){
        //console.log('IN CALLBACK METHOD');
        var action = cmp.get(methodName);
        action.setParams(params);
        action.setCallback(this, callBackFunc);
        $A.enqueueAction(action);
        //console.log('OUT CALLBACK METHOD');
    },

    navigateToNewPage : function(cmp,event,helper,_type,_by,_direction) {
        var createOrderWrapper = cmp.get('v.createOrderWrapper');
        var _pageOrder = '';

        if(_type === 'productList') {
            _pageOrder = createOrderWrapper.pageOrderCreate;
        } else if (_type === 'cartList') {
            _pageOrder = createOrderWrapper.pageOrderCart;
        }

        if(_by) {
            if(_direction === 'next'){
               _pageOrder = _pageOrder + _by;
            } else if (_direction === 'prev') {
                _pageOrder = _pageOrder - _by;
            }
        }

        if(_type === 'productList') {
            createOrderWrapper.pageOrderCreate = _pageOrder;
        } else if (_type === 'cartList') {
            createOrderWrapper.pageOrderCart = _pageOrder;
        }
        console.log('_pageOrder: ',_pageOrder);
        cmp.set('v.createOrderWrapper',createOrderWrapper);

    },
})