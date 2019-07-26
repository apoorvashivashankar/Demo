public without sharing class Training_LogHandler 
    implements ITrigger
{
    // Member variable to hold the Id's of Accounts 'in use'
    private Set<Id> m_inUseIds = new Set<Id>();
    Training_Attendee__c[] insertTrainingAtendee = new Training_Attendee__c[]{};


    // Member variable to record Audit records
    private List<Training_Log__c> m_logs = new List<Training_Log__c>();
 
    // Constructor
    public Training_LogHandler()
    {
    } 
 
    public void bulkBefore()
    {
        if (Trigger.isDelete)
        {
        }
        if (Trigger.isInsert || Trigger.isUpdate) 
        {
    	}
    }
 
    public void bulkAfter()
    {
    	if (Trigger.isInsert || Trigger.isUpdate) 
        {
            insertTrainingAtendee = Training_LogGateway.newTrainingAtendee(Trigger.newMap.keySet());
        }
    }
 
    public void beforeInsert(SObject so)
    {
    }
 
    public void beforeUpdate(SObject oldSo, SObject so)
    {
    }
 
 
    public void beforeDelete(SObject so)
    {
    }
 
    public void afterInsert(SObject so)
    {
    }
 
    public void afterUpdate(SObject oldSo, SObject so)
    {
    }
 
    public void afterDelete(SObject so)
    {
    }
 
    public void andFinally()
    {
        if (!insertTrainingAtendee.isEmpty())
        {
            insert insertTrainingAtendee;
        }
    }
}