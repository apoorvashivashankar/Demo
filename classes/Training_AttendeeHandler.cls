public with sharing class Training_AttendeeHandler 
    implements ITrigger
	{

    private Set<Id> m_inUseIds = new Set<Id>();
 	Event[] insertTrainingEvents = new Event[]{};
    User[] updateUserTraining = new User[]{};
 	Event[] deleteTrainingEvents = new Event[]{};
    User[] deleteUserTraining = new User[]{};
    Training_Attendee__c[] insertTrainingAtendee = new Training_Attendee__c[]{};

	public Training_AttendeeHandler() {
	}

    public void bulkBefore()
    {
        if (Trigger.isDelete)
        {
        	System.debug('====Training_AttendeeHandler + bulkBefore + Trigger.newMap.keySet(): ' + Trigger.oldMap.keySet()); 
        	deleteTrainingEvents = Training_AttendeeGateway.delGroupEvents(Trigger.oldMap.keySet());	
        	deleteUserTraining = Training_AttendeeGateway.delUserTrainingFlag(Trigger.oldMap.keySet());
        }
        if (Trigger.isInsert || Trigger.isUpdate) 
        {
    	}
    }
 
    public void bulkAfter()
    {
        if (Trigger.isDelete)
        {
        }
        if (Trigger.isInsert || Trigger.isUpdate) 
        {
        	insertTrainingEvents = Training_AttendeeGateway.newGroupEvents(Trigger.newMap.keySet());
            updateUserTraining = Training_AttendeeGateway.newUserTrainingUpdates(Trigger.newMap.keySet());
            System.debug('====Training_AttendeeHandler + insertTrainingEvents: ' + insertTrainingEvents); 
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
        if (!insertTrainingEvents.isEmpty())
        {
            insert insertTrainingEvents;
        }
        if (!updateUserTraining.isEmpty())
        {
            update updateUserTraining;
        }   
        if (!deleteTrainingEvents.isEmpty())
        {
            delete deleteTrainingEvents;
        }
        if (!deleteUserTraining.isEmpty())
        {
            update deleteUserTraining;
        }               
    }
}