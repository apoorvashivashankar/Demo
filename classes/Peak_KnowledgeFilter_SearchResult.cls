/**
 * Created by 7Summits on 8/3/17.
 */

public with sharing class Peak_KnowledgeFilter_SearchResult {

    @auraEnabled public String id{get;set;}
    @auraEnabled public String title{get;set;}
    @auraEnabled public Integer viewCount{get;set;}
    @auraEnabled public DateTime lastModifiedDate{get;set;}
    @auraEnabled public List<Peak_KnowledgeFilter_SearchResultTopic> topics{get;set;}

    public Peak_KnowledgeFilter_SearchResult(String articleId, String title, Integer articleViewCount, DateTime lastModifiedDate, List<Peak_KnowledgeFilter_SearchResultTopic> topics){
        this.id = articleId;
        this.title = title;
        this.viewCount = articleViewCount;
        this.lastModifiedDate = lastModifiedDate;
        this.topics = topics;
    }

}