/**
 * Created by 7Summits on 2/28/18.
 */
({
    init: function(component, evt, helper){
        helper.doCallout(component,"c.getSSCDashboardData",null).then(function(response){
            console.log(response);
            component.set('v.dataBlock', response);
        }).catch(function(error){
            console.log('dashboardError',error);
            $A.reportError("error message here", error);
        });

        var _oldAccountId = sessionStorage.getItem('oldAccountId');
        var _isShowPop = sessionStorage.getItem('showPop');
        if(_isShowPop == "true"){
            helper.doCallout(component,"c.getAccountCartDetail",{oldAccountId: _oldAccountId}).then(function(response){
                console.log('oldAccount---',response);
                if(response != null){
                    component.set('v.accountCartResponse', response);
                    console.log('response.divisionName---',response.divisionName);
                    component.set("v.isShowPop",true);
                    sessionStorage.setItem("showPop","false");
                }

            }).catch(function(error){
                console.log('dashboardError',error);
                $A.reportError("error message here", error);
            });

        }
    },
    handleClick : function(component, evt, helper){
        sessionStorage.setItem("showPop","false");
        component.set("v.isShowPop",false);
    }
})