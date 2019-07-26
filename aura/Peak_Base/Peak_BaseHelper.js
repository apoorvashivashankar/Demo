/**
 * Edited by Joe Callin on 8/12/2017.
 */
({
    getSitePrefix: function(component) {
        var action = component.get("c.getSitePrefix");
        action.setCallback(this, function(actionResult) {
            var sitePrefix = actionResult.getReturnValue();
            component.set("v.sitePrefix", sitePrefix);
        });
        $A.enqueueAction(action);
    },
    getIsGuest: function(component) {
        // Create the action
        var action = component.get("c.isGuestUser");

        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.isGuest", response.getReturnValue());
            }
            else {
                console.log("Failed with state: " + state);
            }
            // component.set("v.isInit", true);
        });
        component.set("v.isGuestInit", true);

        // Send action off to be executed
        $A.enqueueAction(action);
    },
    setLabel: function(component, extendedText, attribute) {
        var labelRegex = /^\$Label\.([a-zA-Z0-9_]*\.){1}([a-zA-Z0-9_]+)$/;
        var text = component.get('v.labelText');
        if(extendedText != undefined){
            text = extendedText;
        }
        if (text !== undefined && text !== '') {
            if (text.indexOf('$Label') !== -1) {
                var label = '';
                if (labelRegex.test(text)) {
                    label = $A.getReference(text);
                } else {
                    label = 'This is an invalid label. Please check it.'
                }
                if(extendedText != undefined){
                    component.set('v.' + attribute, label);
                }else{
                    component.set('v.label', label);
                }
            } else {
                component.set('v.label', text);
            }
        } else {
            component.set('v.label', text);
        }
    },
    setLabelEvent: function(component, text, attribute) {
        this.setLabel(component, text, attribute);
    },
    /*
        Usage:
        helper.doCallout(component,"c.yourApexMethod",({"paramName" : component.get("v.propertyName")})).then(function(response){
                component.set("v.yourSaveProperty",response);

                if (!response.success){
                    helper.showMessage('Error',response.messages[0]);
                } else {
                    // Your success route
                }

            });

            // Why not showToast property like in some other uses... so that we can show either success OR error messages and put more control extending component, not base component
     */
    doCallout: function (component, method, params) {
        return new Promise(function (resolve, reject) {
            // Set action and param
            var action = component.get(method);
            if (params != null) {
                action.setParams(params);
            }
            // Callback
            action.setCallback(component, function (response) {
                var state = response.getState();
                if (component.isValid() && state === "SUCCESS") {
                    resolve(response.getReturnValue());
                } else {
                    var errors = response.getError();
                    reject(errors);
                }
            })
            $A.enqueueAction(action);
        });
    },
    /*
        Great way to check for IE
     */
    checkForIE: function(){
        var ua = window.navigator.userAgent;
        var msie = ua.indexOf('MSIE ');
        if (msie > 0) {
            // IE 10 or older => return version number
            return parseInt(ua.substring(msie + 5, ua.indexOf('.', msie)), 10);
        }
        var trident = ua.indexOf('Trident/');
        if (trident > 0) {
            // IE 11 => return version number
            var rv = ua.indexOf('rv:');
            return parseInt(ua.substring(rv + 3, ua.indexOf('.', rv)), 10);
        }
        var edge = ua.indexOf('Edge/');
        if (edge > 0) {
            // Edge (IE 12+) => return version number
            return parseInt(ua.substring(edge + 5, ua.indexOf('.', edge)), 10);
        }
        // other browser
        return false;
    },
    showMessage: function(level, message) {
        // console.log("Message (" + level + "): " + message);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title" : level === "error" ? "Error" : "Message",
            "message" : message,
            "type" : level
        });
        toastEvent.fire();
    },
    validateField: function validateField(component, parentComponent, fieldName, showErrorMsg, hideRequiredFieldErrors) {
        var findIn = null;
        if (parentComponent != null) {
            // Get the element's actual parent component (for example, something in <c:NestedComponent aura:id="NestedThang" />
            findIn = component.find(parentComponent);
        } else {
            findIn = component;
        }

        // Get the field itself
        var inputField = findIn.find(fieldName);

        // Get aura validity
        var validity = inputField.get("v.validity");

        if (!validity.valid) {

            // is the field invalid because it is missing a value,
            // meaning it it a required field
            var isMissingValueError = validity.valueMissing;

            // if showErrorMsg msg is true or is undefined show error messages
            if((showErrorMsg === true || showErrorMsg === undefined)
                && (hideRequiredFieldErrors === false || hideRequiredFieldErrors === undefined || (hideRequiredFieldErrors === true && isMissingValueError === false))){
                inputField.showHelpMessageIfInvalid();
            }

            return false;
        } else {
            return true;
        }
    },
    // Validate a field without aura
    rawValidateField: function rawValidateField(fieldName) {
        // Because some dynamically created components aren't found by aura :/
        // Why name and not ID? Because aura doesn't let you put an id on lightning:input or lightning:select!
        var fields = document.getElementsByName(fieldName);
        if (fields.length > 0) {
            if (fields[0].value != null && fields[0].value != '') {
                return true;
            } else {
                // Hm, trying to trigger the native aura blur effect for form validation fields[0].blur();
                return false;
            }
        }
    },
    // Validate a field against a certain value
    rawValidateFieldAgainst: function rawValidateFieldAgainst(fieldName, expectedValue, equals) {
        // Because some dynamically created components aren't found by aura :/
        var fields = document.getElementsByName(fieldName);
        if (fields.length > 0) {
            if (fields[0].value != null && fields[0].value != '') {
                // Check for equals
                if (equals) {
                    if (fields[0].value == expectedValue) {
                        return true;
                    }
                } else {
                    // Check not equals
                    if (fields[0].value != expectedValue) {
                        return true;
                    }
                }
            }
        }
        return false;
    },
    /*
     Validate an entire form.
     Pass in the component by reference
     parent component (if you are validating a nested component... so if you have Peak_Form which includes <c:Peak_FormPart>, you would call validateForm(component,Peak_FormPart...
     Array of fields - these will find inputs by their aura:id

     Usage: in your extending component's helper
     requiredFields: ['Name','Address','City','Country','State','Zip','Phone','Email'],
     validateFormAddressForm: function (component,event,helper) {
        var isValid = helper.validateForm(component,null,this.requiredFields);
     }
     */
    validateForm: function validateForm(component, parentComponent, requiredFields, showErrorMsg, hideRequiredFieldErrors) {
        var valid = true;
        for (var x = 0; x < requiredFields.length; x++) {
            if (!this.validateField(component, parentComponent, requiredFields[x], showErrorMsg, hideRequiredFieldErrors)) {
                valid = false;
            }
        }

        return valid;
    },

    /**
     * Given a component name will return a promise with that component
     * ex: 'c:MyComponentName'
     * @param componentName
     * @returns {Promise}
     */
    getComponent: function(componentName){
        return new Promise(function(resolve, reject) {
            if(componentName !== undefined && componentName !== ''){
                $A.createComponent(componentName, {}, function(content, status) {
                    if (status === 'SUCCESS') {
                        resolve(content);
                    } else {
                        console.log('Peak_Base:getComponent:Error:Could not find component.');
                        reject();
                    }// end if
                });
            } else {
                console.log('Peak_Base:getComponent:Error:Could not find componentName.');
                reject();
            }
        });
    },

    doGotoURL: function(url, target){
        var urlEvent = $A.get('e.force:navigateToURL');

        // if the target is blank open in new window else use
        // force:navigateToURL and let that handle opening the
        // page. Note: navigateToURl will automatically open in
        // new window if the URL is external
        if(target === '_blank') {
            window.open(url, '_blank');
        } else {
            urlEvent.setParams({
                'url': url
            });

            urlEvent.fire();
        }
    }

})