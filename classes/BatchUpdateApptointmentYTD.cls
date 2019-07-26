global class BatchUpdateApptointmentYTD implements Database.Batchable<sObject>, Database.Stateful {
    
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
                                                 FROM Appointment__c
                                                 WHERE Daltile_Location__c = :currentRecord.Id
                                                 AND Visitor_Time_Out__c = THIS_YEAR
                                                 AND Status__c IN ('Closed','Completed')
                                                 ];
            for (AggregateResult ar : groupedResults)  {                            
                
                currentRecord.Appt_YTD__c = (Decimal) ar.get('total');
            
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
            
        BatchUpdateGalleryTaskCurrentMonth uca = new BatchUpdateGalleryTaskCurrentMonth();
        Id batchId = Database.executeBatch(uca, 75);
        
    }    
}