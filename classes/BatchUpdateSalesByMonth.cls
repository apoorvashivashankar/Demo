global class BatchUpdateSalesByMonth implements Database.Batchable<sObject>, Database.Stateful {
    
    // instance member to retain state across transactions
    global Integer recordsProcessed = 0;
    global Database.QueryLocator start(Database.BatchableContext bc) {
    
        if ( ! Test.isRunningTest() ) {
            return Database.getQueryLocator('SELECT Id FROM Account WHERE RecordType.Name = \'Customer Account\' ');
        }else{
            return Database.getQueryLocator('SELECT Id FROM Account WHERE RecordType.Name = \'Customer Account\' AND Id IN (SELECT Account__c FROM Sales__c) LIMIT 1 ');
        }
    

    }
    global void execute(Database.BatchableContext bc, List<Account> scope){
        // process each batch of records
        List<Sales_By_Month__c> upsertRecords = new List<Sales_By_Month__c>();
        
        for (Account currentRecord : scope) {
        
            AggregateResult[] groupedResults = [SELECT Account__c, GroupKey__c, calendar_year(Sales_Date__c) year, 
                                                calendar_month(Sales_Date__c) month, sum(Gross_Sales__c) gs, sum(Cost_of_Sales__c) cos
                                                FROM Sales__c
                                                WHERE Account__c = :currentRecord.Id
                                                AND calendar_year(Sales_Date__c) > 2016
                                                GROUP BY Account__c, GroupKey__c, calendar_year(Sales_Date__c), calendar_month(Sales_Date__c)
                                                 ];
                                                 
            for (AggregateResult ar : groupedResults)  {                            
            
                Sales_By_Month__c upsertRecord = new Sales_By_Month__c();
                
                String groupKey                  = (String) ar.get('GroupKey__c');
                String year                      = (String) String.valueof(ar.get('year'));
                String month                     = (String) String.valueof(ar.get('month'));
                
                upsertRecord.Key__c              = currentRecord.Id+'::'+groupKey+'::'+year+'::'+month;
                upsertRecord.Account__c          = (Id) ar.get('Account__c');
                upsertRecord.Cost_of_Sales__c    = (Decimal) ar.get('cos');
                upsertRecord.Gross_Sales__c      = (Decimal) ar.get('gs');
                upsertRecord.GroupKey__c         = groupKey;
                upsertRecord.Sales_Date__c       = Date.valueOf(year+'-'+month+'-15');
                upsertRecord.Sales_Adjustment__c = 0;
                
                upsertRecords.add(upsertRecord);
            
            } 
           
            
            // increment the instance member counter
            recordsProcessed = recordsProcessed + 1;
            
        }
        
         upsert upsertRecords Key__c;
        
    }    
    global void finish(Database.BatchableContext bc){
        System.debug(recordsProcessed + ' records processed. Shazam!');
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];
        // call some utility to send email
        //EmailUtils.sendMessage(job, recordsProcessed);
        
        BatchUpdateSalesByQTR uca = new BatchUpdateSalesByQTR();
        Id batchId = Database.executeBatch(uca, 75);
    }    
}