trigger TaskCreatorTrigger on Task_Creator__c (after delete, after insert, after update, before delete, before insert, before update) {
    if( TriggerControl__c.getValues('TaskCreatorTrigger') != null ) {
        Boolean tc = TriggerControl__c.getValues('TaskCreatorTrigger').IsActive__c;
        if( tc == TRUE ) {
            TriggerFactory.createAndExecuteHandler(TaskCreatorHandler.class);
        } 
    }
}