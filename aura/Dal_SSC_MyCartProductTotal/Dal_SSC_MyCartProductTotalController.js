/**
 * Created by ranja on 07-01-2019.
 */
({
    handlePlaceOrder : function(cmp,event,helper) {
        debugger;
        var isPOEmpty = cmp.get('v.isPOEmpty');
        var isPoRequired = cmp.get('v.isPoRequired');
        var isJobNameEmpty = cmp.get('v.isJobNameEmpty');
        var isJobNameRequired = cmp.get('v.isJobNameRequired');
        var myCartPageNumber = cmp.get('v.myCartPageNumber');
        var myCartResponsePageTwo = cmp.get('v.myCartResponsePageTwo');

        var re = /[^\w\s-.,?:;!@#$%*(){}\[\]_+=]/gi
        if(myCartPageNumber === 1) {
            helper.goToCheckoutPage(cmp,event,helper); 
        } else if (myCartPageNumber === 2) {
            myCartResponsePageTwo.jobName = myCartResponsePageTwo.jobName || '';
            myCartResponsePageTwo.po = myCartResponsePageTwo.po || '';
            if(isPoRequired && isJobNameRequired){
                if(isPOEmpty && isJobNameEmpty){
                    cmp.set('v.showPOError', true);
                    cmp.set('v.showJobNameError', true);
                    return;
                }
                if(!isPOEmpty) {
                    if(!myCartResponsePageTwo.po.match(re)){
                        if(!isJobNameEmpty){
                            if(!myCartResponsePageTwo.jobName.match(re)){
                                helper.goToReviewDetailPage(cmp,event,helper,cmp.get('v.myCartResponsePageTwo'));
                                cmp.set('v.myCartPageNumber',(myCartPageNumber+1));
                            }
                        } else{
                            cmp.set('v.showJobNameError', true);
                            return;
                        }
                    }else{
                        return;
                    }

                } else {
                     cmp.set('v.showPOError', true);
                     return;
                }
            }

            if(isPoRequired){
                if(!isPOEmpty) {
                    if(!myCartResponsePageTwo.po.match(re) && !myCartResponsePageTwo.jobName.match(re)){
                        helper.goToReviewDetailPage(cmp,event,helper,cmp.get('v.myCartResponsePageTwo'));
                        cmp.set('v.showPOError', false);
                    } else{
                        return;
                    }
                } else
                    cmp.set('v.showPOError', true);
            }
            if(isJobNameRequired){
                if(!isJobNameEmpty){
                    if(!myCartResponsePageTwo.jobName.match(re) && !myCartResponsePageTwo.po.match(re)){
                        helper.goToReviewDetailPage(cmp,event,helper,cmp.get('v.myCartResponsePageTwo'));
                        cmp.set('v.showJobNameError', false);
                    } else{
                        return;
                    }
                } else{
                    cmp.set('v.showJobNameError', true);
                }
            }
            if(!isPoRequired && !isJobNameRequired){
                helper.goToReviewDetailPage(cmp,event,helper,cmp.get('v.myCartResponsePageTwo'));
                cmp.set('v.myCartPageNumber',(myCartPageNumber+1));
            }

        } else if(myCartPageNumber === 3) {
            helper.handlePlaceOrder(cmp,event,helper);
        }
        if(isPoRequired){
            if(myCartPageNumber === 2 && !isPOEmpty ){
                if(!myCartResponsePageTwo.po.match(re) && !myCartResponsePageTwo.jobName.match(re)){
                    cmp.set('v.myCartPageNumber',(myCartPageNumber+1));
                }else{
                    return;
                }
            }
        }
        if(isJobNameRequired){
            if(myCartPageNumber === 2 && !isJobNameEmpty){
                if(!myCartResponsePageTwo.jobName.match(re) && !myCartResponsePageTwo.po.match(re)){
                    cmp.set('v.myCartPageNumber',(myCartPageNumber+1));
                } else{
                    return;
                }
            }

        }
        if(myCartPageNumber === 1 )
            cmp.set('v.myCartPageNumber',(myCartPageNumber+1));

    },
})