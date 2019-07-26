/**
 * Created by 7Summits on 4/9/18.
 */
({

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