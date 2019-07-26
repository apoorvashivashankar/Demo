// Copyright ©2016-2017 7Summits Inc. All rights reserved.
({
	getFeaturedNews : function(component) {

        this.debug(component,'Featured 1+4 Across called..',null);

		var action = component.get("c.getFeaturedNews");
        action.setParams({
            recordId1: component.get("v.recordId1"),
            recordId2: component.get("v.recordId2"),
            recordId3: component.get("v.recordId3"),
            recordId4: component.get("v.recordId4"),
            recordId5: component.get("v.recordId5"),
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var newsListWrapper  = response.getReturnValue();

                for(var i=0;i< newsListWrapper.newsList.length;i++){
                    newsListWrapper.newsList[i].strTime = moment.utc(newsListWrapper.newsList[i].Publish_DateTime__c).fromNow();
                    if(newsListWrapper.newsList[i].Name.length > 40){
                        newsListWrapper.newsList[i].Name = newsListWrapper.newsList[i].Name.substring(0,40);
                    }


                  newsListWrapper.newsList[i].topics1 = [];
                  newsListWrapper.newsList[i].topics1.push(newsListWrapper.newsToTopicsMap[newsListWrapper.newsList[i].Id]);
                  newsListWrapper.newsList[i].topics = [];

                  /* Logic for topics will be displayed till 27 characters only */
                    if(newsListWrapper.newsList[i].topics1 !== undefined){
                        for(var j=0;j< newsListWrapper.newsList[i].topics1.length;j++){
                            var newsTopicname='';
                            if(newsListWrapper.newsList[i].topics1[j] !== undefined){
                                for(var jj=0;jj< newsListWrapper.newsList[i].topics1[j].length;jj++){
                                    newsTopicname += newsListWrapper.newsList[i].topics1[j][jj].Topic.Name;
                                    /*if(newsTopicname.length <= 27 && newsListWrapper.newsList[i].topics !== undefined){
                                        newsListWrapper.newsList[i].topics.push(newsListWrapper.newsList[i].topics1[j][jj]);
                                    }*/
                                    if(newsListWrapper.newsList[i].topics !== undefined){
                                        newsListWrapper.newsList[i].topics.push(newsListWrapper.newsList[i].topics1[j][jj]);
                                    }
                                }
                            }
                        }
                    }

                }

                component.set("v.newsListWrapper", newsListWrapper);
            }
        });
        $A.enqueueAction(action);
	},
    get_SitePrefix : function(component) {
    	var action = component.get("c.getSitePrefix");
        action.setCallback(this, function(actionResult) {
            var sitePath = actionResult.getReturnValue();
            component.set("v.sitePath", sitePath);
            //component.set("v.sitePrefix", sitePath.replace("/s",""));
		});
        $A.enqueueAction(action);

        var action1 = component.get("c.isObjectCreatable");
        action1.setCallback(this, function(actionResult1) {
            var isObjectCreatable = actionResult1.getReturnValue();
            component.set("v.isObjectCreatable", isObjectCreatable);
        });
        $A.enqueueAction(action1);
    },
    debug: function(component, msg, variable) {

        var debugMode = component.get("v.debugMode");
        if(debugMode){
            if(msg){
            	console.log(msg);
            }
            if(variable){
            	console.log(variable);
            }
        }
    }
})