trigger OpportunityTrigger on Opportunity (after delete, after insert, after update, before delete, before insert, before update)
{
    if( TriggerControl__c.getValues('OpportunityTrigger') != null ) {
	    Boolean tc = TriggerControl__c.getValues('OpportunityTrigger').IsActive__c;
	    if( tc == TRUE ) {
	        TriggerFactory.createAndExecuteHandler(OpportunityHandler.class);
	    } ELSE {

	    }
	}
}