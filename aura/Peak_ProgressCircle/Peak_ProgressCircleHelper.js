({
    doInit : function(component, event, helper)  {
        helper.computeProgress(component, event, helper);

    },
    computeProgress : function(component, event, helper)  {
        var totalVal = component.get("v.totalProgress");
        //console.log("totalProgress = " + totalVal);
        var actualVal = component.get("v.actualProgress");
        //console.log("actualProgress = " + actualVal);

        var threshold = component.get("v.threshold");
        var beforeTheme = component.get("v.themeBeforeThreshold");
        var afterTheme = component.get("v.themeAfterThreshold");
        var statContainer = component.get("v.statContainerId");

        if(totalVal != null && actualVal != null && !isNaN(parseInt(totalVal)) && isFinite(totalVal) && !isNaN(parseInt(actualVal)) && isFinite(actualVal)){
            //parameter is number

            var percVal = parseFloat(parseInt(actualVal) / parseInt(totalVal));
            //console.log(statContainer + " progress percent = " + (percVal * 100));
            var progressVal = parseInt(  percVal * 360  );
            if (progressVal > 360) {
                // console.log("over 100%"); 
                var modulusVal = percVal % 1;
                //document.getElementById(statContainer).classList.add('over100');
                var over100 = '';
                over100 += component.get("v.CustomClassName");
                over100 += " over100";
                component.set("v.CustomClassName", over100);

                progressVal = parseInt((modulusVal) * 360);

            }

            if(beforeTheme != undefined && afterTheme != undefined){
                if((percVal * 100) >= threshold){
                    component.set("v.theme" , afterTheme );
                }else{
                    component.set("v.theme" , beforeTheme );
                }
            }
            component.set("v.cirDeg" , progressVal );
            component.set("v.perText" , parseInt(Math.round(percVal * 100)));
        }else if(actualVal === null || actualVal === ''){
            //not needed if using in Peak_MyStats rather than
            //helper.callApexMethod(component, event, helper, totalVal, actualVal);
        }else{
            //values are used directly
            if(actualVal >= threshold){
                component.set("v.theme" , afterTheme );
            }else{
                component.set("v.theme" , beforeTheme );
            }
        }
    },
    callApexMethod : function(component, event, helper, txt_totalVal, txt_actualVal)  {
        var action = component.get('c.computePercentage');
        var txt_recordId = component.get("v.recordId");
        var txt_sObjectName = component.get("v.sObjectName");

        action.setParams({
            recordId : txt_recordId,
            sObjectName : txt_sObjectName,
            totalValueFieldName : txt_totalVal,
            actualValueFieldName : txt_actualVal
        });

        action.setCallback(this, function(a) {
            if (a.getState() === 'SUCCESS') {
                var retObj =  JSON.parse(a.getReturnValue())  ;
                //console.log("retObj = ", retObj);
                var threshold = component.get("v.threshold");
                var beforeTheme = component.get("v.themeBeforeThreshold");
                var afterTheme = component.get("v.themeAfterThreshold");

                component.set("v.totalProgress" , retObj.total );
                component.set("v.actualProgress" , retObj.actual );

                if( parseInt(retObj.val) >= threshold){
                    component.set("v.theme" , afterTheme );
                }else{
                    component.set("v.theme" , beforeTheme );
                }

                var progressVal = parseInt(  (retObj.val/100) * 360  ) ;
                component.set("v.cirDeg" , progressVal );
                component.set("v.perText" , parseInt(retObj.val)  +'%' );
            }
        });
        $A.enqueueAction(action);
    }

})