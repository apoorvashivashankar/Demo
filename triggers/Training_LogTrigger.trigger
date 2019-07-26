trigger Training_LogTrigger on Training_Log__c (after delete, after insert, after update, before delete, before insert, before update)
{
    if( TriggerControl__c.getValues('Training_LogTrigger') != null ) {
	    Boolean tc = TriggerControl__c.getValues('Training_LogTrigger').IsActive__c;
	    if( tc == TRUE ) {
	        TriggerFactory.createAndExecuteHandler(Training_LogHandler.class);
	    } ELSE {

	    }
	}
}