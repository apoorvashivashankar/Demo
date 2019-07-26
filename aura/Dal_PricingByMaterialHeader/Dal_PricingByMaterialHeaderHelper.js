/**
 * Created by 7Summits on 4/26/18.
 */
({

    init: function(cmp){
        this.getPriceRecords(cmp);
    },

    getPriceRecords: function(cmp){
        var self = this;

        cmp.set('v.isPromotionSelectorLoading', true);

        var promise = this.getPriceRecordsRequest(cmp);

        promise.then(function(response){
            self.setPriceRecords(cmp, response);
            cmp.set('v.isPromotionSelectorLoading', false);
        }, function(response){
            console.log('Dal_PricingByMaterialsHeader:Error getting price records:', response);
        });

        return promise;
    },

    getPriceRecordsRequest: function(cmp){
        var effectiveDate = cmp.get('v.effectiveDate');

        var params = {
            customer: null,
            dateVal: new Date(effectiveDate),
            listlimit: 100
        };

        return this.doCallout(cmp, 'c.getPriceRecordsForCustomerByDate', params);
    },

    setPriceRecords: function(cmp, response){
        var appliedPromotionCode = cmp.get('v.appliedPromotion');

        for(var i = 0; i < response.length; ++i){
            if(response[i].PriceRecordCode__c === appliedPromotionCode){
                response[i].selected = true;
                cmp.set('v.selectedPromotionObject', response[i]);
            } else {
                response[i].selected = false;
            }
        }

        cmp.set('v.promotions', response);
    },

    handleDateChange: function(cmp){
        var self = this;
        var effectiveDate = cmp.get('v.effectiveDate');
        var isDateValid = this.isDateValid(cmp, effectiveDate);

        var datePromoChangeEvtBefore = $A.get('e.c:Dal_PricingByMaterialDatePromoChangeEvt');
        var datePromoChangeEvtAfter = $A.get('e.c:Dal_PricingByMaterialDatePromoChangeEvt');

        // date is valid now lets get some new promotions
        if(isDateValid === true){
            datePromoChangeEvtBefore.setParams({isLoading: true});
            datePromoChangeEvtBefore.fire();

            var promise =this.getPriceRecords(cmp);

            promise.then(function(){
                var appliedPromotionCode = cmp.get('v.appliedPromotion');
                datePromoChangeEvtAfter.setParams({
                    isLoading: false,
                    effectiveDate: effectiveDate,
                    appliedPromotionCode: appliedPromotionCode
                });
                datePromoChangeEvtAfter.fire();
            });

        }

    },

    handlePromoChange: function(cmp){
        var effectiveDate = cmp.get('v.effectiveDate');
        var appliedPromotionCode = cmp.get('v.appliedPromotion');
        var datePromoChangeEvt = $A.get('e.c:Dal_PricingByMaterialDatePromoChangeEvt');

        datePromoChangeEvt.setParams({
            isLoading: false,
            effectiveDate: effectiveDate,
            appliedPromotionCode: appliedPromotionCode
        });

        datePromoChangeEvt.fire();
    },

    isDateValid: function(cmp, date){
        // first check is if the date is in the YYYY-MM-DD format
        // when there is a valid date entered in the component it
        // is returned in this format.
        var regEx = /^\d{4}-\d{1,2}-\d{1,2}$/;

        // check if format is incorrect
        if(date === undefined || !date.match(regEx)){
            cmp.set('v.errorsEffectiveDate', [{message:'Invalid Date'}]);
            return false
        }

        // now we know the format is correct, lets check if it is a valid date
        var jsDateObject = $A.localizationService.parseDateTime(date, 'yyyy-MM-dd');
        if(!jsDateObject.getTime() && jsDateObject.getTime() !== 0){
            cmp.set('v.errorsEffectiveDate', [{message:'Invalid Date'}]);
            return false
        }

        // now we know we have a valid date but lets make sure it is in the future from today.
        var isDateAfter = $A.localizationService.isAfter(jsDateObject, new Date(), 'day');
        var isDateSame = $A.localizationService.isSame(jsDateObject, new Date(), 'day');

        // if date isn't in the future, return false and set errors
        if(isDateAfter === false && isDateSame === false){
            cmp.set('v.errorsEffectiveDate', [{message:'Date must be in the future'}]);
            return false
        }

        // date is valid clear errors and return true
        else {
            cmp.set('v.errorsEffectiveDate', []);
            return true;
        }
    }
    
})