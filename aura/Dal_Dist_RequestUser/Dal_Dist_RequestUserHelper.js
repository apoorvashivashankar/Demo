/**
 * Created by 7Summits on 2/14/18.
 */
({
    handleSubmit: function (cmp) {
        var self = this;

        // set loading to true
        cmp.set('v.isLoading', true);

        // get all the form elements
        var values = ['FirstName', 'LastName', 'AccountNumber', 'AccountName', 'email', 'phone'];

        var isValid = this.isFormValid(cmp, values);

        // if the form is valid format the data and send
        if(isValid === true){
            var formattedData = this.helpers.formatData(cmp, values);
            console.log('Dal_Dist_RequestUser:handleSubmit:', formattedData);

            var promise = this.doCallout(cmp, 'c.webtoCase', formattedData);

            promise.then(function(response){
                cmp.set('v.isLoading', false);

                if(response.success === true){
                    self.helpers.handleSubmitSuccess.call(self);
                } else {
                    self.helpers.handleSubmitFail.call(self);
                }
            }, function(){
                cmp.set('v.isLoading', false);
                self.helpers.handleSubmitFail();
            });
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

            // are we adding or removing a user
            results.remove = cmp.get('v.removeUser');

            return results;
        },

        handleSubmitSuccess: function(){
            this.showMessage('success', 'Your add/remove user request has been submitted.');
        },

        handleSubmitFail: function(){
            this.showMessage('error', 'Unable to submit add/remove user request.');
        }

    } // end helpers

})