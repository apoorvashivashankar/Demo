({
    initPeakStatProgressBar: function(component,event,helper){


        // Calculate percent complete
        var percentComplete = Math.round( 100*(component.get("v.figure1")/component.get("v.figure2")));

        // Set to percent complete attribute
        component.set("v.percentComplete", percentComplete);
        //console.log("initprogressBar = " + percentComplete)
        var isVertical = component.get("v.isVertical");
        var className = component.get("v.CustomClassName");
        if (isVertical === true){
            className += " is-vertical";
        } else {
            className += " is-horizontal";
        }
        component.set("v.CustomClassName", className );

        // If past 100%, just leave marker at 100%
        setTimeout(function(){


            if (percentComplete > 100){
                component.set("v.progressMarkerPosition", 100);
            } else {
                component.set("v.progressMarkerPosition", percentComplete);
            }
        },1); // need timeout for CSS animation

    },
    statReturned: function(component, event, helper) {
        //console.log("statReturned");
        var params = event.getParam('arguments');

        component.set("v.figure1", params.result1);
        component.set("v.figure2", params.result2);
        //console.log("v.figure1 SR = ", params.result1);
        //console.log("v.figure2 SR = ", params.result2);
        var percentComplete = Math.round( 100*(component.get("v.figure1")/component.get("v.figure2")));
        //console.log("percent complete = ", percentComplete);
        // Set to percent complete attribute
        component.set("v.percentComplete", percentComplete);
        if (percentComplete > 100){
            component.set("v.progressMarkerPosition", 100);
        } else {
            component.set("v.progressMarkerPosition", percentComplete);
        }

    }
})