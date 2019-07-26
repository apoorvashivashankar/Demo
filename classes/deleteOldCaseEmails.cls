global class deleteOldCaseEmails implements Database.Batchable < SObject >, Database.Stateful{

  global String queryDelete;
  global List < Case > lstScopeRecords;
  global Integer varNumberOfRecords; 
  
  // Class Constructor - set query string
  global deleteOldCaseEmails() {
        queryDelete = 'SELECT Id,(SELECT id FROM EmailMessages), CreatedDate FROM CASE WHERE ID IN (SELECT ParentId FROM EmailMessage) AND ClosedDate < LAST_N_MONTHS: 12 ';
  }
  // "Start" runs when the class in instantiated 
  global Database.QueryLocator start(Database.BatchableContext bcMain) {
    return Database.getQueryLocator(queryDelete); 
  }
  // "Execute" is what is being run as a separate process per batch
  global void execute(Database.BatchableContext bcMain, List < Case > lstBatchRecords) {
    lstScopeRecords = lstBatchRecords;
    System.debug('deleteOldCaseEmails + lstScopeRecords ---> '+lstScopeRecords);  
    List < EmailMessage > lstRecordsToUpdate = new List < EmailMessage > ();
    for (Case c : lstScopeRecords) { 
        System.debug('deleteOldCaseEmails + c ---> '+c);  
        for (EmailMessage e: c.EmailMessages) {    
            System.debug('deleteOldCaseEmails + e ---> '+c);  
            lstRecordsToUpdate.add(e);
        }
    }
    
    //   lstRecordsToUpdate.add(e);
    // }
    varNumberOfRecords = lstRecordsToUpdate.size();
    System.debug('deleteOldCaseEmails + varNumberOfRecords ---> '+varNumberOfRecords);  
    if (varNumberOfRecords > 0) {
      delete lstRecordsToUpdate;
    }
  }
  // Finish the Batch Job
  global void finish(Database.BatchableContext bcMain) {
    // Optional - you can send an email to an admin with results
    String strResultEmail = 'jon.rust@daltile.com';
    AsyncApexJob aaJob = [SELECT NumberOfErrors, TotalJobItems, ApexClass.Name FROM AsyncApexJob WHERE Id = : bcMain.getJobId()];
    Messaging.SingleEmailMessage semResult = new Messaging.SingleEmailMessage();
    semResult.setToAddresses(new String[]{
    strResultEmail
    });
    semResult.setSubject('Completed Scheduled APEX : ' + aaJob.ApexClass.Name);
    semResult.setPlainTextBody('Processed ' + aaJob.TotalJobItems + ' batches with ' + aaJob.NumberOfErrors + ' failures.  Deleted ' + varNumberOfRecords + ' emails from the system');
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { semResult });
    }
}