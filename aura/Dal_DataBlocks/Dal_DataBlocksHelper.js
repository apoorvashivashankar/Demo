/**
 * Created by 7Summits on 3/1/18.
 */
({
    /**
     *
     * @param cmp
     * @param evt
     */
    handleToggleDetail: function(cmp, evt){
        //  get the attributes from the event
        var id = evt.getParam('id');
        var componentName = evt.getParam('componentName');

        // get the currently active detail view Id
        var activeDetailId = cmp.get('v.activeDetailId');

        // if the id passed from the event is not the same as active event
        // we know we a new detail has been selected so set the active
        // attributes and create component to show in the detail section
        if(activeDetailId !== id){
            console.log('IN IF STATEMENT');
            this.helpers.setComponent.call(this, cmp, id, componentName);
        }else {
            console.log('IN ELSE STATEMENT');
            this.helpers.clearComponent(cmp);
        }
    }, // end handleToggleDetail

    helpers: {

        /**
         * Give a component name will get that component and set it to the page.
         * @param cmp
         * @param id
         * @param componentName
         */
        setComponent: function(cmp, id, componentName){
            // set the active states
            cmp.set('v.innerComponentBody', null); // reset component body
            cmp.set('v.innerComponentBlockLoading', true); // set loading to true
            cmp.set('v.activeDetailId', id); // set the active id
            cmp.set('v.showInnerComponentBlock',true);
            
            // request the component, promise is returned
            var componentResponse = this.getComponent(componentName);

            // Callbacks for the promise returned
            componentResponse.then(function(component){
                cmp.set('v.innerComponentBlockLoading', false);
                cmp.set('v.innerComponentBody', component);
            }, function(){
                console.log('Dal_DataBlocksHelper:GetComponent:Error');
            });
        },

        /**
         * Clear the inner component
         * @param cmp
         */
        clearComponent: function(cmp){
            cmp.set('v.showInnerComponentBlock', false); // hide the inner component block
            cmp.set('v.activeDetailId', null); // reset the active id
            cmp.set('v.innerComponentBody', null); // reset the inner component body
        }

    } // end helpers

})