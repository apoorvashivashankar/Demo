/**
 * Created by brianpoulsen on 3/20/17.
 * Edited by Joe Callin on 8/12/2017.
 */
({
    doInit : function(component, event, helper) {
       helper.buildNav(component);
    },
    onClick : function(component, event, helper) {
        helper.navigate(component, event);
    }
})