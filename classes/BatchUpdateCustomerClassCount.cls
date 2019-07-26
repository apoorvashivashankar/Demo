global class BatchUpdateCustomerClassCount implements 
    Database.Batchable<sObject>, Database.Stateful {
    
    // instance member to retain state across transactions
    global Integer recordsProcessed = 0;
    global Database.QueryLocator start(Database.BatchableContext bc) {
    
        if ( ! Test.isRunningTest() ) {
        
            return Database.getQueryLocator('SELECT Id, CustClass__c FROM Customer_Class__c');
        
        }else{
        
            return Database.getQueryLocator('SELECT Id, CustClass__c FROM Customer_Class__c LIMIT 1');
            
        }

    }
    global void execute(Database.BatchableContext bc, List<Customer_Class__c> scope){
        // process each batch of records
        List<Customer_Class__c> updateCustomerClass = new List<Customer_Class__c>();
        
        for (Customer_Class__c currentRecord : scope) {
        

            integer count =  [SELECT Count() FROM Account
                                WHERE Customer_Class__c = :currentRecord.Id
                                AND RecordType.Name = 'Customer Account'
                             ];
            
            currentRecord.Cust_Count__c = count;

            
            updateCustomerClass.add(currentRecord);
            
            // increment the instance member counter
            recordsProcessed = recordsProcessed + 1;
            
        }
        
        update updateCustomerClass ;
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
        
        BatchUpdateCustomerAccountSales uas = new BatchUpdateCustomerAccountSales();
        Id batchId = Database.executeBatch(uas);

    }    
}