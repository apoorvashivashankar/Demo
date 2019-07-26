trigger Dal_UserTrigger on User (after insert) {
    Dal_UserTriggerHandler.generateSharing(Trigger.New);
}