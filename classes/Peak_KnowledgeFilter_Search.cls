/**
 * Created by 7Summits on 8/3/17.
 */

public with sharing class Peak_KnowledgeFilter_Search {

    public static Peak_KnowledgeFilter_SearchResults doSearch(String searchTerm, List<String> topicFilterOne, List<String> topicFilterTwo, List<String> topicFilterThree, List<String> topicFilterFour,  String orderByField, String orderByDirection){
        String netwrkId = System.Network.getNetworkId();

        // prepare query data
        String objectType = 'KnowledgeArticleVersion';
        String fields = 'KnowledgeArticleId, Title, ArticleTotalViewCount, LastModifiedDate';
        String withClause = '';
        String soslLimitClause = 'LIMIT 2000';
        String soqlLimitClause = 'LIMIT 50000';
        String offsetClause = '';

        // create where clause
        String whereClause = 'WHERE PublishStatus=\'online\' AND Language = \'en_US\' AND IsLatestVersion=true';

        if(!topicFilterOne.isEmpty()){
            List<Id> topicFilterOneIds = Peak_KnowledgeFilter_SearchTA.getTopicAssignments(topicFilterOne);
            whereClause += ' AND Id IN :topicFilterOneIds';

            if(!topicFilterTwo.isEmpty()){
                List<Id> topicFilterTwoIds = Peak_KnowledgeFilter_SearchTA.getTopicAssignments(topicFilterTwo);
                whereClause += ' AND Id IN :topicFilterTwoIds';
            }

            if(!topicFilterThree.isEmpty()){
                List<Id> topicFilterThreeIds = Peak_KnowledgeFilter_SearchTA.getTopicAssignments(topicFilterThree);
                whereClause += ' AND Id IN :topicFilterThreeIds';
            }

            if(!topicFilterFour.isEmpty()){
                List<Id> topicFilterFourIds = Peak_KnowledgeFilter_SearchTA.getTopicAssignments(topicFilterFour);
                whereClause += ' AND Id IN :topicFilterFourIds';
            }
        }

        // create order by field
        String orderBy = (String.isNotEmpty(orderByField)) ? ('ORDER BY ' + orderByField) : 'ORDER BY LastModifiedDate';
        orderBy += (String.isNotEmpty(orderByDirection)) ? (' ' + orderByDirection) : ' DESC';

        // create results object that will be returned
        Peak_KnowledgeFilter_SearchResults results;

        // Check if there is a searchTerm, if there is we need to use SOSL instead of SOQL
        if (String.isNotEmpty(searchTerm.trim())) {
            String searchQuery = String.format('FIND \'\'{0}\'\' RETURNING {1}({2} {3} {7} {5} {6})  {4}', new String[] {searchTerm, objectType, fields, whereClause, withClause, soslLimitClause, offsetClause, orderBy});
            System.debug('Peak_KnowledgeFilterSearch SOSL Query: ' + searchQuery);

            // execute search
            Search.SearchResults searchResults = Search.find(searchQuery);

            // get the results
            List<Search.SearchResult> articlelist = searchResults.get(objectType);
            System.debug('Peak_KnowledgeFilterSearch SOSL Query: -------------------> RESULTS:' + articlelist);
            results = new Peak_KnowledgeFilter_SearchResults(articlelist);
        }

        // Execute SOQL query
        else {
            String searchQuery = String.format('SELECT {0} FROM {1} {2} {3} {6} {4} {5}', new String[] {fields, objectType, whereClause, withClause, soqlLimitClause, offsetClause, orderBy});
            System.debug('Peak_KnowledgeFilterSearch SOQL Query: ' + searchQuery);

            // execute search
            List<KnowledgeArticleVersion> dbResults = Database.query(searchQuery);
            System.debug('Peak_KnowledgeFilterSearch SOQL Query: -------------------> RESULTS:' + dbResults);

            results = new Peak_KnowledgeFilter_SearchResults(dbResults);
        }

        return results;

    }

}