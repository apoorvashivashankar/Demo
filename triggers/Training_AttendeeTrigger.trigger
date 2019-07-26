trigger Training_AttendeeTrigger on Training_Attendee__c (after delete, after insert, after update, before delete, before insert, before update)
{
    if( TriggerControl__c.getValues('Training_AttendeeTrigger') != null ) {
	    Boolean tc = TriggerControl__c.getValues('Training_AttendeeTrigger').IsActive__c;
	    if( tc == TRUE ) {
	        TriggerFactory.createAndExecuteHandler(Training_AttendeeHandler.class);
	    } ELSE {

	    }
	}
}