({
    submitForm: function (component,event,helper) {
        // If valid, submit
        var valid = helper.validateForm(component);
        if (valid){
            console.log('valid!');
            helper.submitForm(component);
        }
    }
})