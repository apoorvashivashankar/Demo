/**
 * Created by 7Summits on 2/16/18.
 */
({
    
    init: function(cmp){
        var self = this;
        var communityType = cmp.get('v.communityType');

        // Get the currently selected location
        var getUserSelectedLocation = this.getUserSelectedLocation(cmp);
        getUserSelectedLocation.then(function(response){
            self.helpers.handleGetUserSelectedLocationSuccess(cmp, response);
        }, function(error){
            console.log('Dal_LocationSwitcher:getUserSelectedLocation:error:' + error);
        });

        // get the available locations for the user
        var getUserLocations = this.getUserLocations(cmp, communityType);
        getUserLocations.then(function(response){
            self.helpers.handleGetUserLocationsSuccess(cmp, response);
        }, function(error){
            console.log('Dal_LocationSwitcher:getUserLocations:error:' + error);
        });
        
        // once we have the currently selected location and the users location we can set their location name
        Promise.all([getUserSelectedLocation, getUserLocations]).then(function(results) {
            // check if the user has locations
            if(self.helpers.peakHasResults(results[1])) {
                self.helpers.setLocationName(cmp);
            } else {
                cmp.set('v.showNoLocations',  true);
            }
        });

    },

    /**
     * When the user selects a new location, will set that
     * location back to DB as well as update the view.
     * @param cmp
     * @param evt
     */
    handleLocationSelected: function(cmp, evt, helper){
        //debugger;
        // show the loader to the user
        cmp.set('v.showLoading', true);

        var self = this;
        var id = evt.getParam('id');

        // Store
        var _oldAccountId = sessionStorage.getItem('newAccountId');
        //var obj = {"newAccountId": id,"oldAccountId": _oldAccountId};
        sessionStorage.setItem('newAccountId', id);
        sessionStorage.setItem('showPop', "true");
        if(_oldAccountId != null){
            sessionStorage.setItem('oldAccountId', _oldAccountId);
        }else{
            sessionStorage.setItem('oldAccountId', id);
        }

        var _isSelected = evt.getParam('isSelected');
		//var selectedAcc = cmp.get('v.selectedLocationId');
        if(! _isSelected){
            var LocationSwitcherCartEvent = $A.get("e.c:Dal_SSC_LocationSwitcherCartEvent");
            LocationSwitcherCartEvent.setParams({
               "selectedAccountId" : id
               });
            LocationSwitcherCartEvent.fire();
            // var selectedCart = self.doCallout(cmp, 'c.getAcccountCartDetail', {accountId: id});
            /*var action = cmp.get("c.getAcccountCartDetail");

            action.setParams({ accountId : id });

               action.setCallback(this, function(response) {
                   var state = response.getState();
                   if (state === "SUCCESS") {
                        var result = response.getReturnValue();
                        var idacc = evt.getParam('id');
                        if(result != null && result !=''){
                               *//*self.openModal(cmp,'c:Dal_SSC_LocationSwitcherModal',{
                                       cartId : result,
                                       accountId : id
                                    },
                                    false,
                                    'dal-modal_small'
                               );*//*


                       }else{
                               // make call to update the DB with the selected location
                               var setUserLocation = self.setUserLocation(cmp, id);

                               // we will set the location right away in the view
                               // but change it back if something went wrong
                               self.helpers.setLocationName(cmp, id);
                               this.toggleSelectLocation(cmp); // close the location selector

                               // handle the response from the set location call
                               setUserLocation.then(function(response){
                                   // Success, reload the page to show the new settings
                                   var baseCommunityUrl = window.location.href.substring(0, window.location.href.lastIndexOf('/s/'));
                                   window.open(baseCommunityUrl,'_top');
                               }, function(error){
                                   console.log('Dal_LocationSwitcher:handleLocationSelected:error:' + error);
                                   self.showMessage('error', 'Unable to save your location.');
                                   cmp.set('v.showLoading', false);
                                   self.helpers.setLocationName(cmp); // something went wrong change the view back
                               });
                       }


                   }

               });

            cmp.set('v.showLoading', false);
            $A.enqueueAction(action);
*/
        }else{
             self.handleLocationSelectedForCart(cmp, evt, helper);
        }
    },

    /**
     * Hide/show user locations menu
     * @param cmp
     */
    toggleSelectLocation: function(cmp){
        var toggleLocationList = cmp.find('locationList').getElement();
        if(toggleLocationList != null){
            if(toggleLocationList.classList.contains('slds-hide'))
                $A.util.removeClass(toggleLocationList, 'slds-hide');
            else
                $A.util.addClass(toggleLocationList, 'slds-hide');
        }
    },

    // shared helpers (function should be only used internal to the file)
    helpers: {

        /**
         * Handle the get user selected location response
         * @param cmp
         * @param response
         */
        handleGetUserSelectedLocationSuccess: function(cmp, response){
            // check if the user has a selected location, is so set it
            if(response !== undefined && response.Id !== undefined){
                cmp.set('v.selectedLocationId', response.Id);
                sessionStorage.setItem('newAccountId', response.Id);
            }
        }, // end handleGetCurrentUserSuccess

        /**
         * Handle the get user location response
         * @param cmp
         * @param response
         */
        handleGetUserLocationsSuccess: function(cmp, response){
            var self = this;
            
            // lets format the results a bit
            var formattedResults = [];
            if(self.peakHasResults(response)){
                response.results.forEach(function(result){
                    var formattedObj = {
                        id: result.Id || '',
                        name: result.Name || '',
                        dwId: result.DW_ID__c || '',
                        dbaName: result.DBA_Name__c || '',
                        sbu: result.SBU__c || '',
                        city: result.ShippingCity || '',
                        divisionName:(result.Division_Name__c != undefined && result.Division_Name__c != '') ? result.Division_Name__r.Name : ''
                    };

                    // create display name
                    formattedObj.displayName = self.createLocationName(formattedObj);

                    // add object to the results
                    formattedResults.push(formattedObj);
                });
            }

            // get the user locations to the view
            cmp.set('v.userLocations', formattedResults);
        }, // end handleGetUserLocationsSuccess

        /**
         * Set the users selected location name, if a location
         * 'id' is provided use that to find the name if not use the
         * 'selectedLocationId' attribute.
         * @param cmp
         * @param id - location id
         */
        setLocationName: function(cmp, id){
            var locations = cmp.get('v.userLocations');
            var selectedLocationId = (id !== undefined) ? id : cmp.get('v.selectedLocationId');

            // iterate all the locations
            for(var x=0; x<locations.length; x++){
                if(locations[x].id === selectedLocationId){
                    cmp.set('v.selectedLocationName', locations[x].displayName);
                    break;
                }
            }
        },  // end setLocationName

        /**
         * Format the display name of the location for consistency
         * @param location
         * @returns {string}
         */
        createLocationName: function(location){
            var dwId = location.dwId || '';
            var name = (location.name !== undefined && location.name !== '') ? (' / ' + location.name) : '';
            var dbaName = (location.dbaName !== undefined && location.dbaName !== '') ? (' / ' + location.dbaName) : '';
            //var sbu = (location.sbu !== undefined && location.sbu !== '') ? (' / ' + location.sbu) : '';
            var brandName = (location.divisionName !== undefined && location.divisionName !== '') ? (' / ' + location.divisionName) : '';
			var city= (location.city !== undefined && location.city !== '') ? (' / ' + location.city) : '';
            brandName= brandName.replace('Sales SBU','');
            brandName= brandName.replace('DISTRB SBU','');
            return dwId + name + dbaName +city+ brandName;
        }, // end createLocationName

        /**
         * Return if peak response object has results or not
         * @param peakResponse
         * @returns {boolean}
         */
        peakHasResults: function(peakResponse){
            return (peakResponse !== undefined && peakResponse.results !== undefined && Array.isArray(peakResponse.results) && peakResponse.results.length > 0);
        }

    }, // end helpers

    handleLocationSelectedForCart : function(cmp, evt, helper){
        var self = this;
        //debugger;
                //var id = evt.getParam('selectedAccountId');
               var id = evt.getParam('selectedAccountId'); 
              // make call to update the DB with the selected location
               var setUserLocation = self.setUserLocation(cmp, id);

               // we will set the location right away in the view
               // but change it back if something went wrong
               self.helpers.setLocationName(cmp, id);
               this.toggleSelectLocation(cmp); // close the location selector

               // handle the response from the set location call
               setUserLocation.then(function(response){
                   // Success, reload the page to show the new settings
                   var baseCommunityUrl = window.location.href.substring(0, window.location.href.lastIndexOf('/s/'));
                   window.open(baseCommunityUrl,'_top');
               }, function(error){
                   console.log('Dal_LocationSwitcher:handleLocationSelected:error:' + error);
                   self.showMessage('error', 'Unable to save your location.');
                   cmp.set('v.showLoading', false);
                   self.helpers.setLocationName(cmp); // something went wrong change the view back
               });
    }
})