/**
 * Created by 7Summits on 2/13/18.
 */
({

    /**
     * Set the current logged in user and
     * their selected location
     * @param cmp
     */
    getCurrentUser: function(cmp){
        var doCallout = this.doCallout(cmp, 'c.getUser', null);

        return new Promise($A.getCallback(function (resolve, reject) {
            doCallout.then(function(response){
                resolve(response);
            }, function(error){
                console.log('Dal_Base:getCurrentUser:Error:', error);
                reject(error);
            });
        }));
    },

    getUserSelectedLocation: function(cmp){
        var doCallout = this.doCallout(cmp, 'c.getUserSelectedLocation', null);

        return new Promise($A.getCallback(function (resolve, reject) {
            doCallout.then(function(response){
                resolve(response);
            }, function(error){
                console.log('Dal_Base:getUserSelectedLocation:Error:', error);
                reject(error);
            });
        }));
    },

    /**
     * Set locations available to the user
     * @param cmp
     */
    getUserLocations: function(cmp, communityType){
        var doCallout = this.doCallout(cmp, 'c.getUserLocations', {communityType: communityType});

        // returns a Peak_Response object
        return new Promise($A.getCallback(function (resolve, reject) {
            doCallout.then(function(response){
                if(response.success === true){
                    resolve(response);
                } else {
                    console.log('Dal_Base:getUserLocations:Error:', response.messages);
                    reject(response.messages);
                }
            }, function(error){
                console.log('Dal_Base:getUserLocations:Error:', error);
                reject(error);
            });
        }));
    },

    /**
     * Set the theme setting for the user
     * @param cmp
     */
    getThemeSettings: function(cmp, name){

        var doCallout = this.doCallout(cmp, 'c.getThemeSettings', {customSettingInstanceName: name});

        // returns a Peak_Response object
        return new Promise($A.getCallback(function (resolve, reject) {
            doCallout.then(function(response){
                if(response.success === true){
                    resolve(response);
                } else {
                    console.log('Dal_Base:getThemeSettings:Error:', response.messages);
                    reject(response.messages);
                }
            }, function(error){
                console.log('Dal_Base:getThemeSettings:Error:', error);
                reject(error);
            });
        }));
    },

    /**
     * Set the users account team
     * @param cmp
     */
    getAccountTeam: function(cmp){
        var doCallout = this.doCallout(cmp, 'c.getAccountTeam', null);

        // returns a Peak_Response object
        return new Promise($A.getCallback(function (resolve, reject) {
            doCallout.then(function(response){
                if(response.success === true){
                    resolve(response);
                } else {
                    console.log('Dal_Base:getAccountTeam:Error:', response.messages);
                    reject(response.messages);
                }
            }, function(error){
                console.log('Dal_Base:getAccountTeam:Error:', error);
                reject(error);
            });
        }));
    },

    /**
     * Give a locationId will set that location to the User object
     * @param locationId
     * @returns {*}
     */
    setUserLocation: function(cmp, locationId){
        var self = this;
        return new Promise($A.getCallback(function (resolve, reject) {
            if(locationId !== undefined){
                var doCallout = self.doCallout(cmp, 'c.setUserSelectedLocation', {locationId: locationId});

                // returns a Peak_Response object
                doCallout.then(function(response){
                    if(response.success === true){
                        resolve(response);
                    } else {
                        console.log('Dal_Base:setUserLocation:Error:', response.messages);
                        reject(response.messages);
                    }
                }, function(error){
                    console.log('Dal_Base:setUserLocation:Error:', error);
                    reject(error);
                });

            } else {
                console.log('Dal_Base:setUserLocation:Error:locationId undefined');
                reject('locationId undefined');
            }
        }));
    },

    /**
     * Yes we are extending Peak_Base but Peak_Base and this component
     * have different controllers and when we call the inherited doCallout
     * it uses Peak_Base's controller. So implementing doCallout here.
     */
    doCallout: function (component, method, params) {
       console.log("params--",params);
        return new Promise($A.getCallback(function (resolve, reject) {
            // Set action and param
            var action = component.get(method);
            if (params !== null && params !== undefined){
                action.setParams(params);
            }
            // Callback
            action.setCallback(component, function (response) {
                var state = response.getState();

                if (component.isValid() && state === 'SUCCESS') {
                    if(response.getReturnValue() !== undefined){
                        resolve(response.getReturnValue());
                    } else {
                        reject('Return Value Undefined');
                    }
                } else {
                    var errors = response.getError();
                    reject(errors);
                }
            });
            $A.enqueueAction(action);
        }));
    },

    isValidJavascriptDate: function(date){
        if (Object.prototype.toString.call(date) === '[object Date]'){
            return !isNaN(date.getTime());
        } else {
            return false;
        }
    },

    /**
     * Given an object or an array returns a deep
     * copy of that element.
     * @param object
     * @returns {*}
     */
    copy: function(object){
        var output, value, key;
        output = Array.isArray(object) ? [] : {};
        for (key in object) {
            value = object[key];
            output[key] = (typeof value === "object") ? this.copy(value) : value;
        }
        return output;
    },

    openModal: function(cmp, componentName, componentData,  showCloseButton, customClasses){
        var modal =  new Promise(function(resolve, reject){

            // doing a check to make sure the implementing component has
            // baseModal declared as an attribute. if not fail and
            // then show an error message in the logs.
            var baseModal = cmp.get('v.baseModal');
            if(baseModal === undefined){
                reject();
                console.error('Dal_Base:openModal:Error: Need to add "<aura:attribute name="baseModal" type="Map" />" to the child component page.');
            }

            // check to make sure we have a component name, it may not be valid but we have one
            if(componentName !== undefined && componentName !== ''){
                $A.createComponent(componentName, componentData || {}, function(content, status, errorMessage) {
                    if (status === 'SUCCESS') {
                        var overlayLib = cmp.find('overlayLib');

                        // make sure we have an overlay library
                        if(overlayLib !== undefined){
                            // create overlay object and open it
                            var modal = cmp.find('overlayLib').showCustomModal({
                                body: content || '',
                                showCloseButton: showCloseButton || false,
                                cssClass: ('dal-modal ' + customClasses) || ''
                            }); // end showCustomModal

                            // creating an overlay returns a promise, resolve the promise
                            // by returning the overlay upon success else reject.
                            modal.then(function(modal){
                                resolve({
                                    modal: modal
                                });
                            }, function(){
                                reject();
                            });
                        } else {
                            reject();
                            console.error('Dal_Base:openModal:Error: Need to add "<lightning:overlayLibrary aura:id="overlayLib" />" to the child component page.');
                        } // end check for overlay library

                    } // end success check

                    // Content body not found, reject
                    else {
                        console.log('Dal_Base:Error:Could not find content body.', errorMessage);
                        reject();
                    }// end if
                });
            }

            // Content body not provided, reject
            else {
                console.log('Dal_Base:Error:Content body not provided.');
                reject();
            }// end if
        });

        // set the modal the view, extending child needs to have
        // this attribute declared.
        cmp.set('v.baseModal', modal);

        return modal;

    }, // end openModal

    closeModal: function(cmp){
        var baseModal = cmp.get('v.baseModal');

        // make sure baseModal exists
        if(baseModal !== undefined) {
            // the overlay is a promise, but will already
            // be resolved so call the 'then' and close
            // use the returned overlay to close it.
            baseModal.then(function(response){
                // close the overlay
                if(response !== undefined && response.modal !== undefined){
                    response.modal.close();
                }
            });

        } else {
            console.error('Dal_Base:closeModal:Error: Need to add "<aura:attribute name="baseModal" type="Map" />" to the child component page.');
        }
    },

    getStatesOptions: function(){
        return [
            { value: 'AL', label: 'Alabama' },
            { value: 'AK', label: 'Alaska' },
            { value: 'AZ', label: 'Arizona' },
            { value: 'AR', label: 'Arkansas' },
            { value: 'CA', label: 'California' },
            { value: 'CO', label: 'Colorado' },
            { value: 'CT', label: 'Connecticut' },
            { value: 'DE', label: 'Delaware' },
            { value: 'DC', label: 'District Of Columbia' },
            { value: 'FL', label: 'Florida' },
            { value: 'GA', label: 'Georgia' },
            { value: 'HI', label: 'Hawaii' },
            { value: 'ID', label: 'Idaho' },
            { value: 'IL', label: 'Illinois' },
            { value: 'IN', label: 'Indiana' },
            { value: 'IA', label: 'Iowa' },
            { value: 'KS', label: 'Kansas' },
            { value: 'KY', label: 'Kentucky' },
            { value: 'LA', label: 'Louisiana' },
            { value: 'ME', label: 'Maine' },
            { value: 'MD', label: 'Maryland' },
            { value: 'MA', label: 'Massachusetts' },
            { value: 'MI', label: 'Michigan' },
            { value: 'MN', label: 'Minnesota' },
            { value: 'MS', label: 'Mississippi' },
            { value: 'MO', label: 'Missouri' },
            { value: 'MT', label: 'Montana' },
            { value: 'NE', label: 'Nebraska' },
            { value: 'NV', label: 'Nevada' },
            { value: 'NH', label: 'New Hampshire' },
            { value: 'NJ', label: 'New Jersey' },
            { value: 'NM', label: 'New Mexico' },
            { value: 'NY', label: 'New York' },
            { value: 'NC', label: 'North Carolina' },
            { value: 'ND', label: 'North Dakota' },
            { value: 'OH', label: 'Ohio' },
            { value: 'OK', label: 'Oklahoma' },
            { value: 'OR', label: 'Oregon' },
            { value: 'PA', label: 'Pennsylvania' },
            { value: 'RI', label: 'Rhode Island' },
            { value: 'SC', label: 'South Carolina' },
            { value: 'SD', label: 'South Dakota' },
            { value: 'TN', label: 'Tennessee' },
            { value: 'TX', label: 'Texas' },
            { value: 'UT', label: 'Utah' },
            { value: 'VT', label: 'Vermont' },
            { value: 'VA', label: 'Virginia' },
            { value: 'WA', label: 'Washington' },
            { value: 'WV', label: 'West Virginia' },
            { value: 'WI', label: 'Wisconsin' },
            { value: 'WY', label: 'Wyoming' }
        ];
    }, // end get state options

    getUrlHashByName: function getUrlHashByName(name) {
        var url = window.location.href;
        var regex = new RegExp('[#]' + name + '(=(.+))');
        var results = regex.exec(url);

        // The name was not a query string param
        if (!results) {
            return null;
        }

        // The name was a query string param but didn't have a value
        if (!results[2]) {
            return '';
        }

        // success return the value
        return decodeURIComponent(results[2].replace(/\+/g, ' '));
    },

    getUrlParamByName: function getUrlParamByName(name) {
        var url = window.location.href;
        var regex = new RegExp( '[?&]' + name + '=([^&#]*)', 'i' );
        var results = regex.exec(url);

        // The name was not a query string param
        if (!results) {
            return null;
        }

        // The name was a query string param but didn't have a value
        if (!results[1]) {
            return '';
        }

        // success return the value
        return decodeURIComponent(results[1].replace(/\+/g, ' '));
    },

    mergeObjects: function() {
        var resObj = {};
        for(var i=0; i < arguments.length; i += 1) {
            var obj = arguments[i],
                keys = Object.keys(obj);
            for(var j=0; j < keys.length; j += 1) {
                resObj[keys[j]] = obj[keys[j]];
            }
        }
        return resObj;
    },

    isValidShippingDate: function(cmp, date){
        // first check is if the date is in the YYYY-MM-DD format
        // when there is a valid date entered in the component it
        // is returned in this format.
        var regEx = /^\d{4}-\d{1,2}-\d{1,2}$/;

        // check if format is incorrect
        if(date === undefined || !date.match(regEx)){
            cmp.set('v.errorsShippingDate', [{message:'Invalid Date'}]);
            return false
        }

        // now we know the format is correct, lets check if it is a valid date
        var jsDateObject = $A.localizationService.parseDateTime(date, 'yyyy-M-d');
        if(!jsDateObject.getTime() && jsDateObject.getTime() !== 0){
            cmp.set('v.errorsShippingDate', [{message:'Invalid Date'}]);
            return false
        }

        // now we know we have a valid date but lets make sure it is in the future from today.
        var isDateInFuture = $A.localizationService.isAfter(jsDateObject, new Date(), 'millisecond');

        // if date isn't in the future, return false and set errors
        if(isDateInFuture === false){
            cmp.set('v.errorsShippingDate', [{message:'Date must be in the future'}]);
            return false
        }

        // date is valid clear errors and return true
        else {
            cmp.set('v.errorsShippingDate', []);
            return true;
        }

    },

    goToSavedOrderPage: function(){
        this.doGotoURL($A.get("$Label.c.Dal_BaseHelper_GotoUrl_Label"));
    },

    goToSchedulePickupsDeliveries: function(orderNumbers){
        this.doGotoURL('/schedule-pickups-deliveries?orderIds=' + orderNumbers);
    },

    goToSchedulePickupsDeliveriesWithMultiple: function(orderNumbers){
        this.doGotoURL('/schedule-pickups-deliveries?orderIds=' + orderNumbers +"#multiple");
    },

    goToAllOrderPage : function(oppNumbers){
        this.doGotoURL('/relate-an-order?oppIds=' + oppNumbers +"#relateOpportunity");
    },
 
    formatPickupDeliveryDate: function(dateString){
        debugger;
        var dateFormatted;
		
        var _getDay = ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'];
        var _getMonth = ['Jan','Feb','Mar','Apr','May','June','July','Aug','Sept','Oct','Nov','Dec'];
        /*
        var _convertedDate = new Date(Date.UTC(dateString));
        var _newDate = _convertedDate.getDate();
        */
        var d=dateString.split("-");
        if(d.length < 2) {
            d=dateString.split("/");
        }
        
        if(d[2].indexOf('T') > -1){
           d[2] = d[2].substring(0, d[2].indexOf('T'));
        }
    	var newDateByString = new Date(d[0],d[1]-1,d[2]);
        
        var dateFormatted1 =  _getDay[(newDateByString.getDay())] + ', ' + _getMonth[(newDateByString.getMonth())] + ' ' + newDateByString.getDate(); //( _newDate > 9 ? _newDate : ('0'+_newDate)); 
        //console.log('TEST: ', _convertedDate.getDay());
        //console.log('_getDay: ', dateFormatted1);
        /*
        //var dateFormatted1 = _getDay[_convertedDat.getDay()] + ', ' + _convertedDate.getMonth() + ' ' + _convertedDate.getDate();
        console.log('dateFormatted1: ' , dateFormatted1);
        */
        try {
            dateFormatted = $A.localizationService.formatDate(dateString, 'EEEE, MMM DD');
        } catch(e) {
            var parsedDateTime = $A.localizationService.parseDateTime(dateString, 'yyyy-M-D');
            dateFormatted = $A.localizationService.formatDate(parsedDateTime, 'EEEE, MMM DD');
        }

        return dateFormatted1;
    }

})