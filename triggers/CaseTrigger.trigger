trigger CaseTrigger on Case (after delete, after insert, after update, before delete, before insert, before update) {
    if( TriggerControl__c.getValues('CaseTrigger') != null ) {
        Boolean tc = TriggerControl__c.getValues('CaseTrigger').IsActive__c;
        if( tc == TRUE ) {
            TriggerFactory.createAndExecuteHandler(CaseHandler.class);
        } 
    }
}