/* Copyright © 2016-2018 7Summits, Inc. All rights reserved. */
public without sharing class Peak_SiteMapController {

    public String XMLHeadingInformation { get; set; }
    public String orgLocale{get;set;}
    public String baseURL{get;set;}

    public Peak_SiteMapController(){
        XMLHeadingInformation  = '<?xml version="1.0" encoding="UTF-8" ?>';

        // Get current user org, get the org's locale
        List<Organization> orgDetails = [SELECT Id, LanguageLocaleKey FROM Organization WHERE Id = :UserInfo.getOrganizationId()];
        orgLocale = orgDetails[0].LanguageLocaleKey;

        baseURL =  System.Site.getBaseUrl() + System.Site.getPathPrefix() +'/s';
    }

    // Get the list of navigation menu items
    @AuraEnabled
    public static Peak_Response getNavigationMenuItemsWrapper() {

        Peak_Response peakResponse = new Peak_Response();

        // Get all of the navigation menu items
        List<NavigationMenuItem> navigationMenuItemList = [SELECT Id,
                AccessRestriction,
                Label,
                NavigationLinkSetId,
                //ParentId,
                Position,
                Target,
                LastModifiedDate,
                Type 
            FROM NavigationMenuItem];

        for (NavigationMenuItem currentNavigationMenuItem : navigationMenuItemList) {
            String currentTarget = currentNavigationMenuItem.Target;

            // If there is a URL-based target for this (so NOT a Menu Label or Topic Link)
            if (currentTarget != null && currentTarget.substring(0, 1) == '/') {
                Peak_ContentObject peakContentObject = new Peak_ContentObject();
                peakContentObject.title = currentNavigationMenuItem.Label;
                peakContentObject.url = currentNavigationMenuItem.Target;
                peakContentObject.dateTimeField = currentNavigationMenuItem.LastModifiedDate;

                peakResponse.peakResults.add(peakContentObject);
            }
        }

        
        // Return
        return peakResponse;
    }

    // Get FeedItems for current community, return Peak Response. If you'd like to fetch for only topics, create a similar method that then calls getFeedItemsForTopics
    @AuraEnabled
    public static Peak_Response getFeedItemsForAllTopicsCurrentCommunity() {
        Peak_Response peakResponse = new Peak_Response();
        List<FeedItem> feedItems = getFeedItemsForAllTopics(Network.getNetworkId());

        for (FeedItem feedItem : feedItems){
            Peak_ContentObject peakContentObject = new Peak_ContentObject();
            peakContentObject.title = feedItem.Title;
            // peakContentObject.url = '/'+feedItem.Type.replace('Post','').toLowerCase()+'/'+feedItem.Id; // base url, plus the type (minus the word Post and to lower case), plus the ID
            peakContentObject.url = '/feed/'+feedItem.Id; // feed always works, regardless of type!

            peakContentObject.dateTimeField = feedItem.LastModifiedDate;
            peakResponse.peakResults.add(peakContentObject);
        }

        return peakResponse;
    }

    // Get the list of Topic Feed
    @AuraEnabled
    public static List<FeedItem> getFeedItemsForTopics(List<Id> topicIds) {
        List<FeedItem> feedItems = new List<FeedItem>();

        // Query the topic assignments, making sure to get EntityId
        List<TopicAssignment> topicAssignments = [Select EntityId,TopicId
            from TopicAssignment
            where TopicId in :topicIds];

        // Build list of entity IDs in those topic assignments
        List<Id> entityIds = new List<Id>();
        for (TopicAssignment topicAssignment : topicAssignments){
            entityIds.add(topicAssignment.EntityId);
        }

        // Finally, query those feed items
        feedItems = [Select Title,LinkUrl,Id,LastModifiedDate,Type
            from FeedItem
            where Id in: entityIds];

        return feedItems;
    }

    // Get the list of Topic Feed
    @AuraEnabled
    public static List<FeedItem> getFeedItemsForAllTopics(Id networkId) {
        List<Topic> allTopics = getAllTopics(networkId);
        List<Id> topicIds = new List<Id>();

        for (Topic thisTopic : allTopics){
            topicIds.add(thisTopic.Id);
        }

        return getFeedItemsForTopics(topicIds);
    }

    // Get the list of Topic Feed for currently running Network
    @AuraEnabled
    public static List<Topic>  getAllTopics(Id networkId) {
        List<Topic> allTopics = [select Id, Name, NetworkId
            from Topic
            where NetworkId = :networkId];

        return allTopics;
    }
}