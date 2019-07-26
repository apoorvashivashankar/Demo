/**
 * Created by Preshit on 02-01-2019.
 */
({
    handleToPageTwo : function(cmp,event,helper) {
        var myCartPageNumber = cmp.get('v.myCartPageNumber');
        cmp.set('v.myCartPageNumber', (myCartPageNumber-1));
    },

    handleToPageOne : function(cmp,event,helper) {
        var myCartPageNumber = cmp.get('v.myCartPageNumber');
        cmp.set('v.myCartPageNumber', (myCartPageNumber-2));
    },

})