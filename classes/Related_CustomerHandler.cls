public without sharing class Related_CustomerHandler
    implements ITrigger 
{
    // Member variable to hold the Id's of Accounts 'in use'
    private Set<Id> m_inUseIds = new Set<Id>();
 
    // Member variable to record Audit records
    private List<OpportunityContactRole> oppContact 		= new List<OpportunityContactRole>();
    private List<Related_Customer__c> otherAccounts 		= new List<Related_Customer__c>();
    private List<Opportunity> clearOpportunity 				= new List<Opportunity>();
    private List<OpportunityContactRole> oppAccountUptes 	= new List<OpportunityContactRole>();
 
    // Constructor
    public Related_CustomerHandler()
    {
    }
 
    public void bulkBefore()
    {
        if (Trigger.isInsert || Trigger.isUpdate) 
        {
        	otherAccounts = Related_CustomerGateway.findOtherRelatedAccounts(Trigger.new);
        	System.debug('::::Related_CustomerHandler + newMap ' + Trigger.new);        
        	System.debug('::::Related_CustomerHandler + otherAccounts ' + otherAccounts);  	
        }
        if (Trigger.IsDelete) 
        {
      		System.debug('::::Related_CustomerHandler + Trigger.newMap.keySet() ' + Trigger.oldMap.keySet());
        	clearOpportunity = Related_CustomerGateway.deleteRelatedAccountFromOpp(Trigger.oldMap.keySet());   
	      	System.debug('::::Related_CustomerHandler + clearOpportunity ' + clearOpportunity);  
      	}

    }
 
    public void bulkAfter()
    {
        if (Trigger.isInsert || Trigger.isUpdate) 
        {
        	oppContact = Related_CustomerGateway.addOpportunityContact(Trigger.newMap.keySet());
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
/*        // Cast the SObject to an Account
        Account myAccount = (Account)so;
 
        // Examine the Set and if the account is in use don't allow it to be deleted.
        if (m_inUseIds.contains(myAccount.Id))
        {
            // Add the error to the offending object
            so.addError('You cannot delete an Account that is in use.');
        }
        else
        {
            // Add an audit record to the list
            Audit__c myAudit = new Audit__c();
            myAudit.Description__c = 'Account Name: ' + myAccount.Name + ' (Id: ' + myAccount.Id + ') was deleted';
 
            m_audits.add(myAudit);
        }
*/        
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
    	System.debug('::::andFinally + otherAccounts ' + otherAccounts);  
        // insert any audit records

        if (!otherAccounts.isEmpty())
        {
//        	System.debug('::::andFinally + updateRelCus.isEmpty() ' + updateRelCus);  
            update otherAccounts;
        }

        if (!oppContact.isEmpty())
        {
            insert oppContact;
        }
        
        if (!clearOpportunity.isEmpty())
        {
        	System.debug('::::andFinally + clearOpportunity.isEmpty() ' + clearOpportunity);
        	update clearOpportunity;	
        }
    }
}