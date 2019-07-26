/**
 * Created by 7Summits on 2/27/18.
 */
({

    init: function(component, evt, helper){
        helper.doCallout(component,"c.getDistributorDashboardData",null).then(function(response){
            console.log(response);
            component.set('v.dataBlock', response);
        }).catch(function(error){
            console.log('dashboard',error);
            $A.reportError("error message here", error);
        });
    }

})