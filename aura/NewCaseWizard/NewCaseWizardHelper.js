({	sortBy: function(component, field) {
        console.log('sort started');
        var sortAsc = component.get("v.sortAsc"),
            sortField = component.get("v.sortField"),
            records = component.get("v.SearchResults");
        sortAsc = field == sortField? !sortAsc: true;
        records.sort(function(a,b){
            var t1 = a[field] == b[field],
                t2 = a[field] > b[field];
            return t1? 0: (sortAsc?-1:1)*(t2?-1:1);
        });
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", field);
        component.set("v.SearchResults", records);
        console.log('sort completed');
    },

    changeTabLabel : function(component){
        console.log('In Tab Label change');
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getAllTabInfo().then(function(response) {
            console.log('response',response);
            var focusedTabId = response[0].tabId;
            console.log('focusedTabId',focusedTabId);
            workspaceAPI.setTabLabel({
                tabId: focusedTabId,
                label: 'New Case Search'
            });
        }).catch(function(error){
            console.log('Error :: Avid_BaseHelper :: error while changing tab label ::',error);
        });
    },

    handleSearch: function(component, event, helper) {
        this.showSpinner(component);
        var _orderNo = component.get("v.orderNo");
        var _custPoNo = component.get("v.custPoNo");
        var _shippingNo = component.get("v.shippingNo");
        var _sapNo = component.get("v.sapNo");
        
        var _allfieldserror = component.find("allfields");
        var _customeracc = component.find("customeracc");
        
        component.set("v.SearchResults", '');
        component.set("v.showTable", false);
        
        if((!component.get("v.selectedAccount")) && (!component.get("v.selectedContact")) && (!_orderNo) && (!_shippingNo) && (!_custPoNo) && (!_sapNo)){
            console.log('Please enter at least one search field above');
            this.hideSpinner(component);
            $A.util.removeClass(_allfieldserror, "slds-hide");
            $A.util.addClass(_allfieldserror, "slds-show");
            return;
        } 
        else {
            this.clearErrors(component);
        }
        
        /* Account or/and Contact Search */
        if((!_orderNo) && (!_shippingNo) && (!_custPoNo) && (!_sapNo)){
            console.log('In Acc and Cont Search');
            var _accId;
            var _conId;
            
            if(component.get("v.selectedAccount")){
                _accId = component.get("v.selectedAccount");
            }
            
            if (component.get("v.selectedContact")){
                _conId = component.get("v.selectedContact");
            }
            
            if(_accId || _conId){
                this.searchCasesByAcctsAndContacts(component, event, _accId, _conId);
            }
        }
        /* Number Fields Search */
        else{
            console.log('In Number fields Search');
            var _action = component.get("c.getCasesByNoFields");
            _action.setParams({
                'orderNo' : _orderNo,
                'custPo' : _custPoNo,
                'shipmentNo' : _shippingNo,
                'stoNo' : _sapNo,
            });
            _action.setCallback(this, function(response){
                var state = response.getState();
                console.log('state ',state);
                if(state === "SUCCESS"){
                    this.hideSpinner(component);
                    var _res = response.getReturnValue();
                    console.log('_res', _res);
                    component.set("v.SearchResults", _res.caseList);
                    component.set("v.showTable", true);
                    component.set("v.isAccountContactSearch", false);
                    component.set("v.sortAsc", true);
                    if(_orderNo){
                        if (_res.orderData.validOrderNo) {
                            console.log('true');
                            var _error = component.find("order-No");
                            $A.util.removeClass(_error, "slds-show");
                            $A.util.addClass(_error, "slds-hide");
                            console.log('order Value', _res.orderData);
                            console.log(_res.orderData.orderRec.CustomerPONo__c);
                            component.set("v.custPoNo",_res.orderData.orderRec.CustomerPONo__c);
                        } 
                        else if (!_res.orderData.validOrderNo) {
                            console.log('false');
                            var _error = component.find("order-No");
                            $A.util.removeClass(_error, "slds-hide");
                            $A.util.addClass(_error, "slds-show");
                            return;
                        }
                    }
                    else if(_sapNo){
                        if (_res.stoData.validSTONo) {
                            console.log('true');
                            var _error = component.find("TransferOrderHeader");
                            $A.util.removeClass(_error, "slds-show");
                            $A.util.addClass(_error, "slds-hide");
                            component.set("v.sapId",_res.stoData.stoRec.Id);
                        } 
                        else if (!_res.stoData.validSTONo) {
                            console.log('false');
                            var _error = component.find("TransferOrderHeader");
                            $A.util.removeClass(_error, "slds-hide");
                            $A.util.addClass(_error, "slds-show");
                            return;
                        }
                    }
                }
                else{
                    this.hideSpinner(component);
                    console.log('res');
                }
            });
            $A.enqueueAction(_action);
        }
    },

	helperLoadData: function(component) {
		this.helperVisualforceListner(component);
    },
  
	helperRecordLoadData: function(component) {
        //debugger;
        var _recid = component.get("v.recordId");
        var _sObjName = component.get("v.sObjectName");
        console.log('helperRecordLoadData + _recid:...', _recid);
        console.log('helperRecordLoadData + sObjName:...', _sObjName);
        
        let hasBoth = component.get('v.hasBoth');
        let _contactRecordId = component.get('v.contactRecordId');
        let _sObjCont = component.get('v.sObjCont');
        
        if (_recid && _sObjName ==  null) {
            if (_recid.startsWith('001')) {
                _sObjName = 'Account';
            } else if (_recid.startsWith('003')) {
                _sObjName = 'Contact';
            }
        	console.log('helperLoadData + updated sObjName:...', _sObjName);
        }
        
        if ((_recid && _sObjName) || (_sObjCont && _contactRecordId)) {
            if(hasBoth) {
                if(_recid && _contactRecordId) {
                    component.find("accountId").set("v.value", _recid);
                    component.set("v.selectedAccount", _recid);
                    component.find("contactId").set("v.value", _contactRecordId);
                    component.set("v.selectedContact", _contactRecordId);
                } else if(_contactRecordId) {
                    component.find("contactId").set("v.value", _contactRecordId);
                    component.set("v.selectedContact", _contactRecordId);
                }
            } else if (_sObjName == 'Account') {
                console.log('In If Acc');
                component.set("v.isAccount", true);
                component.set("v.isContact", false);       
                component.find("accountId").set("v.value", _recid);
                component.set("v.selectedAccount", _recid);
                this.getContactsByAccounts(component, _recid);
            } else if (_sObjName == 'Contact') {
                console.log('In If Con');
                component.set("v.isAccount", false);
                component.set("v.isContact", true);            
                console.log('Con + _sObjName:...' + _sObjName);
                console.log('Con + _recid:...' + _recid);
                component.find("contactId").set("v.value", _recid);
                component.set("v.selectedContact", _recid);    
                this.getAccountsByContacts(component, _recid);
            }
        }  else if (_sObjName == null) {
                console.log('In If Nada...');
                component.set("v.isAccount", false);
                component.set("v.isContact", false);       
				component.find("accountId").set("v.value", null);
				component.find("contactId").set("v.value", null);   
        }     
	},
  
 	helperVisualforceListner: function(component)  {
		console.log('in helperVisualforceListner...');
        
        var visualforceDomain = "https://" + component.get("v.visualforceDomain");
 		var _recid = '';
        var _sObjName = '';
        /**
         * Adding a new event listner on window object
         * to listen for message event
         **/        
        window.addEventListener("message", function(event) {
            console.log('in addEventListener...');
            //Check if origin is not your org's my domain url, in this case, simply return out of function
            if (visualforceDomain.indexOf(event.origin) == -1) {
                // Not the expected origin: reject message!
                console.error('Discarding Message | Message received from invalid domain: ',event.origin);
                return;
            }
            // Handle the message event here
            console.log('Lightning Gets: ', event.data);
            _recid = event.data;
            // document.querySelector('#allMessages').innerHTML += '<p>'+event.data+'</p>';
            if (_recid) {
                if (_recid.startsWith('001')) {
                    _sObjName = 'Account';
                	//component.set("v.isAccount", true);                    
		            var varAccountId = component.find('accountId');                    
                    console.log('Lightning sets varAccountId:...' + varAccountId);
                    if (varAccountId) {
                        component.find("accountId").set("v.value", _recid);
                    	component.set("v.selectedAccount", _recid);
                    }
                } else if (_recid.startsWith('003')) {
                    _sObjName = 'Contact';
                	// component.set("v.isContact", true);               
		            var varContact = component.find('contactId'); 
                    if (varContact) {
                        component.find("contactId").set("v.value", _recid);
                    	component.set("v.selectedContact", _recid);
                    }
                }
                console.log('LightningListner + updated sObjName:...', _sObjName);
            }            
        }, false);             
        
        this.helperRecordLoadData(component);
        console.log('LightningListner + should have updated sObjName:...', _sObjName,' and _recid:...',_recid);
	},
  
	clearErrors: function(component) {
        $A.util.removeClass(component.find("allfields"), "slds-show");
        $A.util.addClass(component.find("allfields"), "slds-hide");
        $A.util.removeClass(component.find("order-No"), "slds-show");
        $A.util.addClass(component.find("order-No"), "slds-hide");
        $A.util.removeClass(component.find("Shipment-No"), "slds-show");
        $A.util.addClass(component.find("Shipment-No"), "slds-hide");
        $A.util.removeClass(component.find("customer-Po"), "slds-show");
        $A.util.addClass(component.find("customer-Po"), "slds-hide");
        $A.util.removeClass(component.find("TransferOrderHeader"), "slds-show");
        $A.util.addClass(component.find("TransferOrderHeader"), "slds-hide");
        $A.util.removeClass(component.find("customeracc"), "slds-show");
        $A.util.addClass(component.find("customeracc"), "slds-hide");
        $A.util.removeClass(component.find("customer"), "slds-show");
        $A.util.addClass(component.find("customer"), "slds-hide");
    },

    searchCasesByAcctsAndContacts: function(component, event, _accId, _conId){
        console.log('Helper Method Entry');
        console.log('_accId' + _accId);
        console.log('_conId' + _conId);
        
        var action = component.get("c.getCasesByAccountAndContact");
        action.setParams({
            'accId': _accId,
            'conId': _conId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                this.hideSpinner(component);
                var _returnValues = response.getReturnValue();
                component.set("v.isAccountContactSearch", true);
                component.set("v.SearchResults", _returnValues);
                component.set("v.showTable", true);
            }
        });
        $A.enqueueAction(action);
    },
    
    getContactsByAccounts: function(component, _accId) {
        console.log('getContactsByAccounts + _accId:...' + _accId);
        var action = component.get("c.getContactsByAccounts");
        action.setParams({
            'accId': _accId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var _conts = response.getReturnValue();
                console.log('_conts' + JSON.stringify(_conts));
                component.set("v.contactOptions", _conts);
                console.log('options' + component.get("v.contactOptions"));
            }
        });
        $A.enqueueAction(action);
    },
    
    getAccountsByContacts: function(component, _conId) {
        console.log('getAccountsByContacts + _conId:...' + _conId);
        var action = component.get("c.getAccountsByContacts");
        action.setParams({
            'conId': _conId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var _accts = response.getReturnValue();
                console.log('_accts' + JSON.stringify(_accts));
                component.set("v.accountOptions", _accts);
                console.log('options' + component.get("v.accountOptions"));
            }
        });
        $A.enqueueAction(action);
    },
    
    navigateToCase: function(component, event, helper) {
        console.log('in navigate to case');
        var _sapNo = component.get("v.sapNo");
        var _accno = component.get("v.selectedAccount");
        var _contact = component.get("v.selectedContact");
        let _defaultValues = {};
        if(_contact && _sapNo){
            _defaultValues.AccountId = _accno,
            _defaultValues.Order_Number__c = component.get("v.orderNo"),
            _defaultValues.Shipment__c = component.get("v.shippingNo"),
            _defaultValues.Customer_PO__c= component.get("v.custPoNo"),
            _defaultValues.ContactId = _contact,
            _defaultValues.SAP_TransferOrderHeader__c= _sapNo
        }
        if(!_contact && !_sapNo){
            _defaultValues.AccountId = _accno,
            _defaultValues.Order_Number__c = component.get("v.orderNo"),
            _defaultValues.Shipment__c = component.get("v.shippingNo"),
            _defaultValues.Customer_PO__c= component.get("v.custPoNo")
        }
        if(_contact && !_sapNo){
            _defaultValues.AccountId = _accno,
            _defaultValues.Order_Number__c = component.get("v.orderNo"),
            _defaultValues.Shipment__c = component.get("v.shippingNo"),
            _defaultValues.Customer_PO__c= component.get("v.custPoNo"),
            _defaultValues.ContactId = _contact
        }
        if(!_contact && _sapNo){
            _defaultValues.AccountId = _accno,
            _defaultValues.Order_Number__c = component.get("v.orderNo"),
            _defaultValues.Shipment__c = component.get("v.shippingNo"),
       		_defaultValues.Customer_PO__c= component.get("v.custPoNo"),
            _defaultValues.SAP_TransferOrderHeader__c= _sapNo
        }
        console.log(_defaultValues)
        var createCaseEvent = $A.get("e.force:createRecord");
        createCaseEvent.setParams({
            "entityApiName": "Case",
            "recordTypeId" : component.get("v.recordtypeid"),
            "defaultFieldValues": _defaultValues
        });
        createCaseEvent.fire();
    },

    showSpinner: function (component, event, helper) {
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },

    hideSpinner: function (component, event, helper) {
        var spinner = component.find("mySpinner");
        console.log('spinner',spinner);
        $A.util.addClass(spinner, "slds-hide");
    }    
})