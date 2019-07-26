public without sharing class User_Group_MemberHandler 
    implements ITrigger
{
    // Member variable to hold the Id's of Accounts 'in use'
    private Set<Id> m_inUseIds = new Set<Id>();
 	List<OpportunityTeamMember> listOppTeamMember = new List<OpportunityTeamMember>();
	List<OpportunityTeamMember> listOppTeamMemberToDel = new List<OpportunityTeamMember>();

    // Constructor
    public User_Group_MemberHandler()
    {
    }
 
    public void bulkBefore()
    {
        if (Trigger.isDelete)
        {
            // pre load all the in use projects passed to this trigger
            listOppTeamMemberToDel = User_Group_MemberGateway.findOppsToRemoveMember(Trigger.oldMap.keySet());
        }
    }
 
    public void bulkAfter()
    {
        if (Trigger.isInsert)
        {
            // pre load all the in use projects passed to this trigger
            listOppTeamMember = User_Group_MemberGateway.findOpenOpportunities(Trigger.newMap.keySet());
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

    /**
     * andFinally
     *
     * This method is called once all records have been processed by the trigger. Use this
     * method to accomplish any final operations such as creation or updates of other records.
     */
    public void andFinally()
    {
        // insert any audit records
        if (!listOppTeamMember.isEmpty())
        {
            insert listOppTeamMember;
        }
        if (!listOppTeamMemberToDel.isEmpty())
        {
            delete listOppTeamMemberToDel;
        }
    }
}