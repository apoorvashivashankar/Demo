trigger ChangeRequestTrigger on Change_Request__c (after insert, after update, before update, before Insert) {
    if( TriggerControl__c.getValues('ChangeRequestTrigger') != null ) {
        Boolean tc = TriggerControl__c.getValues('ChangeRequestTrigger').IsActive__c;
        if( tc == TRUE ) {
            TriggerFactory.createAndExecuteHandler(ChangeRequestHandler.class);
        } 
    }
}