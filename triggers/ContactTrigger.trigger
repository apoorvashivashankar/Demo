trigger ContactTrigger on Contact (after delete, after insert, after update, before delete, before insert, before update) {
    if( TriggerControl__c.getValues('ContactTrigger') != null ) {
        Boolean tc = TriggerControl__c.getValues('ContactTrigger').IsActive__c;
        if( tc == TRUE ) {
            TriggerFactory.createAndExecuteHandler(ContactHandler.class);
        } 
    }
}