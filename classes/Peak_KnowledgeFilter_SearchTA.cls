/**
 * Created by 7Summits on 1/30/18.
 */

public without sharing class Peak_KnowledgeFilter_SearchTA {

    public static List<Id> getTopicAssignments(List<String> topicIds) {
        List<TopicAssignment> topicAssignments = [SELECT EntityId FROM TopicAssignment WHERE IsDeleted = false AND TopicId IN :topicIds];

        List<Id> results = new List<Id>();

        for (TopicAssignment t : topicAssignments) {
            results.add(t.EntityId);
        }

        return results;
    }

}