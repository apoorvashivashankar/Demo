global class UserToLocationScheduled implements Schedulable {
    global void execute(SchedulableContext scMain) {
        AccountShareUserToLocationBatch clsAccountShareBatch = new AccountShareUserToLocationBatch(); 
        ID idBatch = Database.executeBatch(clsAccountShareBatch ,  2000 );
    }
}