/* Copyright © 2016-2018 7Summits, Inc. All rights reserved. */
public without sharing class Peak_KnowledgeSiteMapController {

    public Peak_KnowledgeSiteMapController() {
    }
    
    public Integer siteSearchLimit { set; get;}{siteSearchLimit = 5000;}
    public Integer ceiling { set; get;}{ceiling = 999;}

    public String siteUrl{
        get {
            String surl = URL.getSalesforceBaseUrl().toExternalForm();
            
            if (surl != '' && surl != null) {
                return surl;
            } else {
                return site.getBaseUrl();
            }
        }
        set;
    }

    public List<List<KnowledgeArticleVersion>> listOfAllArticles{
        get {
            List<List<KnowledgeArticleVersion>> listOfUrlsTmp = new List<List<KnowledgeArticleVersion>>();
            // Removed ArticleType from field list, since not available in lightning knowledge
            List<KnowledgeArticleVersion> articleList = [SELECT Language, UrlName, LastPublishedDate FROM KnowledgeArticleVersion WHERE IsVisibleInPkb = TRUE AND PublishStatus='Online' AND Language = 'en_US' LIMIT :siteSearchLimit];
            listOfUrlsTmp = disectList(articleList);
            return listOfUrlsTmp;
        }
        private set;
    }


    private List<List<KnowledgeArticleVersion>> disectList(List<KnowledgeArticleVersion> articleList){
        List<List<KnowledgeArticleVersion>> articleListList = new List<List<KnowledgeArticleVersion>>();
        List<KnowledgeArticleVersion> articleList2 = new List<KnowledgeArticleVersion>();

        for(KnowledgeArticleVersion article : articleList){
            if(articleListList.size() == (ceiling-1)){
                break;
            }

            if(articleList2.size() == ceiling){
                articleListList.add(articleList2);
                articleList2 = new List<KnowledgeArticleVersion>();
            }

            articleList2.add(article);
        }

        articleListList.add(articleList2);
        articleList2 = new List<KnowledgeArticleVersion>();

        return articleListList;
    }
}