/* Copyright © 2016-2018 7Summits, Inc. All rights reserved. */
@isTest
private class Peak_KnowledgeSiteMapControllerTest {
    
    @isTest static void test_siteUrl() {
        Peak_KnowledgeSiteMapController controller = new Peak_KnowledgeSiteMapController();

        String url = controller.siteUrl;
        system.assert(url.length() > 0);
    }
    
    @isTest(SeeAllData=true) static void test_Search() {
        Peak_KnowledgeSiteMapController controller = new Peak_KnowledgeSiteMapController();
        controller.siteSearchLimit = 100;
        controller.ceiling = 5;
        List<List<KnowledgeArticleVersion>> articles = controller.listOfAllArticles;
        
    }
}