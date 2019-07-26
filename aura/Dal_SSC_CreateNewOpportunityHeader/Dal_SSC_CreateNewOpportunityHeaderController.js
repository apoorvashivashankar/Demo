/**
 * Created by ranja on 23-11-2018.
 */
({

    handleOnLoad : function(cmp,event,helper) {
        var inputOppName = cmp.find('inputOppName').get('v.value');
        console.log('inputLeadName: ',inputOppName);
        var appEvent = $A.get("e.c:Dal_SSC_LeadMgmtOpp_BreadCrumbEvent");
        appEvent.setParams({ "pageName" : inputOppName });
        appEvent.fire();
    },

    handleEditClick : function(cmp,event,helper) {
        var recordId = cmp.get('v.recordId');
        /*
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": 'https://dev-daltile.cs19.force.com/SSC/s/editopportunity#'+recordId,
          "isredirect" : true
        });
        urlEvent.fire();
        */
        var communityUrl = location.href;
        var url = communityUrl.split('opportunity');

        console.log('url: ', url);
        window.open(url[0] + "editopportunity#"+recordId,"_self")
    },
    
    handleRelateToOrder : function(cmp, evt, helper){
    //    debugger;
        var oppNumber = cmp.get('v.recordId');
        
        if(oppNumber.length > 0){
            helper.goToAllOrderPage(oppNumber);
        }
        
    }
    
})