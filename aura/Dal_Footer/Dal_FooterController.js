/**
 * Created by 7Summits on 2/13/18.
 */
({
    getCopyYear: function(component, event, helper) {
        var d = new Date();
        var year = d.getFullYear();
        component.set('v.copyrightYear', year);
    }
})