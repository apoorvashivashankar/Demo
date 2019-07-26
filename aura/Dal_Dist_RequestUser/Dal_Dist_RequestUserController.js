/**
 * Created by 7Summits on 2/13/18.
 */
({

    handleSubmit: function(cmp, evt, helper){
        helper.handleSubmit(cmp);
    },

    handleRadioClick: function(cmp, evt, helper){
        // convert value which is a string to boolean
        var value = (evt.getSource().get('v.value') === 'true');
        cmp.set('v.removeUser', value);
    }

})