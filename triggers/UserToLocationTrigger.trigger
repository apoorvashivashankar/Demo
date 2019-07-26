trigger UserToLocationTrigger on User_to_Location__c (after delete, after insert, after update, before delete, before insert, before update) {
    if( TriggerControl__c.getValues('UserToLocationTrigger') != null ) {
        Boolean tc = TriggerControl__c.getValues('UserToLocationTrigger').IsActive__c;
        if( tc == TRUE ) {
            TriggerFactory.createAndExecuteHandler(UserToLocationHandler.class);
        } 
    }
}