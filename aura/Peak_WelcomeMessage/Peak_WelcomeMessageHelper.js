({
    getAccountInfo: function(component) {
        var action = component.get("c.getAccountInfo");

        action.setCallback(this, function(a) {
            component.set("v.currentAccount", a.getReturnValue());
        });
        $A.enqueueAction(action);
    },
    getUserInfo: function(component) {
        var action = component.get("c.getCurrentUser");

        action.setCallback(this, function(a) {
            component.set("v.currentUser", a.getReturnValue());

            var today = new Date();
            var CreatedDate = a.getReturnValue().CreatedDate;
            var CreatedDateFormatted = new Date($A.localizationService.formatDateTime(new Date(CreatedDate)));
            var accountAge = Math.ceil((today - CreatedDateFormatted) / (60*60*24*1000));

            component.set("v.accountAge", accountAge);
        });
        $A.enqueueAction(action);
    }
})