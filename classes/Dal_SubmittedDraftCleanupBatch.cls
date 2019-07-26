/**
* Description :
**/
global class Dal_SubmittedDraftCleanupBatch implements Database.Batchable<sObject> {

	public static Date last30Day = System.today().addDays(-30);
	public static String submitted = 'Submitted';

	global Database.QueryLocator start(Database.BatchableContext BC){
			return Database.getQueryLocator(
	            'SELECT Id FROM DT_Order__c WHERE Status__c =: submitted AND CreatedDate <: last30Day'
	        );
	}
	global void execute(Database.BatchableContext BC, List<sObject>scope){
			Dal_OrderManager.cleanupDraftOrders(scope);
	}

	global void finish(Database.BatchableContext info){
   	}

}