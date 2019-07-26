/**
* Description :
**/
global class Dal_DraftOrderCleanupBatch implements Database.Batchable<sObject> {

	public static Date last7Day = System.today().addDays(-7);
	public static String draft = 'Draft';

	global Database.QueryLocator start(Database.BatchableContext BC){
			return Database.getQueryLocator(
	            'SELECT Id FROM DT_Order__c WHERE Status__c =: draft AND CreatedDate <: last7Day'
	        );
	}
	global void execute(Database.BatchableContext BC, List<sObject>Scope){
			Dal_OrderManager.cleanupDraftOrders(Scope);
	}

	global void finish(Database.BatchableContext info){
   	}

}