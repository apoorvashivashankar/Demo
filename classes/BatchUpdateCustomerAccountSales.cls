global class BatchUpdateCustomerAccountSales implements 
    Database.Batchable<sObject>, Database.Stateful {
    
    // instance member to retain state across transactions
    global Integer recordsProcessed = 0;
    global Database.QueryLocator start(Database.BatchableContext bc) {
    
        if ( ! Test.isRunningTest() ) {
            return Database.getQueryLocator('SELECT Id FROM Account WHERE RecordType.Name = \'Customer Account\' ');
        }else{
            return Database.getQueryLocator('SELECT Id FROM Account WHERE RecordType.Name = \'Customer Account\' LIMIT 1 ');
        }
    

    }
    global void execute(Database.BatchableContext bc, List<Account> scope){
        // process each batch of records
        List<Account> updateAccounts = new List<Account>();
        
        for (Account currentRecord : scope) {
        
            AggregateResult[] groupedResults = [SELECT sum(Cost_of_Sales__c) cos, sum(Net_Sales__c) ns
                                                 FROM Sales__c
                                                 WHERE Account__c = :currentRecord.Id
                                                 AND Sales_Date__c = LAST_N_DAYS:365
                                                 AND Product_Team_Number__c <> '0031'
                                                 ];
            for (AggregateResult ar : groupedResults)  {                            
            
                //system.debug('#####' + (Decimal) ar.get('cos') ) ;
                //system.debug('#####' + (Decimal) ar.get('ns') ) ;
                
                currentRecord.Last_365D_COS__c = (Decimal) ar.get('cos');
                currentRecord.Last_365D_NS__c  = (Decimal) ar.get('ns');
            
            } 
            
            updateAccounts.add(currentRecord);
            
            // increment the instance member counter
            recordsProcessed = recordsProcessed + 1;
            
        }
        
         update updateAccounts;
        
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
        
        BatchUpdateCustomerClassSales uca = new BatchUpdateCustomerClassSales();
        Id batchId = Database.executeBatch(uca, 75);
    }    
}