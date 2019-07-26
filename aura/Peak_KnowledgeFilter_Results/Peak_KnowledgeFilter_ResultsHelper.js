/**
 * Created by 7Summits on 10/17/17.
 */
({
    goToRecord: function(component, event) {
        let id = event.currentTarget.dataset.id;
        let action = $A.get('e.force:navigateToSObject');
        action.setParams({
            'recordId': id
        });
        action.fire();
    }
})