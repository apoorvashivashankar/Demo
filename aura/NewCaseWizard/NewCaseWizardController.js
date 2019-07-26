({
    doInit: function(component, event, helper) {
        var myPageRef = component.get("v.pageReference");
        var recordId, sObj, contactRecordId;
        helper.helperLoadData(component)        
        
        if(myPageRef && myPageRef.state){
            recordId = myPageRef.state.recordId;
            sObj = myPageRef.state.sObjectName;
            contactRecordId = myPageRef.state.contactRecordId;
            component.set("v.recordId",recordId);
            component.set("v.sObjectName",sObj);
        }
        
        //Hardik -> start
        let hasBoth = false;
        
        let sObjCont;
        if(contactRecordId) {
            sObjCont = myPageRef.state.sObjectContact;
            if(sObjCont) {
                component.set("v.contactRecordId",contactRecordId);
                component.set("v.sObjCont",sObjCont); 
                hasBoth = true;
            }
        }
        component.set("v.hasBoth",hasBoth); 
        //Hardik -> stop
        
        console.log('In Init');
        console.log('recordID',component.get("v.recordId"));
        console.log('sobj',component.get("v.sObjectName"));
        // helper.changeTabLabel(component);
        var _recid = component.get("v.recordId");
        var _sObjName = component.get("v.sObjectName");
        
        if (_recid && _sObjName) {
            if(hasBoth) {
                component.set("v.isAccount", false);
                component.set("v.isContact", false);
            } else if (_sObjName == 'Account') {
                component.set("v.isAccount", true);
                component.set("v.isContact", false);
                console.log('in Acc');
            } else if (_sObjName == 'Contact') {
                component.set("v.isContact", true);
                component.set("v.isAccount", false);
                console.log('in con');
            }
        }

        console.log('doInit + isContact:...' + component.get("v.isContact"));
        console.log('doInit + isAccount:...' + component.get("v.isAccount"));
        
        var _action = component.get("c.getRecordTypeId");
        _action.setCallback(this, function(response){
            var state = response.getState();
            console.log('state ',state);
            if(state === "SUCCESS"){
                console.log('in callback');
                console.log(response.getReturnValue());
                component.set("v.recordtypeid", response.getReturnValue());
            }
        });
        $A.enqueueAction(_action);  
        
    },
    
    onLoad: function(component, event, helper) {
		helper.helperLoadData(component);
    },
    sortByStatus: function(component, event, helper) {
        helper.sortBy(component, "Status");
    },
    sortByOpenDate: function(component, event, helper) {
        helper.sortBy(component, "CreatedDate");
    },
    handleErrors :function(component, event, helper){
        helper.clearErrors(component);
    },
    
    doSearch: function(component, event, helper) {
        helper.handleSearch(component, event, helper);
    },
    
    handleAccountChange: function(component, event, helper) {
        var _selectedAccount = event.getParam("value");
        console.log('_selectedAccount' + _selectedAccount);
        component.set("v.selectedAccount", _selectedAccount);
    },
    
    onRecordIdChange : function(component, event, helper) {
        console.log('onRecordIdChange...');    
        var newRecordId = component.get("v.recordId");
        component.set("v.sObjectName", null);
        component.set("v.contactId", null);
        component.set("v.accountId", null);
        component.set("v.selectedContact", null);
        component.set("v.selectedAccount", null);
 
        console.log('onRecordIdChange + newRecordId:...' + newRecordId);               
		helper.helperLoadData(component);    
    },    
        
    handleContactChange: function(component, event, helper) {
        var _selectedContact = event.getParam("value");
        console.log('_selectedContact' + _selectedContact);
        component.set("v.selectedContact", _selectedContact);

        
    },
    
    loadContacts: function(component, event, helper) {
        helper.clearErrors(component);
        console.log('loadContacts');
        console.log('loadContacts + v.isAccount:...' + component.get("v.isAccount"));
        console.log('loadContacts + v.isContact:...' + component.get("v.isContact"));
        var _recid;
        
        if(component.find("accountId")){
            _recid = component.find("accountId").get("v.value");
        }
        var con_recid;
        var acc_recid;
        if(component.find("accountId")){
            acc_recid = component.find("accountId").get("v.value");
        }
        if(component.find("contactId")){
            con_recid = component.find("contactId").get("v.value");
        }
        console.log('loadContacts + con_recid:...' + con_recid);
        console.log('loadContacts + acc_recid:...' + acc_recid);
        if (!acc_recid && !con_recid) {
            component.set("v.isAccount", false);
            component.set("v.isContact", false);
        } else if (!acc_recid && con_recid) {
            component.set("v.isContact", true);
            component.set("v.isAccount", false);
        } else if (acc_recid && !con_recid) {
            component.set("v.isContact", false);
            component.set("v.isAccount", true);
        }
        component.set("v.selectedAccount", _recid);
        helper.getContactsByAccounts(component, _recid);
    },
    
    loadAccounts: function(component, event, helper) {
        helper.clearErrors(component);
        console.log('loadAccounts');
        console.log('loadAccounts + isAccount:...' + component.get("v.isAccount"));
        console.log('loadAccounts + isContact:...' + component.get("v.isContact"));
        var _recid;
        console.log(component.find("contactId"));
        if(component.find("contactId")){
            _recid = component.find("contactId").get("v.value");
        }
        
        //debugger;
        console.log('_recid', _recid);
        var con_recid;
        var acc_recid;
        if(component.find("accountId")){
            acc_recid = component.find("accountId").get("v.value");
        }
        if(component.find("contactId")){
            con_recid = component.find("contactId").get("v.value");
        }
        console.log('loadAccounts + con_recid:...' + con_recid);
        console.log('loadAccounts + acc_recid:...' + acc_recid);
        if (!acc_recid && !con_recid) {
            component.set("v.isAccount", false);
            component.set("v.isContact", false);
        } else if (!acc_recid && con_recid) {
            component.set("v.isContact", true);
            component.set("v.isAccount", false);
        } else if (acc_recid && !con_recid) {
            component.set("v.isContact", false);
            component.set("v.isAccount", true);
        }
        component.set("v.selectedContact", _recid);
        helper.getAccountsByContacts(component, _recid);
    },
    
    createNewCase: function(component, event, helper) {
        helper.clearErrors(component);
        var _customeracc = component.find("customeracc");
        if(component.get("v.selectedAccount")){
            $A.util.removeClass(_customeracc, "slds-show");
            $A.util.addClass(_customeracc, "slds-hide");
            helper.navigateToCase(component, event, helper);      
            var utilityAPI = component.find("utilitybar");
        	var varBlank = '';
            var varNull = null;
            component.set("v.accountId",varNull);
            component.set("v.contactId",varNull);
            component.set("v.orderNo",varBlank);
            component.set("v.shippingNo",varBlank);
            component.set("v.custPoNo",varBlank);
            component.set("v.sapNo",varBlank);
            utilityAPI.minimizeUtility();       
        }
        else{
            console.log('Please enter at least one search field above');
            $A.util.removeClass(_customeracc, "slds-hide");
            $A.util.addClass(_customeracc, "slds-show");
            return;
        }
    },
    
    openCaseInTab : function(component, event, helper){
        //var workspaceAPI = component.find("workspace");
        var _recordId= event.target.id;
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": _recordId
        });
        navEvt.fire();
    }
})