/**
* Created by Yadav on 1/2/2019.
*/

global class Dal_SSC_DeleteCartBatch implements Database.Batchable<sObject>,Schedulable{
    static final String STATUS_VALUE = 'Draft';
    static Date todayValue = Date.today().addDays(-6);
    List<Dt_Cart__c> deleteCartRecords = new List<Dt_Cart__c>();
    global Database.QueryLocator start(Database.BatchableContext context)
    {
        return Database.getQueryLocator('SELECT Id ,Name, Status__c, (SELECT Id,Name,LastModifiedDate from DT_Cart_Product__r ORDER BY LastModifiedDate DESC) FROM DT_Cart__c WHERE Status__c =:STATUS_VALUE');
    }
    
    global void execute(Database.BatchableContext context, List<DT_Cart__c> scope)
    {
        try{
            for(DT_Cart__c obj : scope){
                if(obj.DT_Cart_Product__r.size() > 0){
                    if(todayValue >= obj.DT_Cart_Product__r[0].LastModifiedDate.date() ){
                        deleteCartRecords.add(obj);
                    }
                } 
            }
            System.debug('---deleteCartRecords--'+deleteCartRecords);
            if(deleteCartRecords.size() > 0){
                delete deleteCartRecords;
            }
        }catch(Exception exp){
            System.debug('Exception'+exp);
        }
        
    }
    global void finish(Database.BatchableContext Bc){
        
    }
    global void execute(SchedulableContext ctx)
    {
        Database.executeBatch(new Dal_SSC_DeleteCartBatch());
    }
}