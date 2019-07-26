/**
 * Created by ranja on 25-11-2018.
 */
({
    doInit : function(cmp,event,helper){
          var selectedScoreOfLead = cmp.get('v.selectedScoreOfLead');
          console.log('selectedScoreOfLead---',selectedScoreOfLead);
          cmp.set('v.selectedOpportunityRating',selectedScoreOfLead);
    },

    handleCloseModal : function(cmp,event,helper) {
        cmp.find('overlayLib').notifyClose();
    },

    handleOnload : function(cmp, event, helper) {
    //   debugger;
       /*var selectedStatusOfLead = cmp.get('v.selectedStatusOfLead');
       var recUi = event.getParam("recordUi");
       recUi.record.fields["Status"].value = selectedStatusOfLead;
       event.setParam("recordUi",recUi);
       cmp.find('convertedStatus').set('v.value',selectedStatusOfLead);
       */
       var selectedScoreOfLead = cmp.get('v.selectedScoreOfLead');
       cmp.set('v.selectedOpportunityRating',selectedScoreOfLead);
    },

    handleConvert :  function(cmp,event,helper) {
    //    debugger;

        cmp.set('v.showSpinner',true);
        var _flag1 = false;
        var _flag2 = false;
        var _flag3 = false;

        if(!cmp.get('v.selectedOwner')) {
            cmp.set('v.isOwnerNull',true);
            _flag3 = true;
        } else {
            cmp.set('v.isOwnerNull',false);
            _flag3 = false;
        }

        if(!cmp.get('v.chooseAccount')) {
            cmp.set('v.showErrorAccNull',true);
            _flag1 = true;
            cmp.set('v.showSpinner',false);
        } else {
            cmp.set('v.showErrorAccNull',false);
             _flag1 = false;
        }

        if(!cmp.get('v.chooseContact')) {
            cmp.set('v.showErrorConNull',true);
            _flag2 = true;
            cmp.set('v.showSpinner',false);
        } else {
            cmp.set('v.showErrorConNull',false);
            _flag2 = false;
        }

        if(!cmp.get('v.isAccountNew') && !cmp.find("selectedAccount").get('v.value')){
            cmp.set('v.showErrorAcc',true);
            cmp.set('v.showSpinner',false);
        }
         if(!cmp.get('v.isContactNew') && !cmp.find("selectedContact").get('v.value')) {
             cmp.set('v.showErrorAcc',false);
             cmp.set('v.showErrorCon',true);
             cmp.set('v.showSpinner',false);
        }

        if(!_flag1 && !_flag2 && !_flag3) {

        if(!cmp.get('v.isAccountNew') && !cmp.find("selectedAccount").get('v.value')){
            cmp.set('v.showErrorAcc',true);
            cmp.set('v.showSpinner',false);
        } else if(!cmp.get('v.isContactNew') && !cmp.find("selectedContact").get('v.value')) {
             cmp.set('v.showErrorAcc',false);
             cmp.set('v.showErrorCon',true);
             cmp.set('v.showSpinner',false);
        } else {
            cmp.set('v.showErrorAcc',false);
             cmp.set('v.showErrorCon',false);
            var _oppResult = {};
            _oppResult.selectedOwner = cmp.get('v.selectedOwner');
            _oppResult.sendEmail = cmp.get('v.sendEmail');
            _oppResult.isAccountNew = cmp.get('v.isAccountNew');
            if(cmp.get('v.isAccountNew'))
                 _oppResult.selectedAccount = cmp.get('v.newAccountName');
            else
                _oppResult.selectedAccount = cmp.find('selectedAccount').get('v.value');

            _oppResult.isContactNew = cmp.get('v.isContactNew');
            if(cmp.get('v.isContactNew'))
                _oppResult.selectedContact = cmp.get('v.newContactName');
            else
                _oppResult.selectedContact = cmp.find('selectedContact').get('v.value');

            _oppResult.opportunityName = cmp.get('v.opportunityName');
            _oppResult.convertedStatus = cmp.get('v.selectedConvertedStatus');
            _oppResult.opportunityRating = cmp.get('v.selectedOpportunityRating');
            _oppResult.recordId = cmp.get('v.recordId');


            var _oppResultJSON = JSON.stringify(_oppResult);
            var _params = {
                opportunityValue : _oppResultJSON
            }
			
            console.log('Params for Conversion: ', _params);
            try {
                
            
            
            helper.doCallout(cmp,'c.createOpportunity',_params,function(response) {
                var state = response.getState();
                if(state === 'SUCCESS') {
                   cmp.set('v.showSpinner',false);
                    var _resp = response.getReturnValue();

                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                      "url": '/opportunity/'+ _resp
                    });
                    urlEvent.fire();
                    console.log('Resp after Opp con: ', _resp);
                }
            });
            } catch(ex) {
                 cmp.set('v.showSpinner',false);
            }
            }
        } else {
            cmp.set('v.showSpinner',false);
        }
        //cmp.set('v.showSpinner',false);
    },

    onAccountChange : function(cmp,event,helper) {
        var chooseAccount = cmp.get('v.chooseAccount');

        if(chooseAccount == 'existing') {
            cmp.set('v.isAccountNew',false);
        } else {
            cmp.set('v.isAccountNew',true);
        }
         if(!cmp.get('v.chooseAccount')) {
            cmp.set('v.showErrorAccNull',true);

         } else {
            cmp.set('v.showErrorAccNull',false);
         }


    },

    onContactChange : function(cmp,event,helper) {
        var chooseContact = cmp.get('v.chooseContact');

        if(chooseContact == 'existing') {
            cmp.set('v.isContactNew',false);
        } else {
            cmp.set('v.isContactNew',true);
        }

         if(!cmp.get('v.chooseContact')) {
            cmp.set('v.showErrorConNull',true);

         } else {
            cmp.set('v.showErrorConNull',false);

         }
    },

    handleAccountChange : function(cmp,event,helper) {
    //    debugger;
        console.log('Selected Ac: ', cmp.find("selectedAccount").get('v.value'));
        if(cmp.find("selectedAccount").get('v.value')){
            cmp.set('v.showErrorAcc',false);
        } else {
             cmp.set('v.showErrorAcc',true);
        }

    },

     handleContactChange : function(cmp,event,helper) {
     //    debugger;
        console.log('Selected Co: ', cmp.find("selectedContact").get('v.value'));
        if(cmp.find("selectedContact").get('v.value')) {

             cmp.set('v.showErrorCon',false);
         } else {
             cmp.set('v.showErrorCon',true);
         }

     }

})