/* Copyright © 2016-2018 7Summits, Inc. All rights reserved. */
@isTest
public with sharing class Peak_SiteMapControllerTest {
    
    @testSetup static void setup() {
        UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType ='None' limit 1];
        update new User(Id=userInfo.getUserId(), UserRoleId = ur.Id);
        
        system.runAs(new User(Id=userInfo.getUserId())) {
            // User
            User testUser = Peak_TestUtils.createStandardUser();
            insert testUser;
            
            // Query network
            List<Network> networks = [Select Id from Network limit 1];
            
            // Create some Feed Items - have to use current user ID otherwise you get cross-reference ID errors!
            List<FeedItem> feedItems = Peak_TestUtils.createFeedItems(Peak_TestConstants.HOW_MANY,networks[0].Id,UserInfo.getUserId());
            insert feedItems;
            
            // Create some topics
            List<Topic> topics = Peak_TestUtils.createTopics(Peak_TestConstants.HOW_MANY,networks[0].Id);
            insert topics;
            
            // system.assertEquals(topics.size(),5);
            
            // Now create a list of Topic Assignments and insert them!
            List<TopicAssignment> topicAssignments = new List<TopicAssignment>();
            for (FeedItem feedItem : feedItems){
                TopicAssignment newAssignment = Peak_TestUtils.createTopicAssignment(topics[0].Id,feedItem.Id,networks[0].id);
                topicAssignments.add(newAssignment);
            }
            insert topicAssignments;
        }
    }
    
    @isTest
    public static void testSiteMapController(){
        // Basic assert that XML heading is not null  
        Peak_SiteMapController testController = new Peak_SiteMapController();
        System.assert(testController.XMLHeadingInformation != null);
        
        Peak_Response testResponse = Peak_SiteMapController.getNavigationMenuItemsWrapper();
        system.assert(testResponse.success);
    }
    
    @isTest
    public static void testTopicFeeds(){
        List<Network> networks = [Select Id from Network limit 1];
        
        // Basic test of getting topics
        List<Topic> topics = Peak_SiteMapController.getAllTopics(networks[0].id);
        System.assertEquals(topics.size(),Peak_TestConstants.HOW_MANY);
        
        // Alright, now find topic feeds
        List<FeedItem> feedItems = Peak_SiteMapController.getFeedItemsForAllTopics(networks[0].id);
        System.assertEquals(feedItems.size(),Peak_TestConstants.HOW_MANY);
        
        // Test the actual sitemap method, but don't expect a real result as we're not running in context of a Network. Just assert that it has a success
        Peak_Response testResponse = Peak_SiteMapController.getFeedItemsForAllTopicsCurrentCommunity();
        system.assert(testResponse.success);
    }
}