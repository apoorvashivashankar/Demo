public without sharing class LeadHandler implements ITrigger
{

    Lead[] insertLead = new Lead[]{};
    
    public LeadHandler() 
    {
    }

    public void bulkBefore()
    {
    }
 
    public void bulkAfter()
    {       
        if (Trigger.isInsert) {
            insertLead = LeadGateway.assignDealerLead(Trigger.newMap.keySet()); 
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
        if(insertLead.size()>0){ 
            update insertLead;
        }
    }
}