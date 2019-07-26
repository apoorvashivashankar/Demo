/**
 * Created by abdoundure on 4/11/18.
 */
({
    handleShowModal: function (cmp, evt, helper) {
        helper.handleShowModal(cmp);
    },

    handleCloseModal: function(cmp, evt, helper){
        var overlay = cmp.get('v.overlay');
        // the overlay is a promise, but will already
        // be resolved so call the 'then' and close
        // use the returned overlay to close it.
        overlay.then(function(response){
            // close the overlay
            if(response !== undefined && response.overlay !== undefined){
                response.overlay.close();
            }
        });
    }
})