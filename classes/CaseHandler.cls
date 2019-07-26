public without sharing class CaseHandler implements ITrigger
{

    List <Task> insertTask = new List <Task>{};
    List <Contact> listInsertContact = new List <Contact>{};
    List <Contact> listUpdateContact = new List <Contact>{};
    List <User> listUser = new List <User>{};
    List <Contact> updateContact = new List <Contact>{};
    List <Change_Request__c> insertCustomerRequest = new List <Change_Request__c>{};
    List <Case> updateCase = new List <Case>{};
    
    public CaseHandler() 
    {
    }

    public void bulkBefore()
    {
        if (Trigger.isInsert || Trigger.isUpdate) {
            CaseGateway.validate();
        }
    }
 
    public void bulkAfter()
    {       
        if (Trigger.isInsert) {
            listInsertContact = CaseGateway.createContact(Trigger.newMap); 
            updateCase = CaseGateway.updateCaseAssignment(Trigger.newMap.keySet()); 
        }
        if (Trigger.isUpdate) {
            listUpdateContact = CaseGateway.updateContactAccount(Trigger.newMap.keySet()); 
        }
        if (Trigger.isInsert || Trigger.isUpdate) {
            if (CaseGateway.checkContactCreated == true && CaseGateway.checkUserCreated != true) {
                listUser = CaseGateway.createProExchUser(Trigger.new, Trigger.old); 
            }
            insertTask = CaseGateway.createRepTask(Trigger.newMap.keySet()); 
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
        if(insertTask.size()>0){
            insert insertTask;
        }                 
        
        if(listInsertContact.size()>0){
            System.debug('andFinally + listInsertContact...: ' + listInsertContact);
            upsert listInsertContact;
        }
        
        if(listUpdateContact.size()>0){
            System.debug('andFinally + listUpdateContact...: ' + listUpdateContact);
            try {
                upsert listUpdateContact;
            } catch (Exception e) {
                System.debug('andFinally + listUpdateContact + Exception e...: ' + e);
            }
        }
        
        if(updateCase.size()>0){        
            Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.assignmentRuleHeader.useDefaultRule = true;            
            System.debug('::::CaseHandler + updateCase: ' + updateCase);   
            Database.update(updateCase, dmo);
        }    

        if(listUser.size()>0){
            try {
                insert listUser;
            } catch(DmlException e) {
                System.debug('It looks like there was an issue...: ' + e.getMessage());
            }            
        }         
    }
}