trigger OpportunityLineItemTrigger on OpportunityLineItem (after delete, after insert, after update, before delete, before insert, before update)
{	
	System.debug('::::OpportunityLineItemTrigger + 1');
	        TriggerFactory.createAndExecuteHandler(OpportunityLineItemHandler.class);
/*	
    if( TriggerControl__c.getValues('OpportunityLineItemTrigger') != null ) {
    	System.debug('::::OpportunityLineItemTrigger + 2');
	    Boolean tc = TriggerControl__c.getValues('OpportunityLineItemTrigger').IsActive__c;
	    if( tc == TRUE ) {
	    	System.debug('::::OpportunityLineItemTrigger + 3');
	    } ELSE {
	    	System.debug('::::OpportunityLineItemTrigger + 4');
	    }
	}
*/
}