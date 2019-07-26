// Copyright ©2016-2017 7Summits Inc. All rights reserved.
/**
 * Created by francoiskorb on 9/21/16.
 */
({

    debug: function(component, msg, variable) {
        if (component.get("v.debugMode")) {
            if (msg) {
                console.log(msg);
            }
            if(variable) {
                console.log(variable);
            }
        }
    }
})