public without sharing class UserToLocationHandler implements ITrigger
{
    private List <AccountShare> listAccountShareCreate = new List<AccountShare>();
    private List <Account> listAccountProExchangeUpdate = new List<Account>();
    private List <AccountShare> listAccountShareDelete = new List<AccountShare>();
    private List <Contact> listContactUpdate = new List<Contact>();
    private List <User_to_Location__c> listUserToLocation = new List<User_to_Location__c>();
   
    public UserToLocationHandler () 
    {
    }

    public void bulkBefore()
    {
        if(Trigger.isDelete) {
            // System.debug( ' ::: UserToLocationHandler + bulkBefore + isDelete> ');
            listAccountShareDelete = UserToLocationGateway.deleteSharing();
        }
    } 
 
    public void bulkAfter()
    {       
        if (Trigger.isInsert || Trigger.isUpdate) {
            // System.debug( ' ::: UserToLocationHandler + bulkAfter + isInsert> ');
            listAccountShareCreate = UserToLocationGateway.createAccountShare(trigger.newMap);
            listContactUpdate = UserToLocationGateway.updateProExchangeContact(trigger.newMap);
            listAccountProExchangeUpdate = UserToLocationGateway.updateProExchangeAccount(trigger.newMap);
            listUserToLocation = UserToLocationGateway.createGroupKeySharing(trigger.newMap);
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
        if (listUserToLocation.size() > 0) {
            // System.debug( ' ::: UserToLocationHandler + bulkAfter + andFinally + listUserToLocation:...> ' + listUserToLocation);
            Database.insert(listUserToLocation);
        }
        if (listAccountShareCreate.size() > 0) {
            // System.debug( ' ::: UserToLocationHandler + bulkAfter + andFinally + listAccountShareCreate:...> ' + listAccountShareCreate);
            insert listAccountShareCreate;
        }
        if (listAccountProExchangeUpdate.size() > 0) {
            // System.debug( ' ::: UserToLocationHandler + bulkAfter + andFinally + listAccountProExchangeUpdate:...> ' + listAccountProExchangeUpdate);
            update listAccountProExchangeUpdate;
        }
        if (listContactUpdate.size() > 0) {
            // System.debug( ' ::: UserToLocationHandler + bulkAfter + andFinally + listContactUpdate:...> ' + listContactUpdate);
            update listContactUpdate;
        }
        if (listAccountShareDelete.size() > 0) {
            delete listAccountShareDelete;
        }
    }
}