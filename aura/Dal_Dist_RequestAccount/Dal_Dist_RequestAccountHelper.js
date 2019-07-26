/**
 * Created by 7Summits on 2/14/18.
 */
({

    handleInit: function(cmp){
        // get the states options for the select boxes
        var states = this.getStatesOptions();
        cmp.set('v.states', states);
    },

    handleSubmit: function (cmp) {
        // get all the form elements
        var values = ['name', 'role', 'email', 'phone',  'phoneMobile',  'sendNotifications', 'companyName', 'companyAddressStreet',
            'companyAddressCity', 'companyAddressState', 'companyAddressZipCode', 'dalAccountNumber', 'requestCashAccount'];

        var isValid = this.isFormValid(cmp, values);

        // // if the form is valid format the data and send
        if(isValid === true){
            var formattedData = this.helpers.formatData(cmp, values);
            console.log('readyToSubmit:', formattedData);
        }

    },

    helpers: {

        formatData: function(cmp, props){
            var results = {};
            if(props !== undefined && Array.isArray(props)){
                props.forEach(function (item) {
                    // check if we are passing an aura:id or already are passing the aura object
                    var value = (typeof item === 'string') ? cmp.find(item) : item;
                    var type = value.get('v.type');

                    if(value !== undefined && value.get !== undefined){
                        results[item] = (type !== undefined && type === 'checkbox') ? value.get('v.checked') : value.get('v.value');
                    }
                });
            }

            return results;
        }
        
    } // end helpers

})