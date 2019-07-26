/*Copyright © 2016-2018 7Summits, Inc. All rights reserved.*/
({
	doInit : function(component, event, helper) {
		helper.reputationEnabled(component);
        helper.doGetData(component);
        helper.getSitePrefix(component);
	},
    
    sortPosts : function(component, event, helper){
        helper.doSort("posts", component);
    },
 
 	sortComments : function(component, event, helper){
        helper.doSort("comments", component);
    },

	sortLikes : function(component, event, helper){
        helper.doSort("likes", component);
    },
    
    sortRank : function(component, event, helper){
        helper.doSort("rank", component);
    },
    
    sortPoints : function(component, event, helper){
        helper.doSort("points", component);
    }
})