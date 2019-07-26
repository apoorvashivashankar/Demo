({
    handleInit: function(cmp,evt){

        var varCaseSubject = 'Disconnected Call';
        var varCaseDescription = '';
        cmp.set("v.newCaseSubject", varCaseSubject);
        cmp.set("v.newCaseDescription", varCaseDescription);
    
    },

	helperLoadData: function(cmp) {
		this.helperVisualforceListner(cmp);
    },    
    
	helperRecordLoadData: function(cmp) {
		console.log('in helperRecordLoadData...');

        var _recid = cmp.get("v.recordId");
        var _sObjName = cmp.get("v.sObjectName");
        console.log('helperRecordLoadData + _recid:...', _recid);
        console.log('helperRecordLoadData + sObjName:...', _sObjName);
        
        let hasBoth = cmp.get('v.hasBoth');
        let _contactRecordId = cmp.get('v.contactRecordId');
        let _sObjCont = cmp.get('v.sObjCont');
        
        if ((_recid && _sObjName) || (_sObjCont && _contactRecordId)) {
            if(hasBoth) {
                if(_recid && _contactRecordId) {
                    cmp.find("accountId").set("v.value", _recid);
                    cmp.set("v.selectedAccount", _recid);
                    cmp.find("contactId").set("v.value", _contactRecordId);
                    cmp.set("v.selectedContact", _contactRecordId);
                } else if(_contactRecordId) {
                    cmp.find("contactId").set("v.value", _contactRecordId);
                    cmp.set("v.selectedContact", _contactRecordId);
                }
            } else if (_sObjName == 'Account') {
                console.log('In If Acc');
                cmp.set("v.isAccount", true);
                cmp.set("v.isContact", false);       
                cmp.find("accountId").set("v.value", _recid);
                cmp.set("v.selectedAccount", _recid);
                this.getContactsByAccounts(cmp, _recid);
            } else if (_sObjName == 'Contact') {
                console.log('In If Con');
                cmp.set("v.isAccount", false);
                cmp.set("v.isContact", true);            
                console.log('Con + _sObjName:...' + _sObjName);
                console.log('Con + _recid:...' + _recid);
                cmp.find("contactId").set("v.value", _recid);
                cmp.set("v.selectedContact", _recid);    
                this.getAccountsByContacts(cmp, _recid);
            }
        }  else if (_sObjName == null) {
                console.log('In If Nada...');
                cmp.set("v.isAccount", false);
                cmp.set("v.isContact", false);       
				cmp.find("accountId").set("v.value", null);
				cmp.find("contactId").set("v.value", null);   
        }             
        
	},
  
 	helperVisualforceListner: function(cmp)  {
		console.log('in helperVisualforceListner...');

        var visualforceDomain = "https://" + cmp.get("v.visualforceDomain");
        console.log('helperVisualforceListner + visualforceDomain:...' + visualforceDomain);
		var _sObjName = '';
        /**
         * Adding a new event listner on window object
         * to listen for message event
         **/        
       window.addEventListener("message", function(event) {
            console.log('in helperVisualforceListner + addEventListener, coming from:...' + event.origin);
            //Check if origin is not your org's my domain url, in this case, simply return out of function
            if (visualforceDomain.indexOf(event.origin) == -1) {
                // Not the expected origin: reject message!
                console.error('Discarding Message | Message received from invalid domain: ',event.origin);
                return;
            } else {
            	cmp.set("v.isVF", true);    
            }
            
            // Handle the message event here
            console.log('Lightning Gets: ', event.data);
            var _recid = event.data;
            // document.querySelector('#allMessages').innerHTML += '<p>'+event.data+'</p>';
            if (_recid) {
                if (_recid.startsWith('001')) {
                    _sObjName = 'Account';
                	//cmp.set("v.isAccount", true);                    
		            var varAccountId = cmp.find('accountId');                    
                    console.log('Lightning sets varAccountId:...' + varAccountId);
                    if (varAccountId) {
                        cmp.find("accountId").set("v.value", _recid);
                    	cmp.set("v.selectedAccount", _recid);
                    }
                } else if (_recid.startsWith('003')) {
                    _sObjName = 'Contact';
                	// cmp.set("v.isContact", true);               
		            var varContact = cmp.find('contactId'); 
                    if (varContact) {
                        cmp.find("contactId").set("v.value", _recid);
                    	cmp.set("v.selectedContact", _recid);
                    }
                }
        		console.log('LightningListner + should have updated sObjName:...', _sObjName,' and _recid:...',_recid);
            }            
        }, false);             
        
        // this.helperRecordLoadData(cmp);
	},    
    
    createCase: function(cmp, evt) {
        console.log("createCase...");
        var caseSubject = cmp.find('caseSubject').get("v.value");
        var caseStatus = cmp.find('caseStatus').get("v.value");
        var caseDescription = cmp.find('caseDescription').get("v.value");
        cmp.set("v.newCase.Subject", caseSubject);
        cmp.set("v.newCase.Status", caseStatus);
        cmp.set("v.newCase.Description", caseDescription);
        var caseIsVF = cmp.get("v.isVF");    
        console.log("createCase caseIsVF:..." + caseIsVF);
        if (caseIsVF == true) {
            var caseAccount = cmp.get("v.selectedAccount");
            var caseContact = cmp.get("v.selectedContact");
        	cmp.set("v.newCase.AccountId", caseAccount);
        	cmp.set("v.newCase.ContactId", caseContact);
        } else {
        	cmp.set("v.newCase.AccountId", null);
        	cmp.set("v.newCase.ContactId", null);
        }
            
		console.log("saveRecord + caseSubject: " + caseSubject);
		console.log("saveRecord + caseStatus: " + caseStatus);
		console.log("saveRecord + caseDescription: " + caseDescription);
		console.log("saveRecord + caseAccount: " + caseAccount);
		console.log("saveRecord + caseContact: " + caseContact);
        
        var tempRec = cmp.find("forceRecord")
        var caseDisconnected = cmp.get("{!v.newCase}");
        console.log("createCase...+ tempRec:..." + JSON.stringify(tempRec));
        console.log("createCase...+ caseDisconnected:..." + JSON.stringify(caseDisconnected));
        
        this.upsertCase(cmp, caseDisconnected);        
    },
    
    upsertCase: function(cmp, newCase) {
        var action = cmp.get("c.createCase");
        action.setParams({ "newCase": newCase });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // Alert the user with the value returned 
                // from the server
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": "Saved",
                        "type": "success",
                        "message": "Thanks!  The Case for the disconnected call was saved."
                    });
                    resultsToast.fire();
                    // $A.get("e.force:refreshView").fire();
                    this.clearValues(cmp);
                    var utilityAPI = cmp.find("utilitybar");
                	this.clearValues(cmp);
                    // this.rerender(cmp);
                // You would typically fire a event here to trigger 
                // client-side notification that the server-side 
                // action is complete
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });        
        $A.enqueueAction(action);        
    }, 
    
    clearValues: function(cmp) {
        console.log("clearValues...");
        var varCaseSubject = 'Disconnected Call';
        var varCaseDescription = '';
        cmp.set("v.newCaseSubject", varCaseSubject);
        cmp.set("v.newCaseDescription", varCaseDescription);
        var _recid = '';
        var _sObjName = '';
        cmp.set("v.isVF", false);    
        var caseIsVF = cmp.get("v.isVF");    
        console.log("clearValues caseIsVF:..." + caseIsVF);
        if (caseIsVF == true) {   
            var varAccountId = '';           
            cmp.find("accountId").set("v.value", null);
            cmp.set("v.selectedAccount", null);           
            var varContact = ''; 
            cmp.find("contactId").set("v.value", null);
            cmp.set("v.selectedContact", null);
        }
        var utilityAPI = cmp.find("utilitybar");
        utilityAPI.minimizeUtility(); 
        
    }
})