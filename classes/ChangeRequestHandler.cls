public with sharing class ChangeRequestHandler implements ITrigger {

    private List <Change_Request__c> listChangeRequest = new List<Change_Request__c>();
    private List <Account> listAccount = new List<Account>();
    private List <Case> listCase = new List<Case>();
    private List <Approval.ProcessSubmitRequest> listRequests = new List <Approval.ProcessSubmitRequest> ();
    public Boolean hasErrors;

    public void bulkBefore()
    {
        if (Trigger.isInsert) {
            ChangeRequestGateway.onBeforeInsert(trigger.newMap);
        } 
        if(Trigger.isUpdate) {
            ChangeRequestGateway.onBeforeUpdate(trigger.newMap, trigger.oldMap);
        }
    }
 
    public void bulkAfter()
    {   
        if (Trigger.isInsert) {
            listRequests = ChangeRequestGateway.onAfterInsert(trigger.newMap);
        }    
        if(Trigger.isUpdate) {
            listRequests = ChangeRequestGateway.onAfterUpdate(trigger.newMap, trigger.oldMap);
            listCase = ChangeRequestGateway.updateCase(trigger.newMap, trigger.oldMap);
            listAccount = ChangeRequestGateway.updateAccount(trigger.newMap, trigger.oldMap);
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
        if (!listCase.isEmpty() && listCase != null) {
            upsert listCase;
        }  
        if (!listRequests.isEmpty() && listRequests != null) {
            for (Approval.ProcessSubmitRequest a : listRequests) {
                System.debug('...ChangeRequestHandler + andFinally + a...: '+ a);   
                Approval.ProcessResult result = Approval.process(a);
                System.debug('...ChangeRequestHandler + andFinally + Submitted for approval successfully: '+result.isSuccess());                
            }
        }  
        if (!listAccount.isEmpty()) {
            update listAccount;
        }  
    }
}