public without sharing class OpportunityHandler
    implements ITrigger
{
    List<OpportunityTeamMember> listOppTeamMember = new List<OpportunityTeamMember>();
    List<AccountTeamMember> listActTeamMember = new List<AccountTeamMember>();
    List<OpportunityShare> listOppShares = new List<OpportunityShare>();
    List<Opportunity> listOpportunity = new List<Opportunity>();
    List<Opportunity> validatedOpportunities = new List<Opportunity>(); 
    Related_Customer__c[] listRelatedCustomer = new Related_Customer__c[]{};
    GroupOpportunity__c[] insertGroupOpp = new GroupOpportunity__c[]{};
    opportunitylineitem[] updateValue = new opportunitylineitem[]{};
    Task[] insertSwitchedSpec=new Task[]{};
    Task[] insertGalleryTask=new Task[]{};
    public static boolean firstRun = true;
    public static boolean hasErrors = false;

    public OpportunityHandler()
    {       
    } 

    public void bulkBefore()
    {
        System.debug('OpportunityHandler +  bulkBefore:::>');
        if (Trigger.isInsert || Trigger.isUpdate) {
            System.debug('OpportunityHandler +  bulkBefore + Trigger.newMap:::>' + Trigger.new);
            OpportunityGateway.validateOpportunity();
        }
    }
 
    public void bulkAfter()
    {       
        if (Trigger.isInsert || Trigger.isUpdate) {
            if (firstRun) {
                firstRun = false;
                insertGroupOpp = OpportunityGateway.newOppGroup(Trigger.newMap.keySet());
                updateValue = OpportunityGateway.updateOppValue(Trigger.newMap.keySet());
                insertSwitchedSpec = OpportunityGateway.newSwitchedSpec(Trigger.newMap.keySet());
                // insertGalleryTask = OpportunityGateway.newGalleryTask(Trigger.newMap.keySet());
                listRelatedCustomer = OpportunityGateway.newRelatedCustomer(Trigger.newMap.keySet());
                listOppTeamMember = OpportunityGateway.updateOppTeam(Trigger.newMap.keySet());
                listActTeamMember = OpportunityGateway.updateAccountTeam(Trigger.newMap.keySet());
                listOppShares = OpportunityGateway.updateOppShare(Trigger.newMap.keySet());
                listOpportunity = OpportunityGateway.updateOppportunity(Trigger.newMap.keySet());
            } else {
            System.debug('Already ran!');
            return;
            }           
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
        
        // insert any audit records
        if(insertSwitchedSpec.size()>0){
            insert insertSwitchedSpec;
        }
        if(insertGalleryTask.size()>0){
            insert insertGalleryTask;
        }
        if(listOppTeamMember.size() > 0){
            insert listOppTeamMember;
        }
        if(listOppShares.size() > 0) {
            database.insert(listOppShares, false);
        }
        if(listActTeamMember.size() > 0){
            insert listActTeamMember;
        }
        if(listRelatedCustomer.size()>0){
            insert listRelatedCustomer;
        }       
        if(insertGroupOpp.size()>0){
            insert insertGroupOpp;
        }           
        if(updateValue.size()>0){
            System.debug('OpportunityHandler + updateValue:...' + updateValue);
            upsert updateValue;
        }           
        if(listOpportunity.size()>0){
            System.debug('OpportunityHandler + listOpportunity:...' + listOpportunity);
            upsert listOpportunity;
        }
    }
}