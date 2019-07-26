/**
 * Class OpportunityGroupHandler
 *
 * Trigger Handler for the OpportunityGroup SObject. This class implements the ITrigger
 * interface to help ensure the trigger code is bulkified and all in one place.
 */
public without sharing class OpportunityGroupHandler  
	implements ITrigger
{	
    // Member variable to hold the Id's of Accounts 'in use'
    private Set<Id> m_oppId = new Set<Id>();
    private Set<Id> u_Id = new Set<Id>();
 
    // Member variable to record Audit records
    private List<User_Group_Member__c> m_members = new List<User_Group_Member__c>();
	private List<OpportunityTeamMember> m_users = new List<OpportunityTeamMember>();
    private List<OpportunityTeamMember> m_inUseIds = new List<OpportunityTeamMember>();
    List<OpportunityTeamMember> listOppGroupMember = new List<OpportunityTeamMember>();
    List<GroupOpportunity__c> listOppGroup = new List<GroupOpportunity__c>();
	List<OpportunityTeamMember> listOppTeamMember = new List<OpportunityTeamMember>();
    List<Opportunity> listOpportunity = new List<Opportunity>();

    // Empty Constructor
	public OpportunityGroupHandler() {
		
	} 

    public void bulkBefore()
    {  	        
        if (Trigger.isDelete)
        {
            // pre load all the in use projects passed to this trigger
            listOppGroupMember = OpportunityGroupGateway.delOppTeamMembers(Trigger.oldMap.keySet());
            System.debug('::::OpportunityGroupHandler + listOppGroupMember ' + listOppGroupMember);   
        }
    }
 
    public void bulkAfter()
    {
        // pre load all the Users from Groups in use passed to this trigger
        if (Trigger.IsInsert)
        {
        	System.debug('::::OpportunityGroupHandler + newMap ' + (Trigger.newMap.keySet())); 
            listOppTeamMember = OpportunityGroupGateway.findGroupMembersToAdd(Trigger.newMap.keySet());
            listOpportunity = OpportunityGroupGateway.updateOpportunity(Trigger.newMap.keySet());
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
        if (!listOppTeamMember.isEmpty())
        {
            insert listOppTeamMember;
            System.Debug(':::OpportunityGroupHandler listOppTeamMember + ' + listOppTeamMember);
        }
        if (!listOpportunity.isEmpty())
        {
            update listOpportunity;
            System.Debug(':::OpportunityGroupHandler listOpportunity + ' + listOpportunity);
        }
        if (!listOppGroupMember.isEmpty())
        {
            delete listOppGroupMember;
            System.Debug(':::OpportunityGroupHandler listOppGroupMember + ' + listOppGroupMember);
        }
    }
}