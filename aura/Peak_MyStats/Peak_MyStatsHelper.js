/**
 * Created by michaelsullivan on 6/7/17.
 */
({
    getMyNewOpps: function (component, location) {
        //console.log("getting MyNewOpps stat - helper");
        var action = component.get("c.getMyNewOpps");
        action.setCallback(this, function(response) {
            var state = response.getState();
            //console.log("getMyNewOpps response = ", response.getReturnValue());
            if (component.isValid() && state === "SUCCESS"){
                //console.log(" SUCCESS getMyNewOpps response = ", response.getReturnValue());
                // grab as var to add the currency symbol...
                var respToString = response.getReturnValue();
                //console.log("getnewopps string = " +respToString);
                respToString.figure2 = "$" + respToString.figure2;
                component.set(location,respToString);
                //console.log('getMyNewOpps');
                //console.dir(component);
            }

            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);

    },
    getMyClosedWonOpps: function (component,location) {
        //console.log("getting ClosedWonOpps stat - helper");
        var action = component.get("c.getMyClosedWonOpps");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS"){
                //console.log("Success getMyClosedWonOpps response = ", response.getReturnValue());
                // grab as var to add the currency symbol...
                var respToString = response.getReturnValue();
                respToString.figure2 = "$" + respToString.figure2;
                component.set(location,respToString);

            }

            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },
    getSampleStat: function (component, location) {
        //console.log("getting sample stat -- helper");
        var self = this;
        var suffix = location.replace("v.stat", "");
        //console.log("location = ", location);
        //console.log("suffix = ", suffix);
        var action = component.get("c.getSampleStatApex");
        action.setCallback(this, function(response) {
            //console.log("Sample Stat response = ", response);
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS"){

                var got = response.getReturnValue();
                //console.log("getSampleStat = ", got);
                var thisCount = "v.count";
                var thisTotal = "v.total";
                if (suffix != '1') {
                    thisCount += suffix;
                    thisTotal += suffix;
                }

                //component.set(location,response.getReturnValue());
                component.set(thisCount, got.figure1);
                component.set(thisTotal,got.figure2);
                // console.log("location = ",location);
                // console.log("v.count = ", component.get(thisCount));
                // console.log("v.total = ", component.get(thisTotal));

                var countName = "v.count";
                var totalName = "v.total";
                var mode = "v.statMode";
                if (suffix !== '1'){
                    countName += suffix;
                    totalName += suffix;
                    mode += suffix;
                }
                var thisMode = component.get(mode);
                //console.log("mode = ", thisMode);


                // var thisCount = component.get(countName);
                // var thisTotal = component.get(totalName);
                // var childCmp = component.find(mode);
                // console.log("childCmp = ", childCmp);
                // childCmp.statUpdated(thisCount, thisTotal);
                self.statUpdater(component,  thisMode,countName, totalName, suffix);
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },
    setStatContainerClasses: function(component) {
        var activeStats = 0;
        var stat1 = component.get("v.showStat1");
        var mode1 = component.get("v.statMode");
        var stat2 = component.get("v.showStat2");
        var mode2 = component.get("v.statMode2");
        var stat3 = component.get("v.showStat3");
        var mode3 = component.get("v.statMode3");
        var stat4 = component.get("v.showStat4");
        var mode4 = component.get("v.statMode4");
        var containerClasses = "slds-size_1-of-1 slds-small-order_2 slds-m-around_xx-small slds-card_compact";
        var modifiedClass = " slds-medium-size_1-of-";
        var modifiedClassDW = " slds-medium-size_2-of-";
        var containerClassesDW = "";

        if (stat1 === true){
            //console.log("Mode1 =", mode1);
            if(mode1 == 'Peak_StatProgressBar'){
                activeStats = activeStats + 2;
                component.set("v.statDoubleWide1", true);
                var checker = component.get('v.statDoubleWide1');
                var statSwitch = component.get('v.stat');
                // console.log("peak stat = ", statSwitch);
                // console.log("doubleWide?",checker);
                // console.log("ActiveStats = ", activeStats);
            } else {
                activeStats++;
            }
        }
        if (stat2 === true){
            if(mode2 == 'Peak_StatProgressBar'){
                activeStats = activeStats + 2;
                component.set("v.statDoubleWide2", true);
            } else {
                activeStats++;
            }
        }
        if (stat3 === true && activeStats < 4){
            if(mode3 == 'Peak_StatProgressBar' ){
                if (activeStats < 3) {
                    activeStats = activeStats + 2;
                    component.set("v.statDoubleWide3", true);
                } else {
                    component.set("v.showStat3", false);
                    alert("Component does not fit in remaining space");
                }
            } else {
                activeStats++;
            }
        }
        if (stat4 === true && activeStats < 4){
            if(mode4 == 'Peak_StatProgressBar' ){
                component.set("v.showStat4", false);
                alert("Component does not fit in remaining space");
            } else {
                activeStats++;
            }
        }
        if (activeStats > 0) {
            modifiedClass = (modifiedClass + activeStats);
            modifiedClassDW = (modifiedClassDW + activeStats);
            //console.log("modified = ", modifiedClass);
            containerClassesDW = (containerClasses + modifiedClassDW);
            containerClasses = (containerClasses + modifiedClass);

            component.set("v.containerClasses", containerClasses);
            component.set("v.containerClassesDW", containerClassesDW);

        }

        //console.log("classes = ", component.get("v.containerClasses"));
    },

    queryManager: function(statLocation, statRequest, component) {
        switch(statRequest) {
            case 'getSampleStat':
                this.getSampleStat(component, statLocation);
                break;
            case 'getMyNewOpps':
                this.getMyNewOpps(component, statLocation);
                break;
            case 'getMyClosedWonOpps':
                this.getMyClosedWonOpps(component, statLocation);
                break;
        }



    },
    statUpdater: function(component, mode, countName, totalName, suffix) {
        var slot = "slot" + suffix;
        var thisCount = component.get(countName);
        var thisTotal = component.get(totalName);
        var childCmp = component.find(slot);
        if ( childCmp.statReturned){
            childCmp.statReturned(thisCount, thisTotal);
        }

    }
})