trigger Order_TrackingTrigger on Order_Tracking__c (after delete, after insert, after update, before delete, before insert, before update)
{
	        TriggerFactory.createAndExecuteHandler(Order_TrackingHandler.class);
/*
    if( TriggerControl__c.getValues('Order_TrackingTrigger') != null ) {
	    Boolean tc = TriggerControl__c.getValues('Order_TrackingTrigger').		;
	    if( tc == TRUE ) {
	    } ELSE {

	    } 
	}
*/
}