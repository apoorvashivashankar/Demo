/**
 * Created by 7Summits on 2/16/18.
 */
({

    init: function(cmp, evt, helper){
        helper.init(cmp);
    },

    toggleSelectLocation: function (cmp, evt, helper) {
        helper.toggleSelectLocation(cmp);
    },

    handleLocationSelected: function (cmp, evt, helper) {
        helper.handleLocationSelected(cmp, evt);
    },

    handleLocationSwitched:  function (cmp, evt, helper) {
         helper.handleLocationSelectedForCart(cmp, evt, helper);
    },

})