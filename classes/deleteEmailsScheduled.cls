global class deleteEmailsScheduled implements Schedulable {
  global void execute(SchedulableContext scMain) {
    deleteOldCaseEmails clsDeleteCaeEmails = new deleteOldCaseEmails(); 
    ID idBatchDelete = Database.executeBatch(clsDeleteCaeEmails,  1000 );
  }
}