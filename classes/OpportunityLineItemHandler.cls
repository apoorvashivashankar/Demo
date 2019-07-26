public without sharing class OpportunityLineItemHandler 

    implements ITrigger
{

    Order_Tracking__c[] insertOrderTracking = new Order_Tracking__c[]{};

	public OpportunityLineItemHandler() 
	{
	}

    public void bulkBefore()
    {
    }
 
    public void bulkAfter()
    {       
        if (Trigger.isInsert ) 
        {
            System.debug('::::OpportunityLineItemHandler + bulkAfter: ' + (Trigger.NewMap.keySet()));
            insertOrderTracking = OpportunityLineItemGateway.newOrderTracking(Trigger.NewMap.keySet()); 
        } else if (Trigger.isUpdate) {
            System.debug('::::OpportunityLineItemHandler + bulkAfter: ' + (Trigger.OldMap.keySet()));
            insertOrderTracking = OpportunityLineItemGateway.newOrderTracking(Trigger.OldMap.keySet()); 
        }
    }
 
    public void beforeInsert(SObject so)
    {
    }
 
    public void beforeUpdate(SObject oldSo, SObject so)
    {
    }
 
    public void beforeDelete(SObject so)
    {
    }

    public void afterInsert(SObject so) 
    {
    }
 
    public void afterUpdate(SObject oldSo, SObject so)
    {
    }
 
    public void afterDelete(SObject so)
    {
    }
 
    public void andFinally()
    {      
        if(insertOrderTracking.size()>0){
    		System.debug('::::OpportunityLineItemHandler + andFinally +insertOrderTracking: ' + insertOrderTracking);
    		for (Order_Tracking__c ot : insertOrderTracking) {
                insert ot;
            }
        }                 
    }
}