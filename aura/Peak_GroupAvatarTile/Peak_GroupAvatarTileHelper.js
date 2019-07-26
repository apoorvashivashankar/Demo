//
// Created by 7Summits - Joe Callin on 8/12/17.
//
({
    goToGroup: function (component, event) {
        var id = event.currentTarget.dataset.id;
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": id,
        });
        navEvt.fire();
    }
})