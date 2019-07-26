trigger UserTrigger on User (before insert, before update, after insert, after update) {
    if( TriggerControl__c.getValues('UserTrigger') != null ) {
      Boolean tc = TriggerControl__c.getValues('UserTrigger').IsActive__c;
      if( tc == TRUE ) {
          TriggerFactory.createAndExecuteHandler(UserHandler.class);
      }
  }
}