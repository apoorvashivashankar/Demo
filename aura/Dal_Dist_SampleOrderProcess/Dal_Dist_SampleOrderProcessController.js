/**
 * Created by ranja on 07-08-2018.
 */
({
    initMethodCalling : function (cmp,event,helper) {
        //console.log('Sample Order tab clicked');
        //cmp.set('v.isSampleOrderBaseLoading' , false);
        var wrapperData = cmp.get('v.wrapperData');
        wrapperData.productOrderLines = {};
        //wrapperData.cumulativeOrderWeight = 0.00;
        wrapperData.orderDetails = {};
        //wrapperData.orderDetails.selectedAddress = {};
        cmp.set('v.wrapperData' ,wrapperData);
        //console.log('Wrapper Data');

        helper.initLoadData(cmp);
        //console.log('After initloaddata');

    }
})