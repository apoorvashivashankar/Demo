/**
* Description :
**/
global class Dal_DraftOrderCleanupScheduler implements Schedulable {

   // This test runs a scheduled job at

   global static final String CRON_EXPRESSION = '0 0 12 ? * * *';

   global void execute(SchedulableContext SC){
		Database.executeBatch(new Dal_DraftOrderCleanupBatch(), 200);
   }
   public static void schedule(String cron){
		if(String.isBlank(cron)){
			cron = CRON_EXPRESSION;
		}
		List<CronTrigger> existingCronTriggers = [SELECT Id, CronJobDetail.Name
												  FROM CronTrigger
											      WHERE CronJobDetail.Name LIKE '%Dal_DraftOrderCleanupScheduler%'
											     ];
		if(existingCronTriggers.size() == 0){
			System.schedule('Scheduled Apex: Dal_DraftOrderCleanupScheduler', cron, new Dal_DraftOrderCleanupScheduler());
		}
   }
}