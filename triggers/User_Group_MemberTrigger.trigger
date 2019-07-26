trigger User_Group_MemberTrigger on User_Group_Member__c (after delete, after insert, after update, before delete, before insert, before update)
{
    if( TriggerControl__c.getValues('User_Group_MemberTrigger') != null ) {
	    Boolean tc = TriggerControl__c.getValues('User_Group_MemberTrigger').IsActive__c;
	    if( tc == TRUE ) {
	        TriggerFactory.createAndExecuteHandler(User_Group_MemberHandler.class);
	    } ELSE {

	    }
	}
}