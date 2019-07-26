public class TaskCreatorHandler implements ITrigger {

    /**
     * In order to ustilize bulk methods, from bulfBefore / bulkAfter we call a method in the Gateway.
     * This returns a collection to the handler, which is processed in the andFinally method.
     */

    private List <Task_Creator__c> listUpdatedOthersObject = new List<Task_Creator__c>();

    public void bulkBefore()
    {
       if (Trigger.isInsert || Trigger.isUpdate) {
           TaskCreatorGateway.processTaskCreator(Trigger.New);
       }
    }
 
    public void bulkAfter()
    {
      if (Trigger.isInsert || Trigger.isUpdate) {

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
        if (!listUpdatedOthersObject.isEmpty()) {
            insert listUpdatedOthersObject;
        }
    }
}