/*Copyright © 2016-2018 7Summits, Inc. All rights reserved.*/
({
	doSort : function(filter, component) {
        var element = component.find(filter);
        var people = component.get('v.people');

        if($A.util.hasClass(element, "asc")){
            people.reverse(function (a, b) {
                return a[filter] - b[filter];
            });

            $A.util.addClass(element, 'desc');
        	$A.util.removeClass(element, 'asc');
        }else{
            people.sort(function (a, b) {
                return a[filter] - b[filter];
            });

            $A.util.removeClass(element, 'desc');
        	$A.util.addClass(element, 'asc');
        }

		component.set('v.people', people);
	},

    doGetData : function(component){
        var action = component.get('c.getData');
        var hideInternal = component.get("v.hideInternal");
        var recordNum = component.get("v.numberOfRecords");

        action.setParams({
            'hideInternal': hideInternal,
            'recordNum': recordNum
        });

        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var data = JSON.parse(response.getReturnValue());

	            // fix the notorious apostrophe - it is encoded coming via http rest call
	            var people = data.results;

                for(var pos =0; pos < people.length; ++pos) {
                    var name = people[pos].result.displayName.replace(/&#39;/g, '\'');
	                people[pos].result.displayName = name;
                }

                component.set('v.people', people);
            }
        });
        $A.enqueueAction(action);
    },

	reputationEnabled : function (component) {
		var action = component.get('c.isReputationEnabled');

		action.setCallback(this, function(response){
			var state = response.getState();
			if (state === 'SUCCESS') {
				component.set('v.reputationEnabled', response.getReturnValue());
			}
		});

		$A.enqueueAction(action);
	},

   	getSitePrefix: function(component) {
    	var action = component.get("c.getSitePrefix");
        action.setCallback(this, function(actionResult) {
            var sitePath = actionResult.getReturnValue();
            //console.log("featured user sitePath",sitePath);
            component.set("v.sitePath", sitePath);
            // component.set("v.sitePrefix", sitePath.replace("/s",""));
		});
        $A.enqueueAction(action);
    }
})