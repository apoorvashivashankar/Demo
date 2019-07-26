/**
 * Created by 7Summits on 5/7/18.
 */
({

    save: function(cmp){
        // aura:id's of input attributes
        var inputIds = ['poNumber', 'jobName'];

        // call isValid in base helper
        var isValid = this.validateForm(cmp, null, ['poNumber', 'jobName'], true);

        // if the form is valid make request to see if address is valid
        if(isValid === true){
            var poNumber = cmp.get('v.poNumber');
            var jobName = cmp.get('v.jobName');
            var orderSaveEvent = $A.get('e.c:Dal_Dist_OrderSaveEvt');

            // set event params
            orderSaveEvent.setParams({
                poNumber: poNumber,
                jobName: jobName
            });

            // fire the event
            orderSaveEvent.fire();

        } // end valid check

    }

})