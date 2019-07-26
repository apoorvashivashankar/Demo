global class Dal_DeleteOrderBatch implements Database.Batchable<sObject>,Schedulable{
    static Date todayValue = System.today().addDays(-6);   
	static String Submit = 'Submit';
    global Database.QueryLocator start(Database.BatchableContext context)
    {
        return Database.getQueryLocator('Select Id from DT_Order__c where Submit_Date__c < :todayValue AND Status__c =: Submit');
    }

    global void execute(Database.BatchableContext context, List<SObject> scope)
    {	
        system.debug('scope'+scope);
        try{
        	delete scope;
        }catch(Exception exp){
            System.debug('Exception'+exp);
        }
        
    }
    global void finish(Database.BatchableContext Bc){
        
    } 
    global void execute(SchedulableContext ctx) 
    {
        Database.executeBatch(new Dal_DeleteOrderBatch());
    }
}