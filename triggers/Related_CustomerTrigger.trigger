trigger Related_CustomerTrigger on Related_Customer__c (after delete, after insert, after update, before delete, before insert, before update)
{
    if( TriggerControl__c.getValues('Related_CustomerTrigger') != null ) {
	    Boolean tc = TriggerControl__c.getValues('Related_CustomerTrigger').IsActive__c;
	    if( tc == TRUE ) {
	        TriggerFactory.createAndExecuteHandler(Related_CustomerHandler.class);
	    } ELSE {
 
	    }
	}
}