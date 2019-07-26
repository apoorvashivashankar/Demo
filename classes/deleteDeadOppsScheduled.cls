global class deleteDeadOppsScheduled implements Schedulable {
	global void execute(SchedulableContext scMain) {
		deleteDeadOpps clsDeleteDeadOpps = new deleteDeadOpps(); 
		ID idBatchDelete = Database.executeBatch(clsDeleteDeadOpps,  50 );
		deleteDeadOppsGeneric clsDeadOppsGeneric = new deleteDeadOppsGeneric(); 
		ID idBatchGeneric = Database.executeBatch(clsDeadOppsGeneric,  50 );
	}
}