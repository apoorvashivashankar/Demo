global class BatchUpdateGalleryTaskYTD implements Database.Batchable<sObject>, Database.Stateful {
    
    // instance member to retain state across transactions
    global Integer recordsProcessed = 0;
    global Database.QueryLocator start(Database.BatchableContext bc) {
    
        if ( ! Test.isRunningTest() ) {
            return Database.getQueryLocator('SELECT Id FROM Account WHERE RecordType.Name = \'Gallery Account\' ');
        }else{
            return Database.getQueryLocator('SELECT Id FROM Account WHERE RecordType.Name = \'Gallery Account\' LIMIT 1 ');
        }
    

    }
    global void execute(Database.BatchableContext bc, List<Account> scope){
        // process each batch of records
        List<Account> updateAccounts = new List<Account>();
        
        for (Account currentRecord : scope) {
        
            AggregateResult[] groupedResults = [SELECT count(Id) total
                                                 FROM Task
                                                 WHERE ( Appointment_Location__c = :currentRecord.Id OR WhatId = :currentRecord.Id )
                                                 AND Gallery_Visit_Date__c = THIS_YEAR
                                                 AND RecordType.Name = 'Gallery Task'
                                                 ];
            for (AggregateResult ar : groupedResults)  {                            
            
                
                currentRecord.Gallery_Task_YTD__c = (Decimal) ar.get('total');
            
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
        
        //BatchUpdateCustomerClassSales uca = new BatchUpdateCustomerClassSales();
        //Id batchId = Database.executeBatch(uca, 75);
    }    
}