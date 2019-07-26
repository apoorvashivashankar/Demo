/**
 * Created by Preshit on 13-05-2019.
 */
({
   itemSelected : function(component, event, helper) {
        helper.itemSelected(component, event, helper);
    },
    serverCall :  function(component, event, helper) {
        helper.serverCall(component, event, helper);
    },
    clearSelection : function(component, event, helper){
        helper.clearSelection(component, event, helper);
    },
    handleLookupOnBlur : function(component, event, helper){
        var queryTerm = component.find('lookup-input').get('v.value');
        if( !queryTerm || queryTerm.trim() == "" )
            component.set("v.server_result",null);
    },
})