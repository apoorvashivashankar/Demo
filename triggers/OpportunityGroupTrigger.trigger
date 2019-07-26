trigger OpportunityGroupTrigger on GroupOpportunity__c (before insert, before update, before delete, after insert, after update, after delete) 
{   
    if( TriggerControl__c.getValues('OpportunityGroupTrigger') != null ) {
	    Boolean tc = TriggerControl__c.getValues('OpportunityGroupTrigger').IsActive__c;
	    if( tc == TRUE ) {
	        TriggerFactory.createAndExecuteHandler(OpportunityGroupHandler.class);
	    } ELSE {

	    }
	}
}