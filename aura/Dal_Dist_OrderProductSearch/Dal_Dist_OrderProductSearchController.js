/**
 * Created by 7Summits on 5/1/18.
 */
({

    handleSearchClick: function(cmp, evt, helper){
        helper.doSearch(cmp);
    },

    handleAddToOrder: function(cmp, evt, helper){
        var productIndex = evt.target.value;
        helper.addToOrder(cmp, productIndex);
    },

    handleAddAll: function(cmp, evt, helper){
        var searchResults = cmp.get('v.searchResults');
        searchResults.forEach(function(result, index){
            helper.addToOrder(cmp, index);
        });
    },

    handleClose: function(cmp){
        cmp.find('overlayLib').notifyClose();
    }

})