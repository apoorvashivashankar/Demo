global class BatchUpdateCustomerClassSales implements 
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
        List<Customer_Class__c> updateCustomerClasses = new List<Customer_Class__c>();
        
        for (Customer_Class__c currentRecord : scope) {
        
            system.debug('##### Current ID: ' + currentRecord.Id ) ;    
        
            AggregateResult[] groupedResults = [SELECT sum(Last_365D_COS__c) cos, sum(Last_365D_NS__c) ns
                                                 FROM Account
                                                 WHERE Customer_Class__c = :currentRecord.Id
                                                 ];
            for (AggregateResult ar : groupedResults)  {                            
            
                //system.debug('#####' + (Decimal) ar.get('cos') ) ;
                //system.debug('#####' + (Decimal) ar.get('ns') ) ;
                
                currentRecord.COS__c        = (Decimal) ar.get('cos');
                currentRecord.Net_Sales__c  = (Decimal) ar.get('ns');
            
            } 
            
            updateCustomerClasses.add(currentRecord);
            
            // increment the instance member counter
            recordsProcessed = recordsProcessed + 1;
            
        }
        
         update updateCustomerClasses;
        
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
    }    
}