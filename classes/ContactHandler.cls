public without sharing class ContactHandler implements ITrigger
{
    private List <Case> listUpdateProExchCases = new List<Case>();
    private List <Case> listInsertProExchCases = new List<Case>();
    private List <Case> listProExchCases = new List<Case>();
    private List <Account> listProExchAccount = new List<Account>();
    private list <AccountShare> listAccountShare = new list <AccountShare> ();
   
    public ContactHandler () 
    {
    }

    public void bulkBefore()
    {
        if (Trigger.isInsert || Trigger.isUpdate) {
            ContactGateway.validate();
        }
    } 
 
    public void bulkAfter()
    {       
        if (Trigger.isInsert) {
            // System.debug( ' :::bulkAfter + isInsert> ');
            listInsertProExchCases = ContactGateway.createProExchContact(trigger.newMap);
        }    
        if(Trigger.isUpdate) {
            // System.debug( ' :::bulkAfter + isUpdate> ');
            listUpdateProExchCases = ContactGateway.updateProExchContact(trigger.newMap, trigger.oldMap);
        }
        if (Trigger.isInsert || Trigger.isUpdate) {
            listProExchCases = ContactGateway.handleProExchUserCases(Trigger.new, Trigger.old); 
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
        if (listInsertProExchCases.size() > 0) {
            upsert listInsertProExchCases;
        }
        if (listUpdateProExchCases.size() > 0) {
            update listUpdateProExchCases;
        }
        if (listProExchCases.size() > 0) {
            upsert listProExchCases;
        }
    }
}