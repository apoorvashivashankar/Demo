trigger LeadTrigger on Lead (after delete, after insert, after update, before delete, before insert, before update) {
    if( TriggerControl__c.getValues('LeadTrigger') != null ) {
	    Boolean tc = TriggerControl__c.getValues('LeadTrigger').IsActive__c;
	    if( tc == TRUE ) {
	        TriggerFactory.createAndExecuteHandler(LeadHandler.class);
	    } else {
 
	    }
	}
}