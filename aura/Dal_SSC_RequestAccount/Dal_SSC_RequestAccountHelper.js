({
    
    handleCountryInit: function(cmp){
        var cnts=[];
        let action = cmp.get("c.getCountries");
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let listCountry = response.getReturnValue();
                console.log("handleCountryInit + listCountry: ..." + listCountry);
                for(var i=0;i< response.getReturnValue().length;i++){
                    cnts.push({"class": "optionClass", label: response.getReturnValue()[i], value: response.getReturnValue()[i]});
                }
            }
            cmp.set('v.countries', cnts);   
        });        
        $A.enqueueAction(action);
    },
    
    handleCountryUpdate: function(cmp){
        var caseCountry = cmp.find('caseCountry').get("v.value");
        console.log("handleCountryUpdate + caseCountry: " + caseCountry);
        if (caseCountry != '') {
            if (caseCountry === 'US') {
                cmp.set("v.isCanadian", false);
                cmp.set("v.isInternational", false);
            } else if (caseCountry === 'CA') {
                cmp.set("v.isCanadian", true);
                cmp.set("v.isInternational", false);
            } else {
                cmp.set("v.isInternational", true);
                cmp.set("v.isCanadian", false);
            }
        } else {
            cmp.set("v.isInternational", false);
            cmp.set("v.isCanadian", false);
        }
        this.handleStateInit(cmp,caseCountry);
    },

    handleStateInit: function(cmp, country){        
        var states=[];
        let action = cmp.get("c.getStates");
        action.setParams({ country : country });
        if (country) {
            action.setCallback(this, function(response) {
                let state = response.getState();
                if (state === "SUCCESS") {
                    let listState = response.getReturnValue();
                    console.log("handleCountryInit + listState: ..." + listState);
                    for(var i=0;i< response.getReturnValue().length;i++){
                        states.push({"class": "optionClass", label: response.getReturnValue()[i], value: response.getReturnValue()[i]});
                    }
                }
                cmp.set('v.states', states);
            });        
            $A.enqueueAction(action);
        } else {
            states.push({"class": "optionClass", label: 'Please Select A Country', value: 'Please Select A Country'});
            cmp.set('v.states', states);
        }
    },
    
    handleAccessInit: function(cmp){
        console.log("handleAccessInit initializing ...");
        var accountAccess = this.getAccountAccessNew();       
        cmp.set('v.accountAccess', accountAccess); 
    },
    
    handleNewRecordInit: function(cmp, event, helper) {
        console.log("handleNewRecordInit initializing ...");
        cmp.find("forceRecord").getNewRecord(
                "Case",
                null,
                false,
                $A.getCallback(function() {
                    var rec = cmp.get("v.newCase");
                    var error = cmp.get("v.recordError");
                    if (error || (rec === null)) {
                        console.log("Error initializing record template: " + error);
                        return;
                    } else {
                        console.log("NO Error initializing record template");
                        return;
                    }
                })
        );
    },

    handleCurrentAccountCheck : function(cmp) {
        var caseNewCustomerSetupChecked = cmp.find('caseNewCustomerSetup').get('v.checked');
        console.log("callServerSideAction + caseNewCustomerSetupChecked: " + caseNewCustomerSetupChecked);

        if (!caseNewCustomerSetupChecked) {
            let action = cmp.get("c.getAccountByCustomerNumber");
            var caseAccountNumber = cmp.find('caseAccountNumber').get("v.value");
            action.setParams({ customerNumber : caseAccountNumber });
            action.setCallback(this, function(response) {
                let state = response.getState();
                console.log("callServerSideAction + state: " + state);
                if (state === "SUCCESS") {
                    let returnValue = response.getReturnValue();
    	            this.handleGetCaseRecordType(cmp, returnValue);
                }
                else if (state === "ERROR") {
                    var errorMessage;
                    let errors = response.getError();
                    let message = 'Unknown error'; // Default error message
                    if (errors && Array.isArray(errors) && errors.length > 0) {
                        errorMessage = errors[0].message;
                    }
                    console.log("callServerSideAction + errorMessage: " + errorMessage);
                    this.handleErrors(cmp, errorMessage)
                }
                else {
                    // Handle other reponse states
                }
            });
            $A.enqueueAction(action);
        } else {
            console.error("new customer...");
            this.handleGetCaseRecordType(cmp);
        }
    }, 

    handleGetCaseRecordType : function(cmp,account) {
        let action = cmp.get("c.getCaseRecordTypeID");
        action.setCallback(this, function(response) {
            let state = response.getState();
            console.log("handleGetCaseRecordType + state: " + state);
            if (state === "SUCCESS") {
                let rectype = response.getReturnValue();
                console.log("handleGetCaseRecordType + rectype: " + rectype);
	            this.createCase(cmp, account, rectype);
            } else if (state === "ERROR") {
                var errorMessage;
                let errors = response.getError();
                let message = 'Unknown error'; // Default error message
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    errorMessage = errors[0].message;
                }
                console.log("callServerSideAction + errorMessage: " + errorMessage);
                this.handleErrors(cmp, errorMessage);
            }        
        });
        $A.enqueueAction(action);
    },

    createCase: function(cmp, account, recordType) {
        console.log("createCase...");
        var caseRecordTypeID = recordType;
        var createAccount = cmp.get("v.createAccountChild");
        var caseFirstName = this.handleTitleCase(cmp.find('caseFirstName').get("v.value"));
        var caseLastName = this.handleTitleCase(cmp.find('caseLastName').get("v.value"));
        var caseEmailAddress = cmp.find('caseEmailAddress').get("v.value");
        var casePhoneNumber = cmp.find('casePhoneNumber').get("v.value");
        var caseUserAccess = "All";
        var caseAccountName = this.handleTitleCase(cmp.find('caseAccountName').get("v.value"));
        var caseAccountRequest = cmp.get("{!v.newCase}");
        var caseNewCustomerSetup = cmp.find('caseNewCustomerSetup').get("v.value");
        var caseNewCustomerSetupChecked = cmp.find('caseNewCustomerSetup').get('v.checked');
        cmp.set("v.newCase.AccountName__c", caseAccountName);
        cmp.set("v.newCase.First_Name__c", caseFirstName);
        cmp.set("v.newCase.Last_Name__c", caseLastName);
        cmp.set("v.newCase.Email_Address__c", caseEmailAddress);
        cmp.set("v.newCase.Phone_Number__c", casePhoneNumber);
        cmp.set("v.newCase.User_Access__c", caseUserAccess);
        cmp.set("v.newCase.RecordTypeId", caseRecordTypeID);
        
        var caseCurrentAccountId;
        if (account) {
            for(var key in account) {
                if (key == 'Id'){
                    var caseCurrentAccountId = account[key];
                }
            }  
        }
        
        console.log("current customer + caseCurrentAccountId..." + caseCurrentAccountId);
        console.log("current customer + caseRecordTypeID..." + caseRecordTypeID);
        
        if (caseNewCustomerSetupChecked) {
            var caseSubject = "New ProExchange Account and User Request";
            var caseDBAName = cmp.find('caseDBAName').get("v.value");
            var caseAddressLine1 = cmp.find('caseAddressLine1').get("v.value");
            var caseAddressLine2 = cmp.find('caseAddressLine2').get("v.value");
            var caseCountry = cmp.find('caseCountry').get("v.value");
            if (caseCountry == 'US') {
                var caseCity = cmp.find('caseUSCity').get("v.value");
                var caseState = cmp.find('caseUSState').get("v.value");
                var caseZip = cmp.find('caseUSZip').get("v.value");
            } else if (caseCountry == 'CA') {
                var caseCity = cmp.find('caseCACity').get("v.value");
                var caseState = cmp.find('caseCAState').get("v.value");
                var caseZip = cmp.find('caseCAZip').get("v.value");
            } else {
                var caseCity = cmp.find('caseITCity').get("v.value");
                var caseState = cmp.find('caseITState').get("v.value");
                var caseZip = cmp.find('caseITZip').get("v.value");
            }            
            console.error("new customer + caseCountry..." + caseCountry);
            
            var casePONumberRequired = cmp.find('casePONumberRequired').get("v.value");
            cmp.set("v.newCase.Subject", caseSubject);
            cmp.set("v.newCase.Add_New_Account__c", true);
            cmp.set("v.newCase.DBA__c", caseDBAName);
            cmp.set("v.newCase.Address_Line_1__c", caseAddressLine1);
            cmp.set("v.newCase.Address_Line_2__c", caseAddressLine2);
            cmp.set("v.newCase.City__c", caseCity);
            cmp.set("v.newCase.State__c", caseState);
            cmp.set("v.newCase.Zip__c", caseZip);
            cmp.set("v.newCase.Country__c", caseCountry);
            cmp.set("v.newCase.PO_Number_Required__c", casePONumberRequired);
        } else {
            var caseSubject = "New ProExchange User Request";
            var caseAccountNumber = cmp.find('caseAccountNumber').get("v.value");
            cmp.set("v.newCase.Subject", caseSubject);
            cmp.set("v.newCase.AccountId", caseCurrentAccountId);
            cmp.set("v.newCase.AccountNumber__c", caseAccountNumber);
            cmp.set("v.newCase.Add_New_Account__c", true);
        }
        
        console.log("handleRadioClick + caseNewCustomerSetupChecked: " + caseNewCustomerSetupChecked);
		console.log("saveRecord + createAccount: " + createAccount);
		console.log("saveRecord + caseFirstNamet: " + caseFirstName);
		console.log("saveRecord + caseLastName: " + caseLastName);
		console.log("saveRecord + caseEmailAddress: " + caseEmailAddress);
		console.log("saveRecord + casePhoneNumber: " + casePhoneNumber);
		console.log("saveRecord + caseUserAccess: " + caseUserAccess);
		console.log("saveRecord + caseAccountName: " + caseAccountName);
		console.log("saveRecord + account: " + JSON.stringify(account));
        console.log("handleAccessUpdate + caseNewCustomerSetup: " + caseNewCustomerSetup);
        
        var tempRec = cmp.find("forceRecord")
        var caseAccountRequest = cmp.get("{!v.newCase}");
        console.log("createCase...+ tempRec:..." + JSON.stringify(tempRec));
        console.log("createCase...+ caseAccountRequest:..." + JSON.stringify(caseAccountRequest));
        
        this.upsertCase(cmp, caseAccountRequest, function(a) {
            cmp.find("modalAccountRequestedWorking").closeModal();
            cmp.find("modalAccountRequested").openModal();
        });        
    },

    upsertCase: function(cmp, newCase, callback) {
        var action = cmp.get("c.createCase");
        action.setParams({ 
          "newCase": newCase
        });
        if (callback) {
          action.setCallback(this, callback);
        }
        $A.enqueueAction(action);        
    },

    handleRequestAccount: function(cmp){
        cmp.find("modalAccountRequestedWorking").openModal();
        this.handleCurrentAccountCheck(cmp);
    },


    handleNewCustomerSetup: function(cmp, evt){
        var checkCreateAccount = cmp.find('caseNewCustomerSetup').get('v.checked');
        cmp.set('v.createAccountChild', checkCreateAccount);
        if (checkCreateAccount == true) {
        	var accountAccess = this.getAccountAccessNew();           
        } 
        if (checkCreateAccount == false){
        	var accountAccess = this.getAccountAccessOld(); 
        }
        cmp.set('v.accountAccess', accountAccess); 
    },

    handleSubmit: function (cmp, evt) {
	    console.log("handleSubmit...");
        cmp.find("modalAccountRequestedWorking").openModal();
        var hasErrors;
        var errorMessage;
        // get all the form elements
        var createAccount = cmp.get("v.createAccountChild");
        var caseFirstName = cmp.find('caseFirstName').get("v.value");
        if (!caseFirstName) {
            hasErrors = true;
            errorMessage = 'Please enter a First Name.'
        }
        var caseLastName = cmp.find('caseLastName').get("v.value");
        if (!caseLastName) {
            hasErrors = true;
            errorMessage = 'Please enter a Last Name.'
        }
        var caseEmailAddress = cmp.find('caseEmailAddress').get("v.value");
        if (!caseEmailAddress) {
            hasErrors = true;
            errorMessage = 'Please enter an Email Address.'
        }
        var casePhoneNumber = cmp.find('casePhoneNumber').get("v.value");
        if (!casePhoneNumber) {
            hasErrors = true;
            errorMessage = 'Please enter a Phone Number.'
        } else if (isNaN(casePhoneNumber)) {
            hasErrors = true;
            errorMessage = 'Please enter only numbers for your Phone Number, and no extra charectors.'
        } else if (casePhoneNumber.length != 10 ) {
            hasErrors = true;
            errorMessage = 'Please enter enter 10 digit phone number for your Phone Number, and no extra charectors.'
        } 
        var caseAccountName = cmp.find('caseAccountName').get("v.value");
        if (!caseAccountName) {
            hasErrors = true;
            errorMessage = 'Please enter a Company Name.'
        }
        var caseUserAccess = "All";
        var caseAccountRequest = cmp.get("{!v.newCase}");
        var caseNewCustomerSetup = cmp.find('caseNewCustomerSetup').get("v.value");
        var caseNewCustomerSetupChecked = cmp.find('caseNewCustomerSetup').get('v.checked');
        
        cmp.set("v.newCase.AccountName__c", caseAccountName);
        cmp.set("v.newCase.First_Name__c", caseFirstName);
        cmp.set("v.newCase.Last_Name__c", caseLastName);
        cmp.set("v.newCase.Email_Address__c", caseEmailAddress);
        cmp.set("v.newCase.Phone_Number__c", casePhoneNumber);
        cmp.set("v.newCase.User_Access__c", caseUserAccess);
        
        if (caseNewCustomerSetupChecked) {
		    console.log("saveRecord + caseNewCustomerSetupChecked: " + caseNewCustomerSetupChecked);
            var caseSubject = "New ProExchange Account and User Request";
            var caseDBAName = cmp.find('caseDBAName').get("v.value");
            var caseAddressLine1 = cmp.find('caseAddressLine1').get("v.value");
		    console.log("saveRecord + caseAddressLine1: " + caseAddressLine1);
            if (!caseAddressLine1) {
                hasErrors = true;
                errorMessage = 'Please enter a Street Address.'
            }
            var caseCountry = cmp.find('caseCountry').get("v.value");
		    console.log("saveRecord + caseCountry: " + caseCountry);
            if (!caseCountry) {
                hasErrors = true;
                errorMessage = 'Please select a Country.'
            } else if (caseCountry == 'US') {
                var caseCity = cmp.find('caseUSCity').get("v.value");
    		    console.log("saveRecord + caseCity: " + caseCity);
                if (!caseCity) {
                    hasErrors = true;
                    errorMessage = 'Please enter a City.'
                }
                var caseState = cmp.find('caseUSState').get("v.value");
    		    console.log("saveRecord + caseState: " + caseState);
                if (!caseState) {
                    hasErrors = true;
                    errorMessage = 'Please select a State.'
                }
                var caseZip = cmp.find('caseUSZip').get("v.value");
    		    console.log("saveRecord + caseZip: " + caseZip);
                if (!caseZip) {
                    hasErrors = true;
                    errorMessage = 'Please enter a Zip Code.'
                }                
            } else if (caseCountry == 'CA') {
                var caseCity = cmp.find('caseCACity').get("v.value");
    		    console.log("saveRecord + caseCity: " + caseCity);
                if (!caseCity) {
                    hasErrors = true;
                    errorMessage = 'Please enter a City.'
                }
                var caseState = cmp.find('caseCAState').get("v.value");
    		    console.log("saveRecord + caseState: " + caseState);
                if (!caseState) {
                    hasErrors = true;
                    errorMessage = 'Please select a State.'
                }
                var caseZip = cmp.find('caseCAZip').get("v.value");
    		    console.log("saveRecord + caseZip: " + caseZip);
                if (!caseZip) {
                    hasErrors = true;
                    errorMessage = 'Please enter a Zip Code.'
                } 
            } else {
                var caseCity = cmp.find('caseITCity').get("v.value");
    		    console.log("saveRecord + caseCity: " + caseCity);
                if (!caseCity) {
                    hasErrors = true;
                    errorMessage = 'Please enter a City.'
                }
                var caseState = cmp.find('caseITState').get("v.value");
    		    console.log("saveRecord + caseState: " + caseState);
                if (!caseState) {
                    hasErrors = true;
                    errorMessage = 'Please select a State.'
                }
                var caseZip = cmp.find('caseITZip').get("v.value");
    		    console.log("saveRecord + caseZip: " + caseZip);
                if (!caseZip) {
                    hasErrors = true;
                    errorMessage = 'Please enter a Zip Code.'
                }                          
            }

            var casePONumberRequired = cmp.find('casePONumberRequired').get("v.value");
            cmp.set("v.newCase.Subject", caseSubject);
            cmp.set("v.newCase.Add_New_Account__c", true);
            cmp.set("v.newCase.DBA__c", caseDBAName);
            cmp.set("v.newCase.Address_Line_1__c", caseAddressLine1);
            cmp.set("v.newCase.City__c", caseCity);
            cmp.set("v.newCase.State__c", caseState);
            cmp.set("v.newCase.Zip__c", caseZip);
            cmp.set("v.newCase.Country__c", caseCountry);
            cmp.set("v.newCase.PO_Number_Required__c", casePONumberRequired);
        } else {
            var caseSubject = "New ProExchange User Request";
            var caseAccountNumber = cmp.find('caseAccountNumber').get("v.value");
            cmp.set("v.newCase.Subject", caseSubject);
            cmp.set("v.newCase.AccountNumber__c", caseAccountNumber);
            if (!caseAccountNumber) {
                hasErrors = true;
                errorMessage = 'Please enter an Account #.'
            } else if (caseAccountNumber.startsWith("054100")) {
                hasErrors = true;
                errorMessage = 'It looks like you entered an account that starts with 054100.  Please enter a valid account number, or if you do not have an account select the No Account Number checkbox.';
                cmp.find("caseAccountNumber").set("v.value", "");
            }
            cmp.set("v.newCase.Add_New_Account__c", true);
        }
        
        var caseAccountRequest = cmp.get("{!v.newCase}"); 
        console.log("handleSubmit + caseAccountRequest: " + JSON.stringify(caseAccountRequest));

        if (hasErrors == true) {
            console.log("handleSubmit + hasErrors: " + errorMessage);
            this.handleErrors(cmp, errorMessage)
        } else {
            this.handleRequestAccount(cmp);
        }
    },
    
    handleErrors: function(cmp, errorMessage) {
        var errorMessage = errorMessage;
        console.log("handleErrors + hasErrors: " + errorMessage);
        cmp.set('v.errorMessage', errorMessage);        
        cmp.find("modalErrorMessage").openModal();
        cmp.find("modalAccountRequestedWorking").closeModal();
    },
    
    navigateTo: function(cmp) {
        var navEvt = $A.get("e.force:navigateToURL");
        navEvt.setParams({
            "url": "/"
        });
        navEvt.fire();
    },
    
    onChildAttributeChange : function (cmp, event, helper) {
        console.log("Old value: " + event.getParam("oldValue"));
        console.log("Current value: " + event.getParam("value"));
    },   
    
    getAccountAccessAll: function(){
        console.log("v.createAccountChild : > " + v.createAccountChild);
        getAccountAccessNew();
    }, 
    
    getAccountAccessNew: function(){
        console.log("getAccountAccessNew");
        return [
            { value: '1', label: 'New account only' },
            { value: '2', label: 'New account AND future accounts' }
        ];
    }, 
    
    getAccountAccessOld: function(){
        console.log("getAccountAccessOld");
        return [
 			{ value: '1', label: 'Only to account entered' },
            { value: '2', label: 'Only to future accounts' },
            { value: '3', label: 'Only to existing accounts' },
            { value: '4', label: 'To future AND existing accounts added' }
        ];
    },
  
    handleTitleCase:  function (str) {
        console.log("handleTitleCase + str: " + str);
        str = str.toLowerCase().split(' ');
        for (var i = 0; i < str.length; i++) {
            str[i] = str[i].charAt(0).toUpperCase() + str[i].slice(1); 
        }
        var strTitle = str.join(' ');
        return strTitle;
    },
  
    handleIsFormValid: function(cmp, props){
        var isValid = true;
        
        console.log("handleIsFormValid + isValid: " + isValid);
        console.log("handleIsFormValid + props: " + JSON.stringify(props));
        
        if(props !== undefined && Array.isArray(props)){
            props.forEach(function (item) {
                console.log("handleIsFormValid + prop + item: " + item);
                // check if we are passing an aura:id or already are passing the aura object
                var value = (typeof item === 'string') ? cmp.find(item) : item;
        
                console.log("handleIsFormValid + prop + item + value: " + value);
                // make sure the object has the functions we need
                if(value !== undefined && value.showHelpMessageIfInvalid !== undefined && value.get !== undefined){
                    value.showHelpMessageIfInvalid();
                    isValid = isValid === false ? false : value.get('v.validity').valid;
                }
            });
        }
        
        return isValid;
    },
  
    helpers: {

        formatData: function(cmp, props){
            var results = {};
            if(props !== undefined && Array.isArray(props)){
                props.forEach(function (item) {
                    // check if we are passing an aura:id or already are passing the aura object
                    var value = (typeof item === 'string') ? cmp.find(item) : item;
                    var type = value.get('v.type');

                    if(value !== undefined && value.get !== undefined){
                        results[item] = (type !== undefined && type === 'checkbox') ? value.get('v.checked') : value.get('v.value');       
        				console.log("Current results: " + results);
                    }
                });
            }

            return results;
        }
        
    } // end helpers

})