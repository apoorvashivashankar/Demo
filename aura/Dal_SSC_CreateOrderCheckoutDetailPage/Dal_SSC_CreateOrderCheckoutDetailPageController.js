/**
 * Created by ranja on 17-01-2019.
 */
({
    init: function(component, evt, helper){
        var myCartResponsePageTwo = component.get('v.myCartResponsePageTwo');
        var nationalAccountIdName = myCartResponsePageTwo.nationalAccountIdName;
        component.set('v.record', nationalAccountIdName);
        console.log('myCartResponsePageTwo---',JSON.stringify(myCartResponsePageTwo));
        console.log('record---nationalAccountIdName--',component.get('v.record'));
        //cmp.find('selectedAccount').set("v.value", nationalAccountIdNew);
    },
    handleTaxExemptChange : function(cmp,event,helper) {
        debugger;
        var taxChange = event.getSource().get('v.value'); 
        var myCartResponsePageTwo = cmp.get('v.myCartResponsePageTwo');

        if(taxChange) {
            helper.openModal(cmp,'c:Dal_SSC_MyCartTaxExemptModal',{
                myCartResponsePageTwo : cmp.getReference('v.myCartResponsePageTwo'),
                showJobNameError : cmp.getReference('v.showJobNameError'),
                isJobNameEmpty : cmp.getReference('v.isJobNameEmpty')
            },
            true,
            'dal-modal_large'
            );

        } else {
            myCartResponsePageTwo.jobName = '';
            cmp.set('v.isJobNameEmpty', true);
            cmp.set('v.myCartResponsePageTwo', myCartResponsePageTwo);
        }

        /*var jobName = event.getSource().get('v.value');
        if(jobName && jobName.length > 0) {
            cmp.set('v.showPOError', false);
            cmp.set('v.isPOEmpty', false);
        } else {
            cmp.set('v.isPOEmpty', true);
            cmp.set('v.showPOError', true);
        }*/

    },

    handleChangePO : function(cmp,event,helper) {
        debugger;
        var myCartResponsePageTwo = cmp.get('v.myCartResponsePageTwo');

            if(myCartResponsePageTwo.isPoRequired){
                var skuWord = event.getSource().get('v.value');
                if(skuWord && skuWord.length > 0) {
                    cmp.set('v.showPOError', false);
                    cmp.set('v.isPOEmpty', false);
                    //cmp.set('v.isShowSpecial', false);
                } else {
                    cmp.set('v.isPOEmpty', true);
                    cmp.set('v.showPOError', true);
                    //cmp.set('v.isShowSpecial', false);
                }
            } else{
                cmp.set('v.isPOEmpty', false);
                //cmp.set('v.isShowSpecial', false);
            }


    },

    handleChangeJobName : function(cmp,event,helper) {
        var myCartResponsePageTwo = cmp.get('v.myCartResponsePageTwo');
        if(myCartResponsePageTwo.isJobNameRequired){
            var skuWord = event.getSource().get('v.value');
            if(skuWord && skuWord.length > 0) {
                cmp.set('v.showJobNameError', false);
                cmp.set('v.isJobNameEmpty', false);
            } else {
                cmp.set('v.isJobNameEmpty', true);
                cmp.set('v.showJobNameError', true);
            }
        }
    },

    handleLoad : function(cmp,event,helper) {
        var myCartResponsePageTwo = cmp.get('v.myCartResponsePageTwo');
        var nationalAccountIdNew = myCartResponsePageTwo.nationalAccountIdNew;
        cmp.find('selectedAccount').set("v.value", nationalAccountIdNew);
    },
    /*handleAccountChange : function(cmp,event,helper) {
        try{
            debugger;
            cmp.set('v.showSpinner',true);
            var _accountId = cmp.find('selectedAccount').get('v.value');
            var myCartResponsePageTwo = cmp.get('v.myCartResponsePageTwo');
            if(_accountId) {

            helper.doCallout(cmp, "c.getAccountName", {accountId : _accountId}, function(response){
                var state = response.getState();
                if(state === "SUCCESS"){
                    var _resp =  response.getReturnValue();
                    myCartResponsePageTwo.nationalAccountIdNew = _resp.Id;
                    myCartResponsePageTwo.nationalAccountName = _resp.Name;
                    cmp.set('v.myCartResponsePageTwo', myCartResponsePageTwo);
                    cmp.set('v.showSpinner',false);
                } else {
                    cmp.set('v.showSpinner',false);
                }
            });
            } else {
                myCartResponsePageTwo.nationalAccountIdNew = '';
                myCartResponsePageTwo.nationalAccountName = '';
                myCartResponsePageTwo.nationalAccountNameNew = '';
                cmp.set('v.myCartResponsePageTwo', myCartResponsePageTwo);
                 cmp.set('v.showSpinner',false);
            }
        } catch(ex) {
            cmp.set('v.showSpinner',false);
        }
    },*/

})