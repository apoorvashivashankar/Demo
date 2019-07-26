/**
 * Created by Preshit on 13-05-2019.
 */
({
    itemSelected : function(component, event, helper) {
        var target = event.target;
        var SelIndex = helper.getIndexFrmParent(target,helper,"data-selectedIndex");
        if(SelIndex){
            var serverResult = component.get("v.server_result");
            var selItem = serverResult[SelIndex];
            if(selItem.val){
               component.set("v.recordId",selItem.val);
               component.set("v.recordName",selItem.text);

               component.set("v.last_ServerResult",serverResult);
            }
            component.set("v.server_result",null);
        }
	},
    serverCall : function(component, event, helper) {
        var isEnterKey = event.keyCode === 13;
        var queryTerm = component.find('lookup-input').get('v.value');
        var last_SearchText = component.get("v.last_SearchText");
        //Escape button pressed
        /*if (event.keyCode == 27 || !queryTerm.trim()) {
            helper.clearSelection(component, event, helper);
        }else if (isEnterKey && queryTerm.trim() != last_SearchText ) {*/
            component.set('v.issearching', true);
            const DELAY = 500;
            var delayTimeout = component.get("v.delayTimeout");
            if( delayTimeout )
                window.clearTimeout( delayTimeout );

            delayTimeout = setTimeout($A.getCallback(function() {
             	var objectName = component.get("v.objectName");
                var field_API_text = component.get("v.field_API_text");
                var field_API_val = component.get("v.field_API_val");
                var field_API_search = component.get("v.field_API_search");
                var field_API_recordType = component.get("v.field_API_recordType");
                var limit = component.get("v.limit");

                var action = component.get('c.searchDB');

                action.setParams({
                    objectName : objectName,
                    fld_API_Text : field_API_text,
                    fld_API_Val : field_API_val,
                    lim : limit,
                    fld_API_Search : field_API_search,
                    recordType: field_API_recordType,
                    searchText : queryTerm
                });

                action.setCallback(this,function(a){
                    component.set('v.issearching', false);
                    helper.handleResponse(a,component,helper);
                });

                component.set("v.last_SearchText",queryTerm.trim());
                console.log('Server call made');
                $A.enqueueAction(action);
            }), DELAY);
            component.set( "v.delayTimeout", delayTimeout );
        /*}else if(queryTerm && last_SearchText && queryTerm.trim() == last_SearchText.trim()){
            component.set("v.server_result",component.get("v.last_ServerResult"));
            console.log('Server call saved');
        }  */
	},
    handleResponse : function (res,component,helper){
        if (res.getState() === 'SUCCESS') {
            var retObj = JSON.parse(res.getReturnValue());
            if(retObj.length <= 0){
                var noResult = JSON.parse('[{"text":"No Results Found"}]');
                component.set("v.server_result",noResult);
            	component.set("v.last_ServerResult",noResult);
            }else{
                component.set("v.server_result",retObj);
            	component.set("v.last_ServerResult",retObj);
            }
        }else if (res.getState() === 'ERROR'){
            var errors = res.getError();
            if (errors) {
                if (errors[0] && errors[0].message) {
                    console.log('error ',errors[0].message);
                    //alert(errors[0].message);
                }
            }
        }
    },
    getIndexFrmParent : function(target,helper,attributeToFind){
        //User can click on any child element, so traverse till intended parent found
        var SelIndex = target.getAttribute(attributeToFind);
        while(!SelIndex){
            target = target.parentNode ;
			SelIndex = helper.getIndexFrmParent(target,helper,attributeToFind);
        }
        return SelIndex;
    },
    clearSelection: function(component, event, helper){
        component.set("v.recordId",null);
        component.set("v.recordName",null);
        component.set("v.server_result",null);
    }
})